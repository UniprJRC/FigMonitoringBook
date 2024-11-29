%% Surgical Unit data.
% This file creates Figure 6.1.

%% Prepare input for Figure 6.1
close all;
clearvars;
load('hospitalFS.txt');
y=exp(hospitalFS(:,5));
X=hospitalFS(:,1:4);
% yXplot(y,X)

n=length(y);
prin=0;
[outFSRfan]=FSRfan(y,X,'plots',0,'init',round(n*0.2),'nsamp',100000,'msg',0,'family','YJ');

%% Create Figure 6.1
mm=round(0.6*n);
fanplotFS(outFSRfan,'conflev',[0.99 0.9999],'addxline',mm)


if prin==1
    % print to postscript
    print -depsc figs\H1.eps
else
    title('Figure 6.1')
    set(gcf,"Name",'Figure 6.1')
end

%InsideREADME