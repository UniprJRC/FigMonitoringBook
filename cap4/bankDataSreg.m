%% BANK DATA
load bank_data.mat
y=bank_data{:,end};
X=bank_data{:,1:end-1};
[out]=LXS(y,X,'nsamp',100000);
out.bs
%% 
outFS=FSReda(y,X,out.bs);
resfwdplot(outFS)
 if prin==1
     print -depsc BDmonres.eps;
 end
%% Bruhsing from the yXplot
yXplot(outFS,'databrush',1,'selunit',[])

prin=0;
if prin==1
    % print to postscript
    print -depsc BDyXbrush.eps;
     print -depsc BDmonres.eps;
end

%% Monitoring of mdr with sign
close all
[outLXS]=LXS(y,X,'nsamp',100000);
outEDA=FSReda(y,X,outLXS.bs,'init',round(length(y)*0.25));
% Just plotting part
% end
% Plot minimum deletion residual
mdrplot(outEDA,'ylimy',[1.5 4],'quant',[0.01 0.5 0.99 0.99999],'sign',1);
xlim([400 1970])
set(gca,'FontSize',14)
% tolto messaggio sulla envelope
lwdenv=2;
quant=norminv(0.975);
n=length(y);
[gmin] = FSRenvmdr(n,p,'prob',quant,'init',round(length(y)*0.25));

hold('on')
for i=1:length(quant)
    line(gmin(:,1),gmin(:,i+1),'LineWidth',lwdenv,'LineStyle','--','Color','r','tag','env');
end

prin=0;
if prin==1
    % print to postscript
    print -depsc BDfsrmdr.eps;
end


%% Brushing from mdr (in mormal coordinates)

p=size(X,2)+1;
outMDR=FSRmdr(y,X,outLXS.bs);
[MDRinv] = FSRinvmdr(outMDR,p);
outFS.mdr=MDRinv(:,[1 3]);
mdrplot(outFS,'ncoord',true,'databrush',1)

%% Automatic FS in order to find the outliers automatically

outFSauto=FSR(y,X);
outliers=outFSauto.outliers;
ngood=length(y)-length(outliers);

%% FS T stat  Each variable on a separate panel
close all
figure;
% hA = tight_subplot(4, 4, [.03 .03], [.1 .01], [.05 .01]);

n=size(X,1);
Tols=outEDA.Tols;
for j=3:size(Tols,2)
    subplot(4,4,j-2)
    % axes(hA(j-2));
    plot(Tols(:,1),Tols(:,j))
    set(gca,'XTick',[400 800 1200 1600 2000])
    text(0.1,0.8,['t_{' num2str(j-2) '}'],'Units','normalized','FontSize',14)

    hold('on')
    line([Tols(1,1);Tols(end,1)],[1.96;1.96],'Color','red')
    line([Tols(1,1);Tols(end,1)],-[1.96;1.96],'Color','red')
    xlim([n*0.5 n])
    ylim([floor(min([-3;Tols(:,j)])) ceil(max([3;Tols(:,j)]))])
    xline(ngood,'LineWidth',1)

    if j<=11
        set(gca,'XTickLabel','')
    end

    if j>11
        xlabel('Subset size m')
    end
end

prin=0;
if prin==1
    % print to postscript
    print -depsc BDtstat.eps;
end




%% Monitoring of added tests
close all
[outFSRaddt]=FSRaddt(y,X,'plots',1,'lwdenv',2,'lwdt',2);
xline(ngood,'LineWidth',1)
if prin==1
    % print to postscript
    print -depsc BDtmonitoradd.eps;
end


%% Analysis with S estimators (used differnt rhofunc)
rhofunc='mdpd';
% rhofunc='optimal';
rhofunc='bisquare';
outS=Sregeda(y,X,'rhofunc',rhofunc);
% Compute correlation about residuals (two cons values of bdp)
RES=outS.RES;
bdp=outS.bdp;
RHOS = corr(RES,'type','Spearman');
RHOK = corr(RES,'type','Kendall');
RHOP = corr(RES,'type','Pearson');
upy=1.0001;
droS=diag(RHOS,1);
droK=diag(RHOK,1);
droP=diag(RHOP,1);

sel=[ 892 1098  86 1338 396  1324]';
fground=struct;
fground.funit=sel;
fground.FontSize=1;

LineStyle=[ repmat({'-.'},6,1)];
Color= [ repmat({'r'},6,1); repmat({'k'},9,1); repmat({'b'},2,1)];
fground.Color=Color;  % different colors for different foreground trajectories
fground.LineWidth=3;
fground.LineStyle=LineStyle;
resfwdplot(outS,'fground',fground,'bground',''); %,'fground',fground);

gcf; % open figure
ax1 = gca; % get handle to axes of figure


ini=n-length(bdp)+1;
xaxis=((ini+1):n)';

figure; %create new figure
fig1 = get(ax1,'children'); %get handle to all the children in the figure

s1 = subplot(3,2,[1 3 5]); %create and get handle to the subplot axes
copyobj(fig1,s1); %copy children to new parent axes i.e. the subplot axes
FontSiz=14;
xlabel('bdp','FontSize',FontSiz,'Interpreter','Latex')
ylabel(['S residuals ' rhofunc ' $\rho$ function'],'Interpreter','Latex','FontSize',FontSiz)
xlim([0.01  0.5])
set(gca,'XDir','reverse');

subplot(3,2,2);

