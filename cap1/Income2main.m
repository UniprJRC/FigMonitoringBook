%% This file is referrd to dataset Income2
% 1) monitors the trimmed mean 
% 2) plots it 
% 3) create histbox: Income data
% histogram and boxplot; positive
% skewness is evident in both panels.
% 4) creates boxlaIncome2: boxplots for four values of 𝜆 using the
% normalized Box Cox power transformation after preliminary rescaling of the data to a maximum
% value of one. 
% 5) Compute the score tests 

%% Data loading
clear
load Income2;
y=Income2{:,"Income"};
n=length(y);
alphaAll=(0:0.01:0.5)';
lalphaAll=length(alphaAll);
meanTru=zeros(lalphaAll,1);
% meanTru1=meanTru;
ysor=sort(y);
for i=1:lalphaAll
    m=floor((n-1)*alphaAll(i));
    meanTru(i)=mean(ysor(m+1:n-m));
    % meanTru1(i)=trimmean(y,100*alphaAll(i));
    
end

%% Create figure trimmeanIncome2.eps
FontSize=14;
plot(alphaAll,meanTru)
xlabel('\alpha','FontSize',FontSize)
xlim([0 0.5])
meany=mean(y);
mediany=median(y);
yline(meany)
yline(mediany)
ylabel('$\overline y_\alpha$','Interpreter','latex','FontSize',FontSize)
text(0.45,meany-60,"$\hat \mu = \overline y_n$",'Interpreter','latex','FontSize',FontSize)
text(0.15,mediany+60,"Me",'Interpreter','latex','FontSize',FontSize)

set(gca,"XDir","reverse")

prin=0;
if prin==1
    % print to postscript
    print -depsc trimmeanIncome2.eps;
end

%% Create figure histbox
 subplot(1,2,1)
 histogram(y)
 xlabel('Income','FontSize',FontSize)
 ylabel('Frequencies','FontSize',FontSize)
subplot(1,2,2)
 boxplot(y,'Labels',{''})
 ylabel('Income','FontSize',FontSize)
prin=0;
if prin==1
    % print to postscript
    print -depsc histbox.eps;
end


%% Create figure boxlaIncome2.eps
yl1=-0.8;
yl2=0.1;
yrs=y/max(y);
close all
subplot(2,3,1)
ytra=normBoxCox(yrs,1,1,'Jacobian',true);
boxplot(ytra,'Labels',{''})
title('$\lambda=1$','Interpreter','latex','FontSize',FontSize)
ylim([yl1 yl2])

subplot(2,3,2)
ytra=normBoxCox(yrs,1,0.5,'Jacobian',true);
boxplot(ytra,'Labels',{''})
title('$\lambda=0.5$','Interpreter','latex','FontSize',FontSize)
ylim([yl1 yl2])

subplot(2,3,3)
ytra=normBoxCox(yrs,1,0,'Jacobian',true);
boxplot(ytra,'Labels',{''})
title('$\lambda=0$','Interpreter','latex','FontSize',FontSize)
ylim([yl1 yl2])

subplot(2,3,4)
ytra=normBoxCox(yrs,1,-0.5,'Jacobian',true);
boxplot(ytra,'Labels',{''})
title('$\lambda=-0.5$','Interpreter','latex','FontSize',FontSize)
ylim([yl1 yl2])

subplot(2,3,5)
ytra=normBoxCox(yrs,1,-1,'Jacobian',true);
boxplot(ytra,'Labels',{''})
title('$\lambda=-0.5$','Interpreter','latex','FontSize',FontSize)
ylim([yl1 yl2])

subplot(2,3,6)
ytra=normBoxCox(yrs,1,-0.5,'Jacobian',true);
boxplot(ytra,'Labels',{''})
title('$\lambda=-0.5$','Interpreter','latex','FontSize',FontSize)
ylim([yl1 yl2])

prin=0;
if prin==1
    % print to postscript
    print -depsc boxlaIncome2.eps;
end

%% Analysis of the score test
one=ones(n,1);
out=Score(y,one)
