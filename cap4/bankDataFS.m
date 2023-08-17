
%% BANK DATA FS analysis  brushing from yXplot
load bank_data.mat
y=bank_data{:,end};
X=bank_data{:,1:end-1};
[out]=LXS(y,X,'nsamp',50000);
out.bs
outFS=FSReda(y,X,out.bs);
yXplot(outFS,'databrush',1,'selunit',[])

%% Monitoring scaled residuals 

%% mdrplot in normal coordinates (to be used?)
outFS=FSReda(y,X,out.bs);
p=size(X,2)+1;

% Transform the values of mdr into normal coordinates
[MDRinv] = FSRinvmdr(abs(outFS.mdr),p);
outFS1=outFS;
outFS1.mdr=MDRinv(:,[1 3]);
quant=[0.0100    0.5000    0.9900    0.9990    0.9999];
mdrplot(outFS1,'ncoord',true,'quant',quant,'tag','mdrncoord')


%% Monitoring of tstat from FS
close all
hold('on');
col=repmat({'b';'g';'c';'m';'k'},3,1);
linst=repmat({'-','--',':','-.','--',':'},3,1);

for j=3:size(X,2)+2
    tj=['t_' num2str(j-2)];
    plot(outFS.Tols(:,1),outFS.Tols(:,j),'LineWidth',3,'Color',col{j-2},'LineStyle',linst{j-2})
    text(outFS.Tols(1,1)-1.2,outFS.Tols(1,j),tj,'FontSize',16)

end

quant=norminv(0.95);
v=axis;
lwdenv=2;
line([v(1),v(2)],[quant,quant],'color','g','LineWidth',lwdenv);
line([v(1),v(2)],[-quant,-quant],'color','g','LineWidth',lwdenv);
% plot(out.Tols(end-6:end-1,1),out.Tols(end-6:end-1,3),'LineWidth',4,'color','r')
title('Monitoring of t-stat','FontSize',14);
xlabel('Subset size m');


%% Monitoring of added tstat
outADDt=FSRaddt(y,X,'plots',1);

