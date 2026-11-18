# Data files and variables

The files contain extracted study summary information and prepared effect-size inputs. They do not contain participant- or trial-level data.

## Folders

`raw/`: Four extraction/calculation workbooks; see [raw/README.md](raw/README.md).

`datasets/`: Four split analysis inputs for each of nine rA/rD settings, plus primary control-mode comparison inputs. See [datasets/README.md](datasets/README.md).

`ceiling/`: Two non-ceiling accuracy subsets and the screening workbook. See [ceiling/README.md](ceiling/README.md).

Analysis CSVs use UTF-8, with a BOM. Read them using `read.csv(path, fileEncoding = "UTF-8-BOM")`. Retain the numerical precision in the supplied files.

## Analysis CSV dictionary

`Author`, `Year`: Study labels.

`sID`: Study identifier and clustering variable. Preserve it when combining outcomes or control modes.

`eID`: Effect-size identifier linking analysis inputs to extraction information.

`y`: Hedges' g. Positive RT indicates longer RT in older adults; positive accuracy indicates higher accuracy in older adults.

`v`: Sampling variance of y, not its standard error.

`RT`, `ACC`, `ER`: Outcome indicators retained in the inputs. Error effects in the accuracy analysis files have already been aligned to the accuracy direction.

`c1`, `c2`: Reactive and proactive control indicators, respectively.

`t1`–`t4`: Stroop, stop-signal, Simon, and Flanker indicators.

`t5`–`t8`: Antisaccade, go/no-go, recent-probes, and AX-CPT indicators.

`t9`–`t11`: Attention network, multi-source interference, and prime-target interference indicators.

`i1`, `i2`: Behavior and Other study-type indicators.

`comp1`, `comp2`: Interference control and response inhibition indicators.

`age`: Mean age of the older group, in years.

`wr`: Proportion of women across younger and older groups combined, on a 0–1 scale.

`rob_patient_selection`, `rob_index_test`, `rob_reference_standard`, `rob_flow_timing`: Original domain-specific risk-of-bias ratings.

`Patient_selection_group`: Patient selection grouped as Low Risk versus Unclear or High Risk, available in the 36 split analysis inputs.


Category indicators use 0/1 coding. Blank entries in moderator fields indicate missing values, not zero. Exclude missing values only for the model requiring that variable. The supplied CSVs are not continuously standardized; apply standardization within each continuous-moderator analysis as illustrated in the scripts.

Do not reverse the accuracy/error effects again. Correlation settings are identified by directory names rather than by adding new independent evidence. These rA/rD assumptions concern effect-size calculations, not a common correlation assigned to every pair of effect sizes within a study.
