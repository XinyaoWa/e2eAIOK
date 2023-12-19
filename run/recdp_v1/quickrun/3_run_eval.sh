DATA_PATH="/home/vmagent/app/LLM_datapre/data/llama2_denas_mix_metric_v1/models/Llama-2-7b-hf_denas-lora_mix_metric_v1_3.parquet"
save_name="llama2-denas"

cd /home/vmagent/app/LLM_datapre/work/lm-evaluation-harness
python main.py \
    --model hf-causal-experimental \
    --model_args pretrained=$DATA_PATH/merged_model,use_accelerate=True,trust_remote_code=True \
    --tasks truthfulqa_mc  --num_fewshot 0 \
    --batch_size auto --max_batch_size 32 \
    --output_path $DATA_PATH/$save_name-qa-gpu

python main.py \
    --model hf-causal-experimental \
    --model_args pretrained=$DATA_PATH/merged_model,use_accelerate=True,trust_remote_code=True \
    --tasks arc_challenge  --num_fewshot 25 \
    --batch_size auto --max_batch_size 32 \
    --output_path $DATA_PATH/$save_name-arc-gpu

python main.py \
    --model hf-causal-experimental \
    --model_args pretrained=$DATA_PATH/merged_model,use_accelerate=True,trust_remote_code=True \
    --tasks hellaswag  --num_fewshot 10 \
    --batch_size auto --max_batch_size 32 \
    --output_path $DATA_PATH/$save_name-hellaswag-gpu

python main.py \
    --model hf-causal-experimental \
    --model_args pretrained=$DATA_PATH/merged_model,use_accelerate=True,trust_remote_code=True \
    --tasks hendrycksTest*  --num_fewshot 5 \
    --batch_size auto --max_batch_size 32 \
    --output_path $DATA_PATH/$save_name-mmlu-gpu

cd /home/vmagent/app/LLM_datapre/work/e2eAIOK/run/evaluate_benchmark
bash cal_avg_acc.sh $DATA_PATH/$save_name-mmlu-gpu > $DATA_PATH/$save_name-mmlu-gpu-avg

