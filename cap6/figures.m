
%% Decide to save or not to print figures to postscript files
prin=0;

%% HOSPITAL fig 6.1
load('hospitalFS.txt');
y=exp(hospitalFS(:,5));
X=hospitalFS(:,1:4);
n=length(y);
[outFSRfan]=FSRfan(y,X,'plots',1,'init',round(n*0.2),'nsamp',100000,'msg',0,'family','YJ');

fanplot(outFSRfan,'conflev',[0.99 0.9999])
title('')
xcoo=round(n*0.6);
rangeaxis=axis;
line(repmat(xcoo,2,1), rangeaxis(3:4)','LineWidth',1,'color','k');

if prin==1
    % print to postscript
    print -depsc figs\H1.eps
end

% %% H2 
% [out]=fanBIC(outFSRfan);
% if prin==1
%     % print to postscript
%     print -depsc figs\H2.eps
% end



%% LD (Loyalty cards data)
load('loyalty.txt');
y=loyalty(:,4); %#ok<SUSENS>
X=loyalty(:,1:3);
n=length(y);
[outFSRfan]=FSRfan(y,X,'plots',1,'init',round(n*0.3),'nsamp',10000,'la',[-1:0.1:1],'msg',0);
if prin==1
    % print to postscript
    print -depsc figs\L1.eps
end



%% LD (Loyalty cards data) Prepare routines for L3 and L4
load('loyalty.txt');
y=loyalty(:,4); %#ok<SUSENS>
X=loyalty(:,1:3);
n=length(y);
yt=y.^0.4;
[out]=FSR(yt,X,'plots',0,'init',round(n*0.3),'nsamp',10000);
outl=out.ListOut;

[outLXS]=LXS(yt,X,'nsamp',10000);
[outEDA]=FSReda(yt,X,outLXS.bs);


%% Figure L3: mdrplot with last 18 highlighted
close all
mdr=abs(outEDA.mdr(:,1:2));
mdrplot(outEDA)
rr=18;
hold('on')
plot(mdr(end-rr:end,1),mdr(end-rr:end,2),'LineWidth',1.5,'color','r');
        
%% Figure L4: resfwdplot with outliers highlighted
% Monitoring scaled residuals with all default parameters
fground=struct;
fground.funit=outl;
fground.Color={'r'};
fground.flabstep='';
bground=struct;
bground.bthresh=4;
resfwdplot(outEDA,'fground',fground,'bground',bground);

%% Figure L5: 
% Transformed loyalty cards data: scatterplot against 𝑥1. The 18 outliers detected plotted as
% red crosses 
group=ones(length(y),1);
group(outl)=2;
gscatter(X(:,1),yt,group,'br','o+',10)
xlabel('x1=frequency')
ylabel("Transformed sales")
legend off

%% Figure L6: 
% Monitoring of beta1
close all
j=3;
    plot(outEDA.Bols(:,1),outEDA.Bols(:,3),'LineWidth',2)
    xlim([10 510])
    xlabel('Subset size m');
    % ylabel(nameX(j-2));
