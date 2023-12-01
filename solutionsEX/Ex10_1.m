%% This file Creates Figures A.66-A.69
% Analysis of heart rate data

Y=load('ms212.txt');
y=Y(:,10)-Y(:,9);
n=length(y);

Gender=dummyvar(Y(:,4));
Smoke=dummyvar(Y(:,5));
Alcohol=dummyvar(Y(:,6));
Exercise=dummyvar(Y(:,7));
Run=dummyvar(Y(:,8));

X=[Y(:,1:3) Gender(:,1:end-1)  Smoke(:,1:end-1) Alcohol(:,1:end-1) Exercise(:,1:end-1) Run(:,1:end-1)];

%% Create left panel of Figure A.66
la=[0.5 0.6 0.7 0.8];
out=FSRfan(y,X,'family','YJ','plots',1,'init',round(n/2),'la',la,'tag','plini');
title('')
prin=0;
if prin==1
    % print to postscript
    print -depsc figs\x1L.eps;
end

title('Figure A.66 (left panel)')
set(gcf,"Name",'Figure A.66 (left panel)')

%% Create right panel of Figure A.66
% Fan plot positive and negative la=0.7
la=[0.5 0.6 0.7 0.8];

out=FSRfan(y,X(:,9),'family','YJpn','plots',1,'init',round(n/2),'la',la);
title('')
if prin==1
    % print to postscript
    print -depsc figs\x1R.eps;
end

title('Figure A.66 (right panel)')
set(gcf,"Name",'Figure A.66 (right panel)')


%% Create Figure A.67
figure
la=0.7;
ytra=normYJ(y,[],la,'inverse',false);

subplot(2,2,1)
outlmori=fitlm(X(:,9),y);
qqplot(outlmori.Residuals{:,3})
title('')

subplot(2,2,2)
outlmtra=fitlm(X(:,9),ytra);
qqplot(outlmtra.Residuals{:,3})
title('')

if prin==1
    % print to postscript
    print -depsc figs\x2.eps;
end

sgtitle('Figure A.67')
set(gcf,"Name",'Figure A.67')



%% Create Figure A.68
figure
subplot(2,2,1)
boxplot(y,X(:,9))
subplot(2,2,2)
boxplot(ytra,X(:,9))
if prin==1
    % print to postscript
    print -depsc figs\x3.eps;
end

sgtitle('Figure A.68')
set(gcf,"Name",'Figure A.68')


%% Create Figure A.69
% X4 MMreg
figure
h1=subplot(2,1,1);
conflev=1-0.01/length(y);
[out]=MMreg(y,X(:,9),'Snsamp',3000,'plots',0);
resindexplot(out,'h',h1,'conflev',conflev,'numlab',{13});
title('')

h1=subplot(2,1,2);
conflev=1-0.01/length(y);
[out]=MMreg(ytra,X(:,9),'Snsamp',3000,'plots',0);
resindexplot(out,'h',h1,'conflev',conflev,'numlab',{1});
title('')

if prin==1
    % print to postscript
    print -depsc figs\x4.eps;
end

sgtitle('Figure A.69')
set(gcf,"Name",'Figure A.69')

