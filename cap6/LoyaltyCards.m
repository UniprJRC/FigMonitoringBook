%% Loyalty cards data
% This file creates Figures 6.2-6.6.
% Note that: Figures 6.15-6.16 are created by file LoyaltyCardsBICplots.m


%% LD (Loyalty cards data)
load('loyalty.txt');
y=loyalty(:,4); %#ok<SUSENS>
X=loyalty(:,1:3);
n=length(y);
prin=0;

%% Prepare input for Figure 6.2
%la=[-1:0.1:1];
la=0:0.1:1;
[outFSRfan]=FSRfan(y,X,'plots',1,'init',round(n*0.3),'nsamp',10000,'la',la,'msg',0);

%% Create Figure 6.2
mm=round(n*0.6);
fanplotFS(outFSRfan,'addxline',mm,'xlimx',[150 520])
if prin==1
    % print to postscript
    print -depsc L2a.eps
else
    title('Figure 6.2')
    set(gcf,"Name",'Figure 6.2')
end



%% Prepare input for Figures 6.3-6.5
yt=y.^0.4;
[out]=FSR(yt,X,'plots',0,'init',round(n*0.3),'nsamp',20000);
outl=out.ListOut;

[outLXS]=LXS(yt,X,'nsamp',10000);
[outEDA]=FSReda(yt,X,outLXS.bs);


%% Create Figure 6.3
% mdrplot with last 18 highlighted
mdrplot(outEDA,'quant',[0.01 0.5 0.99 0.999 0.9999 0.99999]);
hold('on')
rr=18;
mdr=abs(outEDA.mdr(:,1:2));
plot(mdr(end-rr:end,1),mdr(end-rr:end,2),'LineWidth',1.5,'color','r');
if prin==1
    % print to postscript
    print -depsc mdrloyalty04scalev4.eps
else
    title('Figure 6.3')
    set(gcf,"Name",'Figure 6.3')
end


%% Create Figure 6.4
% resfwdplot with outliers highlighted
% Monitoring scaled residuals with all default parameters
standard=struct;
standard.xlim=[0,500];
standard.ylim=[-6.5, 2.5];
fground=struct;
fground.funit=outl;
fground.Color={'r'};
fground.flabstep='';
bground='';
resfwdplot(outEDA,'fground',fground,'bground',bground, ...
    'standard', standard,'datatooltip','');
if prin==1
    % print to postscript
    print -depsc L4.eps
else
    title('Figure 6.4')
    set(gcf,"Name",'Figure 6.4')
end

%% Create Figure 6.5:
% Transformed loyalty cards data: scatterplot against x1. The 18 outliers detected plotted as
% red crosses
figure
group=ones(length(y),1);
group(outl)=2;
gscatter(X(:,1),yt,group,'br','o+',7)
xlabel('x1=frequency')

ylabel("y=sales^{0.4}")
legend off
title('Figure 6.5')
set(gcf,"Name",'Figure 6.5')


%% Create Figure 6.6:
% Monitoring of beta1
figure
j=3;
plot(outEDA.Bols(:,1),outEDA.Bols(:,3),'LineWidth',2)
xlim([10 510])
hold('on')
plot(outEDA.Bols(end-rr:end,1), outEDA.Bols(end-rr:end,3),'.','color','r', 'MarkerSize',14);
xlabel('Subset size m');
ylabel('$\hat \beta_{1}$','Interpreter','Latex','FontSize',14)
if prin==1
    print -depsc L6.eps;
else
    title('Figure 6.6')
    set(gcf,"Name",'Figure 6.6')
end

%% Figure 6.15 and Figure 6.16
% See file LoyaltyCardsBICplots.m

%InsideREADME