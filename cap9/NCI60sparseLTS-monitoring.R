## NIC60 data:  monitoring Sparse LTS
# This file creates Figures 9.8 and 9.9
##

library(pracma)     # for tictoc
library(robustHD)
library(ggplot2)
library(reshape2)

prin <- TRUE        # whether to save the figures to disk as PDF files

## Load the data
data("nci60")       # contains matrices 'protein' and 'gene'
y <- protein[, 92]
correlations <- apply(gene, 2, corHuber, y)
keep <- partialOrder(abs(correlations), 100, decreasing = TRUE)
X <- gene[, keep]

##==============================================================================
##  Monitoring sparse LTS
##
##  Compute sparseLTS for bdp=0.5, ..., 0.25, ..., 0 and keep the fits.
##

if(FALSE) {

##  This will take a lot of time ...

    alpha <- seq(0.5, 1, 0.01)                      # for bdp=0.5, ..., 0.25, ..., 0
    allfits <- vector(mode="list", length=length(alpha))
    
    lambda <- seq(0.01, 0.5, length.out = 10)
    
    for (i in 1:length(alpha)) {
        cat("\nalpha=", alpha[i], "i=", i, "of", length(alpha), "\n")
        alpha1 <- alpha[i]
        tic()
        fit <- sparseLTS(X, y, alpha=alpha1, lambda=lambda, mode="fraction", crit="PE", 
            splits=foldControl(K = 10, R = 10))
        allfits[[i]] <- fit
        toc()
    
        save(allfits, file="allfits.rda")
    }
}

##==============================================================================
## Load the monitoring data ...
load(file="allfits.rda")

fit1 <- allfits[[26]]         # bdp=0.25
fit2 <- allfits[[1]]          # bdp=0.50
fit3 <- allfits[[51]]         # bdp=0.0
length(which(coef(fit1) != 0))-1       # bdp=0.25
length(which(coef(fit2) != 0))-1       # bdp=0.5
length(which(coef(fit3) != 0))-1       # bdp=0.0

## bdp=0.25
v_fit <- which(coef(fit1) != 0)       # remove the intercept
v_fit25 <- v_fit <- names(v_fit[-1])

v_fit[which(v_fit %in% v_lasso)]
v_lasso[which(v_lasso %in% v_fit)]

## bdp=0.50
v_fit <- which(coef(fit2) != 0)       # remove the intercept
v_fit50 <- v_fit <- names(v_fit[-1])

v_fit[which(v_fit %in% v_lasso)]
v_lasso[which(v_lasso %in% v_fit)]

## bdp=0.00
v_fit <- which(coef(fit3) != 0)       # remove the intercept
v_fit <- names(v_fit[-1])

v_fit[which(v_fit %in% v_lasso)]
v_lasso[which(v_lasso %in% v_fit)]

v_fit25[which(v_fit25 %in% v_fit50)]
v_fit50[which(v_fit50 %in% v_fit25)]

##=============================================================================
##  Prepare Fig. 9.8 amd 9.9
##
##  Prepare an array with 0-1 for the variables with 1 meaning "selected" for each
##  value of bdp = 0.5, ..., 0.
##
##  Save this array in a text file for later use.
##
names <- names(coef(allfits[[1]]$finalModel))
nvar <- length(names)

a <- matrix(0, ncol=length(allfits), nrow=nvar)
lambda <- vector("numeric", length(allfits))
rownames(a) <- names
colnames(a) <- paste0("BDP_", 1:length(allfits))
for(i in 1:length(allfits)) {
    fit <- allfits[[i]]$finalModel
    colnames(a)[i] <- format(1-fit$alpha, digits=2, nsmall=2)
    a[,i] <- coef(fit) != 0
    lambda[i] <- fit$lambda[1]
}

rx <- rowSums(a)
cx <- colSums(a)
a <- a[order(rx, decreasing=TRUE),]
write.table(a, file="sparseLTS.txt", quote=FALSE)

##

##==============================================================================
##  Create Fig. 9.9
##
##   Monitoring of sparse LTS presented by the frequency of selection of the 
##  different variables for each value of \bds.
##

