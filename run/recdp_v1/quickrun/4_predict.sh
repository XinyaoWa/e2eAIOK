#!/bin/bash
set -x
cd /home/vmagent/app/LLM_datapre/work/e2eAIOK/
data_path="/home/vmagent/app/LLM_datapre/data"
#input_Instruction="Create an answer acting like a CEO of Intel."
#input_Input="Your new statement is about keeping up, or superseding Moore's law, over the next decade. Is this something that you think is going to be unique to Intel, or do you think your competitors will also keep pace?"
#input_Instruction="Create an answer acting like a Machine Learning Engineer"
#input_Input="What Is a False Positive and False Negative and How Are They Significant?"
#input_Instruction="Generate an answer acting like a patent lawyer."
#input_Input="Does my company own software developed by an independent contractor?"
#input_Input="What will be the idea to solve this problem?"
#input_Instruction="Answer with codes as a Software Engineer to find if Path Exists in Graph.There is a bi-directional graph with n vertices, where each vertex is labeled from 0 to n - 1 (inclusive). The edges in the graph are represented as a 2D integer array edges, where each edges[i] = [ui, vi] denotes a bi-directional edge between vertex ui and vertex vi. Every vertex pair is connected by at most one edge, and no vertex has an edge to itself. You want to determine if there is a valid path that exists from vertex source to vertex destination. Given edges and the integers n, source, and destination, return true if there is a valid path from source to destination, or false otherwise."
# input_Instruction="A call center has analyzed the calls received in the last month and found that, on average, 24 calls were received per hour. Assume that call arrivals follow Poisson distribution and come from an infinite population. Service times follow an exponential distribution with an average of two minutes per call served. Assume the queue length can be infinite with FCFS discipline."
# input_Input="What is the average number of people in line?"

# input_prompt="Below is an instruction that describes a task, paired with an input that provides further context. Write a response that appropriately completes the request.\n\n### Instruction:\n"${input_Instruction}"\n\n### Input:\n"${input_Input}"\n\n### Response:"

#input_prompt="Below is an instruction that describes a task, paired with an input that provides further context. Write a response that appropriately completes the request.\n\n### Instruction:\nCreate a timeline for tasks needed to complete the project.\n\n### Input:\nThis is a project to build a prototype for a mobile app.\n\n### Response:"

##select model - finetuned model
model_path=$data_path"/llama2_denas_neural_chat_recdp_v2/models/Llama-2-7b-hf_denas-lora_train_recdp_v2_openorca.parquet/merged_model"
##select model - initial llama model
# model_path=$data_path"/Llama-2-7b-hf"

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
    --input_sentence "${input_prompt}" \
    --output_length_limit 50 \
    --log_level info \
    --output_dir $output_path \
    --trust_remote_code True \
    --load_in_8bit False \
    --debugs \
    2>&1 | tee $log_save_path
