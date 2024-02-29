from transformers import AutoTokenizer
import time, os

data_path = "/home/vmagent/app/LLM_datapre/data"
model_name = os.path.join(data_path, "Llama-2-7b-chat-hf")
prompt_path = os.path.join(data_path, "textformat/data/viggo_mul", "prompt_mul")
input_max = os.path.join(data_path, "textformat/data/viggo_mul", "input_max")
str_max = open(prompt_path).read() + open(input_max).read() + "\n##Output##\n"
print(str_max)

tokenizer = AutoTokenizer.from_pretrained(model_name, trust_remote_code=True)
inputs = tokenizer(str_max, return_tensors="pt")
print(inputs)

max_len = inputs["input_ids"].shape
print("max length: ", max_len)
