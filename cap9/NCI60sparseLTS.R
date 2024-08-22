## NIC60 data:  Least Absolute Shrinkage and Selection Operator (LASSO)
# This file creates Figures 9.3, 9.4, 9.5, 9.6 and 9.7.
##

library(pracma)     # for tictoc
library(glmnet)     # for cv.glmnet() and glmnet()

library(latex2exp)
library(ggplot2)
library(ggrepel)
library(viridis)

prin <- TRUE        # whether to save the figures to disk as PDF files
 
## load package and data
library("robustHD")
data("nci60")  # contains matrices 'protein' and 'gene'
dim(gene)
dim(protein)

## define response variable
y <- protein[, 92]

## screen most correlated predictor variables - remain 59
correlations <- apply(gene, 2, corHuber, y)
keep <- partialOrder(abs(correlations), 100, decreasing = TRUE)
X <- gene[, keep]

## The data set remains with 59 independent variables and 100 observations

## Fit LASSO ==================================================================
set.seed(1)
lasso_cv = cv.glmnet(X, y, alpha=1)
coef(lasso_cv)
(best_lambda = lasso_cv$lambda.min)

lasso_cv

lasso = glmnet(X, y, alpha=1, lambda=best_lambda)
length(which(lasso$beta != 0))
(v_lasso <- row.names(lasso$beta)[which(lasso$beta != 0)])

##==============================================================================
## Create Fig. 9.3
##
##  NCI60 data
##
##  Coefficient paths plotted against the penalty parameter lambda (on a log scale). 
##  Upper x-� axes, number of non-zero coefficients. 
##
##  Left panel: Plot coefficent path for LASSO
##
lasso1 = glmnet(X, y, alpha=1)
plot(lasso1, xvar="lambda", cex.lab=1.4)

if(prin) {
    pdf(file="cap9-nci60-coefficients.pdf", width=7.5, height=7.5)
    plot(lasso1, xvar="lambda", cex.lab=1.4)
    dev.off()
}

##
##  Right panel: Plot coefficent path for ridge regression
##
lasso2 = glmnet(X, y, alpha=0)
plot(lasso2, xvar="lambda", cex.lab=1.4)

if(prin) {
    pdf(file="cap9-nci60-coefficients-ridge.pdf", width=7.5, height=7.5)
    plot(lasso2, xvar="lambda", cex.lab=1.4)
    dev.off()
}

##=============================================================================
##  Create Fig. 9.4 
##
##   Plot CV Mean-Squared Error of LASSO 

df <- data.frame(lambda=log(lasso_cv$lambda), 
    cvm=lasso_cv$cvm, low=lasso_cv$cvlo, 
    upper=lasso_cv$cvup, nzero=lasso_cv$nzero)

## help function for the second X-axis (number of variables),
##  but it does not work - the result is not monotone!
myaxis <- Vectorize(function(x) {
    x1 <- which(x <= df$lambda)
    ret <- if(length(x1) > 0) df[x1[length(x1)], "nzero"] else 0
    ret
})
    
gg <- ggplot(df, aes(x=lambda, y=cvm)) +
    geom_point(color="#cb4154") + 
    geom_ribbon(aes(ymin=low, ymax=upper), alpha=0.2) + 
    geom_vline(xintercept=log(c(lasso_cv$lambda.min, lasso_cv$lambda.1se)), 
        linetype="dotted", linewidth=1.0) + 
##    scale_x_continuous(sec.axis = sec_axis(~ myaxis(.))) +
    theme_bw() +
        theme(plot.title=element_text(size=14, face="bold", hjust=0.5),
              axis.title=element_text(size=14,face="bold")) +
        ##ggtitle(TeX(r"( $\gamma^2 = \alpha^2 + \beta^2$ )") ) +
        ggtitle(TeX(r"( LASSO  )") ) +
        xlab(TeX(r"( $log(\lambda)$ )") ) +
        ylab("Mean-Squared Error")
gg

if(prin) {
    pdf(file="cap9-NCI60-crossval.pdf", width=7.5, height=5)
    print(gg)
    dev.off()
}

## ============================================================================
## Fit sparse LTS regression, first optimizing lambda for the default BDP

##==============================================================================
##  Create Fig. 9.5
##
##  Coefficients path for Sparse LTS
##
lambda <- seq(0.01, 0.5, length.out = 100)
fit_BIC25 <- sparseLTS(X, y, lambda = lambda, mode = "fraction", crit = "BIC")

