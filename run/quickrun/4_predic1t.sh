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

input_prompt="You will be provided an article about the finace report for a company. After reading, you are asked to come up with 50 question-answer pairs. These question-answer pairs will be given to a GPT model and we will evaluate the GPT model for completing the questions.


Here are the requirements:
1. All the question-answer pairs should contains two parts: "question" and "answer". The question field should contains a question realted to the article, while the answer  should be the answer to this questions.
2. Try not to repeat the verb for each question to maximize diversity.
3. The type of questions should be diverse. The list should include diverse types of tasks like summary, answer the information mentioned in the article,  analysis about the data listed in the table, etc.
4. A GPT language model should be able to answer the question. For example, do not ask the assistant to create any visual or audio output.
5. The language should be in English.
6. The questions and answers should both be 1 to 2 sentences long and no more than 100 words. Either an imperative sentence or a question is permitted.
7. The answer should be an appropriate response to the question.
8. All the information should be related to the article provided, either the direct inforamtion or the extended analysis or summary.

Here is two examples:
1. Question: Please give a summary for the Business Highlights part.###\n Answer: Intel is on track to achieve its 2025 goals, including five nodes in four years and leadership in transistor performance. Intel 4, the company's first extreme ultraviolet (EUV) technology node, is in high-volume manufacturing. The opening of Fab 34 in Ireland contributes to a resilient supply chain, and Intel plans facilities in Germany and Poland. Installation of the world's first high-NA EUV tool in Oregon is part of infrastructure expansion. Intel submitted major manufacturing proposals in the U.S., with a customer commitment accelerating plans for chip factories in Arizona. The company emphasizes AI accessibility across its hardware products and outlines progress in processors and accelerators. \n
2. Question: How much is the "Total current assets" in "Consolidated Condensed Balance Sheets", and what percentage of the "Total assets" does it account for? ###\n Answer: The "Total current assets" in "Consolidated Condensed Balance Sheets" is $43,811, account for 23.2% of the "Total assets".

Above are the requirements, below is the article, after reading, remember to generate 50 diverse question-answer pairs.

Intel Corporation
2200 Mission College Blvd.
Santa Clara, CA 95054-1549
                                                         
News Release
 Intel Reports Third -Quarter 2023  Financial Results
NEWS SUMMARY
•Third -quarter revenue of $14.2 billion , down 8%  year over year (YoY). 
•Third -quarter earnings per share (EPS) attributable to Intel was $0.07 ; non-GAAP EPS attributable to Intel was 
$0.41 .
•Third-quarter revenue exceeded high end of guidance  and EPS benefited from strong operating leverage and 
expense discipline; company achieved key milestones across process and product, foundry  and artificial 
intelligence (AI).
•Guiding fourth-quarter revenue of $14.6 billion to $15.6 billion, EPS attributable to Intel of $0.23  and non-GAAP 
EPS attributable to Intel of $0.44 .
SANTA CLARA, Calif., Oct. 26, 2023 – Intel Corporation today reported third-quarter 2023  financial results. 
“We delivered a standout third quarter, underscored by across-the-board progress on our process and product 
roadmaps, agreements with new foundry customers, and momentum as we bring AI everywhere,” said Pat 
Gelsinger, Intel CEO. “We continue to make meaningful progress on our IDM 2.0 transformation by relentlessly 
advancing our strategy, rebuilding our execution engine and delivering on our commitments to our customers.”
David Zinsner, Intel CFO, said, “Our results exceeded expectations for the third consecutive quarter,  with revenue 
above the high end of our guidance and EPS benefiting from strong operating leverage and expense discipline. As 
demonstrated by our recent portfolio actions, we are highly focused on being great allocators of our owners’ capital 
and unlocking value for shareholders.”
Q3 2023  Financial Highlights
GAAP Non-GAAP
 Q3 2023 Q3 2022 vs. Q3 2022 Q3 2023 Q3 2022 vs. Q3 2022
