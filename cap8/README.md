# Chapter 8: Extensions of the Multiple Regression Model


---
Atkinson,A.C., Riani,M., Corbellini,A., Perrotta D., and Todorov,V. (2024), Applied Robust Statistics through the Monitoring Approach, Heidelberg: Springer Nature.

# Abstract
The chapter explores five extensions to the regression model considered in earlier chapters. Section 8.1 introduces the use of prior knowledge in regression analysis, including the construction of prior distributions from fictitious observations. In section 8.2 Bayesian regression is combined with the FS.  Section 8.3 provides analyses of successive annual sets of  trade data, in which the prior distribution is updated annually. Heteroskedastic regression is introduced in section 8.4. The analysis of trade data makes clear the importance of avoiding models in which the variance goes to zero as $x$ does. Section 8.5 extends the analysis of trade data  to data from several regression lines. The number of groups  is estimated in section 8.5.2  from an FS which starts the search many times from random  points. Regression clustering (section 8.5.3) involves the choice of  parameters and, for robustness, a choice of  trimming level.  The monitoring approach in section 8.5.4 identifies solutions which do not depend on arbitrary choices of these hyper-parameters.  The fourth extension, in section 8.6, is to use monitoring to provide a robust model for short term economic time series that may have strong annual trends. The final extension, in section 8.7, is to regression in which the explanatory variables are the components of a composition or mixture.

# Code to reproduce Figures and Tables in this Chapter



| FileName | Description | Open in MATLAB on line | Jupiter notebook |  |---|---|---|---|  |facemasks.m|Facemasks data<br/> Facemasks: 352 imports of FFP2 and FFP3 masks (product 6307909810) into the European Union extracted in a day of November. This file creates Figures 8.19-8.20, 8.22, 8.26-8.29.|[![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=UniprJRC/FigMonitoringBook&file=cap8//facemasks.m)| [[ipynb](facemasks.ipynb)]