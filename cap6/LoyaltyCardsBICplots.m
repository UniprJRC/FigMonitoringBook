%% Loyalty cards data.
% This file creates Figures 6.15-6.16.  
% Note that Figures 6.2-6.6 are created by file LoyaltyCards.m.


%% LD (Loyalty cards data)
load('loyalty.txt');
y=loyalty(:,4); %#ok<SUSENS>
X=loyalty(:,1:3);
n=length(y);
prin=0;

%% Create Figure 6.15
la=-1:0.5:1;
[outFSRfan]=FSRfan(y,X,'plots',0,'init',round(n*0.3),'nsamp',10000,'la',la,'msg',0);
[out5la]=fanBIC(outFSRfan);

set(gcf,"Name",'Figure 6.15)')

if prin==1
    % print to postscript
    print -depsc figs\L2a.eps
     print -depsc figs\L2b.eps
end


%% Create Figure 6.16
% BIC and AGI finer grid for la
la=-1:0.1:1;
[outFSRfan]=FSRfan(y,X,'plots',0,'init',round(n*0.3),'nsamp',10000,'la',la,'msg',0);

[out21la]=fanBIC(outFSRfan,'tag','pl_sco21');
set(gcf,"Name",'Figure 6.16')

if prin==1
    % print to postscript
    print -depsc figs\L1.eps
end

%InsideREADME   
