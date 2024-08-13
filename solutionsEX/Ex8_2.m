%% Differences and similarities between HAR and ART heteroskedasticity.
%
% This file creates Figures 8.45-8.46.

%% Beginning of code
load inttrade1.mat
% This dataset refers to 'POD_4801000000_CH_IT
X=inttrade1.Weight;
y=inttrade1.Value;
prin=0;
close all
X=X./max(X);
Z=log(X);
n=length(y);
% In this Exercise Harvery's heteroskedasiticty is used
typeH='har';

%% Create Figure A.45
% Automatic outlier detection
bonflev=0.99;
outH=FSRH(y,X,Z,'init',round(n*0.8),'plots',1,'ylim',[1.6 3], ...
    'typeH',typeH,'bonflev',bonflev,'nsamp',10000);
pl_fsr=findobj(0, 'type', 'figure','tag','pl_fsr');
close(figure(pl_fsr(end)))
pl_fsr=findobj(0, 'type', 'figure','tag','pl_yX');

if prin ==1
    print -depsc P48bandsHhar.eps;
else
    set(gcf,'Name', 'Figure A.45');
    title('Figure A.45')
end

%% Prepare input for Figure 8.46
[outLXS]=LXS(y,X,'nsamp',1000);
outHEDA=FSRHeda(y,X,Z,outLXS.bs,'init',round(0.7*length(y)),'typeH',typeH);

outl=outH.ListOut;
bsb=1:n;
bsb(outl)=[];

%%  Create Figure A.46
% Forecasts with confidence bands
figure
forecastH(y,X,Z,'outH',outHEDA,'bsb',bsb,'conflev',1-0.01/n);
% scatter(X,y)
title('')
ylabel(typeH)
ylabel('Value')
xlabel('Weight')
if prin==1
    print -depsc P48bandsHhar.eps;
else
    set(gcf,'Name', 'Figure A.46');
    title('Figure A.46')
end


%InsideREADME
