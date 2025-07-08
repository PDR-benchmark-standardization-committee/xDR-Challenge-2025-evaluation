#!/bin/bash
ESTIMATED_TRAJ_DIR=./data/est/

EVAL_RESULT_OUTPUT_DIR=./data/result/

mkdir -p $EVAL_RESULT_OUTPUT_DIR

# python3 コマンドが使えればそれを使い、
# 使えなければ python コマンドを使う関数定義 (windows git bash想定)

if grep -q Microsoft /proc/version 2>/dev/null; then
  # WSL環境（Linux互換）なら python3 を使う
  PYTHON=python3
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
  # Git BashなどWindows環境なら python を使う
  PYTHON=python
else
  PYTHON=python3
fi

$PYTHON create_combination_table.py -e1_f $ESTIMATED_TRAJ_DIR -g1_f data/gt/ \
                                    -e2_f data/destination/ -g2_f data/destination/ \
                                    -rel_target robot exhibit -o ./

$PYTHON evaluation-tools/evaltools/do_eval.py -ed  $ESTIMATED_TRAJ_DIR -gd data/gt/ \
          -t combination_table.csv -o ${EVAL_RESULT_OUTPUT_DIR}evaluation_result.csv

$PYTHON evaluation-tools/evaltools/do_eval_rel.py -ed1  $ESTIMATED_TRAJ_DIR -ed2 data/destination/ \
        -gd1 data/gt/ -gd2 data/destination/ \
        -t combination_table.csv -o ${EVAL_RESULT_OUTPUT_DIR}evaluation_result_rel.csv

$PYTHON evaluation-tools/evaltools/show_result.py -m ${EVAL_RESULT_OUTPUT_DIR}evaluation_result.csv ${EVAL_RESULT_OUTPUT_DIR}evaluation_result_rel.csv \
        -o $EVAL_RESULT_OUTPUT_DIR

$PYTHON evaluation-tools/evaltools/plot_ecdf_from_csv.py -m ${EVAL_RESULT_OUTPUT_DIR}evaluation_result.csv ${EVAL_RESULT_OUTPUT_DIR}evaluation_result_rel.csv \
        -o $EVAL_RESULT_OUTPUT_DIR