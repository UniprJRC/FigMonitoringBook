%% This figure creates Figures 7.1-7.3
clear
close all
load wsctsub.mat
n=length(ty);
sel=[1:8 10]';

prin=0;

%% Create Figure 7.1 
% just show 1 trapezoid on the left area for hatty_1^(0)
plot(yhatord(sel),v(sel),'LineWidth',2)
hold('on')
stem(yhatord(sel),v(sel))
scatter(ty,zeros(length(ty),1),'black','filled')
set(gca,"XTickLabel",'');

yhatstr="$z_{["+ string((1:n-1)') + "]}$";
text(yhatord(sel)',zeros(n-1,1)-0.7,yhatstr,'Interpreter','latex', ...
    'FontSize',16,'VerticalAlignment','baseline','HorizontalAlignment','center')

tyhatstr="$t_{"+ string((1:n)') + "}$";
text(ty,zeros(n,1)+0.8,tyhatstr,'Interpreter','latex', ...
    'FontSize',16,'VerticalAlignment','top','HorizontalAlignment','left')
vstr="$v_{"+ string((1:n-1)') + "}$";

text(yhatord(sel),v(sel),vstr,'Interpreter','latex', ...
    'FontSize',16,'VerticalAlignment','top','HorizontalAlignment','left')

xlabel('Ordered fitted values','FontSize',14)
ylabel('Reciprocal of smoothed residuals ($v$)','Interpreter','latex', ...
    'FontName','Courier New','FontSize',16)
vec_pos = get(get(gca, 'XLabel'), 'Position');
set(get(gca, 'XLabel'), 'Position', vec_pos + [0 -0.9 0],'Interpreter','latex');
set(gca,"Xtick",'')
ngood=9;
vbar=mean(v(1:ngood));
stem(ty(1),vbar)
xcoo=[ty(1) ty(1) yhatord(1) yhatord(1)];
ycoo=[0 vbar v(1) 0];
fill(xcoo,ycoo,'g','FaceAlpha',0.1)
text(ty(1),vbar+0.2,'$\overline{v}$','FontSize',16,'Interpreter','latex')
title('Figure 7.1')
set(gcf,"Name",'Figure 7.1')

if prin==1
    % print to postscript
    print -depsc ctsubthat1.eps;
end

%% Create Figure 7.2 
% just show some trapezoids  area for hatty_3^(0)
figure
plot(yhatord(sel),v(sel),'LineWidth',2)
hold('on')
stem(yhatord(sel),v(sel))
scatter(ty,zeros(n,1),'black','filled')
set(gca,"XTickLabel",'');

yhatstr="$z_{["+ string((1:n-1)') + "]}$";
text(yhatord(sel)',zeros(n-1,1)-0.7,yhatstr,'Interpreter','latex', ...
    'FontSize',16,'VerticalAlignment','baseline','HorizontalAlignment','center')


tyhatstr="$t_{"+ string((1:n)') + "}$";
text(ty,zeros(n,1)+0.8,tyhatstr,'Interpreter','latex', ...
    'FontSize',16,'VerticalAlignment','top','HorizontalAlignment','left')
vstr="$v_{"+ string((1:n-1)') + "}$";

text(yhatord(sel),v(sel),vstr,'Interpreter','latex', ...
    'FontSize',16,'VerticalAlignment','top','HorizontalAlignment','left')


xlabel('Ordered fitted values','FontSize',14)
ylabel('Reciprocal of smoothed residuals ($v$)','Interpreter','latex', ...
    'FontName','Times New Roman','FontSize',16)
vec_pos = get(get(gca, 'XLabel'), 'Position');
set(get(gca, 'XLabel'), 'Position', vec_pos + [0 -0.9 0],'Interpreter','latex');
set(gca,"Xtick",'')

xcoo=[yhatord(1) yhatord(1) yhatord(2:4)' ty(3) ty(3)];
ycoo=[0 v(1:4)' 8.59 0];
fill(xcoo,ycoo,'g','FaceAlpha',0.1)

title('Figure 7.2')
set(gcf,"Name",'Figure 7.2')

if prin==1
    % print to postscript
    print -depsc ctsubthat3.eps;
end

%% Create Figure 7.3 
% all some trapezoids selected + additional area for hatty_5^(0)
figure
plot(yhatord(sel),v(sel),'LineWidth',2)
hold('on')
stem(yhatord(sel),v(sel))
scatter(ty,zeros(length(ty),1),'black','filled')
set(gca,"XTickLabel",'');

yhatstr="$z_{["+ string((1:n-1)') + "]}$";
text(yhatord(sel)',zeros(n-1,1)-0.7,yhatstr,'Interpreter','latex', ...
    'FontSize',16,'VerticalAlignment','baseline','HorizontalAlignment','center')

tyhatstr="$t_{"+ string((1:n)') + "}$";
text(ty,zeros(n,1)+0.8,tyhatstr,'Interpreter','latex', ...
    'FontSize',16,'VerticalAlignment','top','HorizontalAlignment','left')

vstr="$v_{"+ string((1:n-1)') + "}$";

text(yhatord(sel),v(sel),vstr,'Interpreter','latex', ...
    'FontSize',16,'VerticalAlignment','top','HorizontalAlignment','left')

xlabel('Ordered fitted values','FontSize',14)
ylabel('Reciprocal of smoothed residuals ($v$)','Interpreter','latex', ...
    'FontName','Helvetica','FontSize',16)
vec_pos = get(get(gca, 'XLabel'), 'Position');
set(get(gca, 'XLabel'), 'Position', vec_pos + [0 -0.9 0],'Interpreter','latex');
set(gca,"Xtick",'')

vbar=mean(v(1:ngood));
% stem(ty(1),vbar)
xcoo=[yhatord(1) yhatord(1) yhatord([2:end-2 end])' yhatord(end)];
ycoo=[0 v([1:end-2 end])' 0];
fill(xcoo,ycoo,'g','FaceAlpha',0.1)

stem(ty(5),vbar)
xcoo=[yhatord(end) yhatord(end) ty(5) ty(5)];
ycoo=[0 v(end) vbar  0];
fill(xcoo,ycoo,'g','FaceAlpha',0.1)
text(ty(5),vbar+0.2,'$\overline{v}$','FontSize',16,'Interpreter','latex')
% text(ty(1),vbar+0.2,'$\overline{v}$','FontSize',16,'Interpreter','latex')

title('Figure 7.3')
set(gcf,"Name",'Figure 7.3')

prin=0;
if prin==1
    % print to postscript
    print -depsc ctsubthat5.eps;
end