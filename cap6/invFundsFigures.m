%% Investment funds figures;
FondiInv=load('fondi_large.txt');

yori=FondiInv(:,2);
Xall=FondiInv(:,[1 3]);

%% yXplot

booneg=yori<0;
seq=1:length(yori);
group=ones(length(yori),1);
group(seq(booneg))=2;

yXplot(yori,Xall,'group',group)
legend({'Positive performance' 'Negative performance'})

disp('fit on the original scale')
outfillm=fitlm(Xall,yori,'exclude','');


%% Create Figure fanplotori 
% (top panel)
ylimy=20;
nini=100;
la=[0.5 0.6 0.7 0.8 0.9 1];
out=FSRfan(yori,Xall,'la',la,'family','YJ','plots',1,'init',round(nini/2),'ylimy',[-ylimy ylimy]); %#ok<NASGU>

% Create fanplotori (bottom panel)
% pos and neg for 0.7
lasel=0.7;
ylimy1=5;
outpn=FSRfan(yori,Xall,'la',lasel,'family','YJpn','plots',1,'init',round(nini/2),'ylimy',[-ylimy1 ylimy1]); %#ok<NASGU>


la=[0.5 0.6 0.7 0.8 0.9 1];
lasel=0.7;

nr=2;
nc=1;
n=length(yori);
xlim1=50;
xlim2=n+3;

% Upper panel
subplot(nr,nc,1)
Sco=out.Score;

% plot the lines associated with the score test lwd = line width of the
% trajectories which contain the score test
lla=length(la);
lwd=2;
lwdenv=2;
plot1=plot(Sco(:,1),Sco(:,2:end),'LineWidth',lwd);
% Set size for ylabel
FontSizeylabel=12;

% Specify the line type for the units inside vector units
slin={':';'--';'-';'-.'};
slin=repmat(slin,ceil(lla/4),1);

% Specify the color for the trajectories
ColorOrd=[{[1 0 1]}; {[0 0 0]}; {[0 0 1]};{[0 1 1]}; {[0 1 0]}; {[0.6 0.6 0.6]}; {[0 1 0]}; ];
ColorOrd=repmat(ColorOrd,4,1);

set(plot1,{'Color'}, ColorOrd(1:lla,:));

set(plot1,{'LineStyle'},slin(1:lla));

v=axis;
conflev=0.99;
quant=sqrt(chi2inv(conflev,1));
line([v(1),v(2)],[quant,quant],'color','r','LineWidth',lwdenv);
line([v(1),v(2)],[-quant,-quant],'color','r','LineWidth',lwdenv);

if size(la,2)>1
    la=la';
