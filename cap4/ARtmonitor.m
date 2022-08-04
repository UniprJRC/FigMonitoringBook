%% MR: Forward EDA rescaled t stat monitoring
close all;
showtit=false;
load('multiple_regression.txt');
y=multiple_regression(:,4);
X=multiple_regression(:,1:3);
% LMS using 10000 subsamples
[out]=LXS(y,X,'nsamp',10000);
% Forward Search
[out]=FSReda(y,X,out.bs);
nr=2;
nc=1;
subplot(nr,nc,1)
hold('on');
plot(out.Tols(:,1),out.Tols(:,3:end),'LineWidth',3)
for j=3:5
    tj=['t_' num2str(j-2)];
    text(out.Tols(1,1)-1.2,out.Tols(1,j),tj,'FontSize',16)
    
end

quant=norminv(0.95);
v=axis;
lwdenv=2;
line([v(1),v(2)],[quant,quant],'color','g','LineWidth',lwdenv);
line([v(1),v(2)],[-quant,-quant],'color','g','LineWidth',lwdenv);
% plot(out.Tols(end-6:end-1,1),out.Tols(end-6:end-1,3),'LineWidth',4,'color','r')
if showtit==true
title('Monitoring of t-stat','FontSize',14);
end
xlabel('Subset size m');

subplot(2,1,2)
% MR: monitoring of t-stat with zoom for first variable
hold('on');
plot(out.Tols(:,1),out.Tols(:,3:end))
ylim([-3 5]);
quant=norminv(0.95);
v=axis;
lwdenv=2;
line([v(1),v(2)],[quant,quant],'color','g','LineWidth',lwdenv);
line([v(1),v(2)],[-quant,-quant],'color','g','LineWidth',lwdenv);
plot(out.Tols(end-6:end-1,1),out.Tols(end-6:end-1,3),'LineWidth',4,'color','r')
if showtit==true
title('Monitoring of t-stat for first variable');
end
xlabel('Subset size m');
plot(out.Tols(end-7:end-6,1),out.Tols(end-7:end-6,3),'LineWidth',4,'color','b')
plot(out.Tols(end-1:end,1),out.Tols(end-1:end,3),'LineWidth',4,'color','b')
text(out.Tols(end-7,1),out.Tols(end-7,3)+0.9,'43','FontSize',12);
text(out.Tols(end-1,1),out.Tols(end-1,3)+0.9,'43','FontSize',12);
%annotation(gcf,'textarrow',[0.54 0.68],...
%    [0.28 0.44],'TextEdgeColor','none');
text(53,1,'9, 21, 30, 31, 38, 47','FontSize',12,'Rotation',-25);
xlim([40 60])

if prin==1
    % print to postscript
    print -depsc ARtmonitor.eps;
end
