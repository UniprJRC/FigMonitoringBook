%% This file is referred to dataset Income1
% income data from the United States Census Bureau
% Univariate analysis of the response

% 1) monitors the trimmed mean 
% 2) plots it 
% 3) create histbox: Income data
% from the United States Census Bureau: 

%% Data loading
clear
load Income1;
y=Income1{:,"HTOTVAL"};
n=length(y);

close all
FontSize=14;

%% Create figure histbox (Figure 1.2)
% histogram and boxplot; positive
% skewness is evident in both panels.
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

%% Create Figure 1.3: boxplots for four value of lamnìbda
% boxla: boxplots for four values of 𝜆 using the
% normalized Box Cox power transformation after preliminary rescaling of the data to a maximum
% value of one. 
yl1=-1;
yl2=0;
yrs=y/max(y);
close all
subplot(2,2,1)
ytra=normBoxCox(yrs,1,1,'Jacobian',true);
boxplot(ytra,'Labels',{''})
title('$\lambda=1$','Interpreter','latex','FontSize',FontSize)
ylim([yl1 yl2])

subplot(2,2,2)
ytra=normBoxCox(yrs,1,0.5,'Jacobian',true);
boxplot(ytra,'Labels',{''})
title('$\lambda=0.5$','Interpreter','latex','FontSize',FontSize)
ylim([yl1 yl2])

subplot(2,2,3)
ytra=normBoxCox(yrs,1,0,'Jacobian',true);
boxplot(ytra,'Labels',{''})
title('$\lambda=0$','Interpreter','latex','FontSize',FontSize)
ylim([yl1 yl2])

subplot(2,2,4)
ytra=normBoxCox(yrs,1,-0.5,'Jacobian',true);
boxplot(ytra,'Labels',{''})
title('$\lambda=-0.5$','Interpreter','latex','FontSize',FontSize)
ylim([yl1 yl2])

prin=0;
if prin==1
    % print to postscript
    print -depsc boxla.eps;
end

%% Analysis of the score test
% Table 1.1
one=ones(n,1);
out=Score(y,one, 'la', [-1, -0.5, 0, 0.5, 1],'intercept',false);
disp(out.Score);

%% Descriptive statistics
% Table 1.2
ysor=sort(y);

alpha=0.10;
m=floor((n-1)*alpha);
meanTri=mean(ysor(m+1:n-m));
% meanTriCHK=trimmean(y,100*alpha)
mea=mean(y);
medi=median(y);
sta=std(y);
consfact=1/norminv(0.75);
madn=consfact*mad(y,1);

loc=[mea; meanTri; medi; sta; madn];
disp(loc)
%% Trimmed mean monitoring
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

%% Create figure which monitors the trimmed mean (Fig 1.4)
% trimmean.eps 
figure
plot(alphaAll,meanTru)
xlabel('\alpha','FontSize',FontSize)
xlim([0 0.5])
meany=mean(y);
mediany=median(y);
yline(meany)
yline(mediany)
ylabel('$\overline y_\alpha$','Interpreter','latex','FontSize',FontSize)
text(0.45,meany-1000,"$\hat \mu = \overline y_n$",'Interpreter','latex','FontSize',FontSize)
text(0.15,mediany+300,"Me",'Interpreter','latex','FontSize',FontSize)

set(gca,"XDir","reverse")

prin=0;
if prin==1
    % print to postscript
    print -depsc trimmeanIncome1.eps;
end