end
text(n*ones(lla,1)+1,Sco(end,2:end)',num2str(la),'FontSize',FontSizeylabel);
xlim([xlim1 xlim2])
% ylabel('Fanplot','Interpreter','latex','FontSize',14)
ylabel('Fanplot','FontSize',FontSizeylabel);

% Lower panel
subplot(nr,nc,2)
Sco=outpn.Score;
n=length(yori);
la=lasel;
% plot the lines associated with the score test lwd = line width of the
% trajectories which contain the score test
lla=length(la);
lwd=2;
lwdenv=2;
plot1=plot(Sco(:,1),Sco(:,2:end),'LineWidth',lwd);
ColorOrd=[ {[0 0 1]};{[0 1 1]}; {[0 1 0]}; {[0.6 0.6 0.6]}; {[0 1 0]}; ];
ColorOrd=repmat(ColorOrd,4,1);

set(plot1,{'Color'}, ColorOrd(1:lla,:));
v=axis;
conflev=0.99;
quant=sqrt(chi2inv(conflev,1));
line([v(1),v(2)],[quant,quant],'color','r','LineWidth',lwdenv);
line([v(1),v(2)],[-quant,-quant],'color','r','LineWidth',lwdenv);

Scop=outpn.Scorep;
Scon=outpn.Scoren;
hold('on')
plotp=plot(Scop(:,1),Scop(:,2:end),'LineWidth',lwd,'Color','g');
set(plotp,{'LineStyle'},{'--'});
% set(plotp,{'Color'}, ColorOrd(1:lla,:));

plotn=plot(Scon(:,1),Scon(:,2:end),'LineWidth',lwd,'Color','k');
set(plotn,{'LineStyle'},slin(1:lla));
set(plotn,{'LineStyle'},{'--'});
% set(plotn,{'Color'}, ColorOrd(1:lla,:));

set(plot1,{'LineStyle'},{'-'});
text(n*ones(lla,1)+1,Sco(end,2:end)',num2str(la),'FontSize',14);
xlim([xlim1 xlim2])
xlabel('Subset size m','FontSize',FontSizeylabel);
ylabel('Ext. fanplot','FontSize',FontSizeylabel);
prin=0;
if prin==1
    % print to postscript
    print -depsc figsFondi\fanplotori.eps;
     print -depsc figsFondi\fanplotoriA.eps;
     print -depsc figsFondi\fanplotoriB.eps;
end



%% Create fanplottra
close all
nr=3; nc=1;
ylim1=-10;
ylim2=4;
FontSizeylabel=12;
FontSizeO=12;

% Top panel
subplot(nr,nc,1)
Sco=outpnTOP.Score;
% plot the lines associated with the score test lwd = line width of the
% trajectories which contain the score test
lla=length(la);
lwd=2;
lwdenv=2;
plot1=plot(Sco(:,1),Sco(:,2:end),'LineWidth',lwd);
ColorOrd=[ {[0 0 1]};{[0 1 1]}; {[0 1 0]}; {[0.6 0.6 0.6]}; {[0 1 0]}; ];
ColorOrd=repmat(ColorOrd,4,1);

set(plot1,{'Color'}, ColorOrd(1:lla,:));
v=axis;
conflev=0.99;
quant=sqrt(chi2inv(conflev,1));
line([v(1),v(2)],[quant,quant],'color','r','LineWidth',lwdenv);
line([v(1),v(2)],[-quant,-quant],'color','r','LineWidth',lwdenv);

Scop=outpnTOP.Scorep;
Scon=outpnTOP.Scoren;
hold('on')
plotp=plot(Scop(:,1),Scop(:,2:end),'LineWidth',lwd,'Color','g');
set(plotp,{'LineStyle'},{'--'});

plotn=plot(Scon(:,1),Scon(:,2:end),'LineWidth',lwd,'Color','k');
set(plotn,{'LineStyle'},slin(1:lla));
set(plotn,{'LineStyle'},{'--'});

%set(plot1,{'LineStyle'},{'-'});
% text(n*ones(lla,1)+1,Sco(end,2:end)',num2str(la),'FontSize',14);
xlim([xlim1 xlim2])
ylim([ylim1 ylim2])
set(gca,'FontSize',FontSizeO)
ylabel({'$\lambda_P=1$','$\lambda_N=0.5$'},'Interpreter','latex','FontSize',FontSizeylabel);

% Central panel
subplot(nr,nc,2)

Sco=outpnMID.Score;
% la=latest;
% plot the lines associated with the score test lwd = line width of the
% trajectories which contain the score test
lla=length(la);
plot1=plot(Sco(:,1),Sco(:,2:end),'LineWidth',lwd);
ColorOrd=[ {[0 0 1]};{[0 1 1]}; {[0 1 0]}; {[0.6 0.6 0.6]}; {[0 1 0]}; ];
ColorOrd=repmat(ColorOrd,4,1);

set(plot1,{'Color'}, ColorOrd(1:lla,:));
v=axis;
conflev=0.99;
quant=sqrt(chi2inv(conflev,1));
line([v(1),v(2)],[quant,quant],'color','r','LineWidth',lwdenv);
line([v(1),v(2)],[-quant,-quant],'color','r','LineWidth',lwdenv);

Scop=outpnMID.Scorep;
Scon=outpnMID.Scoren;
hold('on')
plotp=plot(Scop(:,1),Scop(:,2:end),'LineWidth',lwd,'Color','g');
set(plotp,{'LineStyle'},{'--'});

plotn=plot(Scon(:,1),Scon(:,2:end),'LineWidth',lwd,'Color','k');
set(plotn,{'LineStyle'},slin(1:lla));
set(plotn,{'LineStyle'},{'--'});

%set(plot1,{'LineStyle'},{'-'});
% text(n*ones(lla,1)+1,Sco(end,2:end)',num2str(la),'FontSize',14);
xlim([xlim1 xlim2])
ylim([ylim1 ylim2])
 set(gca,'FontSize',FontSizeO)
ylabel({'$\lambda_P=1$','$\lambda_N=0.25$'},'Interpreter','latex','FontSize',FontSizeylabel);


% Bottom panel
subplot(nr,nc,3)

Sco=outpnBOT.Score;
n=length(yori);
% plot the lines associated with the score test lwd = line width of the
% trajectories which contain the score test
lla=length(la);
plot1=plot(Sco(:,1),Sco(:,2:end),'LineWidth',lwd);
ColorOrd=[ {[0 0 1]};{[0 1 1]}; {[0 1 0]}; {[0.6 0.6 0.6]}; {[0 1 0]}; ];
ColorOrd=repmat(ColorOrd,4,1);

set(plot1,{'Color'}, ColorOrd(1:lla,:));
v=axis;
conflev=0.99;
quant=sqrt(chi2inv(conflev,1));
line([v(1),v(2)],[quant,quant],'color','r','LineWidth',lwdenv);
line([v(1),v(2)],[-quant,-quant],'color','r','LineWidth',lwdenv);

Scop=outpnBOT.Scorep;
Scon=outpnBOT.Scoren;
hold('on')
plotp=plot(Scop(:,1),Scop(:,2:end),'LineWidth',lwd,'Color','g');
set(plotp,{'LineStyle'},{'--'});

plotn=plot(Scon(:,1),Scon(:,2:end),'LineWidth',lwd,'Color','k');
set(plotn,{'LineStyle'},slin(1:lla));
set(plotn,{'LineStyle'},{'--'});


% text(n*ones(lla,1)+1,Sco(end,2:end)',num2str(la),'FontSize',14);
xlim([xlim1 xlim2])
ylim([ylim1 ylim2])
set(gca,'FontSize',FontSizeO)
xlabel('Subset size m')
ylabel({'$\lambda_P=1$','$\lambda_N=0$'},'Interpreter','latex','FontSize',FontSizeylabel);

if prin==1
    % print to postscript
    print -depsc figsFondi\fanplottra.eps;
end


%%  Figure 7
seq=1:length(ymod);
group=ones(length(ymod),1);
group(seq(booneg))=2;

yXplot(ymod,Xall,'group',group)

legend({'Positive performance' 'Negative performance'})
