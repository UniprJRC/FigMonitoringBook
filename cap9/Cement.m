%% Cement data.
%
% This file creates Tables 9.1 and 9.2.

%% Beginning of code
load cement

disp("Variable selection using MATLAB stepwiselm")
stepwiselm(cement,'Criterion','adjrsquared','Upper','linear')

%% Create Table 9.1
disp("Table 9.1")
disp("ANOVA based on all the variables (including intercept)")
fitlm(cement)


%% Create Table 9.2
disp("Table 9.2")
disp("ANOVA based on all the variables (excluding intercept)")
fitlm(cement,'Intercept',false)


%InsideREADME 