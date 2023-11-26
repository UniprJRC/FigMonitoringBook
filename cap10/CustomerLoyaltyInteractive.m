%% This file is referred to dataset Customer Loyalty
% This is just the interactive part
% It creates Figures 10.22 and 10.24
% The file which creates all the Figures and
% for this dataset is called CustomerLoyalty.m


%% Data loading

load ConsLoyaltyRet.mat
Xytable=ConsLoyaltyRet(:,2:end);
nameXy=Xytable.Properties.VariableNames;
nameX=nameXy(1:end-1);
X=Xytable{:,1:end-1};
y=Xytable{:,end};
n=length(y);
prin=0;

%% Monitoring of residuals


useBestSubset=true;
if useBestSubset==true
    % The figure has been built starting from 500000 subsets giving as best
    % subset

    out.bs=[1471  625 692 64 1456 688 1112];
else
    % LMS using 1000 subsamples
    [out]=LXS(y,X,'nsamp',10000,'lms',2);
end

% Forward Search
[outFS]=FSReda(y,X,out.bs);


% Interactive part
databrush=struct;
databrush.Label='on'; % Write labels of trajectories while selecting
databrush.RemoveLabels='off'; % Do not remove labels after selection
databrush.selectionmode='Rect'; % Rectangular selection
databrush.labeladd='1';
resfwdplot(outFS,'databrush',databrush,'datatooltip','')

fig=findobj(0,'tag','pl_yX');
figure(fig)
sgtitle('Figure similar to Figure 10.22: it depends on your brushing')

fig=findobj(0,'tag','pl_resfwd');
figure(fig)
title('Figure similar to Figure 10.24: It depends on your brushing')

if prin==1
    % print to postscript
    print -depsc figs\regf4.eps;
    print -depsc figs\regf5.eps;
end