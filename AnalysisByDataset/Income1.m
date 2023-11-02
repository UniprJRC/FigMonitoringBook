%% This file is referred to dataset Income1
% Creates all Figures and tables associated with dataset Income1
% See Table A.2 in Appendix A to see where this dataset has been used
% inside the book

%% Data loading
clear
load Income1

% y and X in array format
y=Income1{:,"HTOTVAL"};
X=Income1{:,1:end-1};

% y and X in table format
yt=Income1(:,end);
Xt=Income1(:,1:end-1);

n=length(y);
one=ones(n,1);

close all
FontSize=14;
prin=0; % do not create eps figures

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
sgtitle('Figure 1.2')
set(gcf,"Name",'Figure 1.2')
if prin==1
    % print to postscript
    print -depsc histbox.eps;
end

%% Create Figure 1.3: boxplots for four value of lambda
% boxla: boxplots for four values of 𝜆 using the
% normalized Box Cox power transformation after preliminary rescaling of the data to a maximum
% value of one.
yl1=-1;
yl2=0;
yrs=y/max(y);
figure
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
sgtitle('Figure 1.3')
set(gcf,"Name",'Figure 1.3')


if prin==1
    % print to postscript
    print -depsc boxla.eps;
end

%% Analysis of the score test
% Table 1.1
la=[-1, -0.5, 0, 0.5, 1];
out=Score(y,one, 'la', la,'intercept',false);


Score=out.Score;
rownam=["Inverse" "Reciprocal square root" "Logarithmic" "Square root" "None"];
colnam=["lambda" "Score test"];

ScoreT=array2table([la' Score],"RowNames",rownam,"VariableNames",colnam);
format bank
disp("Table 1.1")
disp(ScoreT)

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


y1=log(y);
ysor1=sort(y1);
meanTri1=mean(ysor1(m+1:n-m));
mea1=mean(y1);
medi1=median(y1);
sta1=std(y1);
madn1=consfact*mad(y1,1);

loc1=[mea1; meanTri1; medi1; sta1; madn1];

LOC=[loc loc1];
rn=["Mean" "Trimmed mean" "Median" "Standard Deviation" "MADN"];
rc=["Original data" "logged data"];
LOCt=array2table(LOC,'RowNames',rn,'VariableNames',rc);
disp("Table 1.2")
disp(LOCt)

%% Trimmed mean monitoring (Figure 1.4)
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
title('Figure 1.4')
set(gcf,"Name",'Figure 1.4')


if prin==1
    % print to postscript
    print -depsc trimmeanIncome1.eps;
end


%% Create Figure 1.5 fanplot
% Fanplot using just the intercept
outFSRfanUNI=FSRfan(y,one,'intercept',0,'ylimy',[-24 26],'nsamp',0);
title('Figure 1.5')
set(gcf,"Name",'Figure 1.5')

if prin==1
    % print to postscript
    print -depsc fanIncome1.eps;
end

%% Exercise 1.1
% Compute the trimmed mean for the first 15 obs.for two values of alpha
y15=y(1:15);
n15=length(y15);

alphaAll=[0.05 0.10];
lalphaAll=length(alphaAll);
meanTru=zeros(lalphaAll,1);
ysor=sort(y15);
for i=1:lalphaAll
    m=floor((n15-1)*alphaAll(i));
    meanTru(i)=mean(ysor(m+1:n15-m));
    % meanTru1(i)=trimmean(y,100*alphaAll(i));
end

disp("Trimmed mean alpha=0.05")
disp(meanTru(1))

disp("Trimmed mean alpha=0.10")
disp(meanTru(2))

%% Visual display of the trimmed mean calling GUItrimmedmean
% Note that given that GUItrimmean trims alpha72 from both tails it is
% necessary to use (2*alpha)*100=20 to have the 10 per cent trimmed mean
%{
    outTRI=GUItrimmean(y15,20);
    disp("Trimmed mean alpha=0.10 using call to GUItrimmean")
    disp(outTRI.trimmedmean)
%}

%% Chapter 2: create input for Figure 2.1
% SC for mean, median and trimmed mean
% Just use the first 11 observations
logy11=log(y(1:11));
alpha=0.10;
% useMATLABtrimmean = Boolean which specifies whether to use MATLAB
% function trimmean or not
useMATLABtrimmean=false;

% Compute median, mean and trimmed mean for all the observations
medy=median(logy11);
meany=mean(logy11);
if useMATLABtrimmean==true
    trimean=trimmean(logy11,100*(alpha*2),'floor');
else
    trimean=trimmeanFS(logy11,alpha);
end

% Value which has to be added to compute the sensitivity curve
x=(9:0.01:14)';

% Txnmean, Txnmed and Txntrimmean will contain the value of the sensitivity
% curve based on y and x(i) i=1, 2, ..., length(x)
Txnmean=zeros(length(x),1);
Txnmed=Txnmean;
Txntrimmean=Txnmean;
for i=1:length(x)
    Txnmean(i)=mean([logy11;x(i)]);
    Txnmed(i)=median([logy11;x(i)]);
    if useMATLABtrimmean==true
        Txntrimmean(i)=trimmean([logy11;x(i)],20,'floor');
    else
        Txntrimmean(i)=trimmeanFS([logy11;x(i)],0.10);
    end
end

n11=length(logy11);
Scurvmean=(n11+1)*(Txnmean-meany);
Scurvmedian=(n11+1)*(Txnmed-medy);
Scurvtrimmean=(n11+1)*(Txntrimmean-trimean);

%% Create Figure 2.1
figure
FontSize=14;
LineWidth=2;
hold('on')
plot(x,Scurvmean,'Color','r','LineStyle','-','LineWidth',LineWidth)
plot(x,Scurvmedian,'Color','b','LineStyle','-.','LineWidth',LineWidth)
plot(x,Scurvtrimmean,'Color','k','LineStyle','--','LineWidth',LineWidth)
xlabel('$y$','Interpreter','latex','FontSize',FontSize)
ylabel('$12 \times \left\{ T(y_1,\ldots, y_{11}, y) - T(y_1, \ldots, y_{11}) \right\}$',...
    'Interpreter','latex','FontSize',FontSize)
% title('Sensitivity curve')
ax=axis;
% add an horizontal line passing through 0
yline(0,'LineStyle',':','LineWidth',1)
% add legend
legend({'$\overline y$' '$Me$' '$\overline y_{0.1}$'},'FontSize',20,'Location','southeast','Interpreter','latex')
title('Figure 2.1')
set(gcf,"Name",'Figure 2.1')

if prin==1
    % print to postscript
    print -depsc SC.eps;
end

%% Chapter 2: create input for Figure 2.28
% Use contaminated income data 
y20=[y(1:20); 600000; 575000; 590000];

% Compute MADn;
mady=mad(y20,1)/0.6745;
% Fix the efficiency
eff=0.95;

TBc=TBeff(eff,1);
HUc=HUeff(eff,1);
HAc=HAeff(eff,1);
HYPc=HYPeff(eff,1);
OPTc=OPTeff(eff,1);
PDc=PDeff(eff);


mu=0:1000:700000;
avePSI=zeros(length(mu),6);
for i=1:length(mu)

    avePSI(i,1)=mean(HUpsi((y20-mu(i))./mady,HUc));
    avePSI(i,2)=mean(HApsi((y20-mu(i))./mady,HAc));
    avePSI(i,3)=mean(TBpsi((y20-mu(i))./mady,TBc));
    avePSI(i,4)=mean(HYPpsi((y20-mu(i))./mady,[HYPc,5]));
    avePSI(i,5)=mean(OPTpsi((y20-mu(i))./mady,OPTc));
    avePSI(i,6)=mean(PDpsi((y20-mu(i))./mady,PDc));

end

%% Create Figure 2.28
figure
Link={'Huber', 'Hampel', 'Tukey', 'Hyperbolic' 'Optimal' 'Power divergence'} ;
for i=1:6
    subplot(2,3,i)
    plot(mu',avePSI(:,i),'LineWidth',2,'Color','k')
    hold('on')
    yline(0) %  line([min(mu);max(mu)],[0;0],'LineStyle',':')
    title(Link(i),'FontSize',14)
    xlabel('$\mu$','FontSize',14,'Interpreter','Latex')
    ylabel('$\overline \psi \left( \frac{ y -\mu}{\hat \sigma} \right)$','FontSize',14,'Interpreter','Latex')
end
sgtitle('Figure 2.28')
set(gcf,"Name",'Figure 2.28')

if prin==1
    % print to postscript
    print -depsc multsol.eps;
end

%% Figures for Chapter 10

%% Show the yX plot
yXplot(yt,Xt);
sgtitle('Figure 10.1')
set(gcf,"Name",'Figure 10.1')
if prin==1
    % print to postscript
    print -depsc inc1f1.eps;
end


%% Analysis using the 5 most common values of lambda
outFSRfan5v=FSRfan(y,X,'plots',1,'tag','best la among 5 most common');
set(gcf,"Name",'Figure not in the book')

title('Fan plot using the 5 most common values of lambda')
[out5v]=fanBIC(outFSRfan5v,'tag','automatic la among 5 most common');
disp('Best value of lambda among the 5 most common')
disp(['labest=' num2str(out5v.labest)])
set(gcf,"Name",'Figure not in the book')


%%  Analysis using a finer grid of values of lambda
% figure
outFSRfan=FSRfan(y,X,'la',[0 0.25  0.5 0.75 1],'plots',1,'tag','best la steps of 0.25');
title('Figure 10.2 (left-hand panel)')
set(gcf,"Name",'Figure 10.2 (left-hand panel)')

if prin==1
    % print to postscript
    print -depsc inc1f2.eps;
end

%% Automatic choice of the transformation
[out]=fanBIC(outFSRfan);
title('Figure 10.2 (right-hand panel)')
set(gcf,"Name",'Figure 10.2 (right-hand panel)')

if prin==1
    % print to postscript
    print -depsc inc1f2bic.eps;
end


%% FSR y in trasformed scale (Figure 10.3)
% figure
ytra=y.^0.5;
outf=FSR(ytra,X);
sgtitle('Figure 10.3')
set(gcf,"Name",'Figure 10.3')

if prin==1
    % print to postscript
    print -depsc inc1f3.eps;
end



%% Plot qqplot of residuals different scales (Figure 10.4)
figure
nr=1; nc=3;
h1=subplot(nr,nc,1);
mdl=fitlm(X,y);
res=mdl.Residuals{:,3};
qqplotFS(res,'X',X,'plots',1,'h',h1,'conflev',0.95);
% title('qqplot of stud. res.')
title('')

h2=subplot(nr,nc,2);
mdlytra=fitlm(X,ytra);
res=mdlytra.Residuals{:,3};
qqplotFS(res,'X',X,'plots',1,'h',h2,'conflev',0.95);
% title('qqplot of stud. res.')
title('')


% Plot residuals
h3=subplot(nr,nc,3);
mdlytraExcludeOutliers=fitlm(X,ytra,'Exclude',outf.outliers);
good=setdiff(1:n,outf.outliers);
Xg=X(good,:);
yg=ytra(good);
resg=mdlytraExcludeOutliers.Residuals{good,3};
qqplotFS(resg,'X',Xg,'plots',1,'h',h3,'conflev',0.99);

title('')
sgtitle('Figure 10.4')
set(gcf,"Name",'Figure 10.4')

if prin==1
    % print to postscript
    print -depsc inc1f4.eps;
end

%% Create Table 10.1
disp('Summary of t-statistics from ANOVA tables for three different models')
tstat=[mdl.Coefficients{2:end,"tStat"} mdlytra.Coefficients{2:end,"tStat"} ...
    mdlytraExcludeOutliers.Coefficients{2:end,"tStat"}];
R2=[mdl.Rsquared.Adjusted mdlytra.Rsquared.Adjusted mdlytraExcludeOutliers.Rsquared.Adjusted];
varlab=["Original" "Tramsformed" "Deletion"];
rowlab=["t"+(1:3) "R2adj"];
tstatT=array2table([tstat;R2],"RowNames",rowlab,"VariableNames",varlab);
disp("Table 10.1")
disp(tstatT)

%% FSRaddt: create Figure 10.5
outFSRaddt=FSRaddt(ytra,X);
fanplot(outFSRaddt);
title('Figure 10.5')
set(gcf,"Name",'Figure 10.5')
if prin==1
    % print to postscript
    print -depsc inc1f5.eps;
end


%% FS Prepare input for Figure 10.6
outLXS=LXS(ytra,X,'nsamp',100000);
outFS=FSReda(ytra,X,outLXS.bs);

%%  Create Figure 10.6
% resfwdplot(outFS,'databrush',1)
figure
fground=struct;
fground.funit=[107 200];
resfwdplot(outFS,'fground',fground,'datatooltip','','bground','');
title('Figure 10.6')
set(gcf,"Name",'Figure 10.6')

if prin==1
    % print to postscript
    print -depsc inc1f6.eps;
end

%% Rotate manually: create Figure 10.7
figure
scatter3(X(:,1),X(:,2),ytra)
xlabel('X1')
ylabel('X2')
zlabel('y')
hold('on');
sel=outf.outliers;
scatter3(X(sel,1),X(sel,2),ytra(sel),'r')
sel1=[107; 200];
hold('on')
% sel1=[];
scatter3(X(sel1,1),X(sel1,2),ytra(sel1),'k','MarkerFaceColor','k')
text(X(sel1,1),X(sel1,2),ytra(sel1),num2str(sel1))
zlabel('$y^{0.5}$','Interpreter','latex')
if prin==1
    % print to postscript
    print -depsc inc1f7.eps;
end
title('Figure 10.7')
set(gcf,"Name",'Figure 10.7')

%% Analysis using heteroskedastic model
outHET=FSRH(zscore(ytra),zscore(X),2:3,'init',round(n*0.8),'typeH','har','plots',0);

%% Creare Figure 10.8
figure
group=ones(length(y),1);
group(outHET.outliers)=2;
group([107 200])=3;
[H,AX,BigAx]=yXplot(ytra,X,'group',group,'namey','y^{0.5}');

label=string((1:n)');
add2yX(H,AX,BigAx,'labeladd','1','RowNamesLabels',label)
legend off
sgtitle('Figure 10.8')
set(gcf,"Name",'Figure 10.8')

if prin==1
    % print to postscript
    print -depsc inc1f8.eps;
end

%% Create Figure 10.9
% Monitoring of 95 per cent and 99 per cent confidence intervals of
% beta and sigma2 using the original scale for y.

yst=zscore(y);
Xst=zscore(X);

% init = point to start monitoring diagnostics along the FS
init=150;
[outLXS]=LXS(yst,Xst,'nsamp',10000);
outEDA=FSRHeda(yst,Xst,Xst,outLXS.bs,'conflev',[0.95 0.99],'init',init,'typeH','har');
p=size(X,2)+1;
% Set font size, line width and line style
figure;
FontSize=12;
lwd=2.5;
linst={'-','--',':','-.','--',':'};
nr=3;
nc=2;
xlimL=init; % lower value fo xlim
xlimU=n+1;  % upper value of xlim
figure
for j=1:p
    subplot(nr,nc,j);
    hold('on')
    % plot 95% and 99% HPD  trajectories
    plot(outEDA.Bgls(:,1),outEDA.betaINT(:,1:2,j),'LineStyle',linst{4},'LineWidth',lwd,'Color','b')
    plot(outEDA.Bgls(:,1),outEDA.betaINT(:,3:4,j),'LineStyle',linst{4},'LineWidth',lwd,'Color','r')

    % plot estimate of beta1_j
    plot(outEDA.Bgls(:,1),outEDA.Bgls(:,j+1)','LineStyle',linst{1},'LineWidth',lwd,'Color','k')


    % Set ylim
    ylimU=max(outEDA.betaINT(:,4,j));
    ylimL=min(outEDA.betaINT(:,3,j));
    ylim([ylimL ylimU])

    % Set xlim
    xlim([xlimL xlimU]);

    ylabel(['$\hat{\beta_' num2str(j-1) '}$'],'Interpreter','LaTeX','FontSize',20,'rot',-360);
    set(gca,'FontSize',FontSize);
    if j>(nr-1)*nc
        xlabel('Subset size m','FontSize',FontSize);
    end
end

% Subplot associated with the monitoring of sigma^2
subplot(nr,nc,5:6);
hold('on')
% 99%
plot(outEDA.sigma2INT(:,1),outEDA.sigma2INT(:,4:5),'LineStyle',linst{4},'LineWidth',lwd,'Color','r')
% 95%
plot(outEDA.sigma2INT(:,1),outEDA.sigma2INT(:,2:3),'LineStyle',linst{2},'LineWidth',lwd,'Color','b')
% Plot rescaled S2
plot(outEDA.S2(:,1),outEDA.S2(:,4),'LineWidth',lwd,'Color','k')
ylabel('$\hat{\sigma}^2$','Interpreter','LaTeX','FontSize',20,'rot',-360);
set(gca,'FontSize',FontSize);

% Set ylim
ylimU=max(outEDA.sigma2INT(:,5));
ylimL=min(outEDA.sigma2INT(:,4));
ylim([ylimL ylimU])
% Set xlim
xlim([xlimL xlimU]);

xlabel('Subset size m','FontSize',FontSize);

% Add multiple title
% suplabel(['Income data 1; confidence intervals of the parameters monitored in the interval ['...
%     num2str(xlimL) ',' num2str(xlimU) ...
%     ']'],'t');
sgtitle('Figure 10.9')

if prin==1
    % print to postscript
    print -depsc inc1f9.eps;
end

%% Create Figure 10.10
% Monitoring of 95 per cent and 99 per cent confidence intervals of
% beta and sigma2.
figure
yst=zscore(ytra);
Xst=zscore(X);

% init = point to start monitoring diagnostics along the FS
init=150;
[outLXS]=LXS(yst,Xst,'nsamp',10000);
outEDA=FSRHeda(yst,Xst,Xst,outLXS.bs,'conflev',[0.95 0.99],'init',init,'typeH','har');
p=size(X,2)+1;
% Set font size, line width and line style
figure;
lwd=2.5;
linst={'-','--',':','-.','--',':'};
nr=3;
nc=2;
xlimL=init; % lower value fo xlim
xlimU=n+1;  % upper value of xlim
figure
for j=1:p
    subplot(nr,nc,j);
    hold('on')
    % plot 95% and 99% HPD  trajectories
    plot(outEDA.Bgls(:,1),outEDA.betaINT(:,1:2,j),'LineStyle',linst{4},'LineWidth',lwd,'Color','b')
    plot(outEDA.Bgls(:,1),outEDA.betaINT(:,3:4,j),'LineStyle',linst{4},'LineWidth',lwd,'Color','r')

    % plot estimate of beta1_j
    plot(outEDA.Bgls(:,1),outEDA.Bgls(:,j+1)','LineStyle',linst{1},'LineWidth',lwd,'Color','k')


    % Set ylim
    ylimU=max(outEDA.betaINT(:,4,j));
    ylimL=min(outEDA.betaINT(:,3,j));
    ylim([ylimL ylimU])

    % Set xlim
    xlim([xlimL xlimU]);

    ylabel(['$\hat{\beta_' num2str(j-1) '}$'],'Interpreter','LaTeX','FontSize',20,'rot',-360);
    set(gca,'FontSize',FontSize);
    if j>(nr-1)*nc
        xlabel('Subset size m','FontSize',FontSize);
    end
end

% Subplot associated with the monitoring of sigma^2
subplot(nr,nc,5:6);
hold('on')
% 99%
plot(outEDA.sigma2INT(:,1),outEDA.sigma2INT(:,4:5),'LineStyle',linst{4},'LineWidth',lwd,'Color','r')
% 95%
plot(outEDA.sigma2INT(:,1),outEDA.sigma2INT(:,2:3),'LineStyle',linst{2},'LineWidth',lwd,'Color','b')
% Plot rescaled S2
plot(outEDA.S2(:,1),outEDA.S2(:,4),'LineWidth',lwd,'Color','k')
ylabel('$\hat{\sigma}^2$','Interpreter','LaTeX','FontSize',20,'rot',-360);
set(gca,'FontSize',FontSize);

% Set ylim
ylimU=max(outEDA.sigma2INT(:,5));
ylimL=min(outEDA.sigma2INT(:,4));
ylim([ylimL ylimU])
% Set xlim
xlim([xlimL xlimU]);

xlabel('Subset size m','FontSize',FontSize);

% Add multiple title
% suplabel(['Income data 1; confidence intervals of the parameters monitored in the interval ['...
%     num2str(xlimL) ',' num2str(xlimU) ...
%     ']'],'t');
sgtitle('Figure 10.10')

if prin==1
    % print to postscript
    print -depsc inc1f10.eps;
end



%% Create Prepare input for Figure 10.11
% RAVAS after deleting the outliers and starting in the transformed scale
critBestSol=struct;
critBestSol.pvalDW=0.01;
critBestSol.pvalJB=0.001;

outAVAS=avasms(y,X,'critBestSol',critBestSol);

nameX=Xt.Properties.VariableNames;
j=1;
outj=outAVAS{j,"Out"};
outrobAV=outj{:};

%% Figure 10.11
figure
nameXy=Income1.Properties.VariableNames;
aceplot(outrobAV,'VarNames',nameXy,'notitle',true,'oneplot',true)


fitlm(outrobAV.tX,outrobAV.ty,'Exclude',outrobAV.outliers)
sgtitle('Figure 10.11')

if prin==1
    % print to postscript
    print -depsc inc1f11.eps;
end


