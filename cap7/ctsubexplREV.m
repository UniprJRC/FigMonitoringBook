prin=0;
rng('default')
rng(3000)
divisor=10;
divisor=9.5;
x = (0:pi/divisor:pi)';
y = sin(x);
% + 0.001*(rand(size(x))-0.5);
% y([3,6:8]) = 1;
X=x;
y=exp(y);
scatter(x,y)
trap=false;
% Standard non-robust analysis without options.
out=avas(y,x,'rob',false,'tyinitial',false,...
    'orderR2',false,'scail',false,'trapezoid',trap);

if prin==1
    % print to postscript
    print -depsc ctsubxy.eps;
end
%%
clear
load wsctsub.mat
close all
sel=[1:8 10]';
plot(yhatord(sel),smoothresm1Ordyhat(sel),'LineWidth',2)
hold('on')
stem(yhatord(sel),smoothresm1Ordyhat(sel))
scatter(ty,zeros(length(ty),1),'black','filled')
set(gca,"XTickLabel",'');
n=length(yhatord);
yhatstr="$z_{["+ string((1:n-1)') + "]}$";
text(yhatord(sel)',zeros(n-1,1)-0.7,yhatstr,'Interpreter','latex', ...
    'FontSize',16,'VerticalAlignment','baseline','HorizontalAlignment','center')

% yhatstr10="$z_{["+ string(n) + "]}$";
% text(yhatord(n)+0.01,zeros(1,1)-0.7,yhatstr10,'Interpreter','latex', ...
%     'FontSize',16,'VerticalAlignment','baseline','HorizontalAlignment','left')

tyhatstr="$t_{"+ string((1:n)') + "}$";
text(ty,zeros(n,1)+0.8,tyhatstr,'Interpreter','latex', ...
    'FontSize',16,'VerticalAlignment','top','HorizontalAlignment','left')
vstr="$v_{"+ string((1:n-1)') + "}$";

text(yhatord(sel),smoothresm1Ordyhat(sel),vstr,'Interpreter','latex', ...
    'FontSize',16,'VerticalAlignment','top','HorizontalAlignment','left')
xlabel('Ordered fitted values','FontSize',14)
ylabel('Reciprocal of smoothed residuals ($v$)','Interpreter','latex', ...
    'FontName','Courier New','FontSize',16)
vec_pos = get(get(gca, 'XLabel'), 'Position');
set(get(gca, 'XLabel'), 'Position', vec_pos + [0 -0.5 0]);
set(gca,"Xtick",'')
prin=0;
if prin==1
    % print to postscript
    print -depsc ctsub.eps;
end


%% just show 1 trapezoid on the left area for hatty_1^(0)
clear
load wsctsub.mat
close all
sel=[1:8 10]';
ty(10)=ty(10)-0.1;
plot(yhatord(sel),smoothresm1Ordyhat(sel),'LineWidth',2)
hold('on')
stem(yhatord(sel),smoothresm1Ordyhat(sel))
scatter(ty,zeros(length(ty),1),'black','filled')
set(gca,"XTickLabel",'');
n=length(yhatord);

yhatstr="$z_{["+ string((1:n-1)') + "]}$";
text(yhatord(sel)',zeros(n-1,1)-0.7,yhatstr,'Interpreter','latex', ...
    'FontSize',16,'VerticalAlignment','baseline','HorizontalAlignment','center')

% yhatstr10="$z_{["+ string(n) + "]}$";
% text(yhatord(n)+0.01,zeros(1,1)-0.7,yhatstr10,'Interpreter','latex', ...
%     'FontSize',16,'VerticalAlignment','baseline','HorizontalAlignment','left')

tyhatstr="$t_{"+ string((1:n)') + "}$";
text(ty,zeros(n,1)+0.8,tyhatstr,'Interpreter','latex', ...
    'FontSize',16,'VerticalAlignment','top','HorizontalAlignment','left')
% vstr="$v_{"+ string((1:n)') + "}$";
% 
% text(yhatord(1:ngood),smoothresm1Ordyhat,vstr,'Interpreter','latex', ...
%     'FontSize',16,'VerticalAlignment','top','HorizontalAlignment','left')

vstr="$v_{"+ string((1:n-1)') + "}$";

text(yhatord(sel),smoothresm1Ordyhat(sel),vstr,'Interpreter','latex', ...
    'FontSize',16,'VerticalAlignment','top','HorizontalAlignment','left')

xlabel('Ordered fitted values','FontSize',14)
ylabel('Reciprocal of smoothed residuals ($v$)','Interpreter','latex', ...
    'FontName','Courier New','FontSize',16)
vec_pos = get(get(gca, 'XLabel'), 'Position');
set(get(gca, 'XLabel'), 'Position', vec_pos + [0 -0.5 0]);
set(gca,"Xtick",'')

vbar=mean(smoothresm1Ordyhat(1:ngood));
stem(ty(1),vbar)
xcoo=[ty(1) ty(1) yhatord(1) yhatord(1)];
ycoo=[0 vbar smoothresm1Ordyhat(1) 0];
fill(xcoo,ycoo,'g','FaceAlpha',0.1)
text(ty(1),vbar+0.2,'$\overline{v}$','FontSize',16,'Interpreter','latex')
prin=0;
if prin==1
    % print to postscript
    print -depsc ctsubthat1.eps;
end

%% just show some trapezoids  area for hatty_3^(0)
clear
load wsctsub.mat
close all
sel=[1:8 10]';
ty(10)=ty(10)-0.1;

plot(yhatord(sel),smoothresm1Ordyhat(sel),'LineWidth',2)
hold('on')
stem(yhatord(sel),smoothresm1Ordyhat(sel))
scatter(ty,zeros(length(ty),1),'black','filled')
set(gca,"XTickLabel",'');
n=length(yhatord);

yhatstr="$z_{["+ string((1:n-1)') + "]}$";
text(yhatord(sel)',zeros(n-1,1)-0.7,yhatstr,'Interpreter','latex', ...
    'FontSize',16,'VerticalAlignment','baseline','HorizontalAlignment','center')


% yhatstr="$z_{["+ string((1:(n-1))') + "]}$";
% text(yhatord(1:n-1),zeros(n-1,1)-0.7,yhatstr,'Interpreter','latex', ...
%     'FontSize',16,'VerticalAlignment','baseline','HorizontalAlignment','center')

% yhatstr10="$z_{["+ string(n) + "]}$";
% text(yhatord(n)+0.01,zeros(1,1)-0.7,yhatstr10,'Interpreter','latex', ...
%     'FontSize',16,'VerticalAlignment','baseline','HorizontalAlignment','left')

tyhatstr="$t_{"+ string((1:n)') + "}$";
text(ty,zeros(n,1)+0.8,tyhatstr,'Interpreter','latex', ...
    'FontSize',16,'VerticalAlignment','top','HorizontalAlignment','left')
% vstr="$v_{"+ string((1:n)') + "}$";
% 
% text(yhatord(1:ngood),smoothresm1Ordyhat,vstr,'Interpreter','latex', ...
%     'FontSize',16,'VerticalAlignment','top','HorizontalAlignment','left')


vstr="$v_{"+ string((1:n-1)') + "}$";

text(yhatord(sel),smoothresm1Ordyhat(sel),vstr,'Interpreter','latex', ...
    'FontSize',16,'VerticalAlignment','top','HorizontalAlignment','left')


xlabel('Ordered fitted values','FontSize',14)
ylabel('\textsf{Reciprocal of smoothed residuals} ($v$)','Interpreter','latex', ...
    'FontName','Times New Roman','FontSize',16)
vec_pos = get(get(gca, 'XLabel'), 'Position');
set(get(gca, 'XLabel'), 'Position', vec_pos + [0 -0.5 0]);
set(gca,"Xtick",'')

vbar=mean(smoothresm1Ordyhat(1:ngood));
% stem(ty(1),vbar)
xcoo=[yhatord(1) yhatord(1) yhatord(2:4)' ty(3) ty(3)];
ycoo=[0 smoothresm1Ordyhat(1:4)' 8.59 0];
fill(xcoo,ycoo,'g','FaceAlpha',0.1)
% text(ty(1),vbar+0.2,'$\overline{v}$','FontSize',16,'Interpreter','latex')
prin=0;
if prin==1
    % print to postscript
    print -depsc ctsubthat3.eps;
end

%% just show some trapezoids  area for hatty_5^(0)
clear
load wsctsub.mat
close all
sel=[1:8 10]';
ty(10)=ty(10)-0.1;

plot(yhatord(sel),smoothresm1Ordyhat(sel),'LineWidth',2)
hold('on')
stem(yhatord(sel),smoothresm1Ordyhat(sel))
scatter(ty,zeros(length(ty),1),'black','filled')
set(gca,"XTickLabel",'');
n=length(yhatord);

yhatstr="$z_{["+ string((1:n-1)') + "]}$";
text(yhatord(sel)',zeros(n-1,1)-0.7,yhatstr,'Interpreter','latex', ...
    'FontSize',16,'VerticalAlignment','baseline','HorizontalAlignment','center')


% yhatstr="$z_{["+ string((1:(n-1))') + "]}$";
% text(yhatord(1:n-1),zeros(n-1,1)-0.7,yhatstr,'Interpreter','latex', ...
%     'FontSize',16,'VerticalAlignment','baseline','HorizontalAlignment','center')

% yhatstr10="$z_{["+ string(n) + "]}$";
% text(yhatord(n)+0.01,zeros(1,1)-0.7,yhatstr10,'Interpreter','latex', ...
%     'FontSize',16,'VerticalAlignment','baseline','HorizontalAlignment','left')

tyhatstr="$t_{"+ string((1:n)') + "}$";
text(ty,zeros(n,1)+0.8,tyhatstr,'Interpreter','latex', ...
    'FontSize',16,'VerticalAlignment','top','HorizontalAlignment','left')
% vstr="$v_{"+ string((1:n)') + "}$";
% 
% text(yhatord(1:ngood),smoothresm1Ordyhat,vstr,'Interpreter','latex', ...
%     'FontSize',16,'VerticalAlignment','top','HorizontalAlignment','left')

vstr="$v_{"+ string((1:n-1)') + "}$";

text(yhatord(sel),smoothresm1Ordyhat(sel),vstr,'Interpreter','latex', ...
    'FontSize',16,'VerticalAlignment','top','HorizontalAlignment','left')

xlabel('Ordered fitted values','FontSize',14)
ylabel('Reciprocal of smoothed residuals ($v$)','Interpreter','latex', ...
    'FontName','Helvetica','FontSize',16)
vec_pos = get(get(gca, 'XLabel'), 'Position');
set(get(gca, 'XLabel'), 'Position', vec_pos + [0 -0.5 0]);
set(gca,"Xtick",'')

vbar=mean(smoothresm1Ordyhat(1:ngood));
% stem(ty(1),vbar)
xcoo=[yhatord(1) yhatord(1) yhatord([2:end-2 end])' yhatord(end)];
ycoo=[0 smoothresm1Ordyhat([1:end-2 end])' 0];
fill(xcoo,ycoo,'g','FaceAlpha',0.1)

stem(ty(5),vbar)
xcoo=[yhatord(end) yhatord(end) ty(5) ty(5)];
ycoo=[0 smoothresm1Ordyhat(end) vbar  0];
fill(xcoo,ycoo,'g','FaceAlpha',0.1)
text(ty(5),vbar+0.2,'$\overline{v}$','FontSize',16,'Interpreter','latex')
% text(ty(1),vbar+0.2,'$\overline{v}$','FontSize',16,'Interpreter','latex')


prin=0;
if prin==1
    % print to postscript
    print -depsc ctsubthat5.eps;
end