gg <- plot(fit_BIC25, labels=NA) + theme_bw(base_size=18) +
    scale_color_viridis(discrete=TRUE, option="viridis") +
    theme(plot.title=element_text(face="bold", hjust=0.5),
          axis.title=element_text(face="bold")) +
    ##ggtitle(TeX(r"( $\gamma^2 = \alpha^2 + \beta^2$ )") ) +
    ggtitle(TeX(r"( Sparse LTS $(bdp=0.25)$ )") ) +
    xlab(TeX(r"( $\lambda$ )") )
gg

if(prin) {
    pdf(file="cap9-NCI60-sparseLTS-25-coef.pdf", width=7.5, height=5)
    print(gg)
    dev.off()
}

## Create parallel cluster
library(parallel)
detectCores(logical = FALSE)
cluster <- makeCluster(10)
clusterExport(cluster, "sparseLTS")

##  This can take some time ...
tic()
lambda <- seq(0.01, 0.5, length.out = 50)
fit25 <- sparseLTS(X, y, lambda=lambda, mode="fraction", crit="PE",
                 splits=foldControl(K=10, R=10), seed=20210507, cl=cluster)
toc()

##  elapsed time is 1720.850000 seconds

fit25
length(which(coef(fit25) != 0))
v_fit25 <- which(coef(fit25) != 0) - 1      # remove the intercept
v_fit25 <- v_fit25[-1]

v_fit25[which(v_fit25 %in% v_lasso)]
v_lasso[which(v_lasso %in% v_fit25)]

## Fit sparse LTS regression, first optimizing lambda for for BDP=0.5
tic()
fit50 <- sparseLTS(X, y, alpha=0.5, lambda=lambda, mode="fraction", crit="PE",
                 splits=foldControl(K=10, R=10), seed=20210507, cl=cluster)
toc()

##  elapsed time is 209.860000 seconds
##  elapsed time is 469.010000 seconds 

fit50

length(which(coef(fit50) != 0))
v_fit50 <- which(coef(fit50) != 0) - 1      # remove the intercept
v_fit50 <- v_fit50[-1]

v_fit50[which(v_fit50 %in% v_lasso)]
v_lasso[which(v_lasso %in% v_fit50)]

v_fit50[which(v_fit50 %in% v_fit25)]

save(fit25, fit50, file="nci60-sparseLTS.rda")

##==============================================================================
##  Create Fig. 9.6
##
##  Plot PE for bdp=0.25 and bdp=0.50 =========================================
##

## to save time - load previously computed fit25 and fit50 models
##

load(file="nci60-sparseLTS.rda")

##  Left panel: bdp=0.25
##
df <- data.frame(lambda=log(fit25$tuning), 
    cvm=fit25$pe$reweighted, low=fit25$pe$reweighted-fit25$se$reweighted, 
    upper=fit25$pe$reweighted+fit25$se$reweighted)
lambda.min <- fit25$tuning[which.min(fit25$pe$reweighted),1]
lambda.1se <- fit25$tuning[fit25$best[1],1]
    
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
    pdf(file="cap9-NCI60-sparseLTS-25-PE.pdf", width=7.5, height=5)
    print(gg)
    dev.off()
}

##  Right panel: bdp=0.50
##
df <- data.frame(lambda=log(fit50$tuning), 
    cvm=fit50$pe$reweighted, low=fit50$pe$reweighted-fit50$se$reweighted, 
    upper=fit50$pe$reweighted+fit50$se$reweighted)
lambda.min <- fit50$tuning[which.min(fit50$pe$reweighted),1]
lambda.1se <- fit50$tuning[fit50$best[1],1]
    
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
    pdf(file="cap9-NCI60-sparseLTS-50-PE.pdf", width=7.5, height=5)
    print(gg)
    dev.off()
}

##  Diagnostic plots ===========================================================
##    'arg' should be one of “all”, “rqq”, “rindex”, “rfit”, “rdiag”

##==============================================================================
##  Create Fig. 9.7
##
##  Robust regression diagnostic plots with 11 non-zero coefficients for bdp = 0.25. 
##
ff <- sparseLTS(X, y, lambda=0.06258666)

##  Set the random seed before the call to setupDiagnosticPlot.sparseLTS(), beacuse
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

