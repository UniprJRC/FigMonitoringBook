%% Example 2, 4 explanatory variables (section 7.5.2).
% This file creates Figures 7.10-7.12

%% Beginning of code
clear
rng(100)
x1 = (0:0.1:15)';
n=length(x1);
X24=randn(n,3);
y = sin(x1) + 0.5*(rand(size(x1))-0.5) + X24*(1:3)';
y([90,100,105:110]) = 1;
X=[x1 X24];
y=exp(y);
prin=0;
% yXplot(y,X)

%% Example 2: automatic model selection create figure 7.10
[VALtfin,~]=avasms(y,X);
disp(VALtfin)
fig=findobj(0,'tag','pl_augstar');
figure(fig(1))

if prin==1
    % print to postscript
    print -depsc glyph1.eps;
else
    sgtitle('Figure 7.10')
    set(gcf,"Name",'Figure 7.10')
end

%% Create Figure 7.11: all options set to false,
outNoOption=avas(y,X,'rob',false,'tyinitial',false,...
    'scail',false,'orderR2',false,'trapezoid',false);
aceplot(outNoOption,'oneplot',true)

disp('pvalue of DW test (no option is used)')
disp(outNoOption.pvaldw)

disp('Value of R2 (no option is used)')
disp(outNoOption.rsq)


if prin==1
    % print to postscript
    print -depsc glyph1bis.eps;
else
    sgtitle('Figure 7.11')
    set(gcf,"Name",'Figure 7.11')
end

%% Create Figure 7.12: all options set to true
outALlopt=avas(y,X,'rob',true,'tyinitial',true,...
    'scail',true,'orderR2',true,'trapezoid',true);
aceplot(outALlopt,'oneplot','')
disp(outALlopt)
disp(['Number of outliers generated using all options=' num2str(length(outALlopt.outliers))])

if prin==1
    % print to postscript
    print -depsc figs\glyph1tris.eps;
else
    sgtitle('Figure 7.12')
    set(gcf,"Name",'Figure 7.12')
end
%InsideREADME