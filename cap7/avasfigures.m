
%% Ex1 (seven outliers).

rng('default')
rng(1000)
x = (0:0.1:15)';
y = sin(x) + 0.5*(rand(size(x))-0.5);
y([100,105:110]) = 1;
X=x;
y=exp(y);

% Standard non-robust analysis without options.
out=avas(y,x,'rob',false,'tyinitial',false,...
    'orderR2',false,'scail',false,'trapezoid',false);

%% Create Figure1 (non robust analysis)
close all
tX=out.tX;
ty=out.ty;
% Top left-hand panel, transformed y against y; top right-hand panel, transformed
% y against fitted values; lower panel, transformed x
addout=false;
subplot(2,2,1)
plot(y,ty,'o')
ylabel('Transformed y')
xlabel('y')
if addout ==true
    hold('on')
    plot(y(highlight),ty(highlight),'ro','MarkerFaceColor','r')
end

yhat=sum(tX,2);

subplot(2,2,2)
plot(yhat,ty,'o')
ylabel('Transformed y')
xlabel('Fitted values')
if addout ==true
    hold('on')
    plot(yhat(highlight),ty(highlight),'ro','MarkerFaceColor','r')
end
subplot(2,2,3:4)
j=1;
plot(X(:,j),tX(:,j),'o')
R=rug(0.03);
try
    delete(R.yRug)
catch
end
ylabel('Transformed X')
xlabel('X')
if addout ==true
    hold('on')
    plot(X(highlight,j),tX(highlight,j),'ro','MarkerFaceColor','r')
end

prin=0;
if prin==1
    % print to postscript
    print -depsc figs\ex1TRAD.eps;
end

%% Ex1: all options set to true
out=avas(y,x,'rob',true,'tyinitial',true,...
    'orderR2',true,'scail',true,'trapezoid',true);

%% Ex1: create Figure 7.5 (all options set to true)
close all
tX=out.tX;
ty=out.ty;
p=size(tX,2);
addout=true;
highlight=out.outliers;
subplot(2,2,1)
plot(y,ty,'o')
ylabel('Transformed y')
xlabel('y')
if addout ==true
    hold('on')
    plot(y(highlight),ty(highlight),'ro','MarkerFaceColor','r')
end

yhat=sum(tX,2);

subplot(2,2,2)
plot(yhat,ty,'o')
ylabel('Transformed y')
xlabel('Fitted values')
if addout ==true
    hold('on')
    plot(yhat(highlight),ty(highlight),'ro','MarkerFaceColor','r')
end
subplot(2,2,3:4)
j=1;
plot(X(:,j),tX(:,j),'o')
R=rug(0.03);
try
    delete(R.yRug)
catch
end
ylabel('Transformed X')
xlabel('X')
if addout ==true
    hold('on')
    plot(X(highlight,j),tX(highlight,j),'ro','MarkerFaceColor','r')
end

prin=0;
if prin==1
    % print to postscript
    print -depsc figs\ex1ROB.eps;
end

%% Two variable model (section 7.10.2)
rng(30)
x2 = (0:0.01:1.5)';
n=length(x2);
x1=randn(n,1);
X=[x1 x2];
y = 10*(1+sin(x1)+ exp(x2)) + 0.5*(randn(n,1)-0.5);
y=y.^3;

% All options initially set to false
out=avas(y,X,'rob',false,'tyinitial',false,...
    'scail',false,'orderR2',false,'trapezoid',false);

%% Two variable model: create Figure 7.6
close all
highlight=out.outliers;
tX=out.tX;
ty=out.ty;
addout=~isempty(highlight);
yhat=sum(tX,2);
res = ty - yhat;
subplot(2,2,1)
plot(yhat,res,'o')
refline(0,0)
title('Plot of residuals vs. fit')
ylabel('Residuals')
xlabel('Fitted values')
if addout ==true
    hold('on')
    plot(yhat(highlight),res(highlight),'ro','MarkerFaceColor','r')
end

subplot(2,2,2)
plot(yhat,ty,'o')
title('Plot of ty vs. fit')
ylabel('Transformed y')
xlabel('Fitted values')
if addout ==true
    hold('on')
    plot(yhat(highlight),ty(highlight),'ro','MarkerFaceColor','r')
end


prin=0;
if prin==1
    % print to postscript
    print -depsc figs\tyinitial1.eps;
end

%% Two variable model: scail set to true
out=avas(y,X,'rob',false,'tyinitial',false,...
    'scail',true,'orderR2',false,'trapezoid',false);
disp(out.pvaldw)
% aceplot(out)


