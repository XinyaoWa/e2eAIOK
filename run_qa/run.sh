bash run_qa/run_finetune_llama_denas.sh
python run_qa/generate.py > run_qa/log/generate
bash run_qa/run_finetune_llama_denas_nomax.sh
python run_qa/generate_nomax.py > run_qa/log/generate_nomax