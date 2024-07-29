%% Empirical size of outlier tests, 
% This file creates Figures 5.1-5.4
%
% Note that nsimul is set to 100. If you wish to use 10000 simulations (as
% done in the book) set nsimul to 10000

%% Beginning of code

% seed to generate random numbers
rng(545532,'twister');

% nsimul = number of simulations
nsimul=100;

% lambda = shift contamination 
lambda=0;


%% Create figure  5.1

% p= number of explanatory variables (including the intercept)
p=2;

% n = sample size
n=50;

% function call
SimSizePowRegParfor(p, n, lambda, nsimul);

if prin==1
    % print to postscript
    print -depsc sizen50p2;
else
    sgtitle('Figure 5.1')
    set(gcf,"Name",'Figure 5.1')

end

%% Create figure  5.2


% p= number of explanatory variables (including the intercept)
p=2;

% n = samples size
n=200;


% function call
SimSizePowRegParfor(p, n, lambda, nsimul);

if prin==1
    % print to postscript
    print -depsc sizen200p2;
else
    sgtitle('Figure 5.2')
    set(gcf,"Name",'Figure 5.2')

end

%% Create figure  5.3

% p= number of explanatory variables (including the intercept)
p=10;

% n = sample size
n=50;

% function call
SimSizePowRegParfor(p, n, lambda, nsimul);

if prin==1
    % print to postscript
    print -depsc sizen50p10;
else
    sgtitle('Figure 5.3')
    set(gcf,"Name",'Figure 5.3')

end

%% Create figure  5.4

% p= number of explanatory variables (including the intercept)
p=10;

% n = sample size
n=200;

% function call
SimSizePowRegParfor(p, n, lambda, nsimul);

if prin==1
    % print to postscript
    print -depsc sizen200p10;
else
    sgtitle('Figure 5.4')
    set(gcf,"Name",'Figure 5.4')

end

%InsideREADME