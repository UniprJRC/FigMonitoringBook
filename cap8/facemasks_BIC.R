## Complements to Figures 8.24 and 8.25

## Install the required R packages, if necessary
#install.packages("flexmix")  
#install.packages("flexCWM")
#install.packages("ggplot2")  
#install.packages("cowplot") 

## Load the dataset and set some parameters common to flexmix and flexCWM

# set your FSDA datasets path, for example:
datapath = "/Users/perrodo/usr_MATLAB/FSDAgit/FSDA/toolbox/datasets/clustering/facemasks.txt"

# read the facemasks data from FSDA
facemasks<- as.data.frame(read.table(datapath, header = FALSE, sep = " "))
names(facemasks) <- c("W", "SU", "V")

# predictor (V) and explanatory (W, SU) variables
W  = facemasks[,1];
SU = facemasks[,2];
V  = facemasks[,3];

# plot the facemasks data
par(mfrow = c(1, 2))
plot(W,V)
plot(SU,V)
par(mfrow = c(1, 1))

# set the number of components to monitor
kvals = 2:7            
nk    = length(kvals)   

# The two packages produce results that are quite unstable
# A seed can be set to reproduce a certain configuration

# set.seed(1234)  

##########################################################
##########################################################

## Figure 8.24: BIC monitoring using the R flexmix Package

library(flexmix)  # Load the package

# Fit flexmix models with varying numbers of components.
# Do 20 random replicates. Remove the intercept, as in the book.
fmm2 <- initFlexmix(V ~ 0 + W + SU, data=facemasks, k = kvals, nrep = 20) 

# save get BIC and log-likelihood values
bicVal2    = BIC(fmm2) 
loglikVal2 = logLik(fmm2) 

# Figure 8.24, left panel: the BIC curve
par(pty = "s")
plot(kvals, bicVal2, type = "b", pch = 19, xlab = "Number of Components", ylab = "BIC", main = "BIC Curve")

# A second plot, comparing the BIC with AIC and ICL
plot(fmm2)

# A third plot, with BIC and log-likelihood values
par(mfrow = c(1, 2))
# Plot the BIC curve
plot(kvals, bicVal2, type = "b", pch = 19, xlab = "Number of Components", ylab = "BIC", main = "BIC Curve")
# Plot the Likelihood curve
plot(kvals, loglikVal2, type = "b", pch = 19, xlab = "Number of Components", ylab = "Log Likelihood", main = "Log Likelihood Curve")
par(mfrow = c(1, 1))

# The model with best BIC
selgroup = getModel(fmm2, which = "BIC")  

# A model with more components leads to 3 clusters only
selgroup = getModel(fmm2, which="6")      

# Cluster assignments
clusters <- clusters(selgroup)

# Coefficients for each cluster
params  <- parameters(selgroup)

# Figure 8.24, right panel: the scatterplot with the classification
library(ggplot2)
library(cowplot)

clusters = as.factor(clusters)
# Scatter plot of x1 vs y, colored by cluster assignment
p1 = ggplot(facemasks, aes(x = W, y = V, color = clusters)) + 
  geom_point(size = 2) +
  labs(title = " ",
       x = "W",
       y = "V") +
  theme_minimal() +
  theme(legend.position = "none") 

# Scatter plot of x2 vs y, colored by cluster assignment
p2 = ggplot(facemasks, aes(x = SU, y = V, color = clusters)) +
  geom_point(size = 2) +
  labs(title = " ",
       x = "SU",
       y = "V") +
  theme_minimal()+
  theme(legend.position = "none") 

# Combine the plots into a single figure with two panels
cowplot::plot_grid(p1, p2, labels = c(" ", " "), ncol = 2)


##########################################################
##########################################################

## Figure 8.25: BIC monitoring using the R flexCWM Package

# Load the package
library(flexCWM)

modelsCWM = list()
logLikCWMval = numeric(nk)
bicCWMval = numeric(nk)
for (i in 1:nk) {
  k = kvals[i]
  cwmm <- cwm(V ~  W + SU, data = facemasks, k = k, familyY = list(gaussian), Xnorm = cbind(W), maxR = 5) 
  modelsCWM[[i]]  = cwmm
  logLikCWMval[i] = cwmm[["models"]][[1]][["logLik"]]
  bicCWMval[i]    = abs(min(getIC(cwmm,"BIC")))
  #bicCWMval[i]    = cwmm[["models"]][[1]][["IC"]][["BIC"]] # another way to get the BIC values
}

par(mfrow = c(1, 2))
# Plot the BIC curve
plot(kvals, bicCWMval, type = "b", pch = 19,    xlab = "Number of Components", ylab = "BIC", main = "BIC Curve")
# Plot the Likelihood curve
plot(kvals, logLikCWMval, type = "b", pch = 19, xlab = "Number of Components", ylab = "Log Likelihood", main = "Log Likelihood Curve")
par(mfrow = c(1, 1))

# The model with the minimum BIC
min_bic_index <- which.min(bicCWMval)
selgroupCWM   <- modelsCWM[[min_bic_index]]

# Cluster assignments
clustersCWM <- selgroupCWM[["models"]][[1]][["cluster"]]

# Coefficients for each cluster
paramsCWM  <- getPar(selgroupCWM)

# Figure 8.25, right panel: the scatterplot with the classification
library(ggplot2)
library(cowplot)

clustersCWM = as.factor(clustersCWM)
# Scatter plot of x1 vs y, colored by cluster assignment
p1 = ggplot(facemasks, aes(x = W, y = V, color = clustersCWM)) + 
  geom_point(size = 2) +
  labs(title = " ",
       x = "W",
       y = "V") +
  theme_minimal() +
  theme(legend.position = "none") 

# Scatter plot of x2 vs y, colored by cluster assignment
p2 = ggplot(facemasks, aes(x = SU, y = V, color = clustersCWM)) +
  geom_point(size = 2) +
  labs(title = " ",
       x = "SU",
       y = "V") +
  theme_minimal()+
  theme(legend.position = "none") 

# Combine the plots into a single figure with two panels
cowplot::plot_grid(p1, p2, labels = c(" ", " "), ncol = 2)


