%% HD
load('hawkins.txt');
y=hawkins(:,9);
X=hawkins(:,1:8);

yXplot(y,X)
prin=0;
if prin==1
    % print to postscript
    print -depsc HDyXplot.eps;
end

%% Sregeda with PD link
out1=Sregeda(y,X,'plots',1,'rhofunc','mdpd');
yl=5;
ylim([-yl yl])
if prin==1
    % print to postscript
    print -depsc HDpdlink.eps;
    print -depsc HDpdlinkZ.eps;
end

%% Sregeda with bisquare link
outTB=Sregeda(y,X,'plots',1,'rhofunc','bisquare');
ylim([-yl yl])
if prin==1
    % print to postscript
    print -depsc HDtblink.eps;
    print -depsc HDtblinkZ.eps;
end


%% FS brushing
%

out=FSReda(y,X);
ylim([-10 10])
% After click on the legend to show just good units
if prin==1
    % print to postscript
    print -depsc HDyXplotgood.eps;
end
%

%% FSReda with brushing
clearvars;close all;
load('hawkins.txt');
y=hawkins(:,9);
X=hawkins(:,1:8);
yXplot(y,X);
[outLXS]=LXS(y,X,'nsamp',10000);
[out]=FSReda(y,X,outLXS.bs);

yXplot(out,'selstep',[40 21 80],'selunit','40000',...
    'databrush',{'persist','on','selectionmode' 'Brush'});
databrush=1;
resfwdplot(out,'databrush',databrush)

