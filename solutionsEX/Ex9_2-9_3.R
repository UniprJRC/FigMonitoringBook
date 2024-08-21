## Analysis of air pollution and mortality data (also II)
#
# This file creates Figures A.59-A.64 (output of Exercise 9.2)
# A.65-A.66 and Table A.21 (output of Exercise 9.3)

##==============================================================================
##
##  Air pollution data
##
##  Ramsey, F. L. and Schafer, D.W. (2013). The Statistical Sleuth: A Course in Methods
##      of Data Analysis (3rd ed). Cengage Learning.
##
##  R package Sleuth3 on CRAN
##  -------------------------
##  See also:
##      Samprit Chatterjee and Ali S. Hadi
##      Regression Analysis By Example
##      Section 11.14, pp. 318
##      http://www1.aucegypt.edu/faculty/hadi/RABE5/
##
##  See also: Smuckler and Yohai (2017)
##

prin <- TRUE        # whether to save the figures to disk as PDF files

library(pracma)     # for tictoc
library(Sleuth3)    # for the data set
library(glmnet)
library(corrplot)   # for the correlation plot
library(ggplot2)
library(ggrepel)    # for the labels in the diagnostic plots
library(latex2exp)  # for TeX() - Latex in ggplot graphs
library(viridis)

## df <- read.table("P320-1.txt", header=TRUE)
## dim(df)
## head(df)

## Load the data set from package Sleuth3 and save it as a csv file
data(ex1217, package="Sleuth3")
air_pollution <- ex1217

##  The observations are ordered by Mortality.
plot(1:nrow(air_pollution), air_pollution$Mortality)

##  Remove the first column which contains the city name and set it as
##  row names. Save the data as a text file.
row.names(air_pollution) <- air_pollution[,1]
air_pollution <- air_pollution[,-1]
write.csv(air_pollution, file="air_pollution.csv")

##==============================================================================
##  1. Perform some preliminary data analysis by visualizing the correlations
##
##  Create Figure A.59 (alternarive, in the book is a figure created by MATLAB)
##
corr <- cor(air_pollution)
corrplot(corr)

if(prin) {
    pdf(file="cap9-air-pollution-corrplot.pdf", width=7.5, height=7.5)
    corrplot(corr)
    dev.off()
}

##  Prepare the data for regression
##  Use the function model.matrix to extract the X-matrix
##  Remove the first column which contains 1s (for the intercept)
##
air_pollution <- read.csv("air_pollution.csv", row.names=1)
x <- model.matrix(Mortality~., data=air_pollution)[, -1]
dim(x)
head(x)
y <- air_pollution$Mortality

## Take logarithms from the pollution variables
x[,"HC"] <- log(x[,"HC"])
x[,"NOX"] <- log(x[,"NOX"])
x[,"SO2"] <- log(x[,"SO2"])


##=============================================================================
##  2. Perform classical ridge regression and LASSO and compare the models
##

##==============================================================================
##  Ceate Fig. A.60
##
##  Coefficients path plots for ridge regression and LASSO 
##
##  Right panel: ridge regession
ridge1 <- glmnet(x, y, alpha=0)
plot(ridge1, xvar="lambda", cex.lab=1.4)

if(prin) {
    pdf(file="cap9-air-pollution-coefficients-ridge.pdf", width=7.5, height=7.5)
    plot(ridge1, xvar="lambda", cex.lab=1.4)
    dev.off()
}

##  Left panel panel: lASSO
lasso1 <- glmnet(x, y, alpha=1)
plot(lasso1, xvar="lambda", cex.lab=1.4)

if(prin) {
    pdf(file="cap9-air-pollution-coefficients-lassox.pdf", width=7.5, height=7.5)
    plot(lasso1, xvar="lambda", cex.lab=1.4)
    dev.off()
}

##==============================================================================
##  Create Figure A.61
##
##  Cross-validated estimate of mean-squared prediction error together with 
##  upper and lower standard deviation curves, as a function of the penalty 
##  parameter lambda (on a log scale).

set.seed(67890)
## Perform cross validation for Ridge regression
ridge_cv = cv.glmnet(x, y, alpha=0)
coef(ridge_cv)

