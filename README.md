# xDR-Challenge-2025-evaluation

## Evaluation criteria

The evaluation criteria of the xDR Challenge is as follows. Score 100 is the maximum points which completely matches to the ground truth.
The competitors are asked to maximize the score (minimize error).

### 1) Pick one summary value per criterion

From each time series / sample set, extract a single number called **`eval_value`** according to **stat**:

* `stat = median` → use the median
* `stat = percentile` → use the *q*-th percentile (e.g., 95 → 95th percentile)

*Example:* For `ce`, use the **95th percentile** of the position error as `eval_value`.

The table for actual values are as follows.

| criteria     | stat       |  percentile | best(100)-score value | zero-score value | weight | note | 
| ------------- | ---------- | -: | --: | ---: | -----: | -- |
| `ce`          | percentile | 95 |   0 |   10 m (approximately half width of the field) |    1/7 | Only evaluate time window with VISO |
| `he`          | median | – |   0 |  π/2 rad (leads to wrong turn-by-turn navigation)|    1/7 | |
| `eag`         | median | – |   0 |    0.25 m/s (cannot even reach to first location) |    1/7 | Only evaluate timw window without VISO|
| `rda_robot`   | median | - |   0 |    1 m (not able to reach by hand) |    1/7 | Only evaluate when approaching to the robot |
| `rpa_robot`   | median | - |   0 |  π rad (not able to reach by hand) |    1/7 | Only evaluate when approaching to the robot |
| `rda_exhibit` | median | - |   0 |    1 m (not able to reach by hand)|    1/7 | Only evaluate when approacing/experiencing exhibit |
| `rpa_exhibit` | median | - |   0 |  π rad (not able to reach by hand) |    1/7 | Only evaluate when approacing/experiencing exhibit |

---

### 2) Convert that value to a 0–100 score (lower-is-better)

Let **best(100)-score value** be `best` and **zero-score value** be `zero`.
Compute:

```
score = 100 × (zero − eval_value) / (zero − best)
```

* If `eval_value = best`, the score is **100**; if `eval_value = zero`, the score is **0**.
* Values outside the range are **not clipped** (they can go below 0 or above 100).
* This assumes “smaller is better” (`best < zero`).
  If a metric were “larger is better,” flip the formula:

  ```
  score = 100 × (eval_value − zero) / (best − zero)
  ```

---

### 3) Overall (Competition) score

Sum the weighted per-criterion scores:

```
Total = Σ_i ( weight_i × score_i )
```

In your table all `weight = 1/7`, so the **overall score equals the average** of the seven criterion scores.

---

### 4) Numerical examples

* **`ce`**: 95th-percentile error `eval_value = 4.0 m`

  `best = 0`, `zero = 10` →

  `score = 100 × (10 − 4) / (10 − 0) = 60`

* **`he`**: median heading error `eval_value = 0.40 rad`

  `best = 0`, `zero = π/2 ≈ 1.571` →

  `score ≈ 100 × (1.571 − 0.40) / 1.571 ≈ 74.5`

* **Overall contribution** (each weight = 1/7):

  `ce`: `60 × 1/7 ≈ 8.57`

  `he`: `74.5 × 1/7 ≈ 10.64`

  Add the other five criteria similarly to get **Total**.

You will find the score in the result/eval_summary.json and result/Score_graph.png.


## Evaluation tool setup

### Install
```
git clone --recursive git@github.com:PDR-benchmark-standardization-committee/xDR-Challenge-2025-evaluation.git
cd xDR-Challenge-2025-evaluation
cd evaluation-tools
pip install -e .
```


### Data placement
For competition participants, the data including `gt` and `destination` will be provided by box link. Please unzip and place in following directory structure.

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

If you want to compare several trajectories, you can select [which folder you want to evaluate](https://github.com/PDR-benchmark-standardization-committee/xDR-Challenge-2025-evaluation/blob/0a26602375b059969c07afffa8227f74281554cc/launch_evaluation.sh#L2) and [which folder you want to output the results](https://github.com/PDR-benchmark-standardization-committee/xDR-Challenge-2025-evaluation/blob/0a26602375b059969c07afffa8227f74281554cc/launch_evaluation.sh#L4).


### Running evaluation on an example
Let's run the evaluaon on [the example](https://github.com/PDR-benchmark-standardization-committee/xdr-challenge-2025-examples).
By running the example 2-6, you will get df_est_001.csv, which is the estimated results.
```
cd xdr-challenge-2025-examples/02_realtime_sample
python 06demo_location_estimate_pdr.py onlinedemo/ http://127.0.0.1:5000/evaalapi/ output/df_est_001.csv
```
Copy the df_est_001.csv into data/est/df_est_001.csv.

```
cp output/df_est_001.csv <path_to_this_repo>/data/est/
```
And run the evaluation.

```
cd <path_to_this_repo> # e.g. cd ~/workspace/xDR-Challenge-2025-evaluation
./launch_evaluation.sh
```

Then you will get result in the `data/result` folder.

### Example results of evaluation
`eval_summary.json` shows statistical values for metrics and total score (tentative) for xDR Challenge 2025.

```eval_summary.json
{
    "ca_x_RCS": {
        "avg": -1.5561634648773182,
        "median": -0.2205001756219832,
        "min": -19.14661049381735,
        "max": 22.628515374464605,
        "per50": -0.2205001756219832,
        "per75": 0.7963232431447023,
        "per90": 7.6387075250533245,
        "per95": 9.370129351858303
    },
    ... ( omitted ) ...
    "rpa_robot": {
        "avg": 1.5269713691979958,
        "median": 1.449279654669375,
        "min": 0.0072481898293466,
        "max": 3.1391562409705767,
        "per50": 1.449279654669375,
        "per75": 2.2588727395631905,
        "per90": 2.5931434973813148,
        "per95": 2.888715382184116
    },
    "Score": 6.677171480642467
}
```

Each entry in the json dictionary means each evaluation metrics and their statistical values, and eCDF_*.png shows eCDF of each metrics.

`Score_graph.png` shows ingredients of the `Score` in `eval_summary.json`.
Left graph shows raw values of each metrics in the score, right graph shows weighted values of each metrics. Sum of the right graph's values becomes the final score.
![Score_graph](https://github.com/user-attachments/assets/4e577e70-fd0e-412e-8cac-75a45ee24d24)



## Execute evaluations in different environments

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



## Evaluation metrics

To be finalized


### File naming conventions for estimated trajectory
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
