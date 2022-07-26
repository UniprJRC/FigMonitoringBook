%% Details of PD link for different values of alpha

% Plot of rho function. PD
close all
c=0.2245;
subplot(2,2,1)
hold('on')
x=-9:0.1:9;
rhoPD=PDrho(x,c);
maxrho=max(rhoPD);
% rhoHA=rhoHA/maxrho;
plot(x,rhoPD,'LineWidth',2)
xlabel('$u$','Interpreter','Latex')
ylabel(['$\rho(u,c=' num2str(c) ') $'],'Interpreter','Latex','FontSize',14)


% stem(c,1,'LineWidth',1,'LineStyle',':','Color','r')
% stem(-c,1,'LineWidth',1,'LineStyle',':','Color','r')
% kk=0.25;
% text(c,kk,{'$c$'},'Interpreter','latex','FontSize',14,'HorizontalAlignment','left')
% text(-c,kk,{'$-c$'},'Interpreter','latex','FontSize',14,'HorizontalAlignment','right')

subplot(2,2,3)
hold('on')
psiPD=PDpsi(x,c);
% psiHA=psiHA/maxrho;
plot(x,psiPD,'LineWidth',2)
xlabel('$u$','Interpreter','Latex','FontSize',14)
ylabel(['$\psi(u,c=' num2str(c) ') $'],'Interpreter','Latex','FontSize',14)
yline(0)
% stem(c,0,'LineWidth',1,'LineStyle',':','Color','r')
% stem(-c,0,'LineWidth',1,'LineStyle',':','Color','r')
% 
 ax=axis;
% ylim([ax(3)-0.1 ax(4)+0.1])
% kk=0.2;
% text(c,-kk,{'$c$'},'Interpreter','latex','FontSize',14,'HorizontalAlignment','left')
% text(-c,kk,{'$-c$'},'Interpreter','latex','FontSize',14,'HorizontalAlignment','right')


c=3;
subplot(2,2,2)
hold('on')
x=-9:0.1:9;
rhoPD=PDrho(x,c);
maxrho=max(rhoPD);
% rhoHA=rhoHA/maxrho;
plot(x,rhoPD,'LineWidth',2)
xlabel('$u$','Interpreter','Latex')
ylabel(['$\rho(u,c=' num2str(c) ') $'],'Interpreter','Latex','FontSize',14)


% stem(c,1,'LineWidth',1,'LineStyle',':','Color','r')
% stem(-c,1,'LineWidth',1,'LineStyle',':','Color','r')
% kk=0.03;
% text(c,kk,{'$c$'},'Interpreter','latex','FontSize',14,'HorizontalAlignment','left')
% text(-c,kk,{'$-c$'},'Interpreter','latex','FontSize',14,'HorizontalAlignment','right')

subplot(2,2,4)
hold('on')
psiPD=PDpsi(x,c);
% psiHA=psiHA/maxrho;
plot(x,psiPD,'LineWidth',2)
xlabel('$u$','Interpreter','Latex','FontSize',14)
ylabel(['$\psi(u,c=' num2str(c) ') $'],'Interpreter','Latex','FontSize',14)

% stem(c,0,'LineWidth',1,'LineStyle',':','Color','r')
% stem(-c,0,'LineWidth',1,'LineStyle',':','Color','r')
yline(0)

ax=axis;
kk=0.05;
ylim([ax(3)-0.1 ax(4)+0.1])
% text(c,-kk,{'$c$'},'Interpreter','latex','FontSize',14,'HorizontalAlignment','left')
% 
% text(-c,kk,{'$-c$'},'Interpreter','latex','FontSize',14,'HorizontalAlignment','right')


if prin==1
    % print to postscript
    print -depsc rhoPD.eps;
end