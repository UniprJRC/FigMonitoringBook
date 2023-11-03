%% Details of TB link for different values of c
% Creates Figure 2.8

% Plot of rho function.
close all
c=4.6851;
subplot(2,2,1)
hold('on')
x=-9:0.1:9;
rhoTB=TBrho(x,c);
% maxrho=max(rhoTB);
% rhoHA=rhoHA/maxrho;
plot(x,rhoTB,'LineWidth',2)
xlabel('$u$','Interpreter','Latex')
ylabel(['$\rho(u,c=' num2str(c) ') $'],'Interpreter','Latex','FontSize',14)


stem(c,c^2/6,'LineWidth',1,'LineStyle',':','Color','r')
stem(-c,c^2/6,'LineWidth',1,'LineStyle',':','Color','r')
kk=0.25;
text(c,kk,{'$c$'},'Interpreter','latex','FontSize',14,'HorizontalAlignment','left')
text(-c,kk,{'$-c$'},'Interpreter','latex','FontSize',14,'HorizontalAlignment','right')

subplot(2,2,3)
hold('on')
psiTB=TBpsi(x,c);
% psiHA=psiHA/maxrho;
plot(x,psiTB,'LineWidth',2)
xlabel('$u$','Interpreter','Latex','FontSize',14)
ylabel(['$\psi(u,c=' num2str(c) ') $'],'Interpreter','Latex','FontSize',14)

stem(c,0,'LineWidth',1,'LineStyle',':','Color','r')
stem(-c,0,'LineWidth',1,'LineStyle',':','Color','r')

ax=axis;
ylim([ax(3)-0.1 ax(4)+0.1])
kk=0.2;
text(c,-kk,{'$c$'},'Interpreter','latex','FontSize',14,'HorizontalAlignment','left')

text(-c,kk,{'$-c$'},'Interpreter','latex','FontSize',14,'HorizontalAlignment','right')


c=1.5476;
subplot(2,2,2)
hold('on')
x=-9:0.1:9;
rhoTB=TBrho(x,c);
maxrho=max(rhoTB);
% rhoHA=rhoHA/maxrho;
plot(x,rhoTB,'LineWidth',2)
xlabel('$u$','Interpreter','Latex')
ylabel(['$\rho(u,c=' num2str(c) ') $'],'Interpreter','Latex','FontSize',14)


stem(c,c^2/6,'LineWidth',1,'LineStyle',':','Color','r')
stem(-c,c^2/6,'LineWidth',1,'LineStyle',':','Color','r')
kk=0.03;
text(c,kk,{'$c$'},'Interpreter','latex','FontSize',14,'HorizontalAlignment','left')

text(-c,kk,{'$-c$'},'Interpreter','latex','FontSize',14,'HorizontalAlignment','right')

subplot(2,2,4)
hold('on')
psiTB=TBpsi(x,c);
% psiHA=psiHA/maxrho;
plot(x,psiTB,'LineWidth',2)
xlabel('$u$','Interpreter','Latex','FontSize',14)
ylabel(['$\psi(u,c=' num2str(c) ') $'],'Interpreter','Latex','FontSize',14)

stem(c,0,'LineWidth',1,'LineStyle',':','Color','r')
stem(-c,0,'LineWidth',1,'LineStyle',':','Color','r')

ax=axis;
kk=0.05;
ylim([ax(3)-0.1 ax(4)+0.1])
text(c,-kk,{'$c$'},'Interpreter','latex','FontSize',14,'HorizontalAlignment','left')

text(-c,kk,{'$-c$'},'Interpreter','latex','FontSize',14,'HorizontalAlignment','right')

sgtitle('Figure 2.8')
set(gcf,"Name",'Figure 2.8')

if prin==1
    % print to postscript
    print -depsc rhoTB.eps;
end