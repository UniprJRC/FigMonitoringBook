%% Analysis of the auto mpg data.
%
% This file creates Figures A.79 and A.80. 
% All the other figures for dataset autompg 
% are created by file Ex10_4.m


%% Data loading 
% carMPG
load autompg.mat
XX=rmmissing(autompg);
y=XX{:,end};
X1=XX{:,1:end-1};
DUM=dummyvar(X1(:,end));
X=[X1(:,1:end-1) DUM(:,1:end-1)];
Xytable=XX;
nameXy=Xytable.Properties.VariableNames;
nameXy=replace(nameXy,"_", " ");
nameXycat=[nameXy(:,1:6) {'ori1' 'ori2'} nameXy(end)];
n=length(y);

% Transform the response
labest=-0.5;
ytra=-y.^labest;

% Select important regressors
selvar=[3 4 6 7 8];
Xs=X(:,selvar);
prin=0;

%% Create Figures A.78 and A.79 
% Monitoring of residuals FSReda and brushing
[outLXS]=LXS(ytra,Xs,'nsamp',10000);
% Forward Search
[out]=FSReda(ytra,Xs,outLXS.bs);

fground=struct;
fground.fthresh=3.3;
resfwdplot(out,'fground',fground,'datatooltip','')

databrush=struct;
databrush.labeladd='1';

% Construct the xlabel and ylabel for the yXplot which shows the brushed
% units
nameX=string(nameXycat(selvar));
namey='-(mpg^{-0.5})';

resfwdplot(out,'databrush',databrush,'fground',fground,'datatooltip','', ...
    'nameX',nameX,'namey',namey)
%%
fig=findobj(0,'tag','pl_yX');
figure(fig)
sgtitle('Figure similar to bottom panel of Figure 8.78 or Figure A.79: It depends on your brushing')
fig=findobj(0,'tag','pl_resfwd');
figure(fig)
title('Figure similar to top panel of Figure 8.78 or Figure A.79','It depends on your brushing')

if prin==1
    % print to postscript
    print -depsc figs\MPGbrushres1.eps;
    print -depsc MPGbrushyX1.eps;
    print -depsc figs\MPGbrushres2.eps;
    print -depsc MPGbrushyX2.eps;
end

%InsideREADME 
