python run_clm_no_trainer.py \
    --model_name_or_path /home/vmagent/app/e2eaiok/xinyao/gptj-xy/data \
    --teacher_model_name_or_path /home/vmagent/app/data/LLM/gpt2/finetune \
    --layermap_model gptj \
    --is_denas \
    --seed 12345 \
    --is_transferrable \
    --alpha_ce 1.0 --alpha_mlm 0.0 --alpha_clm 0.5 --alpha_mse 0.0 --alpha_cos 10.0 \
    --freeze_pos_embs \
    --dataset_name wikitext \
    --learning_rate 5e-4 \
    --dataset_config_name wikitext-2-raw-v1 \
    --per_device_train_batch_size 4 \
    --per_device_eval_batch_size 4 \
    --output_dir /home/vmagent/app/data/LLM/gpt2/gpt2-denas/distillion \
    --report_to none \
    --num_train_epochs 4 \
    --eval_interval 100