plot(xaxis,droS);
xlim([ini n])
xticklabel=get(gca,'Xticklabel');
newlabel=char(num2str(bdp(str2double(xticklabel)-ini+1)'));
set(gca,'Xticklabel',newlabel)
title('Spearman');
% ylim([lowy upy])
ylimp=get(gca,'ylim');
set(gca,'ylim',[ylimp(1) upy])
%xlim([ini-2 n+1])


subplot(3,2,4);
plot(xaxis,droK);
xlim([ini n])
xticklabel=get(gca,'Xticklabel');
newlabel=char(num2str(bdp(str2double(xticklabel)-ini+1)'));
set(gca,'Xticklabel',newlabel)
title('Kendall');
ylimp=get(gca,'ylim');
set(gca,'ylim',[ylimp(1) upy])
%xlim([ini-2 n+1])
%  ylim([lowy upy])



subplot(3,2,6);
plot(xaxis,droP);
xlim([ini n])
xticklabel=get(gca,'Xticklabel');
newlabel=char(num2str(bdp(str2double(xticklabel)-ini+1)'));
set(gca,'Xticklabel',newlabel)
xlabel('bdp','FontSize',FontSiz,'Interpreter','Latex')
title('Pearson');
% ylim([lowy upy])
ylimp=get(gca,'ylim');
set(gca,'ylim',[ylimp(1) upy])
%xlim([ini-2 n+1])

prin=0;
if prin==1
    % print to postscript
    print -depsc BDSresTB.eps;
    print -depsc BDSresPD.eps;
end


%% MOnitoring of tstat (S with bisquare rho function)

n=length(y);
p=size(X,2);
bdp=0.5:-0.01:0.01;
eff=1-bdp;
nres=length(bdp)-1;

RES=zeros(n,length(bdp));

RESMM=zeros(n,length(bdp));
rhofunc='bisquare';

TTS=[bdp' zeros(length(bdp),p+1)];
TTMM=[eff' zeros(length(bdp),p+1)];
TTS1=TTS;
TTMM1=TTMM;


% [outini]=Sreg(y,X,'rhofunc',rhofunc,'bdp',0.5,'conflev',1-0.01/n);


for j=1:length(bdp)
    [out]=Sreg(y,X,'rhofunc',rhofunc,'bdp',bdp(j),'conflev',1-0.01/n);
    RES(:,j)=out.residuals;

    [covrobS]=RobCov(X,out.residuals,out.scale,'rhofunc',rhofunc,'bdp',bdp(j));
    tstatS=out.beta./sqrt(diag(covrobS.covrob));
    tstatS1=out.beta./sqrt(diag(covrobS.covrob));
    TTS(j,2:end)=tstatS';
    TTS1(j,2:end)=tstatS1';

    %     [outMM]=MMregcore(y,X,outini.beta,outini.scale,'eff',eff(j),'rhofunc',rhofunc);
    %     RESMM(:,j)=outMM.residuals;
    %
    %     [covrobMM,covrobMM1]=robSE(X,outMM.residuals,outini.scale,'rhofunc',rhofunc,'eff',eff(j));
    %     tstatMM=outMM.beta./sqrt(diag(covrobMM));
    %     tstatMM1=outMM.beta./sqrt(diag(covrobMM1));
    %     TTMM(j,2:end)=tstatMM';
    %     TTMM1(j,2:end)=tstatMM1';

end

res=RES;
RHOS = corr(res,'type','Spearman');
RHOK = corr(res,'type','Kendall');
RHOP = corr(res,'type','Pearson');
upy=1.02;
droS=diag(RHOS,1);
droK=diag(RHOK,1);
droP=diag(RHOP,1);


% ROBUST T STAT S estimators
% Second proposal  ronchetti
% second proposal Each variable on a separate panel
close all
ini=n-length(bdp)+1;
xaxis = ini:n;
figure;
hA = tight_subplot(4, 4, [.03 .03], [.1 .01], [.05 .01]);

lwd=3;
for j=3:p+2
    axes(hA(j-2)); %#ok<LAXES>

    % subplot(4,4,j-2)
    %    plot(xaxis',TTS1(:,j),'LineWidth',lwd);
    plot(xaxis',TTS1(:,j));
    xlim([ini-4 n])
    ylim([floor(min([-3;TTS1(:,j)])) ceil(max([3;TTS1(:,j)]))])
    set(gca,'FontSize',14)

    xticklabel=get(gca,'Xticklabel');
    newlabel=char(num2str(bdp(str2double(xticklabel)-ini+1)'));
    set(gca,'Xticklabel',newlabel)

    %  ylabel(['S estimator t' num2str(j-2)]);
    %  ylabel(['t_{' num2str(j-2) '}'],'FontSize',14);
    text(0.1,0.8,['t_{' num2str(j-2) '}'],'Units','normalized','FontSize',14)
    quant=norminv(0.95);
    v=axis;
    lwdenv=2;
    line([v(1),v(2)],[quant,quant],'color','r') % ,'LineWidth',lwdenv);
    line([v(1),v(2)],[-quant,-quant],'color','r') % ,'LineWidth',lwdenv);
    if j<=11
        set(gca,'XTickLabel','')
    end

    if j>11
        xlabel('bdp')
    end


    % ylim([-25 20])
end
%suplabel(['S ' rhofunc ' t-stat equation 7.81 of Huber and Ronchetti'],'t');

prin=0;
if prin==1
    % print to postscript
    print -depsc figs\StstatBD.eps;
end






%% Monitoring S estimators
% outS=Sregeda(y,X);
% resfwdplot(outS)


%%
