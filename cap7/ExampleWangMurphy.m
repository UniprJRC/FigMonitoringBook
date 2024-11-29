%% Example from Wang and Murphy
% This file creates Figures 7.13-7.15

%% Generate the data
close all
prin=0;

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
% yXplot(y,X)

%% Prepare input for Figure 7.13
% automatic model selection
[VALtfin,Resarray]=avasms(y,X,'plots',0);
% disp(VALtfin)

%% Create figure 7.13:
H=avasmsplot(VALtfin,'showBars',true);
if prin==1
    % print to postscript
    print -depsc WM1.eps;
else
    title(H,'Figure 7.13')
    set(gcf,"Name",'Figure 7.13')
end

%% Create Figures 7.14 and 7.15 extract best solution
j=1;
outj=VALtfin{j,"Out"};
out=outj{:};
aceplot(out,'tyFitted',false)

pl_ty=findobj(0, 'type', 'figure','tag','pl_ty');
figure(pl_ty(1))
if prin==1
    print -depsc WM2.eps;
else
    sgtitle('Figure 7.14')
    set(gcf,"Name",'Figure 7.14')
end

pl_tX=findobj(0, 'type', 'figure','tag','pl_tX');
figure(pl_tX(1))

if prin==1
    % print to postscript
    print -depsc figs\WM3.eps;
else
    sgtitle('Figure 7.15')
    set(gcf,"Name",'Figure 7.15')
end

%InsideREADME