Revenue ($B) $14.2 $15.3 down 8%
Gross Margin 42.5% 42.6% down 0.1 ppt 45.8% 45.9% down 0.1 ppt
R&D and MG&A ($B) $5.2 $6.0 down 14% $4.6 $5.4 down 15%
Operating Margin (0.1)% (1.1)% up 1 ppt 13.6% 10.8% up 2.8 ppts
Tax Rate 696.2% 642.0% n/m* 13.0% 13.0% —
Net Income (loss) 
Attributable to Intel ($B)$0.3 $1.0 down 71% $1.7 $1.5 up 14%
Earnings (loss) Per Share 
Attributable to Intel—
Diluted$0.07 $0.25 down 72% $0.41 $0.37 up 11%
In the third quarter, the company generated $5.8 billion  in cash from operations and paid dividends of $0.5 billion . Exhibit 99.1
* Not meaningful.
Full reconciliations between GAAP and non-GAAP measures are provided below. 
Business Unit Summary
Intel previously announced the organizational change to integrate its Accelerated Computing Systems and Graphics 
Group into its Client Computing Group and Data Center and AI Group. This change is intended to drive a more 
effective go-to-market capability and to accelerate the scale of these businesses, while also reducing costs. As a 
result, the company modified its segment reporting in the first quarter of 2023 to align to this and certain other 
business reorganizations. All prior-period segment data has been retrospectively adjusted to reflect the way the 
company internally receives information and manages and monitors operating segment performance starting in 
fiscal year 2023.
Business Unit Revenue and Trends Q3 2023 vs. Q3 2022
Client Computing Group (CCG) $7.9 billion down 3%
Data Center and AI (DCAI) $3.8 billion down 10%
Network and Edge (NEX) $1.5 billion down 32%
Mobileye $530 million up18%
Intel Foundry Services (IFS) $311 million up299%
Business Highlights
▪Intel remains on track to meet its goal of achieving five nodes in four years and to regain transistor 
performance and power performance leadership by 2025. Along with Intel 7, Intel 4, the company’s first 
node using extreme ultraviolet (EUV) technology, is now in high-volume manufacturing. Intel also achieved 
a critical milestone on Intel 18A with the release of the 0.9 PDK. In addition, Intel announced one of the 
industry’s first glass substrates for next-generation advanced packaging, planned for the latter part of this 
decade. This breakthrough achievement will enable the continued scaling of transistors in a package and 
advance Moore’s Law to deliver data-centric applications.
▪Continuing its investment in manufacturing capacity to create a geographically balanced, secure and 
resilient supply chain, Intel opened Fab 34 in Leixlip, Ireland, during the quarter. Combined with the 
company’s planned wafer fabrication facility in Magdeburg, Germany, and planned assembly and test facility 
in Wrocław, Poland, this will help create a first-of-its-kind, end-to-end leading-edge semiconductor 
manufacturing value chain in Europe. 
▪This week, Intel shared its plans to begin installation of the world’s first high-NA EUV tool for commercial 
use by the end of the year to continue the company's modernization and infrastructure expansion of the 
Gordon Moore Park at Ronler Acres in Oregon, one of the world’s leading semiconductor innovation and 
productization centers.
▪Intel has submitted all four of its major manufacturing proposals in Arizona, New Mexico, Ohio and Oregon, 
representing more than $100 billion of U.S. manufacturing and research investments, to the U.S. 
Department of Commerce’s CHIPS Program Office .
▪Intel announced that a major customer committed to Intel 18A and Intel 3 with a meaningful pre-payment, 
allowing the company to accelerate its plans to build two new leading-edge chip factories at its Ocotillo 
campus in Chandler,  Arizona. In addition, IFS and Tower Semiconductor announced an agreement where 
Intel will provide foundry services and 300 mm manufacturing capacity to help Tower serve its customers 
globally, utilizing Intel’s advanced manufacturing facility in New Mexico. 
▪At Intel Innovation 2023, Intel outlined its strategy to bring AI everywhere, making it more accessible across 
all workloads, from client and edge to network and cloud. The company showed how it is delivering AI 
capabilities across its hardware products and making it accessible through open multi-architecture software 
solutions.
▪I n  D C A I ,  I n t e l ' s  4 t h   G e n  I n t e l ®  X e o n ®  S c a l a b l e  p r o c e s s o r  c o n t i n u e s  i t s  s t r o n g  r a m p ,  w i t h  t h e  w o r l d ’ s  t o p - 1 0  
cloud service providers now deploying it in general availability. In addition, the company's 5th Gen Inte l® 
Xeon® processor, code-named Emerald Rapids , is in production and began shipping to customers this 
month, officially launching Dec. 14. Customer momentum continues with Intel® Gaudi®2 accelerators, 
whose competitive performance was recently validated by MLCommons benchmarking results. Together 
with Stability AI, Intel is building one of the world's largest AI supercomputers entirely on 4th Gen  Intel Xeon 
Scalable  processors and 4,000 Intel Gaudi2 AI accelerators. Intel/Page 2
▪In client computing, Intel is ushering in the age of the AI PC with Intel® Core™ Ultra processors, code-
named Meteor Lake. Built on Intel 4, the Intel Core Ultra processor began shipping  to customers in the third 
quarter and will officially launch Dec. 14, along with the 5th Gen Intel Xeon processor . Earlier this month, 
Intel launched the new Intel® Core®  14th Generation desktop processor family, delivering the world’s 
fastest desktop frequencies and best desktop experience for enthusiasts.
▪In network and edge, Intel launched  the latest OpenVINO™ toolkit version 2023.1, the AI inferencing and 
deployment runtime of choice for developers on client and edge platforms, with ai.io and Fit:match 
demonstrating how they use OpenVINO to accelerate their applications at Intel Innovation.  
▪Mobileye achieved record third-quarter revenue, growing 18% year over year, and announced meaningful 
design wins for its advanced SuperVision and Chauffeur solutions with automakers FAW and Polestar.
As Intel continues to look for innovative ways to unlock value for shareholders, the company recently announced its 
intent to separate its Programmable Solutions Group (PSG) operations into a standalone business. This will give 
PSG the autonomy and flexibility it needs to fully accelerate its growth and more effectively compete in the FPGA 
industry. The company may explore opportunities with private investors to accelerate the business’s growth, with 
Intel retaining a majority stake. Over the next two to three years, Intel intends to conduct an IPO for PSG.
In the third quarter, Intel also agreed to sell a 10% stake in its IMS Nanofabrication business (IMS) to TSMC, valuing 
IMS at approximately $4.3 billion, consistent with the valuation of the recent stake sale to Bain Capital Special 
Situations. Together, these transactions underscore Intel’s focus on advancing its IDM 2.0 strategy, driving growth in 
its core businesses and creating value for shareholders across all of its assets.
Q4 2023 Dividend
The company's board of directors declared a quarterly dividend of $0.125 per share on the company’s common 
stock, which will be payable Dec. 1, 2023, to shareholders of record as of Nov. 7, 2023.
Business Outlook
Intel's guidance for the fourth  quarter of 2023 includes both GAAP and non-GAAP estimates. Reconciliations 
between GAAP and non-GAAP financial measures are included below.*
Q4 2023 GAAP* Non-GAAP*
Revenue $14.6-15.6 billion $14.6-15.6 billion^
Gross Margin 43.3% 46.5%
Tax Rate 5% 13%
Earnings (Loss) Per Share Attributable to Intel—Diluted $0.23 $0.44
^ No adjustment on a non-GAAP basis.
Actual results may differ materially from Intel’s Business Outlook as a result of, among other things, the factors 
described under “Forward-Looking Statements” below. The g ross margin and EPS outlook are based on the mid-
point of the revenue range.
*Effective January 2023, Intel increased the estimated useful life of certain production machinery and equipment from five years to eight years. 
When compared to the estimated useful life in place as of the end of 2022, Intel expects total depreciation expense in 2023 to be reduced by 
$4.2 billion . Intel expects this change will result in an approximately $2.5 billion  increase to gross margin, a $400 million  decrease in R&D 
expenses and a $1.3 billion  decrease in ending inventory values. 
Earnings Webcast
Intel will hold a public webcast at 2 p.m. PDT today to discuss the results for its third-quarter 2023 . The live public 
webcast can be accessed on Intel's Investor Relations website at www.intc.com . The corresponding earnings 
presentation and webcast replay will also be available on the site.Intel/Page 3
Forward-Looking Statements
This release contains forward-looking statements that involve a number of risks and uncertainties."

##select model - finetuned model
# model_path=$data_path"/llama2_denas_neural_chat_recdp_v2/models/Llama-2-7b-hf_denas-lora_train_recdp_v2_openorca.parquet/merged_model"
##select model - initial llama model
# model_path=$data_path"/Llama-2-7b-hf"
model_path=$data_path"/neural-chat-7b-v3"

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
    --output_length_limit 1000 \
    --log_level info \
    --output_dir $output_path \
    --trust_remote_code True \
    --load_in_8bit False \
    --debugs \
    2>&1 | tee $log_save_path
