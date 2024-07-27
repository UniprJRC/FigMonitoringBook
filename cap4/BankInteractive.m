%% Bank data
% This file creates Figure 4.35 and 4.36.

%% Data loading
load bank_data.mat
y=bank_data{:,end};
X=bank_data{:,1:end-1};
n=length(y);
prin=0;

%% Prepare the input for Figures 4.35 and 4.36
[outLXS]=LXS(y,X,'nsamp',10000);
outEDA=FSReda(y,X,outLXS.bs,'init',round(length(y)*0.25));

%% Create Figures 4.35 and 4.36
% Brush from the monitoring residual plot
mdrplot(outEDA);
resfwdplot(outEDA,'databrush',1);
try
fig=findobj(0,'tag','pl_mdr');
figure(fig)
title('Figure not given in the book')
fig=findobj(0,'tag','pl_resfwd');
figure(fig)
title('Figure similar to 4.35', 'It depends on your brushing')
fig=findobj(0,'tag','pl_yX');
figure(fig)
sgtitle('Figure similar to 4.36', 'It depends on your brushing')
catch
end
%InsideREADME