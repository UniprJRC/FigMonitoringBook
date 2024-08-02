%% Example 1 (Section 7.5.1).
% This file creates Figures 7.4 and 7.5

%% Generate the data
% Ex1 (seven outliers).
rng('default')
rng(1000)
x = (0:0.1:15)';
y = sin(x) + 0.5*(rand(size(x))-0.5);
y([100,105:110]) = 1;
y=exp(y);
prin=0;

%% Create Figure 7.4 (non robust analysis, no option)
% Standard non-robust analysis without options.
outNoOption=avas(y,x,'rob',false,'tyinitial',false,...
    'orderR2',false,'scail',false,'trapezoid',false);
aceplot(outNoOption,'ResFitted',false,'oneplot',true)

if prin==1
    % print to postscript
    print -depsc figs\ex1TRAD.eps;
else
    sgtitle('Figure 7.4')
    set(gcf,"Name",'Figure 7.4')
end

%% Create Figure 7.5  (all options set to true)
outAlloption=avas(y,x,'rob',true,'tyinitial',true,...
    'orderR2',true,'scail',true,'trapezoid',true);
aceplot(outAlloption,'ResFitted',false,'oneplot',true)

if prin==1
    % print to postscript
    print -depsc ex1ROB.eps;
else
    sgtitle('Figure 7.5')
    set(gcf,"Name",'Figure 7.5')
end

%InsideREADME
