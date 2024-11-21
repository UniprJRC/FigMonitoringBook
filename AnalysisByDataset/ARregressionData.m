%% This file is referred to dataset AR regression data
% Creates all Figures and tables associated with dataset AR regression
% data.
% See Table A.2 in Appendix A to see where this dataset has been used
% inside the book



%% Data loading
close all;
load('multiple_regression.txt');
y=multiple_regression(:,4);
X=multiple_regression(:,1:3);
n=length(y);
prin=0;

%% Create Figure 3.1
yXplot(y,X);

if prin==1
    % print to postscript
    print -depsc AR1.eps;
else
    sgtitle('Figure 3.1')
    set(gcf,"Name",'Figure 3.1')

end


%% Fit based on all the data
outLS=fitlm(X,y);
disp('Traditional ANOVA table based on all the observations')
disp(outLS)

%% Create Figure 3.2: residuals
figure
conflev=[0.95 0.99 1-0.05/n];
yl=3.5;
h1=subplot(2,1,1);
resindexplot(outLS.Residuals{:,3},'h',h1,'conflev',conflev,'numlab',{1})
if prin==1
    title('')
else
    title('Studentized residuals')
end
ylim([-yl yl])
h2=subplot(2,1,2);
resindexplot(outLS.Residuals{:,4},'h',h2,'conflev',conflev,'numlab',{1})
if prin==1
    title('')
else
    title('Deletion residuals')
end
ylim([-yl yl])


if prin==1
    % print to postscript
    print -depsc AR2.eps;
else
    % sgtitle('Figure 3.2')
    set(gcf,"Name",'Figure 3.2')
end


%% Create Figure 3.3: qqplot with envelopes + residuals
figure
load('multiple_regression.txt');
y=multiple_regression(:,4);
X=multiple_regression(:,1:3);

outLM=fitlm(X,y,'exclude','');
res=outLM.Residuals{:,3};
h1=subplot(2,2,1);
qqplotFS(res,'X',X,'plots',1,'h',h1);
% title('qqplot of stud. res.')

subplot(2,2,2);
plot(outLM.Fitted,res,'o')
sel=43;
text(outLM.Fitted(sel)+0.5,res(sel),num2str(sel))
xlabel('Fitted values')
ylabel('Residuals')


if prin==1
    % print to postscript
    print -depsc AR3.eps;
else
sgtitle('Figure 3.3')
set(gcf,"Name",'Figure 3.3')
end


%% Create Figure 3.4:
% Added variable plot to show the importance of units 9 21 30 31 38 47