%% Two variable model: create figure 7.7
close all
highlight=out.outliers;
tX=out.tX;
ty=out.ty;
addout=~isempty(highlight);
yhat=sum(tX,2);
res = ty - yhat;
subplot(2,2,1)
plot(yhat,res,'o')
refline(0,0)
title('Plot of residuals vs. fit')
ylabel('Residuals')
xlabel('Fitted values')
if addout ==true
    hold('on')
    plot(yhat(highlight),res(highlight),'ro','MarkerFaceColor','r')
end

subplot(2,2,2)
plot(yhat,ty,'o')
title('Plot of ty vs. fit')
ylabel('Transformed y')
xlabel('Fitted values')
if addout ==true
    hold('on')
    plot(yhat(highlight),ty(highlight),'ro','MarkerFaceColor','r')
end

prin=0;
if prin==1
    % print to postscript
    print -depsc figs\tyinitial2.eps;
end

%% Two variable model: tyinitial true and scail true
close all
tyinitial=struct;
tyinitial.la=[0 0.1 0.2 0.3 0.4 1/2];
out=avas(y,X,'rob',false,'tyinitial',tyinitial,...
    'scail',true,'orderR2',false,'trapezoid',false);
% aceplot(out)
disp(out)


%%  Two variable model: create figure 7.8
close all
highlight=out.outliers;
tX=out.tX;
ty=out.ty;
addout=~isempty(highlight);
yhat=sum(tX,2);
res = ty - yhat;
subplot(2,2,1)
plot(yhat,res,'o')
refline(0,0)
title('Plot of residuals vs. fit')
ylabel('Residuals')
xlabel('Fitted values')
if addout ==true
    hold('on')
    plot(yhat(highlight),res(highlight),'ro','MarkerFaceColor','r')
end

subplot(2,2,2)
plot(yhat,ty,'o')
title('Plot of ty vs. fit')
ylabel('Transformed y')
xlabel('Fitted values')
if addout ==true
    hold('on')
    plot(yhat(highlight),ty(highlight),'ro','MarkerFaceColor','r')
end

if prin==1
    print -depsc figs\tyinitial3.eps;
end


%% Two variable model: all options set to true
close all
tyinitial=struct;
tyinitial.la=[0 0.1 0.2 0.3 0.4 1/2];
out=avas(y,X,'rob',true,'tyinitial',tyinitial,...
    'scail',true,'orderR2',true,'trapezoid',true);

%% Two variable model: create figure 7.9
aceplot(out,'oneplot',true)
disp(out)

if prin==1
    print -depsc figs\tyinitial4.eps;
end

%% Example 2: 4 explanatory variables
clear
rng(100)
x1 = (0:0.1:15)';
n=length(x1);
X24=randn(n,3);
y = sin(x1) + 0.5*(rand(size(x1))-0.5) + X24*(1:3)';
y([90,100,105:110]) = 1;
X=[x1 X24];
y=exp(y);


%% Example 2: automatic model selection create figure 7.10
[VALtfin,~]=avasms(y,X);
disp(VALtfin)
prin=0;
if prin==1
    % print to postscript
    print -depsc figs\glyph1.eps;
end

%% Example 2: all options set to false, create Figure 7.11
close all
out=avas(y,X,'rob',false,'tyinitial',false,...
    'scail',false,'orderR2',false,'trapezoid',false);
aceplot(out,'oneplot',true)
disp(out)
if prin==1
    % print to postscript
    print -depsc figs\glyph1bis.eps;
end

%%  Example 2: all options set to true
out=avas(y,X,'rob',true,'tyinitial',true,...
    'scail',true,'orderR2',true,'trapezoid',true);


%% Example 2: create Figure 7.12
close all
aceplot(out)
close(findobj('type','figure','Tag','pl_tX'));

disp(out)
highlight=out.outliers;
tX=out.tX;
addout=~isempty(highlight);
% Add the fourth panel referred to X1 and tX1
subplot(2,2,4)
j=1;

plot(X(:,j),tX(:,j),'o')
a=gca;
a.XTickLabel='';
R=rug(0.03);
try
    delete(R.yRug)
catch
end
jstr=num2str(j);

ylabel(['Transformed X' jstr])
xlabel(['X' jstr])

if addout ==true
    hold('on')
    plot(X(highlight,j),tX(highlight,j),'ro','MarkerFaceColor','r')
end
prin=0;
if prin==1
    % print to postscript
    print -depsc figs\glyph1tris.eps;
end

%% Example from Wang and Murphy: generate the data
close all
rng('default')
seed=100;
negstate=-30;
n=200;
X1 = mtR(n,0,seed)*2-1;
X2 = mtR(n,0,negstate)*2-1;
X3 = mtR(n,0,negstate)*2-1;
X4 = mtR(n,0,negstate)*2-1;
res=mtR(n,1,negstate);
% Generate y
y = log(4 + sin(3*X1) + abs(X2) + X3.^2 + X4 + .1*res );
X = [X1 X2 X3 X4];
y([121 80 34 188 137 110 79 86 1])=1.9+randn(9,1)*0.01;


