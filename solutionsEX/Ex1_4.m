%% Exercise 1.4
%
% Univariate analysis

%% Data loading
clear
close all
load Income2;
y=Income2{:,"Income"};

% y and X in table format
yt=Income2(:,end);
Xt=Income2(:,1:end-1);

n=length(y);
one=ones(n,1);

%% Analysis of the trimmed mean (Prepare input for Figure 
% Exercise 1.4 - part (a)

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


%% Create figure A.1 
% Exercise 1.4 - part (b)
figure
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
set(gcf,"Name",'Figure A.1')
title('Figure A.1')
prin=0;
if prin==1
    % print to postscript
    print -depsc trimmeanIncome2.eps;
end



%% Create figure A.2.  
% Exercise 1.4 - part (c)
figure
yl1=-0.8;
yl2=0.1;
yrs=y/max(y);
subplot(2,3,1)
ytra=normBoxCox(yrs,1,1,'Jacobian',true);
boxplot(ytra,'Labels',{''})
title('$\lambda=1$','Interpreter','latex','FontSize',FontSize)
ylim([yl1 yl2])


subplot(2,3,2)
ytra=normBoxCox(yrs,1,0,'Jacobian',true);
boxplot(ytra,'Labels',{''})
title('$\lambda=0$','Interpreter','latex','FontSize',FontSize)
ylim([yl1 yl2])

subplot(2,3,3)
ytra=normBoxCox(yrs,1,-0.5,'Jacobian',true);
boxplot(ytra,'Labels',{''})
title('$\lambda=-0.5$','Interpreter','latex','FontSize',FontSize)
ylim([yl1 yl2])

subplot(2,3,4)
ytra=normBoxCox(yrs,1,-1,'Jacobian',true);
boxplot(ytra,'Labels',{''})
title('$\lambda=-1$','Interpreter','latex','FontSize',FontSize)
ylim([yl1 yl2])

subplot(2,3,5)
ytra=normBoxCox(yrs,1,-1.5,'Jacobian',true);
boxplot(ytra,'Labels',{''})
title('$\lambda=-1.5$','Interpreter','latex','FontSize',FontSize)
ylim([yl1 yl2])

subplot(2,3,6)
ytra=normBoxCox(yrs,1,-2,'Jacobian',true);
boxplot(ytra,'Labels',{''})
title('$\lambda=-2$','Interpreter','latex','FontSize',FontSize)
ylim([yl1 yl2])
sgtitle('Figure A.2')
set(gcf,"Name",'Figure A.2')

prin=0;
if prin==1
    % print to postscript
    print -depsc boxlaIncome2.eps;
end
%  BEGIN OF MULTIVARIATE ANALYSIS

%% Figure 10.12 yXplot
yXplot(yt,Xt);
sgtitle("Figure 10.12")
if prin==1
    % print to postscript
    print -depsc inc2f1.eps;
end

%InsideREADME 