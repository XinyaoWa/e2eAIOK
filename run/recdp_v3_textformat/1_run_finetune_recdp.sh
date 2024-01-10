#!/bin/bash
set -x

DATA_PATH="/home/vmagent/app/LLM_datapre/data/"
model_name="Llama-2-7b-chat-hf"
model_name_or_path=${DATA_PATH}"/"${model_name}
TRAIN_FILE=$DATA_PATH"/textformat/data/viggo_recdp/train.parquet"
VALID_FILE=$DATA_PATH"/textformat/data/viggo_recdp/valid.parquet"
prompt_file_viggo_textformat=$DATA_PATH"/textformat/data/viggo_recdp/prompt_textformat"

MODEL_SAVE_PATH=$DATA_PATH"/textformat/models/viggo_recdp/models"
model_save_path=${MODEL_SAVE_PATH}"/"${model_name}"-lora"
LOG_PATH=$DATA_PATH"/textformat/models/viggo_recdp/log"
log_save_path=$LOG_PATH"/"${model_name}"-lora-1epoch.log"
log_save_path_valid=$LOG_PATH"/"${model_name}"-lora-1epoch-valid.log"
log_save_path_merge=$LOG_PATH"/"${model_name}"-lora-1epoch-merge.log"
mkdir -p $LOG_PATH $MODEL_SAVE_PATH

WANDB_DISABLED=true python -u example/instruction_tuning_pipeline/finetune_clm.py \
    --model_name_or_path $model_name_or_path \
    --train_file $TRAIN_FILE \
    --prompt_type viggo_textformat \
    --prompt_file_viggo_textformat $prompt_file_viggo_textformat \
    --max_seq_length 1067 \
    --per_device_train_batch_size 1 \
    --gradient_accumulation_steps 8 \
    --do_train \
    --learning_rate 1e-4 \
    --num_train_epochs 1 \
    --logging_steps 100 \
    --save_total_limit 1 \
    --log_level info \
    --save_strategy epoch \
    --output_dir $model_save_path \
    --peft lora \
    --trust_remote_code True \
    --fp16 \
    --load_in_8bit True \
    2>&1 | tee $log_save_path

WANDB_DISABLED=true python -u example/instruction_tuning_pipeline/finetune_clm.py \
    --model_name_or_path $model_name_or_path \
    --train_file $TRAIN_FILE \
    --validation_file $VALID_FILE \
    --prompt_type viggo_textformat \
    --prompt_file_viggo_textformat $prompt_file_viggo_textformat \
    --max_seq_length 1067 \
    --per_device_train_batch_size 1 \
    --per_device_eval_batch_size 1 \
    --do_eval \
    --logging_steps 100 \
    --save_total_limit 1 \
    --log_level info \
    --output_dir $model_save_path \
    --peft lora \
    --trust_remote_code True \
    --load_in_8bit False \
    --resume_peft $model_save_path \
    2>&1 | tee $log_save_path_valid

WANDB_DISABLED=true python -u example/instruction_tuning_pipeline/finetune_clm.py \
    --model_name_or_path $model_name_or_path \
    --train_file $TRAIN_FILE \
    --validation_file $VALID_FILE \
    --prompt_type viggo_textformat \
    --prompt_file_viggo_textformat $prompt_file_viggo_textformat \
    --max_seq_length 1067 \
    --per_device_train_batch_size 1 \
    --per_device_eval_batch_size 1 \
    --do_eval \
    --logging_steps 100 \
    --save_total_limit 1 \
    --log_level info \
    --output_dir $model_save_path \
    --peft lora \
    --trust_remote_code True \
    --fp16 \
    --load_in_8bit False \
    --resume_peft $model_save_path \
    --save_merged_model True \
    2>&1 | tee $log_save_path_merge