##  Left panel: normal QQ-plot of the standardized residuals against the quantiles 
##  of the standard normal distribution
##
gg <- plot(ff, method="diagnostic", which="rqq", id.n=0) + 
    geom_text_repel(aes(x=theoretical, y=residual, label=names), data=xout, hjust=0, size=4.5, alpha=0.6) +
    scale_color_manual(values = colscheme) +
    theme_bw(base_size=18) +
    theme(legend.position="bottom", 
        plot.title=element_text(face="bold", hjust=0.5),
        axis.title=element_text(face="bold")) 
gg

if(prin){
    pdf(file="cap9-NCI60-sparseLTS-25-diag-rqq.pdf", width=7.5, height=7.5)
    print(gg)
    dev.off()
}

##  Diagnostic plot (not shown in the book)
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

if(prin){
    pdf(file="cap9-NCI60-sparseLTS-25-diag-rdiag.pdf", width=7.5, height=7.5)
    print(gg)
    dev.off()
}

##  Right panel: standardized residuals against the index of the observations.
##
gg <- plot(ff, method="diagnostic", which="rindex", id.n=0) + 
    geom_text_repel(aes(x=index, y=residual, label=names), data=xout, hjust=0, size=4.5, alpha=0.6) +
    scale_color_manual(values = colscheme) +
    theme_bw(base_size=18) +
    theme(legend.position="bottom", 
        plot.title=element_text(face="bold", hjust=0.5),
        axis.title=element_text(face="bold"))
gg

if(prin){
    pdf(file="cap9-NCI60-sparseLTS-25-diag-rindex.pdf", width=7.5, height=7.5)
    print(gg)
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

lasso_min = glmnet(X, y, family="gaussian", alpha=1, lambda=lambda.min)
(lasso_varlist_min <- row.names(lasso_min$beta)[which(lasso_min$beta != 0)])
length(lasso_varlist_min)

lasso_1se = glmnet(X, y, family="gaussian", alpha=1, lambda=lambda.1se)
(lasso_varlist_1se <- row.names(lasso_1se$beta)[which(lasso_1se$beta != 0)])
length(lasso_varlist_1se)

## lts_cv
(lts25_lambda.min <- fit25$tuning[which.min(fit25$pe$reweighted), 1])      # 0.674232
(lts25_lambda.1se <- fit25$tuning[fit25$best[1], 1])                       # 1.059507

lts25_min <- sparseLTS(X, y, alpha=0.75, lambda=lts25_lambda.min)
lts25_min_varlist <- coef(lts25_min)[which(abs(coef(lts25_min)) >= 1e-16)]  # get the beta
(lts25_min_varlist <- names(lts25_min_varlist[-1]))                         # remove the intercept
length(lts25_min_varlist)

lts25_1se <- sparseLTS(X, y, alpha=0.75, lambda=lts25_lambda.1se)
lts25_1se_varlist <- coef(lts25_1se)[which(abs(coef(lts25_1se)) >= 1e-16)]  # get the beta
(lts25_1se_varlist <- names(lts25_1se_varlist[-1]))                         # remove the intercept
length(lts25_1se_varlist)

(lts50_lambda.min <- fit50$tuning[which.min(fit50$pe$reweighted), 1])      # 0.2889566
(lts50_lambda.1se <- fit50$tuning[fit50$best[1], 1])                       # 1.733739

lts50_min <- sparseLTS(X, y, alpha=0.75, lambda=lts50_lambda.min)
lts50_min_varlist <- coef(lts50_min)[which(abs(coef(lts50_min)) >= 1e-16)]  # get the beta
(lts50_min_varlist <- names(lts50_min_varlist[-1]))                         # remove the intercept
length(lts50_min_varlist)

lts50_1se <- sparseLTS(X, y, alpha=0.5, lambda=lts50_lambda.1se)
lts50_1se_varlist <- coef(lts50_1se)[which(abs(coef(lts50_1se)) >= 1e-16)]  # get the beta
(lts50_1se_varlist <- names(lts50_1se_varlist[-1]))                         # remove the intercept
length(lts50_1se_varlist)

## Only 3 variables selected by LASSO are included in the 11 selected by LTS with bdp=0.25
lasso_varlist_1se 
lts25_1se_varlist
which(lasso_varlist_1se %in% lts25_1se_varlist)

## Only 6 variables selected by LASSO are included in the 24 selected by LTS with bdp=0.50
lts50_1se_varlist
which(lasso_varlist_1se %in% lts50_1se_varlist)

## Only 6 of the 11 variables selected by LTS with bdp=0.25 are included in the 24 selected by LTS with bdp=0.50
which(lts25_1se_varlist %in% lts50_1se_varlist)

#InsideREADME
