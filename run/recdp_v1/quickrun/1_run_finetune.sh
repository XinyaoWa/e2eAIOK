#!/bin/bash
set -x

DATA_PATH="/home/vmagent/app/LLM_datapre/data"
ALPACA_TRAIN_DATA="LLM_data/mix_metric"
ALPACA_VALID_DATA="LLM_data/alpaca/alpaca_valid_parquet/alpaca_data_valid.parquet"
LOG_PATH=$DATA_PATH"/llama2_denas_mix_metric_v1/log"
MODEL_SAVE_PATH=$DATA_PATH"/llama2_denas_mix_metric_v1/models"

mkdir -p $LOG_PATH $MODEL_SAVE_PATH

# fine-tune with denas-lora
model_name="Llama-2-7b-hf"
dataset_list="mix_metric_v1_3.parquet"

for dataset_name in $dataset_list
do
    model_name_or_path=${DATA_PATH}"/"${model_name}
    model_best_structure=${DATA_PATH}"/"${model_name}"/best_model_structure.txt"
    model_save_path=${MODEL_SAVE_PATH}"/"${model_name}"_denas-lora_"${dataset_name}
    log_save_path=$LOG_PATH"/"${model_name}"_denas-lora-1epoch_"${dataset_name}".log"
    WANDB_DISABLED=true python -u example/instruction_tuning_pipeline/finetune_clm.py \
        --model_name_or_path $model_name_or_path \
        --train_file ${DATA_PATH}"/"${ALPACA_TRAIN_DATA}"/"${dataset_name} \
        --dataset_concatenation \
        --per_device_train_batch_size 2 \
        --gradient_accumulation_steps 4 \
        --do_train \
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
        --load_in_8bit True \
        2>&1 | tee $log_save_path

    log_save_path_valid=$LOG_PATH"/"${model_name}"_denas-lora-1epoch_"${dataset_name}"-valid.log"
    WANDB_DISABLED=true python -u example/instruction_tuning_pipeline/finetune_clm.py \
        --model_name_or_path $model_name_or_path \
        --train_file ${DATA_PATH}"/"${ALPACA_TRAIN_DATA}"/"${dataset_name} \
        --validation_file ${DATA_PATH}"/"${ALPACA_VALID_DATA} \
        --dataset_concatenation \
        --per_device_train_batch_size 2 \
        --per_device_eval_batch_size 4 \
        --do_eval \
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
        --load_in_8bit False \
        --resume_peft $model_save_path \
        2>&1 | tee $log_save_path_valid
done

