DATA_PATH="/home/vmagent/app/LLM_datapre/data/llama2_denas_neural_chat_random_baseline/models/Llama-2-7b-hf_denas-lora_train_sample.parquet"
save_name="llama2-denas"

cd /home/vmagent/app/LLM_datapre/work/lm-evaluation-harness
#llama2-ssf-qa
python main.py \
    --model hf-causal-experimental \
    --model_args pretrained=$DATA_PATH/merged_model,use_accelerate=True,trust_remote_code=True \
    --tasks truthfulqa_mc  --num_fewshot 0 \
    --batch_size auto --max_batch_size 32 \
    --output_path $DATA_PATH/$save_name-qa-gpu

#llama2-ssf-arc
python main.py \
    --model hf-causal-experimental \
    --model_args pretrained=$DATA_PATH/merged_model,use_accelerate=True,trust_remote_code=True \
    --tasks arc_challenge  --num_fewshot 25 \
    --batch_size auto --max_batch_size 32 \
    --output_path $DATA_PATH/$save_name-arc-gpu

#llama2-ssf-hellaswag
python main.py \
    --model hf-causal-experimental \
    --model_args pretrained=$DATA_PATH/merged_model,use_accelerate=True,trust_remote_code=True \
    --tasks hellaswag  --num_fewshot 10 \
    --batch_size auto --max_batch_size 32 \
    --output_path $DATA_PATH/$save_name-hellaswag-gpu

#llama2-ssf-mmlu
python main.py \
    --model hf-causal-experimental \
    --model_args pretrained=$DATA_PATH/merged_model,use_accelerate=True,trust_remote_code=True \
    --tasks hendrycksTest*  --num_fewshot 5 \
    --batch_size auto --max_batch_size 32 \
    --output_path $DATA_PATH/$save_name-mmlu-gpu

cd /home/vmagent/app/LLM_datapre/work/e2eAIOK/run/evaluate_benchmark
bash cal_avg_acc.sh $DATA_PATH/$save_name-mmlu-gpu