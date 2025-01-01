%% Hawkins data
% This file creates Figure 4.23
% and Figures 4.27-4.29

%% Data loading
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
else
    sgtitle('Figure 4.23')
    set(gcf,"Name",'Figure 4.23')
end


%% Create Figure 4.27
out=FSR(y,X,'plots',0);
seq=1:n;
goodOBS=setdiff(seq,out.ListOut);
yXplot(y(goodOBS),X(goodOBS,:),'tag','pl_goodobs');

if prin==1
    % print to postscript
    print -depsc HDyXplotgood.eps;
else
    sgtitle('Figure 4.27')
    set(gcf,"Name",'Figure 4.27')
end

drawnow

%% Prepare input for Figures 4.28 and 4.29
% Sregeda with PD link
disp('Monitoring S estimators')
tStart=tic;
outPD=Sregeda(y,X,'plots',0,'rhofunc','mdpd','msg',0);
a=toc(tStart);
disp(['PD rho function: number of seconds=' num2str(a)])
disp('---------------------')
tStart=tic;
outTB=Sregeda(y,X,'plots',0,'rhofunc','bisquare','msg',0);
a=toc(tStart);
disp(['TB rho function: number of seconds=' num2str(a)])
disp('---------------------')

%% Create Figure 28 left panel
resfwdplot(outTB,'tag','pl_TBori','datatooltip','');
ylim([-830 830])


if prin==1
    % print to postscript
    print -depsc HDtblink.eps
else
    title('Figure 4.28 (left panel): TB rho function')
    set(gcf,"Name",'Figure 4.28 (left panel)')
end


%% Create Figure 4.28 right panel
resfwdplot(outPD,'tag','pl_PDori','datatooltip','');
ylim([-830 830])

if prin==1
    % print to postscript
    print -depsc HDpdlink.eps
else
    title('Figure 4.28 (right panel): PD rho function')
    set(gcf,"Name",'Figure 4.28 (right panel)')
end


%% Create Figure 4.29 left panel
resfwdplot(outTB,'tag','pl_TBzoom','datatooltip','');
yl=5;
ylim([-yl yl])

if prin==1
    % print to postscript
    print -depsc HDtblinkZ.eps
else
    title('Figure 4.29 (left panel): TB rho function ZOOM')
    set(gcf,"Name",'Figure 4.28 (left panel)')

end

%% Create Figure 29 right panel
resfwdplot(outPD,'tag','pl_PDzoom','datatooltip','');
yl=5;
ylim([-yl yl])

if prin==1
    print -depsc HDpdlinkZ.eps;
else
    title('Figure 4.29 (right panel): PD rho function ZOOM')
    set(gcf,"Name",'Figure 4.29 (right panel)')
end

%InsideREADME


