%% Create Figures 2.20 and 2.21
% Compare derivatives of psi functions (use bdp=0.5 or eff=0.95)

%% Beginning of code
close all 
clear

FontSize=14;
FontSizetitl=12;
LineWidth=2;

bdp=0.5;

cHU=1e-10;
ylim1=-3;
ylim2=3;
x=-4:0.001:4;

dd=100;

ktuning=4.5;
prin=0;


%% Create Figure 2.20

xlim1=min(x);
xlim2=max(x);

subplot(2,3,1)
psiderHU=HUpsider(x,cHU);
plot(x,psiderHU,'LineWidth',LineWidth)
xlabel('$u$','Interpreter','Latex','FontSize',FontSize)
title('Huber','FontSize',FontSizetitl)
ylim([ylim1 ylim2])
xlim([xlim1 xlim2])
yline(0)

subplot(2,3,2)
cHA=HAbdp(bdp,1);
maxRHO=HArho(10000,cHA);
psiderHA=HApsider(x,cHA)/maxRHO;
plot(x,psiderHA,'LineWidth',LineWidth)
xlabel('$u$','Interpreter','Latex','FontSize',FontSize)
title('Hampel','FontSize',FontSizetitl)
ylim([ylim1 ylim2])
xlim([xlim1 xlim2])
yline(0)


subplot(2,3,3)
cTB=TBbdp(bdp,1);

maxRHO=TBrho(10000,cTB);

psiderTB=TBpsider(x,cTB)/maxRHO;
plot(x,psiderTB,'LineWidth',LineWidth)
xlabel('$u$','Interpreter','Latex','FontSize',FontSize)
title('Tukey biweight','FontSize',FontSizetitl)
ylim([ylim1 ylim2])
xlim([xlim1 xlim2])
yline(0)

subplot(2,3,4)
cHYP=HYPbdp(bdp,1,ktuning);

maxRHO=HYPrho(10000,[cHYP,ktuning]);

psiderHYP=HYPpsider(x,[cHYP,ktuning])/maxRHO;
plot(x,psiderHYP,'LineWidth',LineWidth)
xlabel('$u$','Interpreter','Latex','FontSize',FontSize)
title('Hyperbolic','FontSize',FontSizetitl)
ylim([ylim1 ylim2])
xlim([xlim1 xlim2])
yline(0)

subplot(2,3,5)
cOPT=OPTbdp(bdp,1);
psiderOPT=OPTpsider(x,cOPT);
maxRHO=OPTrho(10000,cOPT);

psiderOPT=psiderOPT/maxRHO;
plot(x,psiderOPT,'LineWidth',LineWidth)
xlabel('$u$','Interpreter','Latex','FontSize',FontSize)
title('Optimal','FontSize',FontSizetitl)
ylim([ylim1 ylim2])
xlim([xlim1 xlim2])
yline(0)

subplot(2,3,6)
cPD=PDbdp(bdp);
psiderPD=PDpsider(x,cPD);
plot(x,psiderPD,'LineWidth',LineWidth)
xlabel('$u$','Interpreter','Latex','FontSize',FontSize)
title('Power divergence','FontSize',FontSizetitl)
ylim([ylim1 ylim2])
xlim([xlim1 xlim2])
yline(0)

sgtitle('Figure 2.20')
set(gcf,"Name",'Figure 2.20')

iHU=integral(@(u)abs(HUpsider(u,cHU)).^2.*normpdf(u),-dd,dd);
iHA=integral(@(u)abs(HApsider(u,cHA)).^2.*normpdf(u),-dd,dd);
iTB=integral(@(u)abs(TBpsider(u,cTB)).^2.*normpdf(u),-dd,dd);
iHYP=integral(@(u)abs(HYPpsider(u,[cHYP 4.5])).^2.*normpdf(u),-dd,dd);
iOPT=integral(@(u)abs(OPTpsider(u,cOPT)).^2.*normpdf(u),-dd,dd);
iPD=integral(@(u)abs(PDpsider(u,cPD)).^2.*normpdf(u),-dd,dd);

% Compute values of the areas
areasbdp050=[iHU iHA  iTB iHYP iOPT iPD];


if prin==1
    % print to postscript
    print -depsc CVbdp05.eps;
end

%% Create Figure 2.21
figure
eff=0.95;

subplot(2,3,1)

