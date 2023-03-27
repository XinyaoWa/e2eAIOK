import torch
import json
from torch import nn
from torch.nn import CrossEntropyLoss
from transformers import AutoModel, AutoConfig, AutoModelForCausalLM

layer_dict_gpt2 = {
    ".0.":".0.",
    ".1.":".2.",
    ".2.":".4.",
    ".3.":".6.",
    ".4.":".8.",
    ".5.":".9.",
    ".6.":".10.",
    ".7.":".11.",
}

layer_dict_gptj = {
    ".0.":".0.",
    ".1.":".2.",
    ".2.":".4.",
    ".3.":".6.",
    ".4.":".8.",
    ".5.":".10.",
    ".6.":".12.",
    ".7.":".15.",
    ".8.":".17.",
    ".9.":".19.",
    ".10.":".21.",
    ".11.":".23.",
    ".12.":".25.",
    ".13.":".27.",
}

class SuperHFModel(AutoModel):

    @classmethod
    def set_sample_config(cls, pretrained_model_name_or_path, **kwargs):
        is_pretrained = kwargs.pop("is_pretrained", True)
        # Create the candidate net with random initialization
        candidate_hf_config = AutoConfig.from_pretrained(pretrained_model_name_or_path, **kwargs)
        candidate_hf = cls.from_config(candidate_hf_config)

        if is_pretrained:
            # Create the super net
            super_hf = cls.from_pretrained(pretrained_model_name_or_path)
            # Load pre-trained weight from super net
            candidate_hf_state_dict = candidate_hf.state_dict()
            super_hf_state_dict = super_hf.state_dict()

            new_candidate_hf_state_dict = {}
            for k in candidate_hf_state_dict:
                super_hf_state = super_hf_state_dict[k]
                candidate_hf_state = super_hf_state
                for dim, size in enumerate(candidate_hf_state_dict[k].size()):
                    candidate_hf_state = candidate_hf_state.index_select(dim, torch.tensor(range(size)))
                new_candidate_hf_state_dict[k] = candidate_hf_state
            candidate_hf.load_state_dict(new_candidate_hf_state_dict)

        return candidate_hf

    @classmethod
    def search_space_generation(cls, pretrained_model_name_or_path, **kwargs):
        hf_config = AutoConfig.from_pretrained(pretrained_model_name_or_path)
        search_space = {}
        search_space["num_hidden_layers"] = list(range(int(hf_config.num_hidden_layers/2), int(hf_config.num_hidden_layers), 1))
        search_space["num_attention_heads"] = list(range(int(hf_config.num_attention_heads/2), int(hf_config.num_attention_heads), 1))
        search_space["hidden_size"] = list(range(int(hf_config.hidden_size/2), int(hf_config.hidden_size), 16))
        for k in kwargs:
            if 'max' not in kwargs[k]:
                raise ValueError("Please specify the up bound of {} in search space".format(k))
            search_range = {"min": int(kwargs[k]['max']/2), "max": int(kwargs[k]['max']), "step": 1}
            if 'min' in kwargs[k]:
                search_range["min"] = int(kwargs[k]["min"])
            if 'step' in kwargs[k]:
                search_range["step"] = int(kwargs[k]["step"])
            search_space[k] = list(range(search_range["min"], search_range["max"], search_range["step"]))
        return search_space

class SuperHFModelForCausalLM(AutoModelForCausalLM):
    @classmethod
    def set_sample_config(cls, pretrained_model_name_or_path, layermap_model=None,**kwargs):
        is_pretrained = kwargs.pop("is_pretrained", True)
        # Create the candidate net with random initialization
        candidate_hf_config = AutoConfig.from_pretrained(pretrained_model_name_or_path, **kwargs)
        candidate_hf = cls.from_config(candidate_hf_config)

        if is_pretrained:
            # Create the super net
            super_hf = cls.from_pretrained(pretrained_model_name_or_path)
            # Load pre-trained weight from super net
            candidate_hf_state_dict = candidate_hf.state_dict()
            super_hf_state_dict = super_hf.state_dict()

            new_candidate_hf_state_dict = {}
            for k in candidate_hf_state_dict:
                k_super = k
                if layermap_model is not None and k.startswith("transformer.h"):
                    if layermap_model == "gpt2":
                        layer_dict = layer_dict_gpt2
                    elif layermap_model == "gptj":
                        layer_dict = layer_dict_gptj
                    else:
                        layer_dict = None
                    if layer_dict is not None:
                        for idx in layer_dict:
                            if idx in k:
                                k_super = k.replace(idx, layer_dict[idx])
                super_hf_state = super_hf_state_dict[k_super]
                candidate_hf_state = super_hf_state
                for dim, size in enumerate(candidate_hf_state_dict[k].size()):
                    candidate_hf_state = candidate_hf_state.index_select(dim, torch.tensor(range(size)))
                new_candidate_hf_state_dict[k] = candidate_hf_state
            candidate_hf.load_state_dict(new_candidate_hf_state_dict)
        return candidate_hf