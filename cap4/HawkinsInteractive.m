%% Hawkins data
% This file creates Figures 4.24-4.26
% Note that this file needs interactivity

load('hawkins.txt');
y=hawkins(:,9);
X=hawkins(:,1:8);

prin=0;

%%  HD: resfwdplot persistent brushing with FS
% Interactive_example

[outLXS]=LXS(y,X,'nsamp',10000);
[out]=FSReda(y,X,outLXS.bs);
databrush=struct;
databrush.bivarfit='';
databrush.selectionmode='Brush'; % Brush selection
databrush.persist='on'; % Enable repeated mouse selections
databrush.Label='off'; % Write labels of trajectories while selecting
databrush.RemoveLabels='off'; % Do not remove labels after selection
% Note that if you wish to have the labels for the brushed units in the
% yXplot it is necessary to add the instruction in the line below
% databrush.labeladd='1'
mdrplot(out,'ylimy',[1 8])
resfwdplot(out,'databrush',databrush,'datatooltip','');
fig=findobj(0,'tag','pl_mdr');
figure(fig)
title('Figure similar to bottom panel of 4.24 or 4.25 or 4.26','It depends on your brushing')
fig=findobj(0,'tag','pl_resfwd');
figure(fig)
title('Figure similar to top panel of 4.24 or 4.25 or 4.26', 'It depends on your brushing')

if prin==1
    % print to postscript
    print -depsc HD2a.eps;
    print -depsc HD2b.eps;

    print -depsc HD3a.eps;
    print -depsc HD3b.eps;

    print -depsc HD4a.eps;
    print -depsc HD4b.eps;
end