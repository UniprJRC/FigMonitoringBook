%%  Marketing data
% https://www.kaggle.com/fayejavad/marketing-linear-multiple-regression
clear
close all
load('Marketing_Data')
y=Marketing_Data{:,4};
X=Marketing_Data{:,1:3};
prin=0;

%% Preliminary analysis
% Fit regression model based on the original data
out=fitlm(X,y);
% F stat is 504
disp('F stat')
disp(out.ModelFitVsNullModel.Fstat)
disp('ANOVA table based on untransformed data')
disp(out)

%% Create Figure 7.20  
% all options set to false.
% Monotonicity of the expl. variables imposed.
out=avas(y,X,'rob',false,'tyinitial',false,'orderR2',false,...
    'scail',false,'trapezoid',false','l',3*ones(size(X,2),1));
aceplot(out,'oneplot',true)
sgtitle('Figure 7.20')
set(gcf,"Name",'Figure 7.20')

if prin==1
    % print to postscript
    print -depsc figs\MD1.eps;
end

%% Regression model based on transformed data using all options set to false
% find F-value
outTRAnoOPT=fitlm(out.tX,out.ty);
disp('ANOVA table based on AVAS transformed data')
disp(outTRAnoOPT)

% F stat is 472 (even smaller than that for linear regression)

%% Marketing data: all options set to true. Create Figure 7.21
%tyinitial=struct;
% tyinitial.la=-1:0.5:1;
outTRAallOPT=avas(y,X,'trapezoid',true,'rob',true,'tyinitial',true,'orderR2',true,'scail',true,'l',3*ones(size(X,2),1));
aceplot(outTRAallOPT,'oneplot',true)
sgtitle('Figure 7.21')
set(gcf,"Name",'Figure 7.21')

if prin==1
    % print to postscript
    print -depsc figs\MD2.eps;
end
disp('Number of outliers found')
disp(length(outTRAallOPT.outliers))
disp('p-value DW test (all options set to true)')
disp(outTRAallOPT.pvaldw)
disp('p-value Normality test (all options set to true)')
disp(outTRAallOPT.pvaljb)


%% Marketing data: regression model based on transformed data using all options set to true
% find F value
outALLopts=fitlm(outTRAallOPT.tX,outTRAallOPT.ty,'Exclude',outTRAallOPT.outliers);
disp(outALLopts)
% F stat excluding the outliers is 936

%% Prepare input for Figure 7.22
% model selection with quadratic model

Xq=[X(:,1:2) X(:,1).^2 X(:,2).^2 X(:,1).*X(:,2)];
[VALtfin,CorrMat]=avasms(y,Xq,'l',3*ones(size(Xq,2),1),...
    'critBestSol',0.03,'maxBestSol',4,'plots',0);

%% Create Figure 7.22
BigAx=avasmsplot(VALtfin);
disp(VALtfin)
title(BigAx,'Figure 7.22')
set(gcf,"Name",'Figure 7.22')

if prin==1
    % print to postscript
    print -depsc figs\MD3.eps;
end

%%  Create Figure 7.23 
% Show details of best solution,
j=1;
outj=VALtfin{j,"Out"};
solj=outj{:};
VarNames={'X_1' 'X_2' 'X_1^2' 'X_2^2' 'X_1X_2' 'y'};
aceplot(solj,'oneplot',true,'VarNames',VarNames)
if prin==1
    % print to postscript
    print -depsc figs\MD4.eps;
end
sgtitle('Figure 7.23')
set(gcf,"Name",'Figure 7.23')

% Regression model on the transformed scale
outjr=fitlm(solj.tX,solj.ty,'Exclude',solj.outliers,'VarNames',VarNames);

disp('ANOVA based on the robust quadratic model')
disp(outjr)

%% Marketing data: quadratic model all options set to false
outTRAqNoOpt=avas(y,Xq,'l',3*ones(size(Xq,2),1));
disp('ANOVA based non robust quadratic model')
fitlm(outTRAqNoOpt.tX,outTRAqNoOpt.ty,'Exclude','')
% The F-stat now has a value of 556, hardly better than regression on the
% first-order model without transformation of the response or of the
% explanatory variables

%% Create Figure 7.24
% Quadratic model standand non robust analysis
aceplot(outTRAqNoOpt,'oneplot','','tyFitted',false)
if prin==1
    % print to postscript
    print -depsc figs\MD5.eps;
end

sgtitle('Figure 7.24')
set(gcf,"Name",'Figure 7.24')