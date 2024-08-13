%% Dataset inttrade3
%
% Analysis of ad additional dataset.
% This file creates  Figures A.47 (in a non interactive way),
% Figure A.48 and Figure A.49.
%

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

%% Prepare the input for monitoring residuals and forecasts
[outLXS]=LXS(y,X,'nsamp',10000);
outHEDA=FSRHeda(y,X,Z,outLXS.bs,'init',round(0.75*length(y)),'typeH',typeH);

%% Create Figure A.47 (in a non interactive way)
% Find the units which at step m=350 have a residual smaller than thresh
thresh=-3.2;
pos=find(outHEDA.mdr(:,1)==350,1);
seq=1:n;
selUnits=seq(outHEDA.RES(:,pos)<thresh);
fground=struct;
fground.funit=selUnits;
fground.LineWidth=2;
fground.Color={'r'};
fground.flabstep=[];
resfwdplot(outHEDA,'datatooltip',[],'fground',fground)

fig=findobj(0,'tag','pl_resfwd');
figure(fig)
if prin==1
    print -depsc  P30resfwdbrush.eps
else
    title('Left panel of Figure A.47')
end

group=ones(n,1);
group(selUnits)=2;
figure
spmplot([X y],'group',group,'undock',[2 1])
if prin==1
    print -depsc P30brushxy.eps
else
    title('')
    sgtitle('Right panel of Figure A.47')
end

%% Create Figure A.48
outH=FSRH(y,X,Z,'init',round(n*0.8),'plots',0, ...
    'typeH',typeH);

bsb=seq;
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
else
    set(gcf,'Name', 'Figure A.48');
    title('Figure A.48')
end

%%  Create Figure A.49 (left panel)
%  Homoskedatic  analysis
outHOM=FSR(y,X,'init',round(0.7*length(n)));

pl_fsr=findobj(0, 'type', 'figure','tag','pl_fsr');
close(figure(pl_fsr(end)))
pl_fsr=findobj(0, 'type', 'figure','tag','pl_yX');

if prin==1
    print -depsc P30homobands.eps;
else
    set(gcf,'Name', 'Figure A.49 (left panel)');
    title('Figure A.49 (left panel)')
end

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
box on
if prin==1
    print -depsc P30homobands.eps;
else
    set(gcf,'Name', 'Figure A.49 (right panel)');
    title('Figure A.49 (right panel)')
end

%InsideREADME