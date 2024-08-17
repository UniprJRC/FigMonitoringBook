%% Details of PD link for different values of alpha.
%
% This file creates Figure 2.10.

%% Plot of rho function. PD
close all
prin=0;
alpha=0.2245;
FontSize=14;
subplot(2,2,1)
hold('on')
x=-9:0.1:9;
rhoPD=PDrho(x,alpha);
% maxrho=max(rhoPD);
% rhoHA=rhoHA/maxrho;
plot(x,rhoPD,'LineWidth',2)
xlabel('$u$','Interpreter','Latex','FontSize',FontSize)
ylabel(['$\rho(u,\alpha=' num2str(alpha) ') $'],'Interpreter','Latex','FontSize',14)

subplot(2,2,3)
hold('on')
psiPD=PDpsi(x,alpha);
% psiHA=psiHA/maxrho;
plot(x,psiPD,'LineWidth',2)
xlabel('$u$','Interpreter','Latex','FontSize',FontSize)
ylabel(['$\psi(u,\alpha=' num2str(alpha) ') $'],'Interpreter','Latex','FontSize',14)
yline(0)


alpha=3;
subplot(2,2,2)
hold('on')
x=-9:0.1:9;
rhoPD=PDrho(x,alpha);
maxrho=max(rhoPD);
% rhoHA=rhoHA/maxrho;
plot(x,rhoPD,'LineWidth',2)
xlabel('$u$','Interpreter','Latex','FontSize',FontSize)
ylabel(['$\rho(u,\alpha=' num2str(alpha) ') $'],'Interpreter','Latex','FontSize',14)


subplot(2,2,4)
hold('on')
psiPD=PDpsi(x,alpha);
% psiHA=psiHA/maxrho;
plot(x,psiPD,'LineWidth',2)
xlabel('$u$','Interpreter','Latex','FontSize',FontSize)
ylabel(['$\psi(u,\alpha=' num2str(alpha) ') $'],'Interpreter','Latex','FontSize',14)

yline(0)

ax=axis;
kk=0.05;
ylim([ax(3)-0.1 ax(4)+0.1])


if prin==1
    % print to postscript
    print -depsc rhoPD.eps;
else
    sgtitle('Figure 2.10')
    set(gcf,"Name",'Figure 2.10')
end

%InsideREADME