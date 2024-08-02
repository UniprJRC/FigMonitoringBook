%% Balance sheets data
% This file creates Figure 6.14

%% Beginning of code
XX=load('BalanceSheets.txt');
% Define X and y
y=XX(:,6);
X=XX(:,1:5);
n=length(y);
ytra=normYJpn(y, [], [0.5, 1.5], 'inverse',false, 'Jacobian', false);
close all
prin=0;


%% Figures similar to 6.14
[out]=LXS(ytra,X);
[out]=FSReda(ytra,X,out.bs);
% Plot minimum deletion residual
mdrplot(out,'xlimx',[1000 n+1],'ylimy',[1.7 5]);
% Now, some interactive brushing starting from the monitoring residuals
% plot. Once a set of trajectories is highlighted in the monitoring residual plot,
% the corresponding units are highlighted in the other plots
databrush=struct;
% databrush.bivarfit='i1';
databrush.multivarfit = '2';
databrush.selectionmode='Rect'; % Rectangular selection
% databrush.persist='off'; % Enable repeated mouse selections
databrush.Label='on'; % Write labels of trajectories while selecting
databrush.RemoveLabels='on'; % Do not remove labels after selection
databrush.RemoveTool='off'; %remove yellow

cascade;
fground=struct;
fground.fthresh=100;
standard=struct;
standard.xlim=[800 n+1];
resfwdplot(out,'databrush',databrush,'fground',fground,'standard',standard,'datatooltip','');

%InsideREADME  