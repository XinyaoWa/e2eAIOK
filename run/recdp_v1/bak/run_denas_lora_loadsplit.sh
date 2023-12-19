#!/bin/bash
set -x

DATA_PATH="/home/vmagent/app/data"
ALPACA_TRAIN_DATA="LLM_data/alpaca_train_parquet/alpaca_data_train.parquet"
ALPACA_VALID_DATA="LLM_data/alpaca_valid_parquet/alpaca_data_valid.parquet"
LOG_PATH=$DATA_PATH"/llama2_denas_alpaca70_base/log"
MODEL_SAVE_PATH=$DATA_PATH"/llama2_denas_alpaca70_base/models"

mkdir -p $LOG_PATH $MODEL_SAVE_PATH

# fine-tune with denas-lora
model_name_list="Llama-2-7b-hf"
for model_name in $model_name_list
do
    model_name_or_path=${DATA_PATH}"/"${model_name}
    model_best_structure=${DATA_PATH}"/"${model_name}"/best_model_structure.txt"
    model_save_path=${MODEL_SAVE_PATH}"/"${model_name}"_denas-lora"
    log_save_path=$LOG_PATH"/"${model_name}"_denas-lora-1epoch.log"
    python -u example/instruction_tuning_pipeline/finetune_clm.py \
        --model_name_or_path $model_name_or_path \
        --train_file ${DATA_PATH}"/"${ALPACA_TRAIN_DATA} \
        --validation_file ${DATA_PATH}"/"${ALPACA_VALID_DATA} \
        --dataset_concatenation \
        --per_device_train_batch_size 2 \
        --per_device_eval_batch_size 2 \
        --gradient_accumulation_steps 4 \
        --do_train \
        --do_eval \
        --learning_rate 1e-4 \
        --num_train_epochs 1 \
        --logging_steps 100 \
        --save_total_limit 1 \
        --log_level info \
        --save_strategy epoch \
        --output_dir $model_save_path \
        --peft lora \
        --delta lora \
        --best_model_structure $model_best_structure \
        --denas True \
        --trust_remote_code True \
        --fp16 \
        2>&1 | tee $log_save_path
done

########################## advanced options ##########################
# note 0: used for assign target modules
    # llama: --lora_target_modules q_proj v_proj k_proj o_proj up_proj down_proj \
    # mpt: --lora_target_modules Wqkv out_proj up_proj down_proj \
# note 1: used for 4th Xeon or later (SPR etc.): --bf16 --no_cuda
# note 2: used for 3th Xeon or before (ICX etc.): --no_cuda
# note 3: used for GPU server: --fp16