%% Hospital data (SP)

close all;
clearvars;close all;
load('hospitalFS.txt');
y=hospitalFS(:,5);
X=hospitalFS(:,1:4);

n=length(y);
p=size(X,2);

% LMS using all  subsamples (very lengthy)
[out]=LXS(y,X,'nsamp',0);
disp(out.scale)
%{
% best out of 111,469,176 subsets
 out.bs= [ 3   11   20   23   74];
%}

%% sp original yXplot
group=ones(n,1);
group(55:n)=2;
plo=struct;
plo.sym={'o' '^'};
% plo.color
yXplot(y,X,'group',group,'plo',plo)

%% SP Data Automatic outlier detection
outLXS.bs= [ 3   11   20   23   74];
[out]=FSR(y,X,'lms',outLXS.bs);
prin=0;
if prin==1
    % print to postscript
    print -depsc SPfsr.eps;
end
%% yXplot with different symbols for the different groups (not used)
outl=out.outliers;
group=ones(n,1);
group(55:n)=2;
good=setdiff(1:n,outl);
good1=good(good<=54);
good2=good(good>54);
group(good1)=3;
group(good2)=4;
plo.sym={'o' '^' 'o' '^'};
plo.col={'r' 'b' 'g' 'c'};
[H,AX,BigAx]=yXplot(y,X,'group',group,'plo',plo)
for j=1:p
    AX1=AX(j);
    AX1.Children(2).MarkerFaceColor='k';
    AX1.Children(1).MarkerFaceColor='r';
end

%% 3D plot (not used)
close all
v1=1;
scatter3(X(:,v1),X(:,3),y)
xlabel('X3')
ylabel('X4')
zlabel('y')
hold('on');
outl=out.outliers;
group=ones(n,1);

sel=outl;
sel=1:54;
sel1=setdiff(1:n,outl);

scatter3(X(sel,v1),X(sel,3),y(sel),'r')
% sel=[43];
scatter3(X(sel1,v1),X(sel1,3),y(sel1),'k','MarkerFaceColor','k')
% text(X(sel1,2),X(sel1,3),y(sel1),'43')


%% SP data Monitoring of prop of units in bsb and tstat
prin=0;
close all
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

if prin==1
    % print to postscript
    print -depsc SPtmonitor.eps;
end


%% Forward Search Monitoring of traditional tstat
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

if prin==1
    % print to postscript
    print -depsc SPtmonitortrad.eps;
end

%% SP data Forward Search Monitoring of added tstat

[out]=FSRaddt(y,X,'plots',1,'nameX',{'X1','X2','X3' 'X4'},'lwdenv',2,'lwdt',2);
if prin==1
    % print to postscript
    print -depsc SPtmonitoradd.eps;
end

%% SP mdr in normal coordinates
%{
% best out of 111,469,176 subsets
 out.bs= [ 3   11   20   23   74];
%}
outFS=FSReda(y,X,outLXS.bs);
% outFS.mdr=abs(outFS.mdr);
p=size(X,2)+1;

outMDR=FSRmdr(y,X,outLXS.bs);
[MDRinv] = FSRinvmdr(outMDR,p);
outFS.mdr=MDRinv(:,[1 3]);
mdrplot(outFS,'ncoord',true,'quant',[0.1 0.5 0.99 0.999 0.9999])

if prin==1
    % print to postscript
    print -depsc SPmdrncoord.eps;
end


%% 
close all;
clearvars;close all;
load('hospitalFS.txt');
y=hospitalFS(:,5);
X=hospitalFS(:,1:4);
n=length(y)
group=ones(n,1);
group(55:n)=2;
fitlm([X group],y)
[out]=FSRaddt(y,[X group],'plots',1,'nameX',{'X1','X2','X3' 'X4' 'dum'},'lwdenv',2,'lwdt',2);
if prin==1
    % print to postscript
    print -depsc SPaddvarDUM.eps;
end



%% SD: analysis using S estimators with 2 values of breakdown point
clearvars;close all;
load('hospitalFS.txt');
y=hospitalFS(:,5);
X=hospitalFS(:,1:4);
% 95 and 99 conflev
conflev=[0.95 0.99];

%% TB link
% Sreg using two different level of breakdown point
% Using bdp=0.5 it is clear that the first 54 units have a pattern of residuals
% which is different from the remaining 54
figure;
h1=subplot(2,1,1);
bdp=0.25;
[out]=Sreg(y,X,'nsamp',3000,'bdp',bdp,'rhofunc','bisquare');
resindexplot(out,'h',h1,'conflev',conflev);
ylabel(['Breakdown point =' num2str(bdp)])
h2=subplot(2,1,2);
bdp=0.5;
[out]=Sreg(y,X,'nsamp',3000,'bdp',bdp,'rhofunc','bisquare');
resindexplot(out,'h',h2,'conflev',conflev);
ylabel(['Breakdown point =' num2str(bdp)])
if prin==1
    % print to postscript
    print -depsc SPStwobdp.eps;
end

%% PD LINK
% Sreg using two different level of breakdown point
% Using bdp=0.5 it is clear that the first 54 units have a pattern of residuals
% which is different from the remaining 54
figure;
h1=subplot(2,1,1);
bdp=0.25;
[out]=Sreg(y,X,'nsamp',3000,'bdp',bdp,'rhofunc','mdpd');
resindexplot(out,'h',h1,'conflev',conflev);
ylabel(['Breakdown point =' num2str(bdp)])
h2=subplot(2,1,2);
bdp=0.5;
[out]=Sreg(y,X,'nsamp',3000,'bdp',bdp,'rhofunc','mdpd');
resindexplot(out,'h',h2,'conflev',conflev);
ylabel(['Breakdown point =' num2str(bdp)])
if prin==1
    % print to postscript
    print -depsc SPStwobdpPD.eps;
end