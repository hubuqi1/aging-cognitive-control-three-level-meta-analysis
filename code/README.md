# Analysis scripts

Run each script independently from the repository root in R/RStudio. The common example is reactive-control RT at rA = rD = 0.50. Results appear in the console; script 01 also draws a forest plot.

## Three-level and CR2 models

`01_three_level_analysis.R` estimates the overall effect, assesses within- and between-study heterogeneity using likelihood-ratio tests, and reports variance percentages at each of the three levels. It also includes moderator analyses, leave-one-study-out analysis, and a forest plot.

`02_CR2_inference.R` fits its own working models and applies `robust(..., clubSandwich = TRUE)`. Use the sID values from the exact subset fitted in each model. CR2 retains the coefficients and adjusts inference, using the Satterthwaite correction for coefficient tests and the approximate Hotelling's T-squared method for omnibus tests.

Task categories require k ≥ 5, with at least two eligible categories. When changing datasets, update the task filter and `mods` formula. Reference-category alternatives are shown in the script comments.

For continuous moderators, start from the original dataset, remove missing predictor values, standardize y and the predictor, and divide v by the original SD(y) squared.

## Other moderators

1. Proportion of women: use `wr` in place of age in the missing-value filter, predictor standardization, and `mods` formula.

2. Inhibition type: retain `t7 + t9 + t11 == 0 & comp1 + comp2 == 1`; use `mods = ~ comp2`, with interference control as reference.

3. Patient-selection risk of bias: prepare a factor with Low Risk as reference, then use `mods = ~ patient_selection`:

```r
dataset$patient_selection <- relevel(
  factor(dataset$Patient_selection_group), ref = "Low Risk"
)
```

4. Overall control mode: read `control_mode/all_tasks/dataset_rt.csv` or `dataset_acc.csv` under the primary correlation-setting folder. Use `mods = ~ c2`, with reactive control as reference.

5. Within-task control mode: read the corresponding `control_mode/within_tasks/` input and use the same formula. Each control mode must have at least five effect sizes.

Retain the three-level random-effects specification when adapting these models. For the nine correlation settings, repeat the models with the corresponding inputs. For non-ceiling accuracy subsets, run only the overall-effect sections of scripts 01 and 02.

## Selection models

`03_selection_models.R` uses the primary 0.50/0.50 data. The primary model uses `steps = 0.025`; the sensitivity model uses `steps = c(0.025, 0.50)`. Both specify CML, `define_priors()`, percentile confidence intervals, `bootstrap = "two-stage"`, and `R = 1999`. Random seeds are 20261110 and 20261111, respectively.

Use `alternative = "greater"` for RT and `"less"` in both models for accuracy. Retain all effect-size rows and cluster on sID. Selection models use their own bootstrap inference rather than CR2.

The output reports the average effect (`beta`), marginal heterogeneity (`tau2`), and reporting weights (`lambda`, denoted w in the manuscript). The no-effect reference for beta is 0; reporting weights are relative to a fixed reference of 1.
