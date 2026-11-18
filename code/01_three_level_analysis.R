# Three-level meta-analysis: Assink and Wibbelink (2016).
# https://doi.org/10.20982/tqmp.12.3.p154
# Run the sections in order from the code-and-data folder.

# install.packages("metafor")
library(metafor)

# 1. Import the data.
# All three scripts use the same example: reactive-control reaction time
# at rA = rD = 0.50 (rt = reaction time; c1 = reactive control).
# y = Hedges' g; v = sampling variance; eID = effect size; sID = study.
dataset <- read.csv(
  "data/datasets/rA0.5_rD0.5/datasetall_rA0.5_rD0.5_rt_c1/dataset_rt_c1.csv",
  fileEncoding = "UTF-8-BOM"
)

# 2. Estimate the overall effect by fitting an intercept-only model.
# The random effects represent within-study (Level 2) and between-study
# (Level 3) variance. Sampling variance is represented by v (Level 1).
# tdist = TRUE uses t-tests for coefficients and F-tests for moderators.
overall <- rma.mv(
  y, v,
  random = list(~ 1 | eID, ~ 1 | sID),
  tdist = TRUE,
  data = dataset
)
summary(overall, digits = 3)

# 3. Test the significance of the within-study and between-study variance.
# Fix the Level 2 variance at zero and compare this model with the full model.
modelnovar2 <- rma.mv(
  y, v,
  random = list(~ 1 | eID, ~ 1 | sID),
  sigma2 = c(0, NA),
  tdist = TRUE,
  data = dataset
)
anova(overall, modelnovar2)

# Repeat the likelihood-ratio test with the Level 3 variance fixed at zero.
modelnovar3 <- rma.mv(
  y, v,
  random = list(~ 1 | eID, ~ 1 | sID),
  sigma2 = c(NA, 0),
  tdist = TRUE,
  data = dataset
)
anova(overall, modelnovar3)

# 4. Determine how total variance is distributed over the three levels.
# Calculate the typical sampling variance using the tutorial's formula.
n <- length(dataset$v)
list.inverse.variances <- 1 / dataset$v
sum.inverse.variances <- sum(list.inverse.variances)
squared.sum.inverse.variances <- sum.inverse.variances^2
list.inverse.variances.square <- 1 / dataset$v^2
sum.inverse.variances.square <- sum(list.inverse.variances.square)
numerator <- (n - 1) * sum.inverse.variances
denominator <- squared.sum.inverse.variances - sum.inverse.variances.square
estimated.sampling.variance <- numerator / denominator

# Calculate the proportion of variance at each level.
I2_1 <- estimated.sampling.variance / (estimated.sampling.variance +
                                      overall$sigma2[1] + overall$sigma2[2])
I2_2 <- overall$sigma2[1] / (estimated.sampling.variance +
                            overall$sigma2[1] + overall$sigma2[2])
I2_3 <- overall$sigma2[2] / (estimated.sampling.variance +
                            overall$sigma2[1] + overall$sigma2[2])

# Display the percentages.
amountvariancelevel1 <- I2_1 * 100
amountvariancelevel2 <- I2_2 * 100
amountvariancelevel3 <- I2_3 * 100
amountvariancelevel1
amountvariancelevel2
amountvariancelevel3

# 5. Leave-one-study-out sensitivity analysis.
# Omit one study, including all its effect sizes, and estimate the overall
# effect again. Repeat this for each study to examine its influence.
sensitivity <- data.frame()
for (study in unique(dataset$sID)) {
  dataset_loo <- subset(dataset, sID != study)
  model_loo <- rma.mv(
    y, v,
    random = list(~ 1 | eID, ~ 1 | sID),
    tdist = TRUE,
    data = dataset_loo
  )
  sensitivity <- rbind(sensitivity, data.frame(
    Omitted_sID = study, g = as.numeric(coef(model_loo)),
    SE = model_loo$se, CI_lower = model_loo$ci.lb,
    CI_upper = model_loo$ci.ub, p = model_loo$pval
  ))
}
sensitivity

# 6. Categorical moderator with two categories: study type.
# i1 = Behavior; i2 = Other. Each variable is coded 1 for membership and 0 otherwise.
# Include one dummy variable; the omitted category is the reference category.
dataset_study <- subset(dataset, i1 + i2 == 1)

# Reference-category coding for this two-category moderator:
#   Behavior (i1): mods = ~ i2; the i2 coefficient is Other minus Behavior.
#   Other (i2):    mods = ~ i1; the i1 coefficient is Behavior minus Other.
# The intercept estimates the mean effect for the omitted category.
# Switching the reference changes the intercept and reverses the slope sign,
# but does not change the omnibus F-test or its p-value.
# The intercept estimates the Behavior mean; the coefficient estimates
# the difference between Other and Behavior. The F-test tests study type.
teststudy <- rma.mv(
  y, v,
  mods = ~ i2,
  random = list(~ 1 | eID, ~ 1 | sID),
  tdist = TRUE,
  data = dataset_study
)
summary(teststudy, digits = 3)

# Change the reference category to obtain the Other mean as the intercept.
teststudy2 <- rma.mv(
  y, v,
  mods = ~ i1,
  random = list(~ 1 | eID, ~ 1 | sID),
  tdist = TRUE,
  data = dataset_study
)
summary(teststudy2, digits = 3)

# 7. Categorical moderator with more than two categories: task type.
# This task-moderator example uses the reactive-control RT dataset imported above.
# Include task categories with at least five effect sizes (k >= 5).
# In this dataset, eligible categories are Stroop (t1, k = 15), stop-signal
# (t2, k = 17), Simon (t3, k = 18), and Flanker (t4, k = 19).
# All other task categories have fewer than five effect sizes and are excluded.
# The line below filters the rows: each task variable is coded 0 or 1.
# A sum of 1 keeps a row belonging to t1, t2, t3, or t4; a sum of 0 excludes it.
# This is a filter for the eligible categories listed above, not an automatic k check.
# With another dataset, identify eligible categories and update both the filter
# and the moderator formula. At least two eligible categories are needed.
dataset_task <- subset(dataset, t1 + t2 + t3 + t4 == 1)

# Reference-category coding: include three of the four dummy variables.
# The omitted task is the reference category:
#   Stroop (t1):      mods = ~ t2 + t3 + t4
#   Stop-signal (t2): mods = ~ t1 + t3 + t4
#   Simon (t3):       mods = ~ t1 + t2 + t4
#   Flanker (t4):     mods = ~ t1 + t2 + t3
# To obtain the Simon or Flanker mean, rerun the task model below using
# the corresponding formula above, keeping dataset_task unchanged.
# In each model, the intercept is the reference-category mean; each slope
# is the corresponding category mean minus the reference-category mean.
# Changing the reference changes these coefficients, but not the omnibus F-test.
# Stroop (t1) is the reference category. The intercept estimates its mean.
# Each coefficient compares one task with Stroop. The omnibus F-test
# tests all three coefficients jointly to examine the task moderator.
testtasktype1 <- rma.mv(
  y, v,
  mods = ~ t2 + t3 + t4,
  random = list(~ 1 | eID, ~ 1 | sID),
  tdist = TRUE,
  data = dataset_task
)
summary(testtasktype1, digits = 3)

# Change the reference category from Stroop to stop-signal (t2).
# Omit t2 from mods; the intercept now estimates the stop-signal mean.
# Each coefficient compares its task with stop-signal. The omnibus F-test
# remains unchanged because the data and task categories are the same.
testtasktype2 <- rma.mv(
  y, v,
  mods = ~ t1 + t3 + t4,
  random = list(~ 1 | eID, ~ 1 | sID),
  tdist = TRUE,
  data = dataset_task
)
summary(testtasktype2, digits = 3)

# 8. Continuous moderator: mean age of the older group.
# Remove missing ages, then standardize age and effect size to mean 0 and SD 1.
# Divide v by SD(y)^2 so sampling variances are on the standardized scale.
dataset_age <- subset(dataset, !is.na(age))
dataset_age$v <- dataset_age$v / sd(dataset_age$y)^2
dataset_age$y <- as.numeric(scale(dataset_age$y))
dataset_age$age <- as.numeric(scale(dataset_age$age))
# The coefficient is the change in effect size (in SD units) associated
# with a one-SD increase in mean age of the older group.
# Age is continuous, so it has no categorical reference group.
# After standardization, age = 0 represents the mean age in dataset_age.
# The intercept estimates the standardized effect at that mean age.
# The slope estimates the change in standardized effect for a one-SD increase
# in age; its test examines whether this linear association differs from zero.
# For proportion of women, use wr instead of age in the missing-value filter,
# predictor standardization, and mods formula, starting again from dataset.
age <- rma.mv(
  y, v,
  mods = ~ age,
  random = list(~ 1 | eID, ~ 1 | sID),
  tdist = TRUE,
  data = dataset_age
)
summary(age, digits = 3)

# 9. Draw a forest plot of the observed effect sizes and the overall effect.
forest(
  overall,
  slab = paste(dataset$Author, dataset$Year),
  xlab = "Hedges' g",
  header = c("Study", "g [95% CI]"),
  mlab = "Overall effect"
)
