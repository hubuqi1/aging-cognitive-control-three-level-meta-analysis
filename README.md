# Age-related differences in reactive and proactive cognitive control

Summary data and R code for a three-level meta-analysis comprising 185 effect sizes from 95 studies.

Repository: [aging-cognitive-control-three-level-meta-analysis](https://github.com/hubuqi1/aging-cognitive-control-three-level-meta-analysis)

## Files

`code/` contains three annotated R scripts. `data/raw/` contains extraction and calculation workbooks; `data/datasets/` contains the nine correlation settings and primary control-mode comparison inputs; `data/ceiling/` contains the non-ceiling accuracy subsets. These are study summary data, not participant- or trial-level records.

File descriptions and variable definitions are provided in [data/README.md](data/README.md). Instructions for adapting the models are in [code/README.md](code/README.md).

## Installation and use

Software versions: R 4.5.1, metafor 5.0.1, clubSandwich 0.7.0, and metaselection 0.3.0.

```r
install.packages(c("metafor", "clubSandwich", "metaselection"))
```

1. Set the R working directory to the repository root, containing `code/` and `data/`.
2. Open a script in RStudio and run its sections in order. All three scripts run independently and use reactive-control RT at rA = rD = 0.50 as the example.
3. Results appear in the console; script 01 also draws a forest plot. To run a complete script and display its results, use:

```r
source("code/01_three_level_analysis.R", print.eval = TRUE)
```

## Analysis scripts

1. `01_three_level_analysis.R` estimates the overall effect, assesses within- and between-study heterogeneity using likelihood-ratio tests, and reports variance percentages at each of the three levels. It also includes moderator analyses, leave-one-study-out analysis, and a forest plot.

2. `02_CR2_inference.R` independently fits the same overall and moderator models and applies CR2 inference, clustering by study.

3. `03_selection_models.R` fits the three-parameter primary selection model and four-parameter sensitivity model using CML, default weak penalties, and percentile confidence intervals from 1,999 two-stage cluster-bootstrap resamples.

The scripts provide reusable analysis examples; the extraction and calculation workbooks document the preparation of the CSV inputs.

## Selecting data

Change the input path in `read.csv()` to select an outcome, control mode, or correlation setting. For example:

```text
data/datasets/rA0.5_rD0.5/datasetall_rA0.5_rD0.5_acc_c2/dataset_acc_c2.csv
```

`rt` and `acc` denote reaction time and accuracy; `c1` and `c2` denote reactive and proactive control. Positive effects indicate longer RT or higher accuracy in older adults. Error effects in the accuracy inputs are already sign-reversed. Preserve the supplied `sID` and `eID` identifiers.

For task moderation, update both the category filter and the `mods` formula when changing datasets. Include task categories with k ≥ 5 and at least two eligible categories. The current reactive RT example includes Stroop, stop-signal, Simon, and Flanker. Continuous-moderator analyses standardize y and the predictor within the relevant subset and rescale v accordingly.

## Sensitivity and supplementary analyses

The nine combinations of rA and rD in {0.30, 0.50, 0.70} represent alternative assumptions for the same studies. Reuse scripts 01 and 02 with the corresponding inputs. Control-mode comparisons use the categorical-moderator specification described in [code/README.md](code/README.md).

Selection models use only the primary 0.50/0.50 inputs. Keep `alternative = "greater"` for RT; use `"less"` in both models for accuracy. Both models specify `R = 1999`.

For the non-ceiling accuracy subsets, use `data/ceiling/dataset_re.csv` and `dataset_pro.csv` and run only the overall-effect sections of scripts 01 and 02. Screening details are in [data/ceiling/README.md](data/ceiling/README.md).

## Methodological sources

Assink & Wibbelink (2016), [Fitting three-level meta-analytic models in R](https://doi.org/10.20982/tqmp.12.3.p154).

Assink & Wibbelink (2024), [Addressing dependency in meta-analysis](https://doi.org/10.20982/tqmp.20.1.p001).

Cheung (2019), [A guide to conducting a meta-analysis with non-independent effect sizes](https://doi.org/10.1007/s11065-019-09415-6).

Pustejovsky, Citkowicz, & Joshi (2026), step-function selection models with dependent effects; see the [metaselection documentation](https://jepusto.github.io/metaselection/) and [source code](https://github.com/jepusto/metaselection).
