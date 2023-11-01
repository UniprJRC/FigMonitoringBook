%% VT: (Body measurements to predict percentage of body fat in males): 
% S estimators with 2 values of bdp
load("fatilr.txt")
size(fatilr)

y = fatilr(:,10);
X = fatilr(:,1:9);

conflev=[0.95 0.99];

figure;
h1=subplot(2,1,1);
bdp=0.25;
[out]=Sreg(y,X,'nsamp',3000,'bdp',bdp);
resindexplot(out,'h',h1,'conflev',conflev);
ylabel(['Breakdown point =' num2str(bdp)])

h2=subplot(2,1,2);
bdp=0.5;
[out]=Sreg(y,X,'nsamp',3000,'bdp',bdp);
resindexplot(out,'h',h2,'conflev',conflev,'numlab',{6});
ylabel(['Breakdown point =' num2str(bdp)])
cascade;
prin=0;
if prin==1
    % print to postscript
    print -depsc fatilr_S.eps;
end

%% VT: (Body measurements  data): MM estimators with 2 values of efficiency
clearvars;close all;
load ('fatilr.txt');
size(fatilr)

y = fatilr(:,10);
X = fatilr(:,1:9);

% MMreg using two different level of efficiency
conflev=[0.95 0.99];
figure;
h1=subplot(2,1,1);
eff=0.80;
[out]=MMreg(y,X,'Snsamp',3000,'eff',eff);
resindexplot(out,'h',h1,'conflev',conflev,'numlab',{6});
ylabel(['Eff.=' num2str(eff)])
h2=subplot(2,1,2);
eff=0.99;
[out]=MMreg(y,X,'Snsamp',3000,'eff',eff);
resindexplot(out,'h',h2,'conflev',conflev,'numlab',{4});
ylabel(['Eff.=' num2str(eff)])
prin=1;
if prin==1
    % print to postscript
    print -depsc fatilr_MM.eps;
end

%% VT: (Body measurements  data): Forward search
clearvars;close all;
load ('fatilr.txt');
size(fatilr)

y = fatilr(:,10);
X = fatilr(:,1:9);

%% Signal is in step m=250
[out]=LXS(y,X,'nsamp',1000);
fsout=FSR(y, X);

%% VT: (Body measurements  data): Monitoring S estimtes
clearvars;close all;
load ('fatilr.txt');

y = fatilr(:,10);
X = fatilr(:,1:9);

[out]=Sregeda(y,X);
fground = struct;
fground.Color={'r'};
fground.flabstep = '';
fground.fthresh=2.0;
resfwdplot(out, 'fground', fground, 'datatooltip','');
ylabel('Scaled S residuals');
xlabel('bdp');

prin=1;

if prin==1
    % print to postscript
    print -depsc fatilr_S_mon.eps;
end

RHO = [];
for i=1:49
    RHO(i,1) = corr(out.RES(:,i),out.RES(:,i+1),'type','Spearman');
    RHO(i,2) = corr(out.RES(:,i),out.RES(:,i+1),'type','Kendall');
    RHO(i,3) = corr(out.RES(:,i),out.RES(:,i+1),'type','Pearson');
end
minc = min(RHO);
maxc = max(RHO);
ylimits = [min(minc)*0.8,max(maxc)*1.1];
figure;
subplot(3,1,1);
plot(out.bdp(1:49),RHO(:,1)');
if strcmp(out.class,'Sregeda')
    set(gca,'XDir','reverse','ylim',ylimits);
    title('Spearman');
end

subplot(3,1,2);
plot(out.bdp(1:49),RHO(:,2)');
if strcmp(out.class,'Sregeda')
    set(gca,'XDir','reverse','ylim',ylimits);
    title('Kendall');
end

subplot(3,1,3);
plot(out.bdp(1:49),RHO(:,3)');
if strcmp(out.class,'Sregeda')
    set(gca,'XDir','reverse','ylim',ylimits);
    title('Pearson');
end
xlabel('bdp');


if prin==1
    % print to postscript
    print -depsc fatilr_S_moncor.eps;
end


%% VT: (Body measurements  data): Monitoring MM estimtes
clearvars;close all;
load ('fatilr.txt');

y = fatilr(:,10);
X = fatilr(:,1:9);

[out]=MMregeda(y,X);
fground = struct;
fground.Color={'r'};
fground.flabstep = '';
fground.fthresh=2.0;
resfwdplot(out, 'fground', fground, 'datatooltip','');
ylabel('Scaled S residuals');
xlabel('Efficiency');

prin=1;

if prin==1
    % print to postscript
    print -depsc fatilr_MM_mon.eps;
end

RHO = [];
for i=1:49
    RHO(i,1) = corr(out.RES(:,i),out.RES(:,i+1),'type','Spearman');
    RHO(i,2) = corr(out.RES(:,i),out.RES(:,i+1),'type','Kendall');
    RHO(i,3) = corr(out.RES(:,i),out.RES(:,i+1),'type','Pearson');
end
minc = min(RHO);
maxc = max(RHO);
ylimits = [min(minc)*0.99,max(maxc)*1.0009];
ylimits = [0.9975,1];
figure;
subplot(3,1,1);
plot(out.eff(1:49),RHO(:,1)');
if strcmp(out.class,'Sregeda')
    set(gca,'XDir','reverse','ylim',ylimits);
end
title('Spearman');
%ylim(ylimits);

subplot(3,1,2);
plot(out.eff(1:49),RHO(:,2)');
if strcmp(out.class,'Sregeda')
    set(gca,'XDir','reverse','ylim',ylimits);
end
title('Kendall');
%ylim(ylimits);

subplot(3,1,3);
plot(out.eff(1:49),RHO(:,3)');
if strcmp(out.class,'Sregeda')
    set(gca,'XDir','reverse','ylim',ylimits);
end
title('Pearson');
%ylim(ylimits);
xlabel('Efficiency');


if prin==1
    % print to postscript
    print -depsc fatilr_MM_moncor.eps;
end
