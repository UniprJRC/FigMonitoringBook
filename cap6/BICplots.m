%%
close all
load('loyalty.txt');
y=loyalty(:,4); %#ok<SUSENS>
X=loyalty(:,1:3);
n=length(y);
[outFSRfan]=FSRfan(y,X,'plots',1,'init',round(n*0.3),'nsamp',10000,'la',[-1:0.5:1],'msg',0);
xcoo=round(n*0.6);
rangeaxis=axis;
line(repmat(xcoo,2,1), rangeaxis(3:4)','LineWidth',1,'color','k');
title('')
xlabel('       ')
[out]=fanBIC(outFSRfan);
if prin==1
    % print to postscript
    print -depsc figs\L2a.eps
     print -depsc figs\L2b.eps
end


%% LD (Loyalty cards data) BIC and AGI
close all
load('loyalty.txt');
y=loyalty(:,4); %#ok<SUSENS>
X=loyalty(:,1:3);
n=length(y);
[outFSRfan]=FSRfan(y,X,'plots',1,'init',round(n*0.3),'nsamp',10000,'la',[-1:0.1:1],'msg',0);

[out]=fanBIC(outFSRfan);
if prin==1
    % print to postscript
    print -depsc figs\L1.eps
end