(min_lambda = ridge_cv$lambda.min)
ridge = glmnet(x, y, alpha=0, lambda=min_lambda)
length(which(ridge$beta != 0))
(v_ridge <- row.names(ridge$beta)[which(ridge$beta != 0)])

## Perform cross validation for classical LASSO
lasso_cv = cv.glmnet(x, y, family="gaussian", alpha=1)
coef(lasso_cv)

(min_lambda = lasso_cv$lambda.min)
(best_lambda = lasso_cv$lambda.1se)
lasso_min = glmnet(x, y, family="gaussian", alpha=1, lambda=min_lambda)
length(which(lasso_min$beta != 0))
(v_lasso_min <- row.names(lasso_min$beta)[which(lasso_min$beta != 0)])

lasso_1se = glmnet(x, y, family="gaussian", alpha=1, lambda=best_lambda)
length(which(lasso_1se$beta != 0))
(v_lasso_1se <- row.names(lasso_1se$beta)[which(lasso_1se$beta != 0)])

##  Left panel: LASSO
df <- data.frame(lambda=log(lasso_cv$lambda), 
    cvm=lasso_cv$cvm, low=lasso_cv$cvlo, 
    upper=lasso_cv$cvup, nzero=lasso_cv$nzero)

gg <- ggplot(df, aes(x=lambda, y=cvm)) +
    geom_point(color="#cb4154") + 
    geom_ribbon(aes(ymin=low, ymax=upper), alpha=0.2) + 
    geom_vline(xintercept=log(c(lasso_cv$lambda.min, lasso_cv$lambda.1se)), 
        linetype="dotted", linewidth=1.0) + 
    theme_bw() +
        theme(plot.title=element_text(size=14, face="bold", hjust=0.5),
              axis.title=element_text(size=14,face="bold")) +
        ##ggtitle(TeX(r"( $\gamma^2 = \alpha^2 + \beta^2$ )") ) +
        ggtitle(TeX(r"( LASSO  )") ) +
        xlab(TeX(r"( $log(\lambda)$ )") ) +
        ylab("Mean-Squared Error")
gg

if(prin) {
    pdf(file="cap9-air-pollution-crossval-lasso.pdf", width=7.5, height=5)
    print(gg)
    dev.off()
}

##  Right panel: ridge regression
##
df <- data.frame(lambda=log(ridge_cv$lambda), 
    cvm=ridge_cv$cvm, low=ridge_cv$cvlo, 
    upper=ridge_cv$cvup, nzero=ridge_cv$nzero)

gg <- ggplot(df, aes(x=lambda, y=cvm)) +
    geom_point(color="#cb4154") + 
    geom_ribbon(aes(ymin=low, ymax=upper), alpha=0.2) + 
    geom_vline(xintercept=log(c(ridge_cv$lambda.min, ridge_cv$lambda.1se)), 
        linetype="dotted", linewidth=1.0) + 
    theme_bw() +
        theme(plot.title=element_text(size=14, face="bold", hjust=0.5),
              axis.title=element_text(size=14,face="bold")) +
        ##ggtitle(TeX(r"( $\gamma^2 = \alpha^2 + \beta^2$ )") ) +
        ggtitle(TeX(r"( Ridge regression  )") ) +
        xlab(TeX(r"( $log(\lambda)$ )") ) +
        ylab("Mean-Squared Error")
gg

if(prin) {
    pdf(file="cap9-air-pollution-crossval-ridge.pdf", width=7.5, height=5)
    print(gg)
    dev.off()
}

##==============================================================================
## Check what happens if we add to the model one of the two other highly 
##  correlated polution variables: HC or NOX
##
varlist_1se <- c("Precip",   "Educ",     "NonWhite", "SO2")
varlist_1se <- rownames(lasso_1se$beta)[which(lasso_1se$beta != 0)]

x_1se <- x[, varlist_1se]
(lm_1se <- lm(y~x_1se))

## Add one of the two highly correlated polution variables to the varlist: HC
x_1seHC <- x[, c(varlist_1se, "HC")]
(lm_1seHC <- lm(y~x_1seHC))

