%% Distribution of BIC
% Create Figures 5.23 and 5.24, 5.25 and 5.26
% Confidence bands with 10 per cent contamination
% Simulation results have been created by file BICSimul1.m  and BICsimul2.m
% n=200 p=5;

%% Create Figure 5.23: distribution of trajectories of BIC for outlier detection
close all
load bandswith5LSContn200p5
% j=1 S, j=2 MM, j=3 LTS,  j=4 FS
prin=0;
figure;
hold('on');
quant=[0.01 0.5 0.99];
sel=round(nsimul*quant);
nr=2;
nc=2;

subplot(nr,nc,1)
lwd=1.5;

 j=3; % LTS
mdrStore=sort(BICall(:,:,j),2);
plot(bdp,mdrStore(:,sel),'LineStyle','--','Color','k','LineWidth',lwd);
xlabel('bdp');
title('LTS')
set(gca,'XDir','rev')
xlim([bdp(end) bdp(1)])


subplot(nr,nc,2)
mdrStore=sort(BICFS,2);
plot(Un(:,1),mdrStore(:,sel),'LineStyle','--','Color','k','LineWidth',lwd);
xlabel('Subset size m');
title('FS')
xlim([round(n/2) n])

subplot(nr,nc,3)
j=1; % S estimation
mdrStore=sort(BICall(:,:,j),2);
% Plot lines of empirical quantiles
plot(bdp,mdrStore(:,sel),'LineStyle','--','Color','k','LineWidth',lwd);
xlim([bdp(end) bdp(1)])
xlabel('bdp');
title('S')
set(gca,'XDir','rev')


subplot(nr,nc,4)
j=2; % MM estimation
mdrStore=sort(BICall(:,:,j),2);
plot(eff,mdrStore(:,sel),'LineStyle','--','Color','k','LineWidth',lwd);
xlabel('eff');
title('MM')
xlim([eff(1) eff(end)])


if prin==1
    % print to postscript
    print -depsc SIM1.eps;
else
    sgtitle('Figure 5.23')
    set(gcf,"Name",'Figure 5.23')
end

%% Create Figure 5.24: Boxplots of position of maxima of BIC
figure
POS=zeros(nsimul,4);
for jj=1:3
    BIC1=BICall(:,:,jj);
    pos=zeros(nsimul,1);
    for j=1:nsimul
        [~,posmaxj]=max(BIC1(:,j));
        pos(j)=posmaxj;
    end
    if jj==2
        poseff=eff(pos)';
        POS(:,jj)=poseff;
    else
        posbdp=bdp(pos)';
        POS(:,jj)=posbdp;
    end
end

BIC1=BICFS;
pos=zeros(nsimul,1);
for j=1:nsimul
    [~,posmaxj]=max(BIC1(:,j));
    pos(j)=posmaxj;
end
mm=BIC(:,1);
POS(:,4)=mm(pos);
POS(:,4)=(n-POS(:,4))/n;
lab={'S', 'MM', 'LTS', 'FS'};
sel=[3 4 1 2];
for j=1:4
    subplot(2,2,j)

    boxplot(POS(:,sel(j)),'Labels','')
    set(gca,'XTickLabel',{' '},'FontSize',12)
    if j==3
        ylim([0.16 0.26])
    elseif j==4
        ylim([0.87 0.97])
    elseif j<=2
        ylim([0.03 0.14])
    end
    title(lab{sel(j)},'FontSize',9)
end

if prin==1
    % print to postscript
    print -depsc SIM2.eps;
else
    sgtitle('Figure 5.24')
    set(gcf,"Name",'Figure 5.24')
end

%%  Create Figure 5.25: analysis of outliers detected as LS increases

load bandsWithLSyContn200p5
% boxplot(BICFS,'Labels',string(LSHIFT))
maxylim=0.16;
fs=14;

figure
subplot(2,2,1)
boxplot(BICLTS,'Labels',string(LSHIFT))
xlabel('Contamination level shift')
xlabel('$\delta$','Interpreter','latex','FontSize',fs)
title('LTS')
ylim([0 maxylim])

subplot(2,2,2)
boxplot((n-BICFS)/n,'Labels',string(LSHIFT))
ylim([0 maxylim])
xlabel('$\delta$','Interpreter','latex','FontSize',fs)
title('FS')

if prin==1
    % print to postscript
    print -depsc figs\SIM3.eps;
else
    sgtitle('Figure 5.25')
    set(gcf,"Name",'Figure 5.25')

end

%%  Create Figure 5.26 (n=500 p=15 with leverage points)
% analysis of outliers detected as LS increases
load bandsWithLSyContn500p15WithLev.mat
maxylim=0.16;
fs=14;
figure
subplot(2,2,1)
boxplot(BICLTS,'Labels',string(LSHIFT))
xlabel('Contamination level shift')
xlabel('$\delta$','Interpreter','latex','FontSize',fs)
title('LTS')
ylim([0 maxylim])

subplot(2,2,2)
boxplot((n-BICFS)/n,'Labels',string(LSHIFT))
ylim([0 maxylim])
xlabel('$\delta$','Interpreter','latex','FontSize',fs)
title('FS')

if prin==1
    % print to postscript
    print -depsc figs\SIM4.eps;
else
    sgtitle('Figure 5.26')
    set(gcf,"Name",'Figure 5.26')
end

%InsideREADME