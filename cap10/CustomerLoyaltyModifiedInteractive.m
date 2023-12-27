%% Modified Customer Loyalty dataset (interactive part). 
% It creates Figures 10.37 ---- 10.46
% and Table 10.7

%% Data loading
close all
clear
load ConsLoyaltyRet.mat
Xytable=ConsLoyaltyRet(:,2:end);
nameXy=Xytable.Properties.VariableNames;
nameX=nameXy(1:end-1);
X=Xytable{:,1:end-1};
y=Xytable{:,end};
ytra=sqrt(y);
n=length(y);

% Contaminate the data
ss=Xytable.Price==10 & Xytable.NegativePublicity<0.2;
kk=3;
y(ss)=y(ss)-kk;
Xytable{ss,end}= Xytable{ss,end}-kk;

%% FS analysis with brushing
[outLXS]=LXS(y,X,'nsamp',100000);
% Forward Search
[out]=FSReda(y,X,outLXS.bs);

resfwdplot(out,'databrush',1,'datatooltip',0)
if prin==1
    % print to postscript
    print -depsc figs\modCL3.eps;
    print -depsc figs\modCL4.eps;
end

%InsideREADME 