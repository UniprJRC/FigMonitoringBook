%% Details of hyperbolic link for different values of c
% Creates Figure 2.9

% Plot of rho function.
close all
yl=0.25;
lw=2;
prin=0;
subplot(2,2,1)
hold('on')
x=-7:0.1:7;

ctuning=6;   % bdp= 0.0596  eff= 0.9861
ktuning=5;
rhoHYPk5=HYPrho(x,[ctuning,ktuning]);
maxrhoHYPk5=max(rhoHYPk5);
rhoHYPk5=rhoHYPk5/maxrhoHYPk5;
plot(x,rhoHYPk5,'color','b','LineStyle','-','LineWidth',lw)
text(2.3,0.1,['k=' num2str(ktuning)],'Color','b','FontSize',14)

ktuning=3; % bdp= 0.0933 eff=0.9052
rhoHYPk3=HYPrho(x,[ctuning,ktuning]);
maxrhoHYPk3=max(rhoHYPk3);
rhoHYPk3=rhoHYPk3/maxrhoHYPk3;

plot(x,rhoHYPk3,'color','k','LineStyle','--','LineWidth',lw)
text(0,0.4,['k=' num2str(ktuning)],'Color','k','FontSize',14,'HorizontalAlignment','center')
xlabel('$u$','Interpreter','Latex')
ylabel('$\rho(u,c=6,k) $','Interpreter','Latex','FontSize',14)

stem(ctuning,1,'LineWidth',1,'LineStyle',':','Color','r')
stem(-ctuning,1,'LineWidth',1,'LineStyle',':','Color','r')
kk=0.05;
text(ctuning,kk,{'$c$'},'Interpreter','latex','FontSize',14,'HorizontalAlignment','left')
text(-ctuning,kk,{'$-c$'},'Interpreter','latex','FontSize',14,'HorizontalAlignment','right')

subplot(2,2,3)
hold('on')

% [bdp,eff]=HYPc(6,1)
lw=1.5;
ctuning=6;
ktuning=5;
psiHYP=HYPpsi(x,[ctuning,ktuning]);
psiHYP=psiHYP/maxrhoHYPk5;
plot(x,psiHYP,'color','b','LineStyle','-','LineWidth',lw)
text(6,0.2,['k=' num2str(ktuning)],'Color','b','FontSize',14)
xlabel('$u$','Interpreter','Latex','FontSize',14)
ylabel('$\psi(u,c=6,k) $','Interpreter','Latex','FontSize',14)
%     text(ctuning,-0.1,'c','FontSize',14)
%     text(-ctuning,0.1,'-c','FontSize',14)
hold('on')
ktuning=3;
psiHYP=HYPpsi(x,[ctuning,ktuning]);
psiHYP=psiHYP/maxrhoHYPk3;

plot(x,psiHYP,'color','k','LineStyle','--','LineWidth',lw)
text(1,-0.1,['k=' num2str(ktuning)],'Color','k','FontSize',14)


stem(ctuning,0,'LineWidth',1,'LineStyle',':','Color','r')
stem(-ctuning,0,'LineWidth',1,'LineStyle',':','Color','r')

ax=axis;
ylim([ax(3)-0.1 ax(4)+0.1])
kk=0.02;
text(ctuning,-kk,{'$c$'},'Interpreter','latex','FontSize',14,'HorizontalAlignment','left')

text(-ctuning,kk,{'$-c$'},'Interpreter','latex','FontSize',14,'HorizontalAlignment','right')
ylim([-yl,yl])


subplot(2,2,2)
hold('on')
ctuning=2.3563;   % bdp= 0.30  eff= 0.64
ktuning=5;
rhoHYPk5=HYPrho(x,[ctuning,ktuning]);
maxrhoHYPk5=max(rhoHYPk5);
rhoHYPk5=rhoHYPk5/maxrhoHYPk5;
plot(x,rhoHYPk5,'color','b','LineStyle','-','LineWidth',lw)
text(1.2,0.1,['k=' num2str(ktuning)],'Color','b','FontSize',14)

ktuning=3; % bdp= 0.4767 eff=03324
rhoHYPk3=HYPrho(x,[ctuning,ktuning]);
maxrhoHYPk3=max(rhoHYPk3);
rhoHYPk3=rhoHYPk3/maxrhoHYPk3;

plot(x,rhoHYPk3,'color','k','LineStyle','--','LineWidth',lw)
text(0,0.4,['k=' num2str(ktuning)],'Color','k','FontSize',14,'HorizontalAlignment','center')
xlabel('$u$','Interpreter','Latex')
ylabel(['$\rho(u,c=' num2str(ctuning) ',k) $'],'Interpreter','Latex','FontSize',14)

stem(ctuning,1,'LineWidth',1,'LineStyle',':','Color','r')
stem(-ctuning,1,'LineWidth',1,'LineStyle',':','Color','r')
kk=0.05;
text(ctuning,kk,{'$c$'},'Interpreter','latex','FontSize',14,'HorizontalAlignment','left')
text(-ctuning,kk,{'$-c$'},'Interpreter','latex','FontSize',14,'HorizontalAlignment','right')

subplot(2,2,4)
hold('on')
yl=0.17;
% [bdp,eff]=HYPc(6,1)
lw=1.5;
x=-9:0.1:9;
ctuning=1.9007;   % bdp= 0.50  eff= 0.3009
ktuning=5;
psiHYP=HYPpsi(x,[ctuning,ktuning]);
psiHYP=psiHYP/maxrhoHYPk5;
plot(x,psiHYP,'color','b','LineStyle','-','LineWidth',lw)
% text(6,0.2,['k=' num2str(ktuning)],'Color','b','FontSize',14)
xlabel('$u$','Interpreter','Latex','FontSize',14)
ylabel(['$\psi(u,c=' num2str(ctuning) ',k) $'],'Interpreter','Latex','FontSize',14)
%     text(ctuning,-0.1,'c','FontSize',14)
%     text(-ctuning,0.1,'-c','FontSize',14)
hold('on')
ktuning=3;
psiHYP=HYPpsi(x,[ctuning,ktuning]);
psiHYP=psiHYP/maxrhoHYPk3;

plot(x,psiHYP,'color','k','LineStyle','--','LineWidth',lw)
% text(1,-0.1,['k=' num2str(ktuning)],'Color','k','FontSize',14)


stem(ctuning,0,'LineWidth',1,'LineStyle',':','Color','r')
stem(-ctuning,0,'LineWidth',1,'LineStyle',':','Color','r')

ax=axis;
ylim([ax(3)-0.1 ax(4)+0.1])
kk=0.02;
text(ctuning,-kk,{'$c$'},'Interpreter','latex','FontSize',14,'HorizontalAlignment','left')

text(-ctuning,kk,{'$-c$'},'Interpreter','latex','FontSize',14,'HorizontalAlignment','right')
ylim([-yl,yl])

sgtitle('Figure 2.9')
set(gcf,"Name",'Figure 2.9')

if prin==1
    % print to postscript
    print -depsc rhoHYP.eps;
end