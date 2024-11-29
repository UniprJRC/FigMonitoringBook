%% Balance sheets data.
% This file creates Figure 6.12-6.13 and Table 6.2.

%% Beginning of code
XX=load('BalanceSheets.txt');
% Define X and y
y=XX(:,6);
X=XX(:,1:5);
prin=0;
p=size(X,2)+1;
n=length(y);
% yXplot(y,X)

%% Create Figure 6.12 (top panel)
ylimy=20;
nini=1000;
la=[0.5 0.75 1 1.25];
out=FSRfan(y,X,'la',la,'family','YJ','plots',0,'init',round(nini/2), ...
    'ylimy',[-ylimy ylimy]);
fanplotFS(out,'flabstep',1300,'laby','Fanplot','tag','pl_fanini');

title('Figure 6.12 (top panel)')
set(gcf,"Name",'Figure 6.12 (top panel)')


%% Create Figure 6.12 (bottom panel)
ylimy1=12;
outpn=FSRfan(y,X,'la',1,'family','YJpn','plots',1, 'init',round(nini/2),...
    'ylimy',[-ylimy1 ylimy1],'laby','Extended fanplot');

title('Figure 6.12 (bottom panel)')
set(gcf,"Name",'Figure 6.12 (bottom panel)')

if prin==1
    % print to postscript
    print -depsc figsBS\fanplotoriBS.eps;
end


%% Create Figure 6.13
ytra=normYJpn(y, [], [0.5, 1.5], 'inverse',false, 'Jacobian', false);
outpn=FSRfan(ytra,X,'intercept',1,'plots',1,'family','YJpn','la',1, ...
    'laby','Extended fanplot','tag','plytra');
xlabel('Subset size m')

title('Figure 6.13')
set(gcf,"Name",'Figure 6.13')

if prin==1
    % print to postscript
    print -depsc figsBS\fanplottraBS.eps;
end

%% Create Table 6.2
mdl=fitlm(X,y);
StoreFandR2=[mdl.ModelFitVsNullModel.Fstat;  mdl.Rsquared.Adjusted];

outtra=FSR(ytra,X,'plots',0);
mdltra=fitlm(X,ytra,'Exclude',outtra.outliers);
StoreFandR2tra=[mdltra.ModelFitVsNullModel.Fstat;  mdltra.Rsquared.Adjusted];

laP=[1 0.5];
laN=[1 1.5];
nobs=[n n-length(outtra.outliers)];
mis=NaN(1,2);
tsta=[mdl.Coefficients{:,"tStat"} mdltra.Coefficients{:,"tStat"}];
FandR2=[StoreFandR2 StoreFandR2tra];
df=nobs-p;

namrow=["laP"; "laN"; "Number of observations"; "Error d.f. nu";  
    "t_nu values"; "Intercept"; "x"+(1:5)'; "F5,nu for regression"; "R2adj"];
namcol=["All" "42 deleted"];

data=[laP; laN; nobs;df;mis; tsta; FandR2 ];
dataT=array2table(data,"RowNames",namrow,"VariableNames",namcol);
disp('Table 6.2')
disp(dataT)

%InsideREADME  
