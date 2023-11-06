%% hawkins data
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
yXplot(y,X)
sgtitle('Figure 4.23')
set(gcf,"Name",'Figure 4.23')
if prin==1
    % print to postscript
    print -depsc HDyXplot.eps;
end

%% Create Figure 4.27
out=FSR(y,X,'plots',0);
seq=1:n;
goodOBS=setdiff(seq,out.ListOut);
yXplot(y(goodOBS),X(goodOBS,:),'tag','pl_goodobs')
sgtitle('Figure 4.27')
set(gcf,"Name",'Figure 4.27')

if prin==1
    % print to postscript
    print -depsc HDyXplotgood.eps;
end


%% Prepare input for Figures 4.28 and 4.29
% Sregeda with PD link
outPD=Sregeda(y,X,'plots',0,'rhofunc','mdpd');
outTB=Sregeda(y,X,'plots',1,'rhofunc','bisquare');

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
title('Figure 4.29 (left panel)')
set(gcf,"Name",'Figure 4.28 (left panel)')
yl=5;
ylim([-yl yl])

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




%% FS brushing
%
% 
% out=FSReda(y,X);
% ylim([-10 10])
% % After click on the legend to show just good units
% if prin==1
%     % print to postscript
%     print -depsc HDyXplotgood.eps;
% end
% %
% 
% 
% 
% %% Sregeda with bisquare link brushing
% % For the exercises
% % Perform botht the FS and the S residuals monitoring
% clearvars;close all;
% load('hawkins.txt');
% y=hawkins(:,9);
% X=hawkins(:,1:8);
% yXplot(y,X);
% [outLXS]=LXS(y,X,'nsamp',10000);
% [out]=FSReda(y,X,outLXS.bs);
% 
% outTB=Sregeda(y,X,'plots',1,'rhofunc','bisquare');
% yl=5;
% ylim([-yl yl])
% % The information about the order of entry of the units in the FS is added
% % to outTB
% outTB.Un=out.Un;
% 
% %%
% mdrplot(out,'ylimy',[1 8])
% 
% standard=struct;
% standard.ylim=[-yl yl];
% 
% databrush=struct;
% databrush.bivarfit='';
% databrush.selectionmode='Brush'; % Brush selection
% % databrush.persist='on'; % Enable repeated mouse selections
% databrush.Label='off'; % Write labels of trajectories while selecting
% databrush.RemoveLabels='off'; % Do not remove labels after selection
% 
% resfwdplot(outTB,'databrush',databrush,'datatooltip','','standard',standard)
% if prin==1
%     % print to postscript
%     print -depsc HDtbexeres6.eps;
%     print -depsc HDtbexemdr6.eps;
% 
%     print -depsc HDtbexeres.eps;
%     print -depsc HDtbexemdr.eps;
%     print -depsc HDtbexeyXplot.eps;
% 
% end
