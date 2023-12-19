#!/bin/bash
set -x

DATA_PATH="/home/vmagent/app/LLM_datapre/data/"
LOG_PATH=$DATA_PATH"/QA_dataset/report_qa/log"
MODEL_SAVE_PATH=$DATA_PATH"/QA_dataset/report_qa/models"
TRAIN_FILE="/home/vmagent/app/LLM_datapre/work/generate_dataset/data/9_qa_dataset/QA_train.parquet"
VALID_FILE="/home/vmagent/app/LLM_datapre/work/generate_dataset/data/9_qa_dataset/QA_valid.parquet"

mkdir -p $LOG_PATH $MODEL_SAVE_PATH

model_name="Llama-2-7b-hf"
model_name_or_path=${DATA_PATH}"/"${model_name}
model_save_path=${MODEL_SAVE_PATH}"/"${model_name}
log_save_path=$LOG_PATH"/"${model_name}"-1epoch.log"
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
    --trust_remote_code True \
    --fp16 \
    --load_in_8bit False \
    --debugs \
    2>&1 | tee $log_save_path

# log_save_path_valid=$LOG_PATH"/"${model_name}"-1epoch-valid.log"
# WANDB_DISABLED=true python -u example/instruction_tuning_pipeline/finetune_qa.py \
#     --model_name_or_path $model_name_or_path \
#     --train_file $TRAIN_FILE \
#     --validation_file $VALID_FILE \
#     --dataset_concatenation \
#     --per_device_train_batch_size 2 \
#     --per_device_eval_batch_size 4 \
#     --do_eval \
#     --num_train_epochs 1 \
#     --logging_steps 100 \
#     --save_total_limit 1 \
#     --log_level info \
#     --save_strategy epoch \
#     --output_dir $model_save_path \
#     --trust_remote_code True \
#     --load_in_8bit False \
#     --resume_peft $model_save_path \
#     --debugs \
#     2>&1 | tee $log_save_path_valid
