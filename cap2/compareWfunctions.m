% Compare weight functions using bdp=0.5 or eff=0.95

%% In the first case we use bdp=0.5
prin=0;
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
ceff05HU=HUeff(0.95,1);
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

if prin==1
    % print to postscript
    print -depsc MD2bdp.eps;
end


%% Use eff=0.95

FontSize=14;
FontSizetitl=12;
x=-6:0.01:6;
ylim1=-0.05;
ylim2=1.05;
xlim1=min(x);
xlim2=max(x);
LineWidth=2;

subplot(2,3,1)
ceff05HU=HUeff(0.95,1);
weiHU=HUwei(x,ceff05HU);
plot(x,weiHU,'LineWidth',LineWidth)
xlabel('$u$','Interpreter','Latex','FontSize',FontSize)
title('Huber','FontSize',FontSizetitl)
ylim([ylim1 ylim2])
xlim([xlim1 xlim2])

subplot(2,3,2)
ceff095HA=HAeff(0.95,1);
weiHA=HAwei(x,ceff095HA);
plot(x,weiHA,'LineWidth',LineWidth)
xlabel('$u$','Interpreter','Latex','FontSize',FontSize)
title('Hampel','FontSize',FontSizetitl)
ylim([ylim1 ylim2])
xlim([xlim1 xlim2])


subplot(2,3,3)
ceff095TB=TBeff(0.95,1);
weiTB=TBwei(x,ceff095TB);
plot(x,weiTB,'LineWidth',LineWidth)
xlabel('$u$','Interpreter','Latex','FontSize',FontSize)
title('Tukey biweight','FontSize',FontSizetitl)
ylim([ylim1 ylim2])
xlim([xlim1 xlim2])

subplot(2,3,4)
ceff095HYP=HYPeff(0.95,1);
ktuning=4.5;
weiHYP=HYPwei(x,[ceff095HYP,ktuning]);
plot(x,weiHYP,'LineWidth',LineWidth)
xlabel('$u$','Interpreter','Latex','FontSize',FontSize)
title('Hyperbolic','FontSize',FontSizetitl)
ylim([ylim1 ylim2])
xlim([xlim1 xlim2])


subplot(2,3,5)
ceff095OPT=OPTeff(0.95,1);
% ceff095OPT=ceff095OPT/3;
weiOPT=OPTwei(x,ceff095OPT);
weiOPT=weiOPT/max(weiOPT);
plot(x,weiOPT,'LineWidth',LineWidth)
xlabel('$u$','Interpreter','Latex','FontSize',FontSize)
title('Optimal','FontSize',FontSizetitl)
ylim([ylim1 ylim2])
xlim([xlim1 xlim2])

subplot(2,3,6)
ceff095PD=PDeff(0.95);
weiPD=PDwei(x,ceff095PD);
weiPD=weiPD/max(weiPD);
plot(x,weiPD,'LineWidth',LineWidth)
xlabel('$u$','Interpreter','Latex','FontSize',FontSize)
title('Power divergence','FontSize',FontSizetitl)
ylim([ylim1 ylim2])
xlim([xlim1 xlim2])

if prin==1
    % print to postscript
    print -depsc MD2.eps;
end