% Computes in a new plot the added variable plot with and without the
% outliers
figure;
% Set Font Size for the title
fsiztitl=10;
% Set Font Size for the labels on the axes
SizeAxesNum=10;
outADD=addt(y,X(:,2:3),X(:,1),'plots',1,'units',[9 21 30 31 38 47]','textlab','y','FontSize',fsiztitl,'SizeAxesNum',SizeAxesNum);
ylim([-2.6 2.6])


if prin==1
    % print to postscript
    print -depsc AR4.eps;
else
sgtitle('Figure 3.4')
set(gcf,"Name",'Figure 3.4')
end

%% Create Figure 3.5
% Compute the added variable plot with and without unit 43
figure;
out43=addt(y,X(:,2:3),X(:,1),'plots',1,'units',43','textlab','y','FontSize',fsiztitl,'SizeAxesNum',SizeAxesNum);
text(-1.5,-2.3,'43','FontSize',12)
ylim([-2.6 2.6])

if prin==1
    % print to postscript
    print -depsc AR5.eps;
else
    sgtitle('Figure 3.5')
set(gcf,"Name",'Figure 3.5')

end

%% ANOVA table after removing 43
out=fitlm(X,y,'Exclude',43);
disp('Anova table after deleting unit 43')
disp(out)


%% Create Figure 3.8: traditional robust analysis based on S estimators
% S estimators with 2 values of breakdown point

conflev=[0.95 0.99];
% Note that the pattern of residuals changes completely
% Using bdp=0.5 the outliers are correctly found, on the other hand using
% bdp=0.25 the masking effect is clear
figure;
h1=subplot(2,1,1);
bdp=0.25;
[out]=Sreg(y,X,'nsamp',3000,'bdp',bdp);
resindexplot(out,'h',h1,'conflev',conflev);
ylabel(['Breakdown point =' num2str(bdp)])
title('')
h2=subplot(2,1,2);
bdp=0.5;
[out]=Sreg(y,X,'nsamp',3000,'bdp',bdp);
resindexplot(out,'h',h2,'conflev',conflev,'numlab',{6});
ylabel(['Breakdown point =' num2str(bdp)])
title('')


if prin==1
    % print to postscript
    print -depsc ARtradrobS.eps;
else
sgtitle('Figure 3.8')
set(gcf,"Name",'Figure 3.8')
end

%% Create Figure 3.9
% MR: (Multiple regression data): MM estimators with 2 values of efficiency

% MMreg using two different level of efficiency
conflev=[0.95 0.99];
% Note that the pattern of residuals changes completely
% Using eff=0.90 the outliers are correctly found, on the other hand using
% eff=0.95 the masking effect is clear
figure;
h1=subplot(2,1,1);
eff=0.90;
[out]=MMreg(y,X,'Snsamp',3000,'eff',eff);
resindexplot(out,'h',h1,'conflev',conflev,'numlab',{6});
ylabel(['Eff.=' num2str(eff)])
title('')

h2=subplot(2,1,2);
eff=0.95;
[out]=MMreg(y,X,'Snsamp',3000,'eff',eff);
resindexplot(out,'h',h2,'conflev',conflev,'numlab',{4});
ylabel(['Eff.=' num2str(eff)])
title('')

if prin==1
    % print to postscript
    print -depsc ARtradrobMM.eps;
else
    sgtitle('Figure 3.9')
set(gcf,"Name",'Figure 3.9')

end


%% Create Figure 4.15
% Forward EDA rescaled t stat monitoring
showtit=false;

% LMS using 10000 subsamples
[out]=LXS(y,X,'nsamp',10000);
% Forward Search
[out]=FSReda(y,X,out.bs);
nr=2;
nc=1;
subplot(nr,nc,1)
hold('on');
plot(out.Tols(:,1),out.Tols(:,3:end),'LineWidth',3)
for j=3:5
    tj=['t_' num2str(j-2)];
    text(out.Tols(1,1)-1.2,out.Tols(1,j),tj,'FontSize',16)

end

quant=norminv(0.95);
v=axis;
lwdenv=2;
line([v(1),v(2)],[quant,quant],'color','g','LineWidth',lwdenv);
line([v(1),v(2)],[-quant,-quant],'color','g','LineWidth',lwdenv);
% plot(out.Tols(end-6:end-1,1),out.Tols(end-6:end-1,3),'LineWidth',4,'color','r')
if showtit==true
    title('Monitoring of t-stat','FontSize',14);
end
xlabel('Subset size m');

subplot(2,1,2)
% MR: monitoring of t-stat with zoom for first variable
hold('on');
plot(out.Tols(:,1),out.Tols(:,3:end))
ylim([-3 5]);
v=axis;
lwdenv=2;
line([v(1),v(2)],[quant,quant],'color','g','LineWidth',lwdenv);
line([v(1),v(2)],[-quant,-quant],'color','g','LineWidth',lwdenv);
plot(out.Tols(end-6:end-1,1),out.Tols(end-6:end-1,3),'LineWidth',4,'color','r')
if showtit==true
    title('Monitoring of t-stat for first variable');
end
xlabel('Subset size m');
plot(out.Tols(end-7:end-6,1),out.Tols(end-7:end-6,3),'LineWidth',4,'color','b')
plot(out.Tols(end-1:end,1),out.Tols(end-1:end,3),'LineWidth',4,'color','b')
text(out.Tols(end-7,1),out.Tols(end-7,3)+0.9,'43','FontSize',12);
text(out.Tols(end-1,1),out.Tols(end-1,3)+0.9,'43','FontSize',12);
%annotation(gcf,'textarrow',[0.54 0.68],...
%    [0.28 0.44],'TextEdgeColor','none');
text(53,1,'9, 21, 30, 31, 38, 47','FontSize',12,'Rotation',-25);
xlim([40 60])

sgtitle('Figure 4.15')
set(gcf,"Name",'Figure 4.15')

if prin==1
    % print to postscript
    print -depsc ARtmonitor.eps;
end


%% Prepare input for Figures 4.16-4.18
disp('Monitoring S regression estimators')
disp('PD rho function')
tStart=tic;
outPD=Sregeda(y,X,'plots',0,'rhofunc','mdpd','msg',0);
a=toc(tStart);
disp(['PD rho function: number of seconds=' num2str(a)])
disp('---------------------')

disp('Optimal rho function')
tStart=tic;
outOPT=Sregeda(y,X,'plots',0,'rhofunc','optimal','covrob',0,'msg',0);
a=toc(tStart);
disp(['Optimal rho function: number of seconds=' num2str(a)])
disp('---------------------')

disp('Hampel rho function')
tStart=tic;
outHA=Sregeda(y,X,'plots',0,'rhofunc','hampel','msg',0);
a=toc(tStart);
disp(['Hampel rho function: number of seconds=' num2str(a)])
disp('---------------------')

disp('Hyperbolic rho function')
tStart=tic;
outHYP=Sregeda(y,X,'plots',0,'rhofunc','hyperbolic','msg',0);
a=toc(tStart);
disp(['Hyperbolic rho function: number of seconds=' num2str(a)])
disp('---------------------')

disp('Optimal rho function')
tStart=tic;
outOPT1=Sregeda(y,X,'plots',0,'rhofunc','optimal','covrob',1,'msg',0);
a=toc(tStart);
disp(['Optimal rho function (different cov(b) estimator): number of seconds=' num2str(a)])
disp('---------------------')

fground=struct;
sel=[ 9 21 30 31 38 47    3 11 14 24 27 36 42 50 43  7 39 ]';
fground.funit=sel;
fground.FontSize=1;

LineStyle=[ repmat({'-.'},6,1); repmat({'--'},9,1); repmat({':'},2,1)];
Color= [ repmat({'r'},6,1); repmat({'k'},9,1); repmat({'b'},2,1)];
fground.Color=Color;  % different colors for different foreground trajectories
fground.LineWidth=3;
fground.LineStyle=LineStyle;
standard=struct;
% Fix ylim of the plots below
standard.ylim=[-3 7];

%% Create Figure 4.16
standard.laby='S residuals optimal \rho function';
resfwdplot(outOPT,'fground',fground,'tag','pl_OPT', ...
    'corres',true,'standard',standard);
sgtitle('Figure 4.16')
set(gcf,"Name",'Figure 4.16')


%% Create left-hand panel of Figure 4.17
standard.laby='S residuals Hampel \rho function';
resfwdplot(outHA,'fground',fground,'tag','pl_HA', ...
    'corres',false,'standard',standard);
title('Figure 4.17 (left-hand panel)')
set(gcf,"Name",'Figure 4.17 (left-hand panel)')

%% Create right-hand panel of Figure 4.17
standard.laby='S residuals hyperbolic \rho function';
resfwdplot(outHYP,'fground',fground,'tag','pl_HYP', ...
    'corres',false,'standard',standard);
title('Figure 4.17 (right-hand panel)')
set(gcf,"Name",'Figure 4.17 (right-hand panel)')


%% Create Figure 4.18
standard.laby='S residuals PD \rho function';
resfwdplot(outPD,'fground',fground,'tag','pl_PD', ...
    'corres',false,'standard',standard);
title('Figure 4.18')
set(gcf,"Name",'Figure 4.18')

if prin==1
    % print to postscript
    print -depsc ARmonPD.eps;
end

%% Prepare input for Figures 4.19 and 4.20
bdp=0.5:-0.01:0.01;
RESLTS=zeros(n,length(bdp));
nsamp=20000;
RESLMS=zeros(n,length(bdp));

for j=1:length(bdp)
    % Store LTS residuals
    [out]=LXS(y,X,'lms',2,'bdp',bdp(j),'nsamp',nsamp);
    RESLTS(:,j)=out.residuals;

    % Store LMS residuals
    [outLMS]=LXS(y,X,'bdp',bdp(j),'nsamp',nsamp);
    RESLMS(:,j)=outLMS.residuals;
end
outLTS=struct;
outLTS.RES=RESLTS;
outLTS.class='Sregeda';
outLTS.bdp=bdp;
outLTS.X=X;
outLTS.y=y;

outLMS=outLTS;
outLMS.RES=RESLMS;

%% Create Figure 4.19
standard.laby='LTS residuals';
standard.ylim=[-4 8];
resfwdplot(outLTS,'fground',fground,'tag','pl_LTS', ...
    'corres',true,'standard',standard);
sgtitle('Figure 4.19')
set(gcf,"Name",'Figure 4.19')

%% Create Figure 4.20
standard.laby='LMS residuals';
standard.ylim=[-4 8];
resfwdplot(outLMS,'fground',fground,'tag','pl_LMS', ...
    'corres',true,'standard',standard);
sgtitle('Figure 4.20')
set(gcf,"Name",'Figure 4.20')

%% Create Figure 4.21
% LMS using 10000 subsamples
[outLXS]=LXS(y,X,'nsamp',10000);
% Forward Search
[outFS]=FSReda(y,X,outLXS.bs);

standard.laby='FS residuals';
standard.ylim=[-3 5];
resfwdplot(outFS,'fground',fground,'tag','pl_FS', ...
    'corres',true,'standard',standard);
sgtitle('Figure 4.21')
set(gcf,"Name",'Figure 4.21')

%% Create Figure 4.22
% top panel
fanplotFS(outOPT,'conflev',0.95,'tag','plrobcopv0');
title('')
title('Figure 4.22 (top panel)')
set(gcf,"Name",'Figure 4.22 (top panel)')

% bottom panel
fanplotFS(outOPT1,'conflev',0.95,'tag','plrobcopv1');
title('')
title('Figure 4.22 (bottom panel)')
set(gcf,"Name",'Figure 4.22 (bottom panel)')


if prin==1
    % print to postscript
    print -depsc StstatAR.eps;
end

%InsideREADME