%% AR data
% This function creates Figures 3.1-3.5, 3.8 and 3.9
% Figures 3.1-3.5 Traditional non robust analysis
% Figures 3.8-3.9 Traditional robust analysis based on S and MM estimators

close all
load('multiple_regression.txt');
y=multiple_regression(:,4);
X=multiple_regression(:,1:3);
prin=0;
n=length(y);


%% Create Figure 3.1
% outLS=fitlm(X,y);
yXplot(y,X);
sgtitle('Figure 3.1')
set(gcf,"Name",'Figure 3.1')

if prin==1
    % print to postscript
    print -depsc AR1.eps;
end



%% Create Figure 3.2

outLS=fitlm(X,y);
disp('Traditional ANOVA table based on all the observations')
disp(outLS)
figure
conflev=[0.95 0.99 1-0.05/n];
yl=3.5;
h1=subplot(2,1,1);
resindexplot(outLS.Residuals{:,3},'h',h1,'conflev',conflev,'numlab',{1})
title('')
ylim([-yl yl])
h2=subplot(2,1,2);
resindexplot(outLS.Residuals{:,4},'h',h2,'conflev',conflev,'numlab',{1})
title('')
ylim([-yl yl])

sgtitle('Figure 3.2')
set(gcf,"Name",'Figure 3.2')

if prin==1
    % print to postscript
    print -depsc AR2.eps;
end

%% ANOVA table after removing 43
out=fitlm(X,y,'Exclude',43);
disp('Anova table after deleting unit 43')
disp(out)



%% Create Figure 3.3
% qqplot with envelopes + residuals
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

sgtitle('Figure 3.3')
set(gcf,"Name",'Figure 3.3')

if prin==1
    % print to postscript
    print -depsc AR3.eps;
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

sgtitle('Figure 3.4')
set(gcf,"Name",'Figure 3.4')

if prin==1
    % print to postscript
    print -depsc AR4.eps;
end

%% Create Figure 3.5
% Compute the added variable plot with and without unit 43
figure;
out43=addt(y,X(:,2:3),X(:,1),'plots',1,'units',43','textlab','y','FontSize',fsiztitl,'SizeAxesNum',SizeAxesNum);
text(-1.5,-2.3,'43','FontSize',12)
ylim([-2.6 2.6])
sgtitle('Figure 3.5')
set(gcf,"Name",'Figure 3.5')

if prin==1
    % print to postscript
    print -depsc AR5.eps;
end

%% Create Figure 3.8 
% Traditional robust analysis based on S estimators
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
h2=subplot(2,1,2);
bdp=0.5;
[out]=Sreg(y,X,'nsamp',3000,'bdp',bdp);
resindexplot(out,'h',h2,'conflev',conflev,'numlab',{6});
ylabel(['Breakdown point =' num2str(bdp)])

sgtitle('Figure 3.8')
set(gcf,"Name",'Figure 3.8')

if prin==1
    % print to postscript
    print -depsc ARtradrobS.eps;
end

%% Create Figure 3.9 
%% MR: (Multiple regression data): MM estimators with 2 values of efficiency

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
h2=subplot(2,1,2);
eff=0.95;
[out]=MMreg(y,X,'Snsamp',3000,'eff',eff);
resindexplot(out,'h',h2,'conflev',conflev,'numlab',{4});
ylabel(['Eff.=' num2str(eff)])
sgtitle('Figure 3.9')
set(gcf,"Name",'Figure 3.9')

if prin==1
    % print to postscript
    print -depsc ARtradrobMM.eps;
end


