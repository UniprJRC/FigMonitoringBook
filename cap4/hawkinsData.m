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

%%  HD: resfwdplot persistent brushing with FS
% Interactive_example
clearvars;close all;
load('hawkins.txt');
y=hawkins(:,9);
X=hawkins(:,1:8);

[outLXS]=LXS(y,X,'nsamp',10000);
[out]=FSReda(y,X,outLXS.bs);
%%
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

if prin==1
    % print to postscript
    print -depsc HD2a.eps;
    print -depsc HD2b.eps;

        print -depsc HD3a.eps;
    print -depsc HD3b.eps;

        print -depsc HD4a.eps;
    print -depsc HD4b.eps;

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




%% Sregeda with bisquare link brushing
% For the exercises
% Perform botht the FS and the S residuals monitoring
clearvars;close all;
load('hawkins.txt');
y=hawkins(:,9);
X=hawkins(:,1:8);
yXplot(y,X);
[outLXS]=LXS(y,X,'nsamp',10000);
[out]=FSReda(y,X,outLXS.bs);

outTB=Sregeda(y,X,'plots',1,'rhofunc','bisquare');
yl=5;
ylim([-yl yl])
% The information about the order of entry of the units in the FS is added
% to outTB
outTB.Un=out.Un;

%%
mdrplot(out,'ylimy',[1 8])

standard=struct;
standard.ylim=[-yl yl];

databrush=struct;
databrush.bivarfit='';
databrush.selectionmode='Brush'; % Brush selection
% databrush.persist='on'; % Enable repeated mouse selections
databrush.Label='off'; % Write labels of trajectories while selecting
databrush.RemoveLabels='off'; % Do not remove labels after selection

resfwdplot(outTB,'databrush',databrush,'datatooltip','','standard',standard)
if prin==1
    % print to postscript
    print -depsc HDtbexeres6.eps;
    print -depsc HDtbexemdr6.eps;

    print -depsc HDtbexeres.eps;
    print -depsc HDtbexemdr.eps;
    print -depsc HDtbexeyXplot.eps;
    
end
