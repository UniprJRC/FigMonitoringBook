%% This file is referred to dataset Income2
% Creates all Figures and tables associated with dataset Income2
% See Table A.2 in Appendix A to see where this dataset has been used
% inside the book

%% Data loading
clear
close all
load Income2;
y=Income2{:,"Income"};
X=Income2{:,1:end-1};

% y and X in table format
yt=Income2(:,end);
Xt=Income2(:,1:end-1);
Xytable=Income2;

n=length(y);
one=ones(n,1);
% prin = 
prin=0;

%% Analysis of the score test
% Table 1.3
la=[-2  -1.5 -1 -0.5 0 1];
out=Score(y,one, 'la',la);
disp([la' out.Score])

Score=out.Score;
rownam=["-2" "-1.5" "Inverse" "Reciprocal square root" "Logarithmic" "None"];
colnam=["lambda" "Score test"];

ScoreT=array2table([la' Score],"RowNames",rownam,"VariableNames",colnam);
format bank
disp('Table 1.3')
disp(ScoreT)

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
outFSRfanUNI=FSRfan(y,one,'intercept',0,'la',[-2 -1.5 -1 -0.5],'tag','fanplotnoExpl');
title('Figure 1.6')
if prin==1
    % print to postscript
    print -depsc fanIncome2.eps;
end


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

%  BEGIN OF REGRESSION ANALYSIS (CHAPTER 10)

%% Figure 10.12 yXplot
yXplot(yt,Xt);
sgtitle("Figure 10.12")
if prin==1
    % print to postscript
    print -depsc inc2f1.eps;
end

%% Fit in the original scale using all the observations
disp("Table 10.2")
mdl=fitlm(X,y);
disp(mdl)

%% Variable selectoin in the orginal scale
% Standard automatic variable selection
disp('Variable selection in the original scale')
stepwiselm(Xytable)

%% Create Figure 10.13
% Analysis using a set of values of lambda
outFSRfan=FSRfan(y,X,'plots',1,'la',[-2 -1 -0.5 0 0.5 1],'nsamp',10000);
title('Figure 10.13')
if prin==1
    % print to postscript
    print -depsc inc2f2.eps;
end


%%  Create Figure 10.14
[out]=fanBIC(outFSRfan);
disp('Best value of transformation parameter according to robust BIC')
disp(out.labest)
sgtitle('Figure 10.14')
set(gcf,'Name','Figure 10.14')
if prin==1
    % print to postscript
    print -depsc inc2f3.eps;
end

% %%  Analysis using a finer grid of values of lambda
% % not given in the book
% outFSRfan=FSRfan(y,X,'la',[0 0.25  0.5 0.75 1],'plots',1);
% [out]=fanBIC(outFSRfan);


%% Transformed SQRT scale
ytra=y.^0.5;

%% Create Figure 10.15
% FSR in the trasformed scale
outf=FSR(ytra,X,'plots',1);
 fsr_yXplot=findobj(0, 'type', 'figure','tag','fsr_yXplot');
figure(fsr_yXplot(end))
sgtitle('Figure 10.15')
set(gcf,'Name','Figure 10.15')

% group=one;
% group(outf.outliers)=2;
% yXplot(ytra,X,'group',group)
sgtitle('Figure 10.15')
if prin==1
    % print to postscript
    print -depsc inc2f4.eps;
end


%% Prepare the input for Figure 10.16
% FS monitoring of residuals in the transformed scale
% Use LTS as a starting point
outLXS=LXS(ytra,X,'nsamp',50000,'lms',0,'conflev',0.975);
outFS=FSReda(ytra,X,outLXS.bs);

%%  Create Figure 10.17
fground=struct;
fground.fthresh=[-3 1.5];
fground.Color={'r'};
fground.flabstep='';
bground='';

resfwdplot(outFS,'datatooltip','','fground',fground, ...
    'bground',bground)
title('Figure 10.16')
set(gcf,'Name','Figure 10.16')

if prin==1
    % print to postscript
    print -depsc inc2f5.eps;
end

%% Create Figure 10.17
disp('ANOVA in the transformed scale using all obs')
mdlyatrallobs=fitlm(X,ytra);
disp(mdlyatrallobs)

figure
conflev=0.99;
nr=2;
nc=2;
h1=subplot(nr,nc,1);
res=mdlyatrallobs.Residuals{:,3};
qqplotFS(res,'X',X,'plots',1,'h',h1,'conflev',conflev);
% title('qqplot of stud. res.')
title('')

% Plot residuals excluding outl
mdl=fitlm(X,ytra,'Exclude',outf.outliers);
h2=subplot(nr,nc,2);
good=setdiff(1:n,outf.outliers);
Xg=X(good,:);
yg=ytra(good);
resg=mdl.Residuals{good,3};
qqplotFS(resg,'X',Xg,'plots',1,'h',h2,'conflev',conflev);

sgtitle('Figure 10.17')
set(gcf,'Name','Figure 10.17')

if prin==1
    % print to postscript
    print -depsc inc2f6.eps;
end


%% FSRaddt in the original scale
% Not given in the book
% outFSRaddt=FSRaddt(y,X);
% fanplot(outFSRaddt)


%% FSRaddt in the transformed scale (with and without the outliers)
% FSRaddt using all the observations
outFSRaddt1=FSRaddt(ytra,X);
nr=2;
nc=1;
fanplot(outFSRaddt1,'tag','fanplotytraallobs')
title('Figure 10.18 (top panel)')
set(gcf,'Name','Figure 10.18')

if prin==1
    % print to postscript
    print -depsc inc2f7top.eps;
end


% FSRaddt with outliers removed
outFSRaddt1=FSRaddt(yg,Xg);
fanplot(outFSRaddt1,'tag','fanplotytwithoutoutl')
title('Figure 10.18 (bottom panel)')

if prin==1
    % print to postscript
    print -depsc inc2f7bot.eps;
end


%% Create Table 10.3
disp("Table 10.3")
disp('ANOVA in the transformed scale using all obs')
mdlyOutRemoved=fitlm(X,ytra,'Exclude',outf.outliers);
disp(mdlyOutRemoved)


%% LXS
disp("Given that there is a slight instability of the results with LTS")
disp("We take a very large number of susbets ")
outLXS=LXS(ytra,X,'nsamp',100000,'lms',1,'conflev',1-0.01/n);
nout=length(outLXS.outliers);
disp(['Using conflev 0.99 number of units declared as outliers=' num2str(nout)])
resindexplot(outLXS,'conflev',[0.975 0.99],'numlab','')
title('Residuals based on LTS')
if prin==1
    % print to postscript
    print -depsc inc2f7bot.eps;
end

%% Variable selection in the transformed scale
% The outliers have been excluded

disp('Variable selection in the transformed scale (upper model is linear)')
Xytabltra=Xytable;
Xytabltra(:,end)=sqrt(Xytabltra(:,end));
stepwiselm(Xytabltra,'upper','linear','Exclude',outf.outliers)


disp('Variable selection in the transformed scale (upper model is quadratic)')
Xytabltra=Xytable;
Xytabltra(:,end)=sqrt(Xytabltra(:,end));
stepwiselm(Xytabltra,'upper','quadratic','Exclude',outf.outliers)

%% Non parametric analysis: create Figure 10.19
critBestSol=struct;
critBestSol.pvalDW=0.01;
critBestSol.pvalJB=0.001;

outAVAS=avasms(y,X,'critBestSol',critBestSol);
pl_aug=findobj(0, 'type', 'figure','tag','pl_augstar');
figure(pl_aug(end))
title('Figure 10.19 (left-hand panel)')
set(gcf,"Name",'Figure 10.19 (left-hand panel)')

pl_heat=findobj(0, 'type', 'figure','tag','pl_heatmap');
figure(pl_heat(end))
title('Figure 10.19 (right-hand panel)')
set(gcf,"Name",'Figure 10.19 (right-hand panel)')


% avasmsplot(outAVAS)
if prin==1
    % print to postscript
    print -depsc inc2f8ASP.eps;
    print -depsc inc2f8HM.eps;
    
end

%% Create Figures 10.20 and 10.21
% Best solution aceplot

nameXy=Xytable.Properties.VariableNames;
j=1;
outj=outAVAS{j,"Out"};
outrobAV=outj{:};
aceplot(outrobAV,'VarNames',nameXy,'notitle',true)

pl_ty=findobj(0, 'type', 'figure','tag','pl_ty');
figure(pl_ty(end))
sgtitle('Figure 10.20')
set(gcf,'Name','Figure 10.20')

pl_tX=findobj(0, 'type', 'figure','tag','pl_tX');
figure(pl_tX(end))
sgtitle('Figure 10.21')
set(gcf,'Name','Figure 10.21')
if prin==1
    % print to postscript
    print -depsc inc2f9aceploty.eps;
    print -depsc inc2f9aceplottX.eps;
    
end

%% Create Table 10.4
format short
mdlAVAtra=fitlm(outrobAV.tX,outrobAV.ty,'Exclude',outrobAV.outliers);
disp('Table 10.4')
disp(mdlAVAtra)


%InsideREADME


