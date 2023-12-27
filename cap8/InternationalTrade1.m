%% Heteroskedasticity: International Trade Data 2.
% This file creates Figures 8.12-8.15.

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

%% Create Figure 8.12
scatter(X,y)
ylabel('Value')
xlabel('Weight')
if prin==1
    print -depsc P48scatter.eps;
end
set(gcf,'Name', 'Figure 8.12');
title('Figure 8.12')



%% Preapare input for Figures 8.13 and 8.14
typeH='art';
% typeH='har';
[outLXS]=LXS(y,X,'nsamp',1000);
outHEDA=FSRHeda(y,X,Z,outLXS.bs,'init',round(0.7*length(y)),'typeH',typeH);

%% Create Figure 8.13
% Monitoring parameter estimates
nr=3; nc=1;
figure
subplot(nr,nc,1)
plot(outHEDA.Hetero(:,1),outHEDA.Hetero(:,2))
xlabel('Subset size m')
kk=20;
xlim([outHEDA.Hetero(1,1) outHEDA.Hetero(end,1)+kk])
title('\alpha')
subplot(nr,nc,2)
plot(outHEDA.Hetero(:,1),log(outHEDA.Hetero(:,3)))
title('log(\theta)')
xlim([outHEDA.Hetero(1,1) outHEDA.Hetero(end,1)+kk])
% ylim([9 14])
xlabel('Subset size m')
subplot(nr,nc,3)
plot(outHEDA.S2(:,1),outHEDA.S2(:,2))
xlim([outHEDA.Hetero(1,1) outHEDA.Hetero(end,1)+kk])
% ylim([0 2000])
title('\sigma^2')
xlabel('Subset size m')
if prin==1
    print -depsc P48param.eps;
end
set(gcf,'Name', 'Figure 8.13');
sgtitle('Figure 8.13')


%% Create Figure 8.14
% Monitoring residuals
resfwdplot(outHEDA,'datatooltip','')
if prin==1
    print -depsc P48resfwd.eps;
end
set(gcf,'Name', 'Figure 8.14');
title('Figure 8.14')

%% Prepare input for Figure 8.15 
% Automatic outlier detection 
bonflev=0.99;
outH=FSRH(y,X,Z,'init',round(n*0.8),'plots',0,'ylim',[1.6 3], ...
    'typeH',typeH,'bonflev',bonflev);
outl=[outH.ListOut];
bsb=1:n;
bsb(outl)=[];

%%  Create Figure 8.15
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
    print -depsc P48bandsH.eps;
    print -depsc P48scatterwithouthar.eps;
end

set(gcf,'Name', 'Figure 8.15');
title('Figure 8.15')


% %% HOMOSCEDASTIC analysis
% close all
% [outLXS]=LXS(y,X,'nsamp',10000,'lms',0);
% 
% out.ListOut=outLXS.outliers;
% mdl = fitlm(X,y,'Exclude',outLXS.ListOut);
% Xnew=(min(X):(max(X)-min(X))/100:max(X))';
% [ypred,yci] = predict(mdl,Xnew,'Prediction','observation','alpha',0.01,'Simultaneous','on');
% hold('on')
% seq=1:length(y);
% good=setdiff(seq,out.ListOut);
% plot(X(good),y(good),'o')
% plot(X(out.ListOut),y(out.ListOut),'rx','MarkerSize',5)
% 
% plot(Xnew,ypred,'k')
% plot(Xnew,yci,'r','LineWidth',1)
% ylim([0 5e+04])
% xlabel('Quantity')
% ylabel('Value')
% xlim([min(X) max(X)])
% if prin==1
%     print -depsc P48param.eps;
% end

%InsideREADME