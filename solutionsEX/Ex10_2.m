%% Exercise 10.2
%
% Additional analysis of the customer loyalty data.
%  This file creates Figure A.1 

%% Data loading

load ConsLoyaltyRet.mat
Xytable=ConsLoyaltyRet(:,2:end);
nameXy=Xytable.Properties.VariableNames;
nameX=nameXy(1:end-1);
X=Xytable{:,1:end-1};
y=Xytable{:,end};
n=length(y);

outFSRfan=FSRfan(y,X,'plots',0);
% Best automatic value of lambda is 0.5
outBIC=fanBIC(outFSRfan);
if prin==1
    % print to postscript
    print -depsc figs\transf2.eps;
end

title('Figure A.71')
set(gcf,"Name",'A.71')
disp('Proportion of observations included in the regression analysis')
disp('of the square root transformation')
disp(outBIC.mmstop(end-1,2)/n)

%InsideREADME 