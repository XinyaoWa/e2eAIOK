from transformers import AutoTokenizer, AutoModelForCausalLM
import numpy as np
import torch

model_name = "/home/vmagent/app/LLM_datapre/data/QA_dataset/report_qa_nomax/models/Llama-2-7b-hf_denas-lora/merged_model/"
# model_name = "/home/vmagent/app/LLM_datapre/data/QA_dataset/report_qa/models/Llama-2-7b-hf/merged_model/"
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

tokenizer = AutoTokenizer.from_pretrained(model_name, trust_remote_code=True)
model = AutoModelForCausalLM.from_pretrained(model_name, trust_remote_code=True).to(device)

prompts = ["Which business unit experienced the highest revenue increase in Q4 2022?", \
            "How did Intel's total liabilities change from 2021 to 2022?", \
            "What was the total change in Intel's accounts receivable from 2021 to 2022?", \
            "What was the adjusted free cash flow for the three months and the year ended December 31, 2022?"]
for prompt in prompts:
    inputs = tokenizer(prompt, return_tensors="pt").to(device)

    outputs = model.generate(**inputs, max_new_tokens=200, return_dict_in_generate=True)
    input_length = inputs.input_ids.shape[1]
    generated_tokens = outputs.sequences[:, input_length:]
    output = tokenizer.decode(generated_tokens[0])
    print("==============================")
    print(prompt)
    print("==============================")
    print(output)
