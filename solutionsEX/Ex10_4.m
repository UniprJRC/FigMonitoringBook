%% Exercise 10.4
%
% Analysis of the auto mpg data.
% This file creates Figures A.74-A.83
% and Tables A.21-A.23

%% Data loading 
% carMPG
load autompg.mat
XX=rmmissing(autompg);
y=XX{:,end};
X1=XX{:,1:end-1};
DUM=dummyvar(X1(:,end));
X=[X1(:,1:end-1) DUM(:,1:end-1)];
Xytable=XX;
nameXy=Xytable.Properties.VariableNames;
nameXy=replace(nameXy,"_", " ");
nameXycat=[nameXy(:,1:6) {'ori1' 'ori2'} nameXy(end)];
n=length(y);

%% Create Figure A.75
% yXplot plot (without dummy for last column)
yXplot(Xytable(:,end),Xytable(:,1:end-1),'tag','pl_yXini');
legend off
prin=0;
if prin==1
    print -depsc figs\MPGyXplot.eps
end
sgtitle('Figure A.75')
set(gcf,"Name",'Figure A.75')


%% Create Table A.21
% fitlm on the original scale
outLM=fitlm(X,y,'VarNames',nameXycat);
disp("Table A.21")
disp(outLM)


%% Create Figure A.76 
% fanplot just one lambda
ylimy='';
FSRfan(y,X,'plots',1,'init',round(n/3),'ylimy',[-ylimy ylimy],'msg',0);

if prin==1
    print -depsc figs\MPGfan.eps
end
title('Figure A.76')
set(gcf,'Name','Figure A.76')
drawnow

%% Automatic procedure to detect best value of lambda
[outFSRfan]=FSRfan(y,X,'plots',0,'init',round(n*0.3),'nsamp',10000,'la',-1:0.25:1,'msg',0);
[outini]=fanBIC(outFSRfan,'plots',1);
sgtitle('Figure A.77')
set(gcf,'Name','Figure A.77')

if prin==1
    % print to postscript
    print -depsc figs\MPGauto.eps;
end

%% Transform the response
labest=outini.labest;
ytra=-y.^labest;
Xytable1=Xytable;
Xytable1{:,end}=-Xytable1{:,end}.^labest;


%% Create Table A.22
% Variable selection in the transformed scale
mdlVS=stepwiselm(Xytable1,'CategoricalVars','origin','Upper','linear');
disp('Table A.22')
disp(mdlVS)


%% Analysis of the correlation among the explanatory variables
% Not shown in the book
% [R2]=corrplot(Xytable1(:,1:6),'TestR','on')

%% Create Figure A.78 
% yXplot in the transformed using only important variables
% Show the categorical variable with 3 levels in just one panel
selvar1=[3 4 6 7];
yXplot(Xytable1(:,end),Xytable1(:,selvar1),'namey','-(mpg^-0.5)');
legend off
if prin==1
    % print to postscript
    print -depsc MPGytraX.eps;
end
sgtitle('Figure A.78')
set(gcf,'Name','Figure A.78')
drawnow

%% Figures A.79 and A.80 are create by file Ex10_4Interactive.m


%% Monitoring of residuals FSReda and brushing
selvar=[3 4 6 7 8];
Xs=X(:,selvar);

%%  Create Figure A.81
% RAVAS
l=[ones(6,1); 5*ones(2,1)];
outAVAS=avasms(y,X,'l',l);
pl_aug=findobj(0, 'type', 'figure','tag','pl_augstar');
figure(pl_aug(end))
title('Figure A.81 (left-hand panel)')
set(gcf,"Name",'Figure A.81 (left-hand panel)')

pl_heat=findobj(0, 'type', 'figure','tag','pl_heatmap');
figure(pl_heat(end))
title('Figure A.81 (right-hand panel)')
set(gcf,"Name",'Figure A.81 (right-hand panel)')

% avasmsplot(outAVAS)

if prin==1
    % print to postscript
    print -depsc figs\MPGasp.eps;
    print -depsc figs\MPGheat.eps;
end

%% Create Figure A.82
% Best solution aceplot.
% Show just some selected predictors in the aceplot
j=1;
outj=outAVAS{j,"Out"};
outrobAV=outj{:};

DataVars=2:6;
aceplot(outrobAV,'VarNames',nameXy,'notitle',true, ...
    'oneplot',true,'DataVars',DataVars)

if prin==1
    % print to postscript
    print -depsc figs\mpgRAVAS.eps;
end

sgtitle('Figure A.82')
set(gcf,'Name','Figure A.82')


%% Create Table A.23
% fitlm in the transformed RAVAS scale

Xtra=outrobAV.tX;
ytraAV=outrobAV.ty;
% exclude the outliers
disp('Table A.23')
outRAVAS=fitlm(Xtra,ytraAV,'Exclude',outrobAV.outliers,'VarNames',nameXycat);
disp(outRAVAS)

%% Create Figure A.83 
% FSRaddt in RAVAS scale
% Use just the quantitative variables
outADD=FSRaddt(ytraAV,Xtra,'plots',1,'DataVars',1:6);

fanplotFS(outADD,'highlight',outrobAV.outliers,'ylimy',[-4 19], ...
    'xlimx',[80 410]);
title('')

title('Figure A.83')
set(gcf,'Name','Figure A.83')

if prin==1
    % print to postscript
    print -depsc figs\mpgADDT.eps;
end


%% Create Figure A.84 
% 3D plot using the most significant variables (modelyear and weight)
% Rotate manually
figure
aa=4;
bb=6;
scatter3(Xtra(:,aa),Xtra(:,bb),ytraAV)
xlabel(['f(' nameXycat{aa} ')'])
ylabel(['f(' nameXycat{bb} ')'])
zlabel('y')
hold('on');
sel=outrobAV.outliers;
scatter3(Xtra(sel,aa),Xtra(sel,bb),ytraAV(sel),'r')
sel1=[];
hold('on')
% sel1=[];
scatter3(X(sel1,aa),X(sel1,bb),ytraAV(sel1),'k','MarkerFaceColor','k')
text(X(sel1,aa),X(sel1,bb),ytraAV(sel1),num2str(sel1))
zlabel('g(y)','Interpreter','latex')
if prin==1
    % print to postscript
    print -depsc mpgXYZ.eps;
    print -depsc mpgXYZ1.eps;
end
%%
title('Figure A.84 (top or bottom panel depending on your rotation) ')
set(gcf,"Name",'Figure A.84')

%InsideREADME 