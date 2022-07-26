%% Details of optimal link for different values of c

% Plot of rho function. TODO incomplete file
close all
subplot(2,2,1)
hold('on')
x=-9:0.1:9;
c=OPTeff(0.5,1);

rhoOPT=OPTrho(x,c);
maxrho=max(rhoOPT);
% rhoHA=rhoHA/maxrho;
plot(x,rhoOPT,'LineWidth',2)
xlabel('$u$','Interpreter','Latex')
ylabel(['$\rho(u,c=' num2str(c) ') $'],'Interpreter','Latex','FontSize',14)


stem(c,1,'LineWidth',1,'LineStyle',':','Color','r')
stem(-c,1,'LineWidth',1,'LineStyle',':','Color','r')
kk=0.25;
text(c,kk,{'$c$'},'Interpreter','latex','FontSize',14,'HorizontalAlignment','left')
text(-c,kk,{'$-c$'},'Interpreter','latex','FontSize',14,'HorizontalAlignment','right')

subplot(2,2,3)
hold('on')
psiOPT=OPTpsi(x,c);
% psiHA=psiHA/maxrho;
plot(x,psiOPT,'LineWidth',2)
xlabel('$u$','Interpreter','Latex','FontSize',14)
ylabel(['$\psi(u,c=' num2str(c) ') $'],'Interpreter','Latex','FontSize',14)

stem(c,0,'LineWidth',1,'LineStyle',':','Color','r')
stem(-c,0,'LineWidth',1,'LineStyle',':','Color','r')

ax=axis;
ylim([ax(3)-0.1 ax(4)+0.1])
kk=0.2;
text(c,-kk,{'$c$'},'Interpreter','latex','FontSize',14,'HorizontalAlignment','left')

text(-c,kk,{'$-c$'},'Interpreter','latex','FontSize',14,'HorizontalAlignment','right')


c=OPTbdp(0.5,1);
subplot(2,2,2)
hold('on')
x=-9:0.1:9;
rhoOPT=OPTrho(x,c);
maxrho=max(rhoOPT);
% rhoHA=rhoHA/maxrho;
plot(x,rhoOPT,'LineWidth',2)
xlabel('$u$','Interpreter','Latex')
ylabel(['$\rho(u,c=' num2str(c) ') $'],'Interpreter','Latex','FontSize',14)


stem(c,1,'LineWidth',1,'LineStyle',':','Color','r')
stem(-c,1,'LineWidth',1,'LineStyle',':','Color','r')
kk=0.03;
text(c,kk,{'$c$'},'Interpreter','latex','FontSize',14,'HorizontalAlignment','left')

text(-c,kk,{'$-c$'},'Interpreter','latex','FontSize',14,'HorizontalAlignment','right')

subplot(2,2,4)
hold('on')
psiOPT=OPTpsi(x,c);
% psiHA=psiHA/maxrho;
plot(x,psiOPT,'LineWidth',2)
xlabel('$u$','Interpreter','Latex','FontSize',14)
ylabel(['$\psi(u,c=' num2str(c) ') $'],'Interpreter','Latex','FontSize',14)

stem(c,0,'LineWidth',1,'LineStyle',':','Color','r')
stem(-c,0,'LineWidth',1,'LineStyle',':','Color','r')

ax=axis;
kk=0.05;
ylim([ax(3)-0.1 ax(4)+0.1])
text(c,-kk,{'$c$'},'Interpreter','latex','FontSize',14,'HorizontalAlignment','left')

text(-c,kk,{'$-c$'},'Interpreter','latex','FontSize',14,'HorizontalAlignment','right')


if prin==1
    % print to postscript
    print -depsc rhoOPT.eps;
end