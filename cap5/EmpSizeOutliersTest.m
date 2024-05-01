%% Empirical size of outlier tests, 
% This file creates Figures 5.1-5.4


%% common settings

% seed to generate random numbers
rng(545532,'twister');

% nsimul = number of simulations
nsimul=100;

% lambda = shift contamination (so far not used)
lambda=0;


%% figure  5.1

% p= number of explanatory variables (including the intercept)
p=2;

% n = samples size
n=50;

% function call
SimSizePowRegParfor(p, n, lambda, nsimul);



%% figure  5.2


% p= number of explanatory variables (including the intercept)
p=2;

% n = samples size
n=200;


% function call
SimSizePowRegParfor(p, n, lambda, nsimul);

%% figure  5.3

% p= number of explanatory variables (including the intercept)
p=10;

% n = samples size
n=50;

% function call
SimSizePowRegParfor(p, n, lambda, nsimul);

%% figure  5.4

% p= number of explanatory variables (including the intercept)
p=10;

% n = samples size
n=200;

% function call
SimSizePowRegParfor(p, n, lambda, nsimul);