# Chapter 5 Robust Estimators in Multiple Regression


---
Atkinson,A.C., Riani,M., Corbellini,A., Perrotta D., and Todorov,V. (2024), Applied Robust Statistics through the Monitoring Approach, Heidelberg: Springer Nature.

# Abstract
 
Results for small $n$ and moderate $p$ show that the size and power of robust tests of regression models can be far from the nominal asymptotic values. This chapter uses simulation to investigate the properties of outlier tests  for moderate sample sizes. Section 5.1 compares the size of outlier tests for 30 very robust estimators, which leads to the selection of five  estimators for comparison  in the next sections: S, MM, LTS and LTSr, the reweighted LTS estimator, together with FS. Section 5.2 compares the sizes of the five test for $n$ from 100 to 1,000 and section 5.3 compares the average  power (the proportion of outliers correctly identified) over a range of values of the outlier shift.  Section 5.4 describes a parametric framework for comparing robust regression estimators. In this a set of outliers is moved along some trajectory in $y,X$ space and the effect on inferences calculated; typically bias and variance of parameter estimates and average power. In all these comparisons all estimators, apart from FS, have fixed, very robust, settings. Monitoring the comparisons is provided in section 5.6 by using the extended BIC (section 4.11) to determine the robustness level at which the properties of the    various estimators are assessed.

# Code to reproduce Figures and Tables in this Chapter



| FileName | Description | Open in MATLAB on line | Jupiter notebook |  |---|---|---|---|  |Effect_Size.m|Size comparison<br/> This file creates Figures 5.5-5.6|[![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=UniprJRC/FigMonitoringBook&file=cap5//Effect_Size.m)| [[ipynb](Effect_Size.ipynb)]|EmpSizeOutliersTest.m|Empirical size of outlier tests,<br/> This file creates Figures 5.1-5.4|[![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=UniprJRC/FigMonitoringBook&file=cap5//EmpSizeOutliersTest.m)| [[ipynb](EmpSizeOutliersTest.ipynb)]