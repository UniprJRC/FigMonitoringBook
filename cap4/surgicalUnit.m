%% Surgical Unit 
% This file creates Figures 4.30-4.33

close all;
clearvars;
load('hospitalFS.txt');
y=hospitalFS(:,5);
X=hospitalFS(:,1:4);

n=length(y);

%% 
% LMS using all  subsamples (very lengthy)
nsamp=0
[outLXS]=LXS(y,X,'nsamp',0);

%{
% best out of 111,469,176 subsets
 outLXS.bs= [ 3   11   20   23   74];
%}

%% SP mdr in normal coordinates
% best susbet out of all 111,469,176 subsets
outLXS.bs= [ 3   11   20   23   74];
p=size(X,2)+1;

outMDR=FSRmdr(y,X,outLXS.bs);
[MDRinv] = FSRinvmdr(outMDR,p);
outFS.mdr=MDRinv(:,[1 3]);
mdrplot(outFS,'ncoord',true,'quant',[0.1 0.5 0.99 0.999 0.9999]);

if prin==1
    % print to postscript
    print -depsc SPmdrncoord.eps;
end
%% SP Data Automatic outlier detection
%{
outLXS.bs= [ 3   11   20   23   74];
[out]=FSR(y,X,'lms',outLXS.bs);
prin=0;
if prin==1
    % print to postscript
    print -depsc SPfsr.eps;
end
%}


%% Create Figure 4.31
% SP data Monitoring of prop of units in bsb and tstat
figure
n=length(y);
nr=1;
nc=2;
Prop=[(p+1:n)' zeros(n-p,1)];
[Un,BB]=FSRbsb(y,X,outLXS.bs,'init',p+1,'bsbsteps',p+1:n);
for j=1:size(BB,2)
    bj=BB(:,j);
    bj=bj(~isnan(bj));
    Prop(j,2)=sum(bj<=54)/length(bj);
end

subplot(nr,nc,1)
plot(Prop(:,1),Prop(:,2),'LineWidth',2)
xlabel('Subset size')

subplot(nr,nc,2)
% Forward Search
[outFS]=FSReda(y,X,outLXS.bs,'init',p+1);
hold('on');
col=repmat({'m';'k';'g';'b';'c'},3,1);
linst=repmat({'-';'--';':';'-.';'--';':'},3,1);

for j=3:size(X,2)+2
    plot(outFS.Tols(:,1),outFS.Tols(:,j),'LineWidth',2,'Color',col{j-2},'LineStyle',linst{j-2})
    % tj=['t_' num2str(j-2)];
    tj=[num2str(j-2)];
    text(outFS.Tols(2,1)-5.2,outFS.Tols(2,j),tj,'FontSize',16)
    text(outFS.Tols(end,1)+2.2,outFS.Tols(end,j),tj,'FontSize',16)

end

quant=norminv(0.95);
v=axis;
lwdenv=1;
line([v(1),v(2)],[quant,quant],'color','r','LineWidth',lwdenv);
line([v(1),v(2)],[-quant,-quant],'color','r','LineWidth',lwdenv);
% plot(out.Tols(end-6:end-1,1),out.Tols(end-6:end-1,3),'LineWidth',4,'color','r')
% title('Monitoring of t-stat','FontSize',14);
xlabel('Subset size m');
sgtitle('Figure 4.31')
set(gcf,"Name",'Figure 4.31')

if prin==1
    % print to postscript
    print -depsc SPtmonitor.eps;
end


%% Create Figure 4.32
% Forward Search Monitoring of traditional tstat
close all
[outFS]=FSReda(y,X,outLXS.bs,'init',p+1,'tstat','trad');
hold('on');
col=repmat({'m';'k';'g';'b';'c'},3,1);
linst=repmat({'-';'--';':';'-.';'--';':'},3,1);

for j=3:size(X,2)+2
    plot(outFS.Tols(:,1),outFS.Tols(:,j),'LineWidth',2,'Color',col{j-2},'LineStyle',linst{j-2})
    % tj=['t_' num2str(j-2)];
    tj=[num2str(j-2)];
    text(outFS.Tols(2,1)-5.2,outFS.Tols(2,j),tj,'FontSize',16)
    text(outFS.Tols(end,1)+2.2,outFS.Tols(end,j),tj,'FontSize',16)

end

quant=norminv(0.95);
v=axis;
lwdenv=1;
line([v(1),v(2)],[quant,quant],'color','r','LineWidth',lwdenv);
line([v(1),v(2)],[-quant,-quant],'color','r','LineWidth',lwdenv);
% plot(out.Tols(end-6:end-1,1),out.Tols(end-6:end-1,3),'LineWidth',4,'color','r')
% title('Monitoring of t-stat','FontSize',14);
xlabel('Subset size m');
ylim([-5 300])

title('Figure 4.32')
set(gcf,"Name",'Figure 4.32')

if prin==1
    % print to postscript
    print -depsc SPtmonitortrad.eps;
end

%% Create Figure 4.33 
% SP data Forward Search Monitoring of added tstat
figure
[out]=FSRaddt(y,X,'plots',1,'nameX',{'X1','X2','X3' 'X4'},'lwdenv',2,'lwdt',2);
title('Figure 4.33')
set(gcf,"Name",'Figure 4.33')

if prin==1
    % print to postscript
    print -depsc SPtmonitoradd.eps;
end