## The result does not change (HC is not significant, the coeficient estimates of 
##  the other bariables remain the same, R2 remains the same, the adjusted R2 
##  slightly decreases)
summary(lm_1se)
summary(lm_1seHC)

##=============================================================================
##  3. Perform sparse LTS and compare to the classical LASSO
##

library(robustHD)
library(parallel)   ## Create parallel cluster
detectCores(logical = FALSE)
cluster <- makeCluster(10)
clusterExport(cluster, "sparseLTS")

##==============================================================================
##  Create Fig. A.62
##  Coefficients path for Sparse LTS
##
lambda <- seq(0.01, 0.5, length.out = 50)
fit_BIC25 <- sparseLTS(x, y, lambda = lambda, mode = "fraction", crit = "BIC")

gg <- plot(fit_BIC25, labels=NA) + theme_bw(base_size=18) +
    scale_color_viridis(discrete=TRUE, option="viridis") +
    theme(plot.title=element_text(face="bold", hjust=0.5),
          axis.title=element_text(face="bold")) +
    ##ggtitle(TeX(r"( $\gamma^2 = \alpha^2 + \beta^2$ )") ) +
    ggtitle(TeX(r"( Sparse LTS $(bdp=0.25)$ )") ) +
    xlab(TeX(r"( $\lambda$ )") )
gg

if(prin) {
    pdf(file="cap9-air-pollution-sparseLTS-25-coef.pdf", width=7.5, height=5)
    print(gg)
    dev.off()
}

##==============================================================================
##  Create Fig. A.63
##

tic()
lambda <- seq(0.01, 0.5, length.out = 50)
fit25 <- sparseLTS(x, y, alpha=0.75, lambda=lambda, mode="fraction", crit="PE",
                 splits = foldControl(K=10, R=10), seed=20210507, cl=cluster)
toc()

##  elapsed time is 174.200000 seconds

tic()
lambda <- seq(0.01, 0.5, length.out = 50)
fit50 <- sparseLTS(x, y, alpha=0.50, lambda=lambda, mode="fraction", crit="PE",
                 splits = foldControl(K=10, R=10), seed=20210507, cl=cluster)
toc()

##  elapsed time is 194.630000 seconds 

save(fit25, fit50, file="air-pollution-sparseLTS.rda")

##==============================================================================
## to save time - load previously computed fit25 and fit50 models
##

load(file="air-pollution-sparseLTS.rda")

##  Left panel: bdp=0.25
##
df <- data.frame(lambda=log(fit25$tuning), 
    cvm=fit25$pe$reweighted, low=fit25$pe$reweighted-fit25$se$reweighted, 
    upper=fit25$pe$reweighted+fit25$se$reweighted)
(lambda.min <- fit25$tuning[which.min(fit25$pe$reweighted),1])
(lambda.1se <- fit25$tuning[fit25$best[1],1])
    
gg <- ggplot(df, aes(x=lambda, y=cvm)) +
    geom_point(color="#cb4154") + 
    geom_ribbon(aes(ymin=low, ymax=upper), alpha=0.2) + 
    ##scale_x_reverse() +
    geom_vline(xintercept=log(c(lambda.min, lambda.1se)), linetype="dotted", linewidth=1) + 
    theme_bw(base_size=18) +
        theme(plot.title=element_text(face="bold", hjust=0.5),
              axis.title=element_text(face="bold")) +
        ##ggtitle(TeX(r"( $\gamma^2 = \alpha^2 + \beta^2$ )") ) +
        ggtitle(TeX(r"( Sparse LTS: $bdp=0.25$ )") ) +
        xlab(TeX(r"( $log(\lambda)$ )") ) +
        ylab("RTMSPE")
gg

if(prin) {
    pdf(file="cap9-air-pollution-sparseLTS-25-PE.pdf", width=7.5, height=5)
    print(gg)
    dev.off()
}

df <- data.frame(lambda=log(fit50$tuning), 
    cvm=fit50$pe$reweighted, low=fit50$pe$reweighted-fit50$se$reweighted, 
    upper=fit50$pe$reweighted+fit50$se$reweighted)
