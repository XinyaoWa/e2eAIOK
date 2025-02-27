#!/bin/bash

failed_tests=""
echo "Setup pyrecdp latest package"
pip install -e .[LLM]

python -m unittest tests.test_llmutils_pipelines.Test_LLMUtils_Pipeline

# echo "test_llmutils_pipeline.Test_LLMUtils_Pipeline.test_TextGlobalDeduplicate"
# python -m unittest tests.test_llmutils_pipeline.Test_LLMUtils_Pipeline.test_TextGlobalDeduplicate
# if [ $? != 0 ]; then
#     failed_tests=${failed_tests}"tests.test_llmutils_pipeline.Test_LLMUtils_Pipeline.test_TextGlobalDeduplicate\n"
# fi



# if [ -z ${failed_tests} ]; then
#     echo "All tests are passed"
# else
#     echo "*** Failed Tests are: ***"
#     echo -e ${failed_tests}
#     exit 1
# fi
