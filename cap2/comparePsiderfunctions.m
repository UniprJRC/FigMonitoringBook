%% Compare derivatives of psi functions
FontSize=14;
FontSizetitl=12;
LineWidth=2;

bdp=0.5;
eff=0.95;

% if bdpboo is true the analysis will be done from bdp=0.5
% else the analysis will be done for eff=0.95
bdpboo=false;


subplot(2,3,1)
if bdpboo==true
    cHU=1e-10;
    ylim1=-3;
    ylim2=3;
    x=-4:0.001:4;

else
    cHU=HUeff(0.95,1);
    ylim1=-1.1;
    ylim2=1.1;
    x=-7:0.001:7;

end

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
if bdpboo ==true
    cHA=HAbdp(bdp,1);
else
    cHA=HAeff(eff,1);
end

maxRHO=HArho(10000,cHA);
psiderHA=HApsider(x,cHA)/maxRHO;
plot(x,psiderHA,'LineWidth',LineWidth)
xlabel('$u$','Interpreter','Latex','FontSize',FontSize)
title('Hampel','FontSize',FontSizetitl)
ylim([ylim1 ylim2])
xlim([xlim1 xlim2])
yline(0)


subplot(2,3,3)
if bdpboo ==true
    cTB=TBbdp(bdp,1);
else
    cTB=TBeff(eff,1);
end

maxRHO=TBrho(10000,cTB);

psiderTB=TBpsider(x,cTB)/maxRHO;
plot(x,psiderTB,'LineWidth',LineWidth)
xlabel('$u$','Interpreter','Latex','FontSize',FontSize)
title('Tukey biweight','FontSize',FontSizetitl)
ylim([ylim1 ylim2])
xlim([xlim1 xlim2])
yline(0)

subplot(2,3,4)
ktuning=4.5;
if bdpboo ==true
    cHYP=HYPbdp(bdp,1,ktuning);
else
    cHYP=HYPeff(eff,1,ktuning);
end

maxRHO=HYPrho(10000,[cHYP,ktuning]);

psiderHYP=HYPpsider(x,[cHYP,ktuning])/maxRHO;
plot(x,psiderHYP,'LineWidth',LineWidth)
xlabel('$u$','Interpreter','Latex','FontSize',FontSize)
title('Hyperbolic','FontSize',FontSizetitl)
ylim([ylim1 ylim2])
xlim([xlim1 xlim2])
yline(0)

subplot(2,3,5)
if bdpboo ==true
    cOPT=OPTbdp(bdp,1);
else
    cOPT=OPTeff(eff,1);
end
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
if bdpboo ==true
    cPD=PDbdp(bdp);
else
    cPD=PDeff(eff);
end
psiderPD=PDpsider(x,cPD);
plot(x,psiderPD,'LineWidth',LineWidth)
xlabel('$u$','Interpreter','Latex','FontSize',FontSize)
title('Power divergence','FontSize',FontSizetitl)
ylim([ylim1 ylim2])
xlim([xlim1 xlim2])
yline(0)
sum(abs([psiderHU(:) psiderHA(:) psiderTB(:) psiderHYP(:) psiderOPT(:) psiderPD(:)]))

dd=100;
iHU=integral(@(u)abs(HUpsider(u,cHU)).^2.*normpdf(u),-dd,dd);
iHA=integral(@(u)abs(HApsider(u,cHA)).^2.*normpdf(u),-dd,dd);
iTB=integral(@(u)abs(TBpsider(u,cTB)).^2.*normpdf(u),-dd,dd);
iHYP=integral(@(u)abs(HYPpsider(u,[cHYP 4.5])).^2.*normpdf(u),-dd,dd);
iOPT=integral(@(u)abs(OPTpsider(u,cOPT)).^2.*normpdf(u),-dd,dd);
iPD=integral(@(u)abs(PDpsider(u,cPD)).^2.*normpdf(u),-dd,dd);

disp("Show values of area")
nam=["HU" "HA" "TB" "HYP" "OPT" "PD"];
areas=[iHU iHA  iTB iHYP iOPT iPD];

% Table 2.2
% Analysis of CVS under the normal model for 5 link functions, after fixing bdp = 0.5 and
% eff =0.95 
CVS=array2table(areas,"VariableNames",nam)

if prin==1
    % print to postscript
    print -depsc CVbdp05.eps;
      print -depsc CVeff095.eps;
end


