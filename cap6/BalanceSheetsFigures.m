%% Data reading
XX=load('BalanceSheets.txt');
% Define X and y
yori=XX(:,6);
X=XX(:,1:5);
prin=0;

%% Prepare data for Figure 12 (fan plot)
ylimy=20;
nini=1000;
la=[0.5 0.75 1 1.25];
out=FSRfan(yori,X,'la',la,'family','YJ','plots',0,'init',round(nini/2),'ylimy',[-ylimy ylimy]);

% pos and neg for 1
lasel=1;
ylimy1=5;
outpn=FSRfan(yori,X,'la',lasel,'family','YJpn','plots',0,'init',round(nini/2),'ylimy',[-ylimy1 ylimy1]);

%% Create high quality figure 12 (fanplot and extended fanplot)
la=[0.5 0.75 1 1.25];
lasel=1;
FontSizeO=12;


nr=2;
nc=1;
xlim1=500;

% Upper panel
subplot(nr,nc,1)
Sco=out.Score;
n=length(yori);
xlim2=n+3;

% plot the lines associated with the score test lwd = line width of the
% trajectories which contain the score test
lla=length(la);
lwd=2;
lwdenv=2;
plot1=plot(Sco(:,1),Sco(:,2:end),'LineWidth',lwd);

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
hordisp=100;
text((n-hordisp)*ones(lla,1)+1,Sco(end-hordisp,2:end)'+1,num2str(la),'FontSize',14);
xlim([xlim1 xlim2])
ylim([-20 20])
set(gca,'FontSize',FontSizeO)
ylabel('Fanplot','FontSize',14)

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

plotn=plot(Scon(:,1),Scon(:,2:end),'LineWidth',lwd,'Color','k');
set(plotn,{'LineStyle'},slin(1:lla));
set(plotn,{'LineStyle'},{'--'});

set(plot1,{'LineStyle'},{'-'});
text(n*ones(lla,1)+1,Sco(end,2:end)',num2str(la),'FontSize',14);
xlim([xlim1 xlim2])
ylim([-12 12])
set(gca,'FontSize',FontSizeO)

xlabel('Subset size m')
FontSizeylabel=14;
ylabel('Extended fanplot','FontSize',FontSizeylabel);

if prin==1
    % print to postscript
    print -depsc figsBS\fanplotoriBS.eps;
end



%% Prepare the data for figure 13

% Why not use normJpn() instead of normYJ() separately for positive and negative?
%booneg=yori<=0;
%la=1.5;
%yneg=normYJ(yori(booneg),[],la,'inverse',false,'Jacobian',false);
%la=0.5;
%ypos=normYJ(yori(~booneg),[],la,'inverse',false,'Jacobian',false);
%ytra=yori;
%ytra(booneg)=yneg;
%ytra(~booneg)=ypos;

ytra=normYJpn(yori, [], [0.5, 1.5], 'inverse',false, 'Jacobian', false);

outpn=FSRfan(ytra,X,'intercept',1,'plots',0,'family','YJpn','la',1);

% Create high quality figure 13 (Extended fan plot transf. data)
Sco=outpn.Score;
la=1;
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

plotn=plot(Scon(:,1),Scon(:,2:end),'LineWidth',lwd,'Color','k');
set(plotn,{'LineStyle'},{'--'});

%set(plot1,{'LineStyle'},{'-'});
% text(n*ones(lla,1)+1,Sco(end,2:end)',num2str(la),'FontSize',14);
xlim1=400;
xlim2=n+12;
ylim1=-6;
ylim2=9;
xlim([xlim1 xlim2])
ylim([ylim1 ylim2])
set(gca,'FontSize',FontSizeO)
title('')
xlabel('Subset size m')
ylabel('Extended fanplot','FontSize',FontSizeylabel);

if prin==1
    % print to postscript
    print -depsc figsBS\fanplottraBS.eps;
end


%% Brushing  (FIGURE 14)
n=length(yori);
[out]=LXS(ytra,X);
[out]=FSReda(ytra,X,out.bs);
% Plot minimum deletion residual
mdrplot(out,'xlimx',[1000 n+1],'ylimy',[1.7 5]);
% Now, some interactive brushing starting from the monitoring residuals
% plot. Once a set of trajectories is highlighted in the monitoring residual plot,
% the corresponding units are highlighted in the other plots
databrush=struct;
% databrush.bivarfit='i1';
databrush.multivarfit = '2';
databrush.selectionmode='Rect'; % Rectangular selection
% databrush.persist='off'; % Enable repeated mouse selections
databrush.Label='on'; % Write labels of trajectories while selecting
databrush.RemoveLabels='on'; % Do not remove labels after selection
databrush.RemoveTool='off'; %remove yellow

cascade;
fground=struct;
fground.fthresh=100;
standard=struct;
standard.xlim=[800 n+1];
resfwdplot(out,'databrush',databrush,'fground',fground,'standard',standard,'datatooltip','');

%% yXplot with 3 symbols

% Brushed units
brushedun=[94 188 206 226 373 488 496 535 653 757 764 836 842 856 863 ...
         1129 1136 1207 1400];
outTRA=FSR(ytra,X);
outl=outTRA.outliers;
% setdiff(brushedun,outTRA.outliers)
extraOUT=setdiff(outTRA.outliers,brushedun);
%%  yXplot 
group=ones(n,1);
group(brushedun)=2;
group(extraOUT)=3;
yXplot(ytra,X,group);
if prin==1
    % print to postscript
    print -depsc BS3groups.eps;
end