cHU=HUeff(0.95,1);
ylim1=-1.1;
ylim2=1.1;
x=-7:0.001:7;

xlim1=min(x);
xlim2=max(x);

psiderHU=HUpsider(x,cHU);
plot(x,psiderHU,'LineWidth',LineWidth)
xlabel('$u$','Interpreter','Latex','FontSize',FontSize)
title('Huber','FontSize',FontSizetitl)
ylim([ylim1 ylim2])
xlim([xlim1 xlim2])
yline(0)
subplot(2,3,2)
cHA=HAeff(eff,1);

maxRHO=HArho(10000,cHA);
psiderHA=HApsider(x,cHA)/maxRHO;
plot(x,psiderHA,'LineWidth',LineWidth)
xlabel('$u$','Interpreter','Latex','FontSize',FontSize)
title('Hampel','FontSize',FontSizetitl)
ylim([ylim1 ylim2])
xlim([xlim1 xlim2])
yline(0)


subplot(2,3,3)
cTB=TBeff(eff,1);

maxRHO=TBrho(10000,cTB);

psiderTB=TBpsider(x,cTB)/maxRHO;
plot(x,psiderTB,'LineWidth',LineWidth)
xlabel('$u$','Interpreter','Latex','FontSize',FontSize)
title('Tukey biweight','FontSize',FontSizetitl)
ylim([ylim1 ylim2])
xlim([xlim1 xlim2])
yline(0)

subplot(2,3,4)
cHYP=HYPeff(eff,1,ktuning);

maxRHO=HYPrho(10000,[cHYP,ktuning]);

psiderHYP=HYPpsider(x,[cHYP,ktuning])/maxRHO;
plot(x,psiderHYP,'LineWidth',LineWidth)
xlabel('$u$','Interpreter','Latex','FontSize',FontSize)
title('Hyperbolic','FontSize',FontSizetitl)
ylim([ylim1 ylim2])
xlim([xlim1 xlim2])
yline(0)

subplot(2,3,5)
cOPT=OPTeff(eff,1);
psiderOPT=OPTpsider(x,cOPT);
maxRHO=OPTrho(10000,cOPT);

psiderOPT=psiderOPT/maxRHO;
plot(x,psiderOPT,'LineWidth',LineWidth)
xlabel('$u$','Interpreter','Latex','FontSize',FontSize)
title('Optimal','FontSize',FontSizetitl)
ylim([ylim1 ylim2])
xlim([xlim1 xlim2])
yline(0)

subplot(2,3,6)
cPD=PDeff(eff);
psiderPD=PDpsider(x,cPD);
plot(x,psiderPD,'LineWidth',LineWidth)
xlabel('$u$','Interpreter','Latex','FontSize',FontSize)
title('Power divergence','FontSize',FontSizetitl)
ylim([ylim1 ylim2])
xlim([xlim1 xlim2])
yline(0)

sgtitle('Figure 2.21')
set(gcf,"Name",'Figure 2.21')


iHU=integral(@(u)abs(HUpsider(u,cHU)).^2.*normpdf(u),-dd,dd);
iHA=integral(@(u)abs(HApsider(u,cHA)).^2.*normpdf(u),-dd,dd);
iTB=integral(@(u)abs(TBpsider(u,cTB)).^2.*normpdf(u),-dd,dd);
iHYP=integral(@(u)abs(HYPpsider(u,[cHYP 4.5])).^2.*normpdf(u),-dd,dd);
iOPT=integral(@(u)abs(OPTpsider(u,cOPT)).^2.*normpdf(u),-dd,dd);
iPD=integral(@(u)abs(PDpsider(u,cPD)).^2.*normpdf(u),-dd,dd);
% Compute the values of the areas
areaseff095=[iHU iHA  iTB iHYP iOPT iPD];

if prin==1
    % print to postscript
    print -depsc CVeff095.eps;
end

%% Create Table 2.2
disp("Compute values of area")
nam=["Huber" "Hampel" "Tukey Biweight" "Hyperbolic" "Optimal" "Power Divergence"];
namCol=["bdp=0.5" "eff=0.95"];

AreasT=array2table([areasbdp050' areaseff095'],'RowNames',nam,'VariableNames',namCol);
disp("Table 2.2 (+ Huber) ")
disp(AreasT)

%InsideREADME  