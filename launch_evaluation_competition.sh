#!/bin/bash

TEAM_NAMES=("906team" "Revenge_of_Dream_Hunters" "CARELab" "KajiLab")
DATA_DIR="./data/02results_from_competitors"
# DATA_DIR="./data/03results_from_competitors_reference"

for TEAM_NAME in "${TEAM_NAMES[@]}"; do
        ESTIMATED_TRAJ_DIR=${DATA_DIR}/${TEAM_NAME}/merged/
        EVAL_RESULT_OUTPUT_DIR=${DATA_DIR}/result_${TEAM_NAME}/

        echo "Processing $TEAM_NAME"
        echo "  Trajectory dir: $ESTIMATED_TRAJ_DIR"
        echo "  Result dir: $EVAL_RESULT_OUTPUT_DIR"

        mkdir -p $EVAL_RESULT_OUTPUT_DIR

        # Define a function that uses python3 if available,
        # otherwise falls back to python (for Windows Git Bash)

        if grep -q Microsoft /proc/version 2>/dev/null; then
        # Use python3 if running in a WSL (Linux-like) environment
        PYTHON=python3
        elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
        # Otherwise, use python (e.g., for Windows Git Bash)
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

        $PYTHON evaluation-tools/evaltools/plot_traj.py -ed $ESTIMATED_TRAJ_DIR -gd data/gt/ \
                -t combination_table.csv -o ${EVAL_RESULT_OUTPUT_DIR}
done