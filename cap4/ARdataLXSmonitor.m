%% AR data LTS monitoring

load('multiple_regression.txt');
y=multiple_regression(:,4);
X=multiple_regression(:,1:3);

% Find LMS and LTS residuals
[n]=size(X,1);
bdp=0.5:-0.01:0.01;
RES=zeros(n,length(bdp));
nsamp=20000;
RESLMS=zeros(n,length(bdp));

for j=1:length(bdp)
    
    [out]=LXS(y,X,'lms',2,'bdp',bdp(j),'nsamp',nsamp);
    
    RES(:,j)=out.residuals;
    
    [outLMS]=LXS(y,X,'bdp',bdp(j),'nsamp',nsamp);
    RESLMS(:,j)=outLMS.residuals;
    
end

%%  just plotting part for LTS

out=struct;
out.RES=RES;
out.Un=1;
out.X=X;
out.y=y;
out.class='LTS';

fground=struct;
sel=[ 9 21 30 31 38 47    3 11 14 24 27 36 42 50 43  7 39 ]';
fground.funit=sel;
fground.FontSize=1;

LineStyle=[ repmat({'-.'},6,1); repmat({'--'},9,1); repmat({':'},2,1)];
Color= [ repmat({'r'},6,1); repmat({'k'},9,1); repmat({'b'},2,1)];
fground.Color=Color;  % different colors for different foreground trajectories
fground.LineWidth=3;
fground.LineStyle=LineStyle;
%fground.flabstep=15;

resfwdplot(out,'fground',fground);

h1 = gcf; % open figure
ax1 = gca; % get handle to axes of figure

res=RES;
RHOS = corr(res,'type','Spearman');
RHOK = corr(res,'type','Kendall');
RHOP = corr(res,'type','Pearson');
upy=1.02;
droS=diag(RHOS,1);
droK=diag(RHOK,1);
droP=diag(RHOP,1);

ini=n-length(bdp)+1;

xaxis=((ini+1):n)';

hall = figure; %create new figure
fig1 = get(ax1,'children'); %get handle to all the children in the figure

s1 = subplot(3,2,[1 3 5]); %create and get handle to the subplot axes
copyobj(fig1,s1); %copy children to new parent axes i.e. the subplot axes
FontSiz=14;
xlabel('bdp','FontSize',FontSiz,'Interpreter','Latex')
ylabel(['LTS residuals'],'Interpreter','Latex','FontSize',FontSiz)
ini=n-length(bdp)+1;
xlim([ini n])
xticklabel=get(gca,'Xticklabel');
newlabel=char(num2str(bdp(str2double(xticklabel)-ini+1)'));
set(gca,'Xticklabel',newlabel)
%xlim([ini-3 n+3])


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
% ylim([lowy upy])
ylimp=get(gca,'ylim');
set(gca,'ylim',[ylimp(1) upy])
%xlim([ini-2 n+1])



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
    print -depsc  LTSresAR.eps;
end

%% just plotting part for LMS

out=struct;
out.RES=RESLMS;
out.Un=1;
out.X=X;
out.y=y;
out.class='LMS';

fground=struct;
sel=[ 9 21 30 31 38 47    3 11 14 24 27 36 42 50 43  7 39 ]';
fground.funit=sel;
fground.FontSize=1;

LineStyle=[ repmat({'-.'},6,1); repmat({'--'},9,1); repmat({':'},2,1)];
Color= [ repmat({'r'},6,1); repmat({'k'},9,1); repmat({'b'},2,1)];
fground.Color=Color;  % different colors for different foreground trajectories
fground.LineWidth=3;
fground.LineStyle=LineStyle;
resfwdplot(out,'fground',fground);

h1 = gcf; % open figure
ax1 = gca; % get handle to axes of figure

res=RESLMS;
RHOS = corr(res,'type','Spearman');
RHOK = corr(res,'type','Kendall');
RHOP = corr(res,'type','Pearson');
upy=1.02;
droS=diag(RHOS,1);
droK=diag(RHOK,1);
droP=diag(RHOP,1);

ini=n-length(bdp)+1;

xaxis=((ini+1):n)';

hall = figure; %create new figure
fig1 = get(ax1,'children'); %get handle to all the children in the figure

s1 = subplot(3,2,[1 3 5]); %create and get handle to the subplot axes
copyobj(fig1,s1); %copy children to new parent axes i.e. the subplot axes
FontSiz=14;
xlabel('bdp','FontSize',FontSiz,'Interpreter','Latex')
ylabel(['LMS residuals'],'Interpreter','Latex','FontSize',FontSiz)
ini=n-length(bdp)+1;
xlim([ini n])
xticklabel=get(gca,'Xticklabel');
newlabel=char(num2str(bdp(str2double(xticklabel)-ini+1)'));
set(gca,'Xticklabel',newlabel)
%xlim([ini-3 n+3])


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
% ylim([lowy upy])
ylimp=get(gca,'ylim');
set(gca,'ylim',[ylimp(1) upy])
%xlim([ini-2 n+1])



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
    print -depsc LMSresAR.eps;
end