%% Example from Wang and Murphy: create Figure 10 
% Automatic model selection
close all
[VALtfinchk,Resarraychk]=avasms(y,X,'plots',0);
avasmsplot(VALtfinchk,'showBars',true)
if prin==1
    % print to postscript
    print -depsc figs\WM1.eps;
end

%% Example from Wang and Murphy: extract best solution
close all
j=1;
outj=VALtfinchk{j,"Out"};
out=outj{:};


%% Example from Wang and Murphy: create Figure 7.14
% ty vs y and residuaal vs fit for best solution (2 panels plot)
highlight=out.outliers;
tX=out.tX;
ty=out.ty;
addout=~isempty(highlight);

figure
subplot(2,2,1)
plot(y,ty,'o')
ylabel('Transformed y')
xlabel('y')
title('Plot of ty vs. y')
if addout ==true
    hold('on')
    plot(y(highlight),ty(highlight),'ro','MarkerFaceColor','r')
end

yhat=sum(tX,2);
res = ty - yhat;
subplot(2,2,2)
plot(yhat,res,'o')
refline(0,0)
title('Plot of residuals vs. fit')
ylabel('Residuals')
xlabel('Fitted values')
if addout ==true
    hold('on')
    plot(yhat(highlight),res(highlight),'ro','MarkerFaceColor','r')
end

if prin==1
    % print to postscript
    print -depsc figs\WM2.eps;
end

%% Example from Wang and Murphy: create Figure 7.15
% tXj against Xj for j=1, 2, 3 and 4.
close all
aceplot(out)
close(findobj('type','figure','Tag','pl_ty'));

if prin==1
    % print to postscript
    print -depsc figs\WM3.eps;
end


%%  Marketing data
% https://www.kaggle.com/fayejavad/marketing-linear-multiple-regression
clear
close all
load('Marketing_Data')
y=Marketing_Data{:,4};
X=Marketing_Data{:,1:3};

% Fit regression model based on the original data
fitlm(X,y)
% F stat is 504

%%  Marketing data: all options set to false.
% Monotonicity of the expl. variables imposed.
out=avas(y,X,'rob',false,'tyinitial',false,'orderR2',false,...
    'scail',false,'trapezoid',false','l',3*ones(size(X,2),1));
aceplot(out,'oneplot',true)
prin=0;
if prin==1
    % print to postscript
    print -depsc figs\MD1.eps;
end

%% Marketing data: regression model based on transformed data using all options set to false
% find F-value
fitlm(out.tX,out.ty)
% F stat is 472 (even smaller than that for linear regression)

%% Marketing data: all options set to true. Create Figure 7.21
close all
out=avas(y,X,'trapezoid',true,'rob',true,'tyinitial',true,'orderR2',true,'scail',true,'l',3*ones(size(X,2),1));
aceplot(out,'oneplot',true)

if prin==1
    % print to postscript
    print -depsc figs\MD2.eps;
end

%% Marketing data: regression model based on transformed data using all options set to true
% find F value
fitlm(out.tX,out.ty,'Exclude',out.outliers)
% F stat excluding the outliers is 936

%% Marketing data: model selection with quadratic model, create Figure 7.22
close all
Xq=[X(:,1:2) X(:,1).^2 X(:,2).^2 X(:,1).*X(:,2)];
[VALtfin,CorrMat]=avasms(y,Xq,'l',3*ones(size(Xq,2),1),...
    'critBestSol',0.03,'maxBestSol',4);
avasmsplot(VALtfin)
disp(VALtfin)

if prin==1
    % print to postscript
    print -depsc figs\MD3.eps;
end

%% Marketing data: show details of best solution, create Figure 7.23
close all
j=1;
outj=VALtfin{j,"Out"};
solj=outj{:};
VarNames={'X_1' 'X_2' 'X_1^2' 'X_2^2' 'X_1X_2' 'y'};
aceplot(solj,'oneplot',true,'VarNames',VarNames)
if prin==1
    % print to postscript
    print -depsc figs\MD4.eps;
end

% Regression model on the transformed scale
outjr=fitlm(solj.tX,solj.ty,'Exclude',solj.outliers,'VarNames',VarNames);

%% Marketing data: quadratic model all options set to false
out=avas(y,Xq,'l',3*ones(size(Xq,2),1));
fitlm(out.tX,out.ty,'Exclude','')
% The F-stat now has a value of 556, hardly better than regression on the
% first-order model without transformation of the response or of the
% explanatory variables

%% Create Figure 7.24
close all
% In the paper just the two top panels have been shown
aceplot(out,'oneplot',true)
if prin==1
    % print to postscript
    print -depsc figs\MD5.eps;
end