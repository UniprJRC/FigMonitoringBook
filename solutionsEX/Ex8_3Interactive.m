%% Dataset inttrade3
%
% This file creates  Figures A.47 (in an interactive way),
% Figure A.47 (created in a non interactive way),
% and Figure A.48 and Figure A.49 are created by Ex8_3.m.


%% Data loading
load inttrade3.mat
% This dataset refers to 'POD_0307591000_SN_IT'
X=inttrade3.Weight;
y=inttrade3.Value;
prin=0;
close all
X=X./max(X);
Z=log(X);
n=length(y);
% In this Exercise ART heteroskedasiticty is used
typeH='har';
typeH='art';

%% Prepare the input for monitoring residuals and forecasts
[outLXS]=LXS(y,X,'nsamp',10000);
outHEDA=FSRHeda(y,X,Z,outLXS.bs,'init',round(0.75*length(y)),'typeH',typeH);

databrush=struct;
% Do not show the labels of the brushed units in the yXplot
% databrush.labeladd='1';
databrush.BrushShape='rect';

resfwdplot(outHEDA,'databrush',databrush,'datatooltip','');

% Add titles to figures after brushing
fig=findobj(0,'tag','pl_yX');
figure(fig)
if prin ==1
    print -depsc P30brushxy.eps 
else
    sgtitle('Figure similar to right hand panel of Figure A.47: it depends on your brushing')
end


fig=findobj(0,'tag','pl_resfwd');
figure(fig)
if prin==1
    print -depsc  P30resfwdbrush.eps
else
    title('Figure similar to left panel of Figure A.47: it depends on your brushing')
end

%InsideREADME
