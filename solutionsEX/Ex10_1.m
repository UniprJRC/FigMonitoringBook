%% Analysis of heart rate data
%
% This file creates Figures  A.67-A.70

%% Data loading
Y=load('ms212.txt');
y=Y(:,10)-Y(:,9);
n=length(y);

Gender=dummyvar(Y(:,4));
Smoke=dummyvar(Y(:,5));
Alcohol=dummyvar(Y(:,6));
Exercise=dummyvar(Y(:,7));
Run=dummyvar(Y(:,8));

X=[Y(:,1:3) Gender(:,1:end-1)  Smoke(:,1:end-1) Alcohol(:,1:end-1) Exercise(:,1:end-1) Run(:,1:end-1)];

%% Create left panel of Figure A.67
la=[0.5 0.6 0.7 0.8];
out=FSRfan(y,X,'family','YJ','plots',1,'init',round(n/2),'la',la,'tag','plini');
title('')
prin=0;
if prin==1
    % print to postscript
    print -depsc x1L.eps;
else
    title('Figure A.67 (left panel)')
    set(gcf,"Name",'Figure A.67 (left panel)')
end


%% Create right panel of Figure A.67
% Fan plot positive and negative la=0.7
la=[0.5 0.6 0.7 0.8];

out=FSRfan(y,X(:,9),'family','YJpn','plots',1,'init',round(n/2),'la',la);
title('')
if prin==1
    % print to postscript
    print -depsc x1R.eps;
else
    title('Figure A.67 (right panel)')
    set(gcf,"Name",'Figure A.67 (right panel)')
end



%% Create Figure A.68
figure
la=0.7;
ytra=normYJ(y,[],la,'inverse',false);

h1=subplot(2,2,1);
outlmori=fitlm(X(:,9),y);
qqplotFS(outlmori.Residuals{:,3},'X',X,'plots',1,'h',h1,'conflev',0.95);

title('')
h2=subplot(2,2,2);
outlmtra=fitlm(X(:,9),ytra);
qqplotFS(outlmtra.Residuals{:,3},'X',X,'plots',1,'h',h2,'conflev',0.95);
title('')

if prin==1
    % print to postscript
    print -depsc x2.eps;
else
    sgtitle('Figure A.68')
    set(gcf,"Name",'Figure A.68')
end




%% Create Figure A.69
figure
subplot(2,2,1)
boxplot(y,X(:,9))
subplot(2,2,2)
boxplot(ytra,X(:,9))
if prin==1
    % print to postscript
    print -depsc x3.eps;
else
    sgtitle('Figure A.69')
    set(gcf,"Name",'Figure A.69')
end



%% Create Figure A.70
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
    print -depsc x4.eps;
else
    sgtitle('Figure A.70')
    set(gcf,"Name",'Figure A.70')
end

%InsideREADME
