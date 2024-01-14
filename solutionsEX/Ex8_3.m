%% Exercise 8.3
%
% Analysis of ad additional dataset.
% This file creates  Figures A.48 and A.49

%% Beginning of code
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

%% Create Figure A.48
outH=FSRH(y,X,Z,'init',round(n*0.8),'plots',0, ...
    'typeH',typeH);

% FSRHeda and forecasts
[outLXS]=LXS(y,X,'nsamp',10000);
outHEDA=FSRHeda(y,X,Z,outLXS.bs,'init',round(0.75*length(y)),'typeH',typeH);

bsb=1:n;
if ~ismissing(outH.ListOut)
    outl=outH.ListOut;
    bsb(outl)=[];
end

figure
forecastH(y,X,Z,'outH',outHEDA,'bsb',bsb,'conflev',1-0.01/n);
ylabel('Value')
xlabel('Weight')
if prin==1
    print -depsc P30bandsH.eps;
end
set(gcf,'Name', 'Figure A.48');
title('Figure A.48')

%%  Create Figure A.49 (left panel)
%  Homoskedatic  analysis
outHOM=FSR(y,X,'init',round(0.7*length(n)));

pl_fsr=findobj(0, 'type', 'figure','tag','pl_fsr');
close(figure(pl_fsr(end)))
pl_fsr=findobj(0, 'type', 'figure','tag','pl_yX');
set(gcf,'Name', 'Figure A.49 (left panel)');
title('Figure A.49 (left panel)')


%%  Create Figure A.49 (right panel)
mdl = fitlm(X,y,'Exclude',outHOM.ListOut);
Xnew=(min(X):(max(X)-min(X))/100:max(X))';
[ypred,yci] = predict(mdl,Xnew,'Prediction','observation','alpha',0.01,'Simultaneous','on');
figure
hold('on')
seq=1:length(y);
good=setdiff(seq,outHOM.ListOut);
plot(X(good),y(good),'bo')
plot(X(outHOM.ListOut),y(outHOM.ListOut),'rx','MarkerSize',9); % ,'LineWidth',2)

plot(Xnew,ypred,'k')
plot(Xnew,yci,'r','LineWidth',1)
xlabel('Quantity')
ylabel('Value')
xlim([min(X) max(X)])
if prin==1
    print -depsc P30homobands.eps;
else
    set(gcf,'Name', 'Figure A.49 (right panel)');
    title('Figure A.49 (right panel)')
end

%InsideREADME