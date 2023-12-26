%% This file creates Figure 8.17
% The file which creates Figures 8.16 and 8.18 is called InterenationalTrade2.m
close all
load inttrade2.mat
% This dataset refers to 0307491800
X=inttrade2{:,1};
y=inttrade2{:,2};

X=X./max(X);
Z=log(X);
n=length(y);

prin=0;
typeH='art';

%% Prepare input for Figure 8.17 
[outLXS]=LXS(y,X,'nsamp',10000);
outHEDA=FSRHeda(y,X,Z,outLXS.bs,'init',round(0.75*length(y)),'typeH',typeH);

%% Brushing from the monitoring of residuals
databrush=struct;
databrush.labeladd='1';
databrush.selectionmode='Rect'; % Rectangular selection
resfwdplot(outHEDA,'databrush',databrush,'datatooltip','')

if prin==1
    print -depsc P307resfwdbrush.eps;
    print -depsc P307brushxy.eps;
end

fig=findobj(0,'tag','pl_yX');
figure(fig)
title('Figure similar to bottom panel of Figure 8.17','It depends on your brushing')
fig=findobj(0,'tag','pl_resfwd');
figure(fig)
title('Figure similar to top panel of Figure 8.17','It depends on your brushing')

%InsideREADME  