#!/bin/bash
set -x

DATA_PATH="/home/data/"
LOG_PATH=$DATA_PATH"/QA_dataset/test/log"
MODEL_SAVE_PATH=$DATA_PATH"/QA_dataset/test/models"
TRAIN_FILE="/home/work/LLM_datapre/frameworks.bigdata.AIDK/llm_data/text_to_qa/test/data/9_dataset_test/QA_train.parquet"
VALID_FILE="/home/work/LLM_datapre/frameworks.bigdata.AIDK/llm_data/text_to_qa/test/data/9_dataset_test/QA_test.parquet"

mkdir -p $LOG_PATH $MODEL_SAVE_PATH

# fine-tune with denas-lora
model_name="Llama-2-7b-hf"
model_name_or_path=${DATA_PATH}"/"${model_name}
model_best_structure=${DATA_PATH}"/"${model_name}"/best_model_structure.txt"
model_save_path=${MODEL_SAVE_PATH}"/"${model_name}"_denas-lora"
log_save_path=$LOG_PATH"/"${model_name}"_denas-lora-1epoch.log"

WANDB_DISABLED=true python -u example/instruction_tuning_pipeline/finetune_qa.py \
    --model_name_or_path $model_name_or_path \
    --train_file $TRAIN_FILE \
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
    --load_in_8bit False \
    --debugs \
    2>&1 | tee $log_save_path

log_save_path_valid=$LOG_PATH"/"${model_name}"_denas-lora-1epoch-valid.log"
WANDB_DISABLED=true python -u example/instruction_tuning_pipeline/finetune_qa.py \
    --model_name_or_path $model_name_or_path \
    --train_file $TRAIN_FILE \
    --validation_file $VALID_FILE \
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
    --debugs \
    2>&1 | tee $log_save_path_valid

##merge
log_save_path_merge=$LOG_PATH"/"${model_name}"_denas-lora-1epoch-merge.log"
WANDB_DISABLED=true python -u example/instruction_tuning_pipeline/finetune_qa.py \
    --model_name_or_path $model_name_or_path \
    --train_file $TRAIN_FILE \
    --dataset_concatenation \
    --logging_steps 100 \
    --save_total_limit 1 \
    --log_level info \
    --output_dir $model_save_path \
    --peft lora \
    --delta lora \
    --best_model_structure $model_best_structure \
    --denas True \
    --trust_remote_code True \
    --load_in_8bit False \
    --resume_peft $model_save_path \
    --save_merged_model True \
    2>&1 | tee $log_save_path_merge