a.long <- melt(a)

## Remove the Intercept row - it is a factor, drop also the corresponding level
a.long <- a.long[-which(a.long[,1] =="(Intercept)"),]
a.long[,1] <- droplevels(a.long[,1])
lev <- levels(a.long[,1])

## Var1 = row
## Var2 = column
gg <- ggplot(subset(a.long, value == 1), aes(x = Var2, y = as.numeric(Var1)))
gg <- gg + geom_point(size =1, fill = "blue", col="blue", shape = 22)

## Add a second Y-axes and write the odd variables left, the even - right
gg <- gg + scale_y_continuous(breaks = seq(1, 100, 2), labels=lev[seq(1, 100, 2)],
            sec.axis = sec_axis(trans=~., breaks = seq(2, 100, 2), labels=lev[seq(2, 100, 2)], name="Variable"))
    
gg <- gg + theme_bw()
gg <- gg + labs(y="Variable", x="bdp", title="Monitoring of sparse LTS")
gg <- gg + theme(
          panel.border = element_rect(fill = NA, linewidth=0.01, color="gray50"),
          panel.grid.minor = element_line(linewidth=0.01, linetype="dashed", color="gray95"),
          panel.grid.major = element_line(linewidth=0.01, linetype="dashed", color="gray95"),
          panel.background = element_rect(linewidth=0.01, fill="white", color="white"),
          axis.text.y=element_text(size=7), axis.title=element_text(size=10), axis.ticks.y = element_blank())
gg <- gg + scale_x_reverse()
gg

if(prin) {
    pdf(file="cap9-NCI60-sparseLTS-dotplot.pdf", width=7.5, height=5)
    print(gg)
    dev.off()
}

#==============================================================================
##  Create Fig. 9.8
##
##  Monitoring of sparse LTS presented by the number of non-zero
##      coefficients estimated for each value of bdp
##
b <- cbind.data.frame(bdp=as.numeric(names(cx)), lambda=lambda, nvar=cx)
gg <- ggplot(b, aes(x=bdp))
gg <- gg + geom_line(aes(y=nvar), linewidth=1, color="red")
gg <- gg + geom_point(aes(y=nvar), shape=20, size=4, color="red")
gg <- gg + scale_x_reverse()
gg <- gg + labs(x="bdp", y="Number of nonzero coefficients", title="Monitoring of sparse LTS")
gg <- gg + theme_bw() 
      
gg

if(prin) {
    pdf(file="cap9-NCI60-sparseLTS-nvar.pdf", width=7.5, height=5)
    print(gg)
    dev.off()
}

##==============================================================================
##  Create Fig 9.X (not in the book)
##
##  A plot of the response variable against the seven most frequently selected 
##  variables when sparse LTS is run for different values of bds.
##
yy <- which(sort(rx) > 30)
yy <- yy[-which(names(yy) == "(Intercept)")]
(yy <- names(yy))
length(yy)
x1 <- X[, yy]
X1 <- cbind.data.frame(x1, y)

lts <- ltsReg(y~x1)
X1plot <- cbind(X1, outlier=factor(!lts$lts.wt))
library(reshape2)
X1.long <- melt(X1plot, c("y", "outlier"))

gg <- ggplot(X1.long, aes(x = value, y = y)) +
  geom_point(aes(color=outlier, shape=outlier)) +
  scale_color_manual(values=c("blue", "red")) +
  facet_wrap(~variable) +
  xlab(element_blank()) + theme_bw() +
  theme(legend.position="top")
gg
  
if(prin){
    pdf(file="cap9-NCI60-sparseLTS-yxplot.pdf", width=7.5, height=5)
    print(gg)
    dev.off()
}

##==============================================================================
##
##  See 10.6 NCI60 Cancer Cell Panel Data
##
  
## lm fit with the selected variables
lm <- lm(y~x1)
summary(lm)

## lts fit with the selected variables
lts <- ltsReg(y~x1)
summary(lts)

## lm fit with the selected variables and the outliers removed
iout <- which(lts$lts.wt==0)
lm1 <- lm(y[-iout]~x1[-iout,])
summary(lm1)

#InsideREADME