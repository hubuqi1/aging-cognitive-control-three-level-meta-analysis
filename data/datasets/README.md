# Analysis datasets for nine correlation settings

This directory contains nine combinations of r_A and r_D, each taking values of 0.30, 0.50 and 0.70. The primary setting is `rA0.5_rD0.5`.

## Directory structure

Each correlation-setting directory contains four subdirectories and four CSV files. For example:

1. `rA0.5_rD0.5/datasetall_rA0.5_rD0.5_rt_c1/dataset_rt_c1.csv` contains reactive-control RT data.

2. `rA0.5_rD0.5/datasetall_rA0.5_rD0.5_acc_c1/dataset_acc_c1.csv` contains reactive-control accuracy data.

3. `rA0.5_rD0.5/datasetall_rA0.5_rD0.5_rt_c2/dataset_rt_c2.csv` contains proactive-control RT data.

4. `rA0.5_rD0.5/datasetall_rA0.5_rD0.5_acc_c2/dataset_acc_c2.csv` contains proactive-control accuracy data.

The other eight settings follow the same naming convention. There are 36 split analysis CSV files across the nine settings. Five additional primary-setting CSV files support control-mode comparisons.

`dataset_rt_c1.csv` contains 79 effect sizes from 63 studies for reactive-control reaction time.

`dataset_acc_c1.csv` contains 43 effect sizes from 37 studies for reactive-control accuracy.

`dataset_rt_c2.csv` contains 39 effect sizes from 36 studies for proactive-control reaction time.

`dataset_acc_c2.csv` contains 24 effect sizes from 21 studies for proactive-control accuracy.

Every correlation setting covers 185 unique effect-size IDs from 95 studies. Study counts must not be added across the four files because a study can contribute to more than one dataset. The nine settings use the same evidence under different assumed correlations; they are not independent sets of studies.

## Input conventions

Files are UTF-8 CSVs with a byte-order mark (BOM). In R, use `read.csv(path, fileEncoding = "UTF-8-BOM")`.

`y` is Hedges' g, and `v` is its sampling variance.

Positive reaction-time effects indicate higher reaction-time values in older adults. Positive accuracy effects indicate higher accuracy in older adults.

Error outcomes have already been sign-reversed and included in the accuracy files. Do not reverse them again.

Global `sID` and `eID` values are retained. Preserve the same `sID` when combining datasets for control-mode comparisons.

Task, inhibition-type, study-type and risk-of-bias coding are retained from the analysis inputs. `comp1` and `comp2` are already included.

`rob_patient_selection` retains the original Low Risk, Unclear Risk or High Risk rating. `Patient_selection_group` contains Low Risk versus Unclear or High Risk for moderator analysis. Patient-selection moderator analyses were subsequently completed for all nine correlation settings using the same model specification.

`wr` denotes the proportion of women across the younger and older groups combined, coded from 0 to 1. It corresponds to "proportion of women" in the manuscript.

Blank moderator entries indicate missing data, not zero. Exclude missing values only from the moderator model requiring that variable.

These are the full split datasets before model-specific task filtering and continuous-moderator standardization. Perform those steps in the analysis scripts; separate filtered or standardized datasets are unnecessary.

Use only the primary 0.50/0.50 setting for the selection-model publication-bias analyses.

## Dataset preparation

All nine settings retain the global study and effect-size identifiers. `Patient_selection_group` combines Unclear Risk and High Risk for moderator analysis while preserving the original domain ratings in `rob_patient_selection`. Differences in y and v across correlation settings reflect the corresponding assumptions used in effect-size calculation.

## Primary control-mode comparison inputs

These additional files are under `rA0.5_rD0.5/control_mode/`:

`all_tasks/dataset_rt.csv` contains 118 effect sizes from 80 studies for All-task RT: 79 reactive-control effects and 39 proactive-control effects.

`all_tasks/dataset_acc.csv` contains 67 effect sizes from 52 studies for All-task accuracy: 43 reactive-control effects and 24 proactive-control effects.

`within_tasks/dataset_Stroop_rt.csv` contains 30 effect sizes from 26 studies for Stroop RT: 15 reactive-control effects and 15 proactive-control effects.

`within_tasks/dataset_Flanker_rt.csv` contains 24 effect sizes from 19 studies for Flanker RT: 19 reactive-control effects and 5 proactive-control effects.

`within_tasks/dataset_Stroop_acc.csv` contains 19 effect sizes from 16 studies for Stroop accuracy: 9 reactive-control effects and 10 proactive-control effects.

Each within-task file has at least five effects in both control modes. Use `c2` as the binary moderator with reactive control as the reference. Preserve sID when combining control modes. The y and v entries in these auxiliary files match the corresponding primary split inputs. These five files are supplied for the primary setting; other correlation settings can combine the corresponding split inputs using the same identifiers.
