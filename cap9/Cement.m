load cement

% X=cement{:,1:4};
% y=cemenr{:,end};

% namesXy=["x1" "x2" "x3" "x4" "y"];
% Xytable=array2table(XX,VariableNames=namesXy)
% yXplot(y,X)
% 
% % ANOVA based on all the variables
% fitlm(Xytable)
% 
% % ANOVA removing the intercept
% fitlm(Xytable,'Intercept',false)
% 
% 
% FSRaddt(y,X,'plots',1)
% ylim([-5 5])
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
