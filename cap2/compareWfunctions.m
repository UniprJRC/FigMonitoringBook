%% Compare weight functions using bdp=0.5 or eff=0.95
% Creates Figure 2.11 and 2.11

%% In the first case we use bdp=0.5 (Figure 2.11)
prin=0;
figure
FontSize=14;
FontSizetitl=12;
x=-6:0.001:6;
ylim1=-0.05;
ylim2=1.05;
xlim1=min(x);
xlim2=max(x);
LineWidth=2;

bdp=0.5;
subplot(2,3,1)
weiHU=HUwei(x,1e-30);
plot(x,weiHU,'LineWidth',LineWidth)
xlabel('$u$','Interpreter','Latex','FontSize',FontSize)
title('Huber','FontSize',FontSizetitl)
ylim([ylim1 ylim2])
xlim([xlim1 xlim2])

subplot(2,3,2)
cbdp05HA=HAbdp(bdp,1);
weiHA=HAwei(x,cbdp05HA);
plot(x,weiHA,'LineWidth',LineWidth)
xlabel('$u$','Interpreter','Latex','FontSize',FontSize)
title('Hampel','FontSize',FontSizetitl)
ylim([ylim1 ylim2])
xlim([xlim1 xlim2])


subplot(2,3,3)
cbdp05TB=TBbdp(bdp,1);
weiTB=TBwei(x,cbdp05TB);
plot(x,weiTB,'LineWidth',LineWidth)
xlabel('$u$','Interpreter','Latex','FontSize',FontSize)
title('Tukey biweight','FontSize',FontSizetitl)
ylim([ylim1 ylim2])
xlim([xlim1 xlim2])

subplot(2,3,4)
cbdp05HYP=HYPbdp(bdp,1);
ktuning=4.5;
weiHYP=HYPwei(x,[cbdp05HYP,ktuning]);
plot(x,weiHYP,'LineWidth',LineWidth)
xlabel('$u$','Interpreter','Latex','FontSize',FontSize)
title('Hyperbolic','FontSize',FontSizetitl)
ylim([ylim1 ylim2])
xlim([xlim1 xlim2])


subplot(2,3,5)
cbdp05OPT=OPTbdp(bdp,1);
weiOPT=OPTwei(x,cbdp05OPT);
weiOPT=weiOPT/max(weiOPT);
plot(x,weiOPT,'LineWidth',LineWidth)
xlabel('$u$','Interpreter','Latex','FontSize',FontSize)
title('Optimal','FontSize',FontSizetitl)
ylim([ylim1 ylim2])
xlim([xlim1 xlim2])

subplot(2,3,6)
cbdp05PD=PDbdp(bdp);
weiPD=PDwei(x,cbdp05PD);
weiPD=weiPD/max(weiPD);
plot(x,weiPD,'LineWidth',LineWidth)
xlabel('$u$','Interpreter','Latex','FontSize',FontSize)
title('Power divergence','FontSize',FontSizetitl)
ylim([ylim1 ylim2])
xlim([xlim1 xlim2])
sgtitle('Figure 2.11')
set(gcf,"Name",'Figure 2.11')

if prin==1
    % print to postscript
    print -depsc MD2bdp.eps;
end


%% Use eff=0.95 (Figure 2.12)
eff=0.95;
figure
FontSize=14;
FontSizetitl=12;
x=-6:0.01:6;
ylim1=-0.05;
ylim2=1.05;
xlim1=min(x);
xlim2=max(x);
LineWidth=2;

subplot(2,3,1)
ceff05HU=HUeff(eff,1);
weiHU=HUwei(x,ceff05HU);
plot(x,weiHU,'LineWidth',LineWidth)
xlabel('$u$','Interpreter','Latex','FontSize',FontSize)
title('Huber','FontSize',FontSizetitl)
ylim([ylim1 ylim2])
xlim([xlim1 xlim2])

subplot(2,3,2)
ceff095HA=HAeff(eff,1);
weiHA=HAwei(x,ceff095HA);
plot(x,weiHA,'LineWidth',LineWidth)
xlabel('$u$','Interpreter','Latex','FontSize',FontSize)
title('Hampel','FontSize',FontSizetitl)
ylim([ylim1 ylim2])
xlim([xlim1 xlim2])


subplot(2,3,3)
ceff095TB=TBeff(eff,1);
weiTB=TBwei(x,ceff095TB);
plot(x,weiTB,'LineWidth',LineWidth)
xlabel('$u$','Interpreter','Latex','FontSize',FontSize)
title('Tukey biweight','FontSize',FontSizetitl)
ylim([ylim1 ylim2])
xlim([xlim1 xlim2])

subplot(2,3,4)
ceff095HYP=HYPeff(eff,1);
ktuning=4.5;
weiHYP=HYPwei(x,[ceff095HYP,ktuning]);
plot(x,weiHYP,'LineWidth',LineWidth)
xlabel('$u$','Interpreter','Latex','FontSize',FontSize)
title('Hyperbolic','FontSize',FontSizetitl)
ylim([ylim1 ylim2])
xlim([xlim1 xlim2])


subplot(2,3,5)
ceff095OPT=OPTeff(eff,1);
weiOPT=OPTwei(x,ceff095OPT);
weiOPT=weiOPT/max(weiOPT);
plot(x,weiOPT,'LineWidth',LineWidth)
xlabel('$u$','Interpreter','Latex','FontSize',FontSize)
title('Optimal','FontSize',FontSizetitl)
ylim([ylim1 ylim2])
xlim([xlim1 xlim2])

subplot(2,3,6)
ceff095PD=PDeff(eff);
weiPD=PDwei(x,ceff095PD);
weiPD=weiPD/max(weiPD);
plot(x,weiPD,'LineWidth',LineWidth)
xlabel('$u$','Interpreter','Latex','FontSize',FontSize)
title('Power divergence','FontSize',FontSizetitl)
ylim([ylim1 ylim2])
xlim([xlim1 xlim2])
sgtitle('Figure 2.12')
set(gcf,"Name",'Figure 2.12')

if prin==1
    % print to postscript
    print -depsc MD2.eps;
end

%InsideREADME 
