# Robust variance estimation (RVE): Assink and Wibbelink (2024), Listing 6.
# https://doi.org/10.20982/tqmp.20.1.p001
# See also Cheung (2019): https://doi.org/10.1007/s11065-019-09415-6
# Run independently from the code-and-data folder.

# install.packages("metafor")
# install.packages("clubSandwich")
library(metafor)
library(clubSandwich)

# 1. Import the data.
# All three scripts use the same example: reactive-control reaction time
# at rA = rD = 0.50 (rt = reaction time; c1 = reactive control).
# y = Hedges' g; v = sampling variance; eID = effect size; sID = study.
dataset <- read.csv(
  "data/datasets/rA0.5_rD0.5/datasetall_rA0.5_rD0.5_rt_c1/dataset_rt_c1.csv",
  fileEncoding = "UTF-8-BOM"
)

# Fit each three-level working model, then apply RVE to that model.
# cluster = sID groups effect sizes from the same study.
# clubSandwich = TRUE applies the CR2 estimator with a bias-reduced
# linearization adjustment. Coefficients remain unchanged; standard errors,
# confidence intervals, and tests are adjusted.
# Coefficient t-tests use the Satterthwaite correction; omnibus F-tests
# use the approximate Hotelling's T-squared distribution.

# 2. Overall effect.
# Fit an intercept-only three-level working model.
overall <- rma.mv(
  y, v,
  random = list(~ 1 | eID, ~ 1 | sID),
  tdist = TRUE,
  data = dataset
)

# Apply RVE and display the results.
overall_rve <- robust(
  overall,
  cluster = dataset$sID,
  clubSandwich = TRUE
)
summary(overall_rve, digits = 3)

# 3. Study type: a categorical moderator with two categories.
# i1 = Behavior; i2 = Other. Retain records belonging to one category.
dataset_study <- subset(dataset, i1 + i2 == 1)

# Reference-category coding for this two-category moderator:
#   Behavior (i1): mods = ~ i2; the i2 coefficient is Other minus Behavior.
#   Other (i2):    mods = ~ i1; the i1 coefficient is Behavior minus Other.
# The intercept estimates the mean effect for the omitted category.
# Switching the reference changes the intercept and reverses the slope sign,
# but does not change the omnibus F-test or its p-value.

# With Behavior as the reference, the intercept estimates the Behavior mean.
# The i2 coefficient compares Other with Behavior; the F-test tests study type.
teststudy <- rma.mv(
  y, v,
  mods = ~ i2,
  random = list(~ 1 | eID, ~ 1 | sID),
  tdist = TRUE,
  data = dataset_study
)

teststudy_rve <- robust(
  teststudy,
  cluster = dataset_study$sID,
  clubSandwich = TRUE
)
summary(teststudy_rve, digits = 3)

# Change the reference category to estimate the Other mean as the intercept.
teststudy2 <- rma.mv(
  y, v,
  mods = ~ i1,
  random = list(~ 1 | eID, ~ 1 | sID),
  tdist = TRUE,
  data = dataset_study
)

teststudy2_rve <- robust(
  teststudy2,
  cluster = dataset_study$sID,
  clubSandwich = TRUE
)
summary(teststudy2_rve, digits = 3)

# 4. Task type: a categorical moderator with more than two categories.
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
# After changing the formula, refit the working model and apply robust()
# to that fitted model with cluster = dataset_task$sID, as shown below.

# Stroop is the reference category; the intercept estimates its mean.
# Each coefficient compares one task with Stroop. The omnibus F-test
# jointly tests all three task coefficients.
testtasktype1 <- rma.mv(
  y, v,
  mods = ~ t2 + t3 + t4,
  random = list(~ 1 | eID, ~ 1 | sID),
  tdist = TRUE,
  data = dataset_task
)

testtasktype1_rve <- robust(
  testtasktype1,
  cluster = dataset_task$sID,
  clubSandwich = TRUE
)
summary(testtasktype1_rve, digits = 3)

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

testtasktype2_rve <- robust(
  testtasktype2,
  cluster = dataset_task$sID,
  clubSandwich = TRUE
)
summary(testtasktype2_rve, digits = 3)

# 5. Mean age of the older group: a continuous moderator.
# Remove missing ages, then standardize effect size and age to mean 0 and SD 1.
# Rescale v using the original SD(y), before standardizing y.
dataset_age <- subset(dataset, !is.na(age))
dataset_age$v <- dataset_age$v / sd(dataset_age$y)^2
dataset_age$y <- as.numeric(scale(dataset_age$y))
dataset_age$age <- as.numeric(scale(dataset_age$age))

# Fit the three-level meta-regression working model.
# The age coefficient is the change in effect size, in SD units,
# associated with a one-SD increase in mean age of the older group.
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

# Apply RVE and display the results.
age_rve <- robust(
  age,
  cluster = dataset_age$sID,
  clubSandwich = TRUE
)
summary(age_rve, digits = 3)
