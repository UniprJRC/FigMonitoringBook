

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
