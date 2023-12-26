%% Hawkins data
% This file creates Figure 4.23 
% and Figures 4.27-4.29
close all;
load('hawkins.txt');
y=hawkins(:,9);
X=hawkins(:,1:8);

n=length(y);
prin=0;

%% Create Figure 4.23
% yX plot
yXplot(y,X);
if prin==1
    % print to postscript
    print -depsc HDyXplot.eps;
end

sgtitle('Figure 4.23')
set(gcf,"Name",'Figure 4.23')

%% Create Figure 4.27
out=FSR(y,X,'plots',0);
seq=1:n;
goodOBS=setdiff(seq,out.ListOut);
yXplot(y(goodOBS),X(goodOBS,:),'tag','pl_goodobs')

if prin==1
    % print to postscript
    print -depsc HDyXplotgood.eps;
end

sgtitle('Figure 4.27')
set(gcf,"Name",'Figure 4.27')
drawnow

%% Prepare input for Figures 4.28 and 4.29
% Sregeda with PD link
disp('Monitoring S estimators')
outPD=Sregeda(y,X,'plots',0,'rhofunc','mdpd','msg',0);
outTB=Sregeda(y,X,'plots',0,'rhofunc','bisquare','msg',0);

%% Create Figure 28 left panel
resfwdplot(outTB,'tag','pl_TBori');

title('Figure 4.28 (left panel)')
set(gcf,"Name",'Figure 4.28 (left panel)')

%% Create Figure 28 right panel
resfwdplot(outTB,'tag','pl_PDori');

title('Figure 4.28 (right panel)')
set(gcf,"Name",'Figure 4.28 (right panel)')

%% Create Figure 29 left panel
resfwdplot(outTB,'tag','pl_TBzoom');
yl=5;
ylim([-yl yl])
title('Figure 4.29 (left panel)')
set(gcf,"Name",'Figure 4.28 (left panel)')

%% Create Figure 29 right panel
resfwdplot(outTB,'tag','pl_PDzoom');
title('Figure 4.29 (right panel)')
set(gcf,"Name",'Figure 4.29 (right panel)')
yl=5;
ylim([-yl yl])

if prin==1
    % print to postscript
    print -depsc HDtblink.eps;
    print -depsc HDtblinkZ.eps;

    print -depsc HDpdlink.eps;
    print -depsc HDpdlinkZ.eps;

end

%InsideREADME


