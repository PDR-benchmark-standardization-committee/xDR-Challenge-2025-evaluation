
@echo off
set ESTIMATED_TRAJ_DIR=.\data\est\
set EVAL_RESULT_OUTPUT_DIR=.\data\result\

REM Create the directory if it does not exist
if not exist "%EVAL_RESULT_OUTPUT_DIR%" (
    mkdir "%EVAL_RESULT_OUTPUT_DIR%"
)

python create_combination_table.py -e1_f %ESTIMATED_TRAJ_DIR% -g1_f data/gt/ ^
                                    -e2_f data/destination/ -g2_f data/destination/ ^
                                    -rel_target robot exhibit -o ./

python evaluation-tools/evaltools/do_eval.py -ed %ESTIMATED_TRAJ_DIR% -gd data/gt/ ^
          -t combination_table.csv -o %EVAL_RESULT_OUTPUT_DIR%evaluation_result.csv

python evaluation-tools/evaltools/do_eval_rel.py -ed1 %ESTIMATED_TRAJ_DIR% -ed2 data/destination/ ^
        -gd1 data/gt/ -gd2 data/destination/ ^
        -t combination_table.csv -o %EVAL_RESULT_OUTPUT_DIR%evaluation_result_rel.csv

python evaluation-tools/evaltools/show_result.py -m %EVAL_RESULT_OUTPUT_DIR%evaluation_result.csv %EVAL_RESULT_OUTPUT_DIR%evaluation_result_rel.csv ^
        -o %EVAL_RESULT_OUTPUT_DIR%

python evaluation-tools/evaltools/plot_ecdf_from_csv.py -m %EVAL_RESULT_OUTPUT_DIR%evaluation_result.csv %EVAL_RESULT_OUTPUT_DIR%evaluation_result_rel.csv ^
        -o %EVAL_RESULT_OUTPUT_DIR%