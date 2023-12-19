#!/bin/bash
set -x
cd /home/vmagent/app/LLM_datapre/work/e2eAIOK/
data_path="/home/vmagent/app/LLM_datapre/data"

##select model - finetuned model
model_path=$data_path"/llama2_denas_neural_chat_recdp_v2/models/Llama-2-7b-hf_denas-lora_train_recdp_v2_openorca.parquet/merged_model"
##select model - initial llama model
model_path=$data_path"/Llama-2-7b-hf"

train_file=$data_path"/LLM_data/alpaca/alpaca_train_parquet/alpaca_data_train.parquet"
valid_file=$data_path"/LLM_data/alpaca/alpaca_valid_parquet/alpaca_data_valid.parquet"
output_path=$model_path"/analysis/predict"
log_save_path=$output_path"/log"

WANDB_DISABLED=true python -u example/instruction_tuning_pipeline/finetune_clm.py \
    --model_name_or_path $model_path \
    --train_file $train_file \
    --validation_file $valid_file \
    --dataset_concatenation \
    --per_device_eval_batch_size 4 \
    --do_predict \
    --input_sentence "Below is an instruction that describes a task, paired with an input that provides further context. Write a response that appropriately completes the request.\n\n### Instruction:\nCreate a timeline for tasks needed to complete the project.\n\n### Input:\nThis is a project to build a prototype for a mobile app.\n\n### Response:" \
    --output_length_limit 50 \
    --log_level info \
    --output_dir $output_path \
    --trust_remote_code True \
    --load_in_8bit False \
    --debugs \
    2>&1 | tee $log_save_path