(lambda.min <- fit50$tuning[which.min(fit50$pe$reweighted),1])
(lambda.1se <- fit50$tuning[fit50$best[1],1])
    
gg <- ggplot(df, aes(x=lambda, y=cvm)) +
    geom_point(color="#cb4154") + 
    geom_ribbon(aes(ymin=low, ymax=upper), alpha=0.2) + 
    ##scale_x_reverse() +
    geom_vline(xintercept=log(c(lambda.min, lambda.1se)), linetype="dotted", linewidth=1) + 
    theme_bw(base_size=18) +
        theme(plot.title=element_text(face="bold", hjust=0.5),
              axis.title=element_text(face="bold")) +
        ##ggtitle(TeX(r"( $\gamma^2 = \alpha^2 + \beta^2$ )") ) +
        ggtitle(TeX(r"( Sparse LTS: $bdp=0.50$ )") ) +
        xlab(TeX(r"( $log(\lambda)$ )") ) +
        ylab("RTMSPE")
gg

if(prin) {
    pdf(file="cap9-air-pollution-sparseLTS-50-PE.pdf", width=7.5, height=5)
    print(gg)
    dev.off()
}

##==============================================================================
## Check what happens if we add to the model one of the two other highly 
##  correlated polution variables: HC or NOX
##
(lambda.min <- fit25$tuning[which.min(fit25$pe$reweighted),1])      # 0.674232
(lambda.1se <- fit25$tuning[fit25$best[1],1])                       # 1.059507

fit <- sparseLTS(x, y, alpha=0.75, lambda=lambda.1se)
varlist_1se <- coef(fit)[which(coef(fit) != 0)]         # get the beta
varlist_1se <- varlist_1se[-1]                          # remove the intercept

x_1se <- x[, varlist_1se]
(lts_1se <- ltsReg(y~x_1se))

## Add one of the two highly correlated polution variables to the varlist: HC
x_1seHC <- x[, c(varlist_1se, "HC")]
(lts_1seHC <- ltsReg(y~x_1seHC))

## The result does not change (HC is not significant, the coeficient estimates of 
##  the other bariables remain the same, R2 remains the same, the adjusted R2 
##  slightly decreases)
summary(lts_1se)
summary(lts_1seHC)

##  If we add one of the other two (highly correlated) polution variables (NOX or HC) 
##  to the model the result does not change (the estimated coefficient of the newly 
##  added variable is not significant, R-squared and adjusted R-squared slightly decrease)

##=============================================================================
##  4. Are there outliers in the data? What is their effect?
##
##  Diagnostic plots (for bdp=25%)
##    'arg' should be one of “all”, “rqq”, “rindex”, “rfit”, “rdiag”

##  Create Fig. A.64
##

ff <- sparseLTS(x, y, alpha=0.75, lambda=1.059507)

##  Set the random seed befor ethe call to setupDiagnosticPlot.sparseLTS(), beacuse
##  subsecuqnt calls to MCD could produce different solutions (and thus different rd-distances).
##  Use the same seed before the call to plot(..., which+"rdiag") 
set.seed(2345)

objx <- robustHD:::setupDiagnosticPlot.sparseLTS(ff)
iout <- which(abs(objx$data$residual) > sqrt(qchisq(0.975, 1)))     # vertical outliers
ird <- which(objx$data$rd > objx$q[1,1])                            # leverage points
igood <- ird[which(!(ird %in% iout))]                               # good leverage points

## vertical outliers
xout <- objx$data[iout,]
xout$names <- as.character(xout$index) #rownames(xout)

## good leverage points
yout <- objx$data[igood,]
yout$names <- as.character(yout$index) #rownames(yout)

## Choose the colors: from RColorBrewer (qualitative), Set 1
colscheme <- c("Regular observation"="#377eb8", "Potential outlier"="#e41a1c")

##  plot(ff, method="diagnostic", which="rqq")
##  plot(ff, method="diagnostic", which="rindex")
##  plot(ff, method="diagnostic", which="rfit")
##  plot(ff, method="diagnostic", which="rdiag")

##  Top-left panel: QQ-plot
gg <- plot(ff, method="diagnostic", which="rqq", id.n=0) + 
    geom_text_repel(aes(x=theoretical, y=residual, label=names), data=xout, hjust=0, size=4.5, alpha=0.6) +
    scale_color_manual(values = colscheme) +
        theme_bw(base_size=18) +
        theme(legend.position="bottom", 
        plot.title=element_text(face="bold", hjust=0.5),
        axis.title=element_text(face="bold")) 
gg

if(prin) {
    pdf(file="cap9-air-pollution-sparseLTS-25-diag-rqq.pdf", width=7.5, height=7.5)
    print(gg)
    dev.off()
}

##  Top-right panel: diag plot
set.seed(2345)
gg <- plot(ff, method="diagnostic", which="rdiag", id.n=0) + 
        geom_text_repel(aes(x=rd, y=residual, label=names), data=xout, hjust=0, size=4.5, alpha=0.6) +
        geom_text_repel(aes(x=rd, y=residual, label=names), data=yout, hjust=0, size=4.5, alpha=0.6) +    
        scale_color_manual(values = colscheme) +
        theme_bw(base_size=18) +
        theme(legend.position="bottom", 
        plot.title=element_text(face="bold", hjust=0.5),
        axis.title=element_text(face="bold")) 

gg

if(prin) {
    pdf(file="cap9-air-pollution-sparseLTS-25-diag-rdiag.pdf", width=7.5, height=7.5)
    print(gg)
    dev.off()
}

## Bottom-left panel: index plot
gg <- plot(ff, method="diagnostic", which="rindex", id.n=0) + 
    geom_text_repel(aes(x=index, y=residual, label=names), data=xout, hjust=0, size=4.5, alpha=0.6) +
    scale_color_manual(values = colscheme) +
        theme_bw(base_size=18) +
        theme(legend.position="bottom", 
        plot.title=element_text(face="bold", hjust=0.5),
        axis.title=element_text(face="bold")) 
gg

if(prin) {
    pdf(file="cap9-air-pollution-sparseLTS-25-diag-rindex.pdf", width=7.5, height=7.5)
    print(gg)
    dev.off()
}

##  Bottom-right panel: residuals vs. fitted values
gg <- plot(ff, method="diagnostic", which="rfit", id.n=0) + 
        geom_text_repel(aes(x=fitted, y=residual, label=names), data=xout, hjust=0, size=4.5, alpha=0.6) +
        scale_color_manual(values = colscheme) +
        theme_bw(base_size=18) +
        theme(legend.position="bottom", 
        plot.title=element_text(face="bold", hjust=0.5),
        axis.title=element_text(face="bold")) 
gg

if(prin) {
    pdf(file="cap9-air-pollution-sparseLTS-25-diag-rfit.pdf", width=7.5, height=7.5)
    print(gg)
    dev.off()
}

##=============================================================================
##  Exercise 9.3: Analysis of air pollution and mortality data II
##
##  Conduct the analysis of the data from the previous problem 
##  using the robust PENSE method. 
##  Compare the obtained model to the one obtained by sparse LTS.
##

library(pense)
library(pracma)     # for tictoc

##  Prepare the data for regression
##  Use the function model.matrix to extract the X-matrix
##  Remove the first column which contains 1s (for the intercept)
##
air_pollution <- read.csv("air_pollution.csv", row.names=1)
x <- model.matrix(Mortality~., data=air_pollution)[, -1]
dim(x)
head(x)
y <- air_pollution$Mortality

## Take logarithms from the pollution variables
x[,"HC"] <- log(x[,"HC"])
x[,"NOX"] <- log(x[,"NOX"])
x[,"SO2"] <- log(x[,"SO2"])

##======================================================================

tic()
set.seed(5678)
pense_fit25 <- pense_cv(x, y, alpha=1, bdp=0.25, cv_k=10, cv_repl=10)
toc()

##  elapsed time is 16.090000 second

tic()
set.seed(5678)
pense_fit50 <- pense_cv(x, y, alpha=1, bdp=0.4, cv_k=10, cv_repl=10)
toc()

##  elapsed time is 19.080000 second

##==============================================================================
##  Create Fig. A.65
##
## Plot coefficient path
if(prin) {
    pdf(file="cap9-air-pollution-pense-25-coef.pdf", width=7.5, height=5)
    plot(pense_fit25, what="coef.path")
    dev.off()
}

##==============================================================================
##  Create Fig. A.66
##

## Left panel: Plot CV results for bdp=25%
if(prin) {
    pdf(file="cap9-air-pollution-pense-25-PE.pdf", width=7.5, height=5)
    plot(pense_fit25, main="CV prediction performance for bdp=0.25", cex=1.4)
    dev.off()
}

## Right panel: Plot CV results for bdp=50%
if(prin) {
    pdf(file="cap9-air-pollution-pense-50-PE.pdf", width=7.5, height=5)
    plot(pense_fit50, main="CV prediction performance for bdp=0.40", cex=1.4)
    dev.off()
}

##==============================================================================
##
##  Compare LASSO, Sparse LTS and PENSE
##
##==============================================================================

##  lasso_cv

(lambda.min = lasso_cv$lambda.min)
(lambda.1se = lasso_cv$lambda.1se)

lasso_min = glmnet(x, y, family="gaussian", alpha=1, lambda=lambda.min)
(lasso_varlist_min <- row.names(lasso_min$beta)[which(lasso_min$beta != 0)])
length(lasso_varlist_min)

lasso_1se = glmnet(x, y, family="gaussian", alpha=1, lambda=lambda.1se)
(lasso_varlist_1se <- row.names(lasso_1se$beta)[which(lasso_1se$beta != 0)])
length(lasso_varlist_1se)

## lts_cv
(lts25_lambda.min <- fit25$tuning[which.min(fit25$pe$reweighted), 1])      # 0.674232
(lts25_lambda.1se <- fit25$tuning[fit25$best[1], 1])                       # 1.059507

lts25_min <- sparseLTS(x, y, alpha=0.75, lambda=lts25_lambda.min)
lts25_min_varlist <- coef(lts25_min)[which(abs(coef(lts25_min)) >= 1e-16)]  # get the beta
(lts25_min_varlist <- names(lts25_min_varlist[-1]))                         # remove the intercept
length(lts25_min_varlist)

lts25_1se <- sparseLTS(x, y, alpha=0.75, lambda=lts25_lambda.1se)
lts25_1se_varlist <- coef(lts25_1se)[which(abs(coef(lts25_1se)) >= 1e-16)]  # get the beta
(lts25_1se_varlist <- names(lts25_1se_varlist[-1]))                         # remove the intercept
length(lts25_1se_varlist)

(lts50_lambda.min <- fit50$tuning[which.min(fit50$pe$reweighted), 1])      # 0.2889566
(lts50_lambda.1se <- fit50$tuning[fit50$best[1], 1])                       # 1.733739

lts50_min <- sparseLTS(x, y, alpha=0.75, lambda=lts50_lambda.min)
lts50_min_varlist <- coef(lts50_min)[which(abs(coef(lts50_min)) >= 1e-16)]  # get the beta
(lts50_min_varlist <- names(lts50_min_varlist[-1]))                         # remove the intercept
length(lts50_min_varlist)

lts50_1se <- sparseLTS(x, y, alpha=0.5, lambda=lts50_lambda.1se)
lts50_1se_varlist <- coef(lts50_1se)[which(abs(coef(lts50_1se)) >= 1e-16)]  # get the beta
(lts50_1se_varlist <- names(lts50_1se_varlist[-1]))                         # remove the intercept
length(lts50_1se_varlist)

## pense_cv
pense25_min_varlist <- coef(pense_fit25, lambda="min")
pense25_min_varlist <- pense25_min_varlist[which(abs(pense25_min_varlist) >= 1e-16)]
(pense25_min_varlist <- pense25_min_varlist[-1])
length(pense25_min_varlist)

pense25_1se_varlist <- coef(pense_fit25, lambda="se")
pense25_1se_varlist <- names(pense25_1se_varlist[which(abs(pense25_1se_varlist) >= 1e-16)])
(pense25_1se_varlist <- pense25_1se_varlist[-1])
length(pense25_1se_varlist)

pense50_min_varlist <- coef(pense_fit50, lambda="min")
pense50_min_varlist <- pense50_min_varlist[which(abs(pense50_min_varlist) >= 1e-16)]
(pense50_min_varlist <- pense50_min_varlist[-1])
length(pense50_min_varlist)

pense50_1se_varlist <- coef(pense_fit50, lambda="se")
pense50_1se_varlist <- names(pense50_1se_varlist[which(abs(pense50_1se_varlist) >= 1e-16)])
(pense50_1se_varlist <- pense50_1se_varlist[-1])
length(pense50_1se_varlist)

## all 4 variables selected by LASSO are included in the 6 selected by LTS with bdp=0.25
lasso_varlist_1se 
lts25_1se_varlist
which(lasso_varlist_1se %in% lts25_1se_varlist)

## all 4 variables selected by LASSO are included in the 8 selected by LTS with bdp=0.50
lts50_1se_varlist
which(lasso_varlist_1se %in% lts50_1se_varlist)

## 5 of the 6 variables selected by LTS with bdp=0.25 are included in the 8 selected by LTS with bdp=0.50
which(lts25_1se_varlist %in% lts50_1se_varlist)

## all 4 variables selected by LASSO are included in the 7 selected by PENSE with bdp=0.25
lasso_varlist_1se %in% pense25_1se_varlist


## all 6 variables selected by LTS with bdp=0.25 are included in the 7 selected by PENSE with bdp=0.25
which(lts25_1se_varlist %in% pense25_1se_varlist)

## 6 variables of the 8 selected by LTS with bdp=0.50 are included in the 7 selected by PENSE with bdp=0.25
which(lts50_1se_varlist %in% pense25_1se_varlist)

##  All 4 variables selected by LASOO, all 6 variables selected by LTS with bdp=0.25 
##  and all 8 variables selected by LTS with bdp=0.50 are included 
##  in the 15 selected by PENSE with 0.50


## all 4 variables selected by LASSO are included in the 6 selected by LTS with bdp=0.25
## all 4 variables selected by LASSO are included in the 8 selected by LTS with bdp=0.50
## all 4 variables selected by LASSO are included in the 7 selected by PENSE with bdp=0.25
## 5 of the 6 variables selected by LTS with bdp=0.25 are included in the 8 selected by LTS with bdp=0.50
## all 6 variables selected by LTS with bdp=0.25 are included in the 7 selected by PENSE with bdp=0.25
## 6 variables of the 8 selected by LTS with bdp=0.50 are included in the 7 selected by PENSE with bdp=0.25
## PENSE with bdp=0.5 selects all variables

##==============================================================================
##
##  Table A.21 
##
##              LASSO   LTS25   LTS50   PENSE25 PENSE50
##  Precip        X       X       X        X        X
##  Humidity                                        X
##  JanTemp                       X                 X
##  JulyTemp                                        X
##  Over65                                          X
##  House                 X       X        X        X
##  Educ          X       X       X        X        X
##  Sound                         X                 X
##  Density               X                X        X
##  NonWhite      X       X       X        X        X
##  WhiteCol                      X        X        X
##  Poor
##  HC
##  NOX
##  SO2           X       X       X        X        X
 
##               LASSO    LTS25    LTS50   PENSE25 PENSE40
##              min 1se  min 1se  min 1se  min 1se  min 1se
##  Precip       X   X    X   X    X   X    X   X    X   X
##  Humidity                       X                 X   X
##  JanTemp      X        X        X   X             X   X
##  JulyTemp                                         X   X
##  Over65                X                 X        X   X
##  House                     X        X    X   X    X   X
##  Educ         X   X    X   X    X   X    X   X    X   X
##  Sound        X        X        X   X             X   X
##  Density      X        X   X    X        X   X    X   X
##  NonWhite     X   X    X   X    X   X    X   X    X   X
##  WhiteCol              X        X   X    X   X    X   X
##  Poor                                             X   X  
##  HC                                               X   X   
##  NOX          X                                   X   X  
##  SO2          X   X    X   X    X   X     X  X    X   X
##================================================================================
##               8   4    9   6    9   8     8  7   15  15

#InsideREADME