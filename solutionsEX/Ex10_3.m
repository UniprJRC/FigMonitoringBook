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
sqy=sqrt(y);
prin=0;

%% Create Figure A.70
outFSRfan=FSRfan(y,X,'plots',0);
% Best automatic value of lambda is 0.5
outBIC=fanBIC(outFSRfan);
sgtitle('Figure A.70')
set(gcf,"Name",'Figure A.70')


%% Create Figure A.71 
% Monitoring of res in sqrt scale
% LMS
[outLXSsq]=LXS(sqy,X,'nsamp',50000);
% Forward Search
[outsq]=FSReda(sqy,X,outLXSsq.bs);


resfwdplot(outsq,'datatooltip','','tag','pl_resfwdini')
if prin==1
    % print to postscript
    print -depsc modCLmonressqrt.eps;
end
title('Figure A.71')
set(gcf,"Name",'Figure A.71')
drawnow

%% Create Figure A.72 
% FSR in sqrt scale
outsqrty=FSR(sqy,X,'plots',0);

% plots of res in sqrt scale
mdl=fitlm(X,sqy,'Exclude',outsqrty.outliers,'VarNames',nameXy);

figure
h1=subplot(2,1,1);
res=mdl.Residuals{:,3};
qqplotFS(res,'X',X,'plots',1,'h',h1);

subplot(2,1,2)

plotResiduals(mdl,'symmetry','ResidualType','studentized')
title('')

if prin==1
    % print to postscript
    print -depsc figs\modCL8.eps;
end
sgtitle('Figure A.72')
set(gcf,"Name",'Figure A.72')
drawnow

%%  Create Figure A.73
% FSRaddt in the model without the interactions sqrt scale
outADDt=FSRaddt(sqy,X,'plots',0);
fanplotFS(outADDt,'highlight',outsqrty.outliers)
title('')
if prin==1
    % print to postscript
    print -depsc modCL6sqrt.eps;
end
title('Figure A.73')
set(gcf,"Name",'Figure A.73')