%% This file is referrd to dataset Income2
% Exercise 1.4,  Table 1.3, 1.4 and Figure Figure 1.6, 

%% Data loading
clear
load Income2;
y=Income2{:,"Income"};
n=length(y);

%% Analysis of the trimmed mean
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


%% Create figure A.3 trimmeanIncome2.eps
% Exercise 1.4 - part (b)
close all
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



%% Create figure A.4 boxlaIncome2.eps
% Exercise 1.4 - part (c)
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

prin=0;
if prin==1
    % print to postscript
    print -depsc boxlaIncome2.eps;
end

%% Analysis of the score test
% Table 1.3
one=ones(n,1);
la=[-2  -1.5 -1 0 ];
out=Score(y,one, 'la',la);
disp([la' out.Score])

%% Compute statistics in the original and transformed scale
% Table 1.4 with lambda=1, lambda=-1 or lambda=-1.5

ysor=sort(y);

alpha=0.10;
m=floor((n-1)*alpha);
meanTri=mean(ysor(m+1:n-m));
mea=mean(y);
medi=median(y);
sta=std(y);
consfact=1/norminv(0.75);
madn=consfact*mad(y,1);

loc=[mea; meanTri; medi; sta; madn];
yori=y;


laj=-1;
y1=100000*(yori.^laj);

ysor=sort(y1);
alpha=0.10;
m=floor((n-1)*alpha);
meanTri1=mean(ysor(m+1:n-m));
mea1=mean(y1);
medi1=median(y1);
sta1=std(y1);
madn1=consfact*mad(y1,1);

loc1=[mea1; meanTri1; medi1; sta1; madn1];


laj=-1.5;
y1=10000000*(yori.^laj);
ysor=sort(y1);
meanTri1=mean(ysor(m+1:n-m));
mea1=mean(y1);
medi1=median(y1);
sta1=std(y1);
madn1=consfact*mad(y1,1);

loc2=[mea1; meanTri1; medi1; sta1; madn1];

LOC=[loc loc1 loc2];

rn=["Mean" "Trimmed mean" "Median" "Standard Deviation" "MADN"];
vn=["Original data" "Inverse transf" "la=-1.5"];
LOCt=array2table(LOC,'RowNames',rn,'VariableNames',vn);
format bank
disp(LOCt)

%% Create Figure 1.6 fanplot
% Fanplot using just the intercept
outFSRfanUNI=FSRfan(y,ones(n,1),'intercept',0,'la',[-2 -1.5 -1 -0.5]);
title('')
prin=0;
if prin==1
    % print to postscript
    print -depsc fanIncome2.eps;
end
