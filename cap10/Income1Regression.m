% Regression analysis of dataset Income1.
%
% This file creates Figures 10.1-10.11
% and Table 10.1


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


%% Create Figure 10.1: yX plot
yXplot(yt,Xt);
prin=0;
if prin==1
    % print to postscript
    print -depsc inc1f1.eps;
else
    sgtitle('Figure 10.1','tag','yXplotIntro')
    set(gcf,"Name",'Figure 10.1')
end


%% Analysis using the 5 most common values of lambda (not in the book)
outFSRfan5v=FSRfan(y,X,'plots',1,'tag','best la among 5 most common');
set(gcf,"Name",'Figure not in the book')

title('Fan plot using the 5 most common values of lambda')
[out5v]=fanBIC(outFSRfan5v,'tag','automatic la among 5 most common');
disp('Best value of lambda among the 5 most common')
disp(['labest=' num2str(out5v.labest)])
set(gcf,"Name",'Figure not in the book')


%%  Figure 10.2 left panel: analysis using a finer grid of values of lambda
outFSRfan=FSRfan(y,X,'la',[0 0.25  0.5 0.75 1],'plots',1,'tag','best la steps of 0.25','nsamp',20000);

if prin==1
    % print to postscript
    print -depsc inc1f2.eps;
else
    title('Figure 10.2 (left-hand panel)')
    set(gcf,"Name",'Figure 10.2 (left-hand panel)')
end

%% Figure 10.2 right panel: Automatic choice of the transformation
[out]=fanBIC(outFSRfan);

if prin==1
    % print to postscript
    print -depsc inc1f2bic.eps;
else
    sgtitle('Figure 10.2 (right-hand panel)')
    set(gcf,"Name",'Figure 10.2 (right-hand panel)')
end


%% Create Figure 10.3: FSR with y in transformed scale
% figure
ytra=y.^0.5;
outf=FSR(ytra,X);

if prin==1
    % print to postscript
    print -depsc inc1f3.eps;
else
    sgtitle('Figure 10.3')
    set(gcf,"Name",'Figure 10.3')
end



%% Create Figure 10.4: qqplot of residuals in different scales
figure
nr=1; nc=3;
h1=subplot(nr,nc,1);
mdl=fitlm(X,y);
res=mdl.Residuals{:,3};
qqplotFS(res,'X',X,'plots',1,'h',h1,'conflev',0.95);
% title('qqplot of stud. res.')
if prin==1
    title('')
else
    title('Original data')
end


h2=subplot(nr,nc,2);
mdlytra=fitlm(X,ytra);
res=mdlytra.Residuals{:,3};
qqplotFS(res,'X',X,'plots',1,'h',h2,'conflev',0.95);
% title('qqplot of stud. res.')
if prin==1
    title('')
else
    title('Square-root transformed data')
end

% Plot residuals
h3=subplot(nr,nc,3);
mdlytraExcludeOutliers=fitlm(X,ytra,'Exclude',outf.outliers);
good=setdiff(1:n,outf.outliers);
Xg=X(good,:);
yg=ytra(good);
resg=mdlytraExcludeOutliers.Residuals{good,3};
qqplotFS(resg,'X',Xg,'plots',1,'h',h3,'conflev',0.99);

if prin==1
    title('')
else
    title('Square-root transformed data (outliers removed)')
end


if prin==1
    % print to postscript
    print -depsc inc1f4.eps;
else
    sgtitle('Figure 10.4')
    set(gcf,"Name",'Figure 10.4')
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
if prin==1
    % print to postscript
    print -depsc inc1f5.eps;
else
    title('Figure 10.5')
    set(gcf,"Name",'Figure 10.5')
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

if prin==1
    % print to postscript
    print -depsc inc1f6.eps;
else
    title('Figure 10.6')
    set(gcf,"Name",'Figure 10.6')
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
zlabel('y^{0.5}','Interpreter','tex')
if prin==1
    % print to postscript
    print -depsc inc1f7.eps;
else
    title('Figure 10.7')
    set(gcf,"Name",'Figure 10.7')
end

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

if prin==1
    % print to postscript
    print -depsc inc1f8.eps;
else
    sgtitle('Figure 10.8')
    set(gcf,"Name",'Figure 10.8')
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

if prin==1
    % print to postscript
    print -depsc inc1f9.eps;
else
    sgtitle('Figure 10.9')
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


if prin==1
    % print to postscript
    print -depsc inc1f10.eps;
else
    sgtitle('Figure 10.10')
end



%% Prepare input for Figure 10.11
% RAVAS after deleting the outliers and starting in the transformed scale
critBestSol=struct;
critBestSol.pvalDW=0.01;
critBestSol.pvalJB=0.001;

outAVAS=avasms(y,X,'critBestSol',critBestSol,'plots',0);

nameX=Xt.Properties.VariableNames;
j=1;
outj=outAVAS{j,"Out"};
outrobAV=outj{:};

%% Figure 10.11
figure
nameXy=Income1.Properties.VariableNames;
aceplot(outrobAV,'VarNames',nameXy,'notitle',true,'oneplot',true)


fitlm(outrobAV.tX,outrobAV.ty,'Exclude',outrobAV.outliers)

if prin==1
    % print to postscript
    print -depsc inc1f11.eps;
else
    sgtitle('Figure 10.11')
end

%InsideREADME

