# Chapter 4 The Monitoring Approach in Multiple Regression


---
Atkinson,A.C., Riani,M., Corbellini,A., Perrotta D., and Todorov,V. (2023), Applied Robust Statistics through the Monitoring Approach, Heidelberg: Springer Nature.

# Abstract
 This chapter introduces algorithms for the monitoring approach to robust statistical analysis
 and compares their performance in the analyses of several sets of data. The Forward Search (FS) is introduced
 in \S\ref{cap4:forsea}. This algorithm fits subsets of the data of increasing size in such a way that the most
 outlying observations are included towards the end of the search. To monitor other forms of robust regression,
 we estimate the parameters using, typically, a grid of 50 values of \bd or \efs.  Monitoring plots of residuals,
 parameter estimates and $t$-tests from very robust regression to LS are introduced in \S\ref{cap4:mongen};
 these plots are enriched by brushing and linking to other plots. Frequently, the plots from monitoring residuals
 show an abrupt change from robust to LS analyses. In \S\ref{cap4:empbdp} we introduce the empirical \bd defining
 the most efficient robust estimator for each dataset, thus overcoming the arbitrariness of the conventional
 approach to robust statistics.  Many examples are given in \S\ref{cap4:monprax} for a variety of estimators.
 The chapter concludes in \S\ref{cap4:genbic} with a generalized Bayesian Information Criterion (BIC) for model
 choice which, via the mean shift outlier model, makes it possible to compare models in which different numbers of
 observations have been deleted. 

# Code to reproduce Figures and Tables in this Chapter





| FileName | Description | Open in MATLAB on line | Jupiter notebook |  |---|---|---|---|  |MentalIllness.m|Contaminated illness data.<br/> This file creates Figure 4.33.|[![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=UniprJRC/FigMonitoringBook&file=cap4//MentalIllness.m)| [[ipynb](MentalIllness.ipynb)]|Stars.m|Stars data.<br/> This file creates Figures 4.1-4.4, 4.9-4.11|[![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=UniprJRC/FigMonitoringBook&file=cap4//Stars.m)| [[ipynb](Stars.ipynb)]|SurgicalUnit.m|Surgical Unit data.<br/> This file creates Figures 4.30-4.33.|[![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=UniprJRC/FigMonitoringBook&file=cap4//SurgicalUnit.m)| [[ipynb](SurgicalUnit.ipynb)]|Wool.m|Wool data.<br/> This file creates Figures 4.5-4.8.|[![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=UniprJRC/FigMonitoringBook&file=cap4//Wool.m)| [[ipynb](Wool.ipynb)]