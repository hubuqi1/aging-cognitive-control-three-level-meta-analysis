# Step-function selection models: Pustejovsky, Citkowicz, and Joshi (2026).
# Official examples: https://jepusto.github.io/metaselection/
# Run from the code-and-data folder, independently of scripts 01 and 02.

# install.packages("metaselection")
library(metaselection)

# 1. Import one of the four primary-analysis datasets.
# All three scripts use the same example: reactive-control reaction time
# at rA = rD = 0.50 (rt = reaction time; c1 = reactive control).
# y = Hedges' g; v = sampling variance; sID = independent study.
# Keep all effect sizes; cluster = sID accounts for dependence in inference.
dat <- read.csv(
  "data/datasets/rA0.5_rD0.5/datasetall_rA0.5_rD0.5_rt_c1/dataset_rt_c1.csv",
  fileEncoding = "UTF-8-BOM"
)

# 2. Fit the primary three-parameter step-function selection model.
# The parameters describe the average effect, heterogeneity, and selection weight.
# steps = 0.025 separates significant results in the expected direction
# from all remaining results, using one-sided p-values.
# alternative = "greater" specifies the expected positive RT effect.
# For accuracy data, change alternative to "less" in BOTH models below.
set.seed(20261110)
mod_3PSM <- selection_model(
  data = dat,
  yi = y,
  vi = v,
  cluster = sID,
  selection_type = "step",
  steps = 0.025,
  estimator = "CML",         # Composite marginal likelihood.
  priors = define_priors(),  # Default weak penalties to regularize estimation.
  alternative = "greater",
  CI_type = "percentile",    # Percentile bootstrap confidence intervals.
  bootstrap = "two-stage",   # Two-stage cluster bootstrap.
  R = 1999                   # Number of bootstrap resamples.
)

# In the output, beta is the average effect and tau2 is marginal heterogeneity.
# lambda0, lambda1, and lambda2 are the reporting weights (w0, w1, w2 in the paper).
# lambda0 = 1 is the reference for significant results in the expected direction.
# Other weights below 1 indicate lower relative reporting probabilities;
# weights above 1 indicate higher relative reporting probabilities.
# An interval containing 1 remains compatible with equal reporting probabilities.
summary(mod_3PSM)

# 3. Fit the four-parameter model as a sensitivity analysis.
# The additional threshold at 0.50 separates nonsignificant results in the
# expected direction from opposite-direction results, allowing separate weights.
set.seed(20261111)
mod_4PSM <- selection_model(
  data = dat,
  yi = y,
  vi = v,
  cluster = sID,
  selection_type = "step",
  steps = c(0.025, 0.50),
  estimator = "CML",         # Composite marginal likelihood.
  priors = define_priors(),  # Default weak penalties to regularize estimation.
  alternative = "greater",
  CI_type = "percentile",    # Percentile bootstrap confidence intervals.
  bootstrap = "two-stage",   # Two-stage cluster bootstrap.
  R = 1999                   # Number of bootstrap resamples.
)
summary(mod_4PSM)
