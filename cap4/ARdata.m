


%% MR (Multiple regression data): Forward EDA datatooltip which monitors bsb
load('multiple_regression.txt');
y=multiple_regression(:,4);
X=multiple_regression(:,1:3);
% LMS using 1000 subsamples
[out]=LXS(y,X,'nsamp',30000);
% Forward Search
[out]=FSReda(y,X,out.bs);


% Create scaled squared residuals
out1=out;
% out1.RES=out.RES.^2;
datatooltip=struct;
datatooltip.SubsetLinesColor=[1 0 0];
resfwdplot(out,'datatooltip',datatooltip)

if prin==1
    % print to postscript
    print -depsc ARmonbsb30.eps;
     print -depsc ARmonbsb53.eps;
end

%% 3D plot

%% Rotate manually
scatter3(X(:,1),X(:,2),y)
xlabel('X1')
ylabel('X2')
zlabel('y')
hold('on');
sel=[9 30 31 38 47 21];
scatter3(X(sel,1),X(sel,2),y(sel),'r','MarkerFaceColor','r')
% sel=[43];
hold('on')
sel1=43;
scatter3(X(sel1,1),X(sel1,2),y(sel1),'k','MarkerFaceColor','k')
text(X(sel1,1),X(sel1,2),y(sel1),'43')
if prin==1
    % print to postscript
    print -depsc AR3D.eps;
     print -depsc AR3Drot.eps;
end


%% MR (Multiple regression data): Forward EDA using persistent brushing
load('multiple_regression.txt');
y=multiple_regression(:,4);
X=multiple_regression(:,1:3);
% LMS using 1000 subsamples
[out]=LXS(y,X,'nsamp',20000);
% Forward Search
[out]=FSReda(y,X,out.bs);
out1=out;
% Create scaled squared residuals
% out1.RES=out.RES.^2;

% plot minimum deletion residual with personalized options
% mdrplot(out,'ylimy',[1 4.2],'xlimx',[10 60],'FontSize',14,'SizeAxesNum',14,'lwdenv',2);

% Persistent brushing on the plot of the scaled residuals. The plot is:
fground.flabstep='';        % without labels at steps 0 and n
fground.fthresh=3.5;      % threshold which defines the trajectories in foreground
fground.LineWidth=1.5;      % personalised linewidth for trajectories in foreground
fground.Color={'r'};        % personalised color (red lines) for trajectories in foreground

databrush=struct;
databrush.bivarfit='';
databrush.selectionmode='Rect'; % Rectangular selection
% databrush.persist='on'; % Enable repeated mouse selections
databrush.Label='on'; % Write labels of trajectories while selecting
databrush.RemoveLabels='off'; % Do not remove labels after selection
databrush.Pointer='hand'; % Hand cursor point while selecting
databrush.FlagSize='8'; % Size of the brushed points
databrush.RemoveTool='on'; % Remove yellow selection after finishing brushing
resfwdplot(out1,'fground',fground,'databrush',databrush);
if prin==1
    % print to postscript
    print -depsc ARbrush.eps;
     print -depsc ARbrushyX.eps;
end


%% Monitoring of residuals 
load('multiple_regression.txt');
y=multiple_regression(:,4);
X=multiple_regression(:,1:3);

% [out] = mdpdReda(y, X, 'plots',1,'alphaORbdp','bdp','tuningpar',0.5:-0.01:0.01);
out1=Sregeda(y,X,'plots',1,'rhofunc','mdpd');

%% Draw plot
fground=struct;
sel=[ 9 21 30 31 38 47    3 11 14 24 27 36 42 50 43  7 39 ]';
fground.funit=sel;
fground.FontSize=1;

LineStyle=[ repmat({'-.'},6,1); repmat({'--'},9,1); repmat({':'},2,1)];
Color= [ repmat({'r'},6,1); repmat({'k'},9,1); repmat({'b'},2,1)];
fground.Color=Color;  % different colors for different foreground trajectories
fground.LineWidth=3;
fground.LineStyle=LineStyle;
% Options for the trajectories in background

resfwdplot(out1,'fground',fground,'tag','BF');
if prin==1
    % print to postscript
    print -depsc ARmonPD.eps;
end
