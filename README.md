# xDR-Challenge-2025-evaluation


## Setup

### Install
```
git clone --recursive git@github.com:PDR-benchmark-standardization-committee/xDR-Challenge-2025-evaluation.git
cd xDR-Challenge-2025-evaluation
cd evaluation-tools
pip install -e .
```


### Data placement
```
evaluation-tools      : evaluation script (submodule)
launch_evaluation.sh  : exe file for Linux
launch_evaluation.bat : exe file for Windows
create_combination_table.py : gen combination_table.csv (It runs inside the launch_evaluation.sh)
data -
      |
      - map - map_comp2025.bmp        : bitmap (use Obstacle-Error evaluation or Viewer)
      |
      - gt - df_iPhone_{dataname}.csv : Ground Truth
      |
      - destination - exhibit - {dataname} - destE_{dataname}_section{N}.csv : (use relative evaluation)
      |             |
      |             - robot   - {dataname} - destR_{dataname}_section{N}.csv : (use relative evaluation)
      |
      - est - [put your estimated trajectory datas (with {dataname})] : ex) est_{dataname}.csv
```


## Execute evaluations

1.linux or windows(GitBash)
```
cd xDR-Challenge-2025-evaluation
./launch_evaluation.sh
```

2.windows(CMD)
```
cd xDR-Challenge-2025-evaluation
launch_evaluation.bat
```


3.manual command
```
set RESULT_DIR=./data/result/

python create_combination_table.py -e1_f data/est/ -g1_f data/gt/ -e2_f data/destination/ -g2_f data/destination/ -rel_target robot exhibit -o ./

python evaluation-tools/evaltools/do_eval.py -ed data/est/ -gd data/gt/ -t combination_table.csv -o %RESULT_DIR%evaluation_result.csv

python evaluation-tools/evaltools/do_eval_rel.py -ed1 data/est/ -ed2 data/destination/ -gd1 data/gt/ -gd2 data/destination/ -t combination_table.csv -o %RESULT_DIR%evaluation_result_rel.csv

python evaluation-tools/evaltools/show_result.py -m %RESULT_DIR%evaluation_result.csv %RESULT_DIR%evaluation_result_rel.csv -o %RESULT_DIR%

python evaluation-tools/evaltools/plot_ecdf_from_csv.py -m %RESULT_DIR%evaluation_result.csv %RESULT_DIR%evaluation_result_rel.csv -o %RESULT_DIR%
```
OUTPUT : result/evaluation_result.csv result/evaluation_result_rel.csv result/eCDF_***_.png result/eval_summary.json



## Evaluation Metrics

To be filled


### File Naming Conventions for Estimated trajectory
```
 File Search and Matching Procedure:

result = [text for text in files if dataname in text.split('.')[0][-len(dataname)-1:]]

step1. Split the file name at the last period to separate the extension.
step2. Extract the last N characters from the base name.
step3. Compare the extracted string with the target data ID for a match.
```
To ensure reliable mapping between data entries and file names, the following conventions are applied:

 - File names must not contain any periods (.) other than the one before the file extension.

 - The data identifier must appear immediately before the file extension.

 - The data identifier should be of a fixed length (e.g., always 6 characters) to allow for easier parsing and validation.
