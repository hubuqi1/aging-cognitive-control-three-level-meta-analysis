# Non-ceiling accuracy subsets

`dataset_re.csv` contains 11 effect sizes from 10 independent studies for reactive-control accuracy, 95% non-ceiling subset.

`dataset_pro.csv` contains 5 effect sizes from 3 independent studies for proactive-control accuracy, 95% non-ceiling subset.

`dataset_ceiling_effect.xlsx`: Record-level screening information.

Under the 95% criterion, records were classified as showing ceiling effects when mean accuracy in both age groups was at least 95%. The non-ceiling subsets retain assessable records not meeting that criterion; records with unassessable ceiling status are excluded. Use the workbook to trace classification, including the interpretation of error measures in terms of accuracy.

Both CSV subsets retain the primary rA = rD = 0.50 effect-size inputs and their global identifiers. Their y and v values match the corresponding primary accuracy files.

Change the input path, then run only the pooled-effect section of `01_three_level_analysis.R` and the corresponding CR2 overall-effect section of `02_CR2_inference.R`. No separate ceiling-analysis script is needed. Do not run the example task moderator or selection models automatically on these small subsets. Restricting the data by ceiling status does not reconstruct participant-level accuracy distributions.
