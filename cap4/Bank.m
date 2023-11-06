%% Bank data
% This file creates Figure 4.34-4.42
clear
close all
load bank_data.mat
y=bank_data{:,end};
X=bank_data{:,1:end-1};
[n,p]=size(X);
prin=0;

%% Create Figure 4.34
[outLXS]=LXS(y,X,'nsamp',10000);
outFSeda=FSReda(y,X,outLXS.bs,'init',round(length(y)*0.25));
% Just plotting part
% end
% Plot minimum deletion residual
mdrplot(outFSeda,'ylimy',[1.5 4],'quant',[0.01 0.5 0.99 0.99999],'sign',1);
xlim([400 1970])
set(gca,'FontSize',14)

if prin==1
    % print to postscript
    print -depsc BDfsrmdr.eps;
end


%% Create Figure 4.35
% Monitoring scaled residuals and highlight the 6 largest residuals
Un6Largest=outFSeda.Un(end-5:end,2);

fground=struct;
fground.funit=Un6Largest;
% Alternatively it was possible to define a thresh
% fground.fthresh=5.5;
fground.LineWidth =2;
fground.Color={'r'};
bground=struct;
bground.bthresh=-Inf;
resfwdplot(outFSeda,'fground',fground,'bground',bground)

title('Figure 4.35')
set(gcf,"Name",'Figure 4.35')


%% Create Figure 4.36
group=ones(n,1);
group(Un6Largest)=2;
yXplot(y,X,group);
sgtitle('Figure 4.36')
set(gcf,"Name",'Figure 4.36')

% REMARK: in this file Figures 4.35 and 4.36 are not created interactively.
% In order to create them using brushing, please see file BankInteractive.m

%% Prepare input for Figures 4.37 and 4.38
% Analysis with S estimators (used differnt rhofunc)

% rhofunc='optimal';
rhofunc='bisquare';
outsTB=Sregeda(y,X,'rhofunc',rhofunc);

rhofunc='mdpd';
outsPD=Sregeda(y,X,'rhofunc',rhofunc);

sel=Un6Largest';
fground=struct;
fground.funit=sel;
fground.FontSize=1;

LineStyle=[ repmat({'-.'},6,1)];
Color= [ repmat({'r'},6,1); repmat({'k'},9,1); repmat({'b'},2,1)];
fground.Color=Color;  % different colors for different foreground trajectories
fground.LineWidth=3;
fground.LineStyle=LineStyle;

%% Create Figure 4.37
resfwdplot(outsTB,'fground',fground,'bground','','corres',true,'tag','plresTB');
sgtitle('Figure 4.37')
set(gcf,"Name",'Figure 4.37')

%% Create Figure 4.38
resfwdplot(outsPD,'fground',fground,'bground','','corres',true,'tag','plresPD');
sgtitle('Figure 4.38')
set(gcf,"Name",'Figure 4.38')

%% Prepare input for Figure 4.39
bdp=0.5:-0.01:0.01;
TTS=[bdp' zeros(length(bdp),p+1)];
TTS1=TTS;

rhofunc='bisquare';
for j=1:length(bdp)
    [out]=Sreg(y,X,'rhofunc',rhofunc,'bdp',bdp(j),'conflev',1-0.01/n);
    [covrobS]=RobCov(X,out.residuals,out.scale,'rhofunc',rhofunc,'bdp',bdp(j));
    tstatS=out.beta./sqrt(diag(covrobS.covrob));
    tstatS1=out.beta./sqrt(diag(covrobS.covrob));
    TTS(j,2:end)=tstatS';
    TTS1(j,2:end)=tstatS1';
end

%% Create Figure 4.39
% ROBUST T STAT S estimators (using covrob1)
%
figure;
ini=n-length(bdp)+1;
xaxis = ini:n;
lwd=1;
quant=norminv(0.975);
for j=3:p+2
    subplot(4,4,j-2)
    plot(xaxis',TTS1(:,j),'LineWidth',lwd);
    % plot(xaxis',TTS1(:,j));
    xlim([ini-4 n])
    ylim([floor(min([-3;TTS1(:,j)])) ceil(max([3;TTS1(:,j)]))])
    set(gca,'FontSize',14)

    xtick=get(gca,'Xtick');
    newlabel=num2str(bdp(xtick-ini+1)');
    set(gca,'Xtick',xtick,'Xticklabel',newlabel)
    text(0.1,0.8,['t_{' num2str(j-2) '}'],'Units','normalized','FontSize',14)
    yline([-quant quant],'color','r')
    if j<=11
        set(gca,'XTickLabel','')
    end
    if j>11
        xlabel('bdp')
    end

end
sgtitle('Figure 4.39')
set(gcf,"Name",'Figure 4.39')

if prin==1
    % print to postscript
    print -depsc figs\StstatBD.eps;
end

%% Prepare input for Figure 4.40
% Monitoring of tstat from FS
figure
quant=norminv(0.975);

for j=3:p+2
    subplot(4,4,j-2)
    plot(outFSeda.Tols(:,1),outFSeda.Tols(:,j),'LineWidth',lwd)
    text(0.1,0.8,['t_{' num2str(j-2) '}'],'Units','normalized','FontSize',14)
    yline([-quant quant],'color','r')
    xlim([1000 n+1])
    xline(1694)
    if j<=11
        set(gca,'XTickLabel','')
    end
    if j>11
        xlabel('Subset size m')
    end
end
xlabel('Subset size m')
sgtitle('Figure 4.40')
set(gcf,"Name",'Figure 4.40')

%% Create Figure 4.41
% Monitoring of added tstat
figure
outADDt=FSRaddt(y,X,'plots',1);
sgtitle('Figure 4.41')
set(gcf,"Name",'Figure 4.41')

%% Prepare input for Figure 4.42
[outFSauto]=FSR(y,X,'plots',0);
seq=1:n;
outliers=outFSauto.outliers;
good=setdiff(seq,outliers);
maxy=max(y);
plo=struct;
plo.ylimy=[0 maxy];
nameX="X"+string(1:p);
plo.nameX=nameX;
plo.namey='y';

%% Create left-hand panel of Figure 4.42
plo.sym='+';
plo.clr='b';
yXplot(y(good),X(good,:),'plo',plo,'tag','yXgood');
sgtitle('Figure 4.42 (left hand panel)')
set(gcf,"Name",'Figure 4.42 (left hand panel)')

%% Create right-hand panel of Figure 4.42
plo.sym='o';
plo.clr='r';
Xout=X(outliers,:);
yout=y(outliers);
% Some jittering for the third column because it is constant and yXplot
% thinks it is an intercept which does not have to be shown
Xout(:,3)=Xout(:,3)+1e-08*randn(length(outliers),1);
yXplot(yout,Xout,'plo',plo,'tag','yXout');
sgtitle('Figure 4.42 (right hand panel)')
set(gcf,"Name",'Figure 4.42 (right hand panel)')
