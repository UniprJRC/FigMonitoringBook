%% Regression analysis of dataset Income2. 
%
% This file creates Figures 10.12-10.21
% and Tables 10.2-10.4.


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
outLXS=LXS(ytra,X,'nsamp',50000,'lms',0);
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