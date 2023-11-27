%% Fig. A.53
%% VT: (Body measurements to predict percentage of body fat in males): 
% S estimators with 2 values of bdp
load("fatilr.txt")
size(fatilr)

y = fatilr(:,10);
X = fatilr(:,1:9);

conflev=[0.95 0.99];

prin=1;

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
if prin==1
    % print to postscript
    print -depsc fatilr_S.eps;
end

%% Fig. A.54
%% VT: (Body measurements  data): MM estimators with 2 values of efficiency
clearvars;close all;
load ('fatilr.txt');
size(fatilr)

y = fatilr(:,10);
X = fatilr(:,1:9);

prin=1;

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
if prin==1
    % print to postscript
    print -depsc fatilr_MM.eps;
end

%% Fig. A.55 and Fig. A.56
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

prin=1;

[out]=Sregeda(y,X);
fground = struct;
fground.Color={'r'};
fground.flabstep = '';
fground.fthresh=2.0;
resfwdplot(out, 'fground', fground, 'datatooltip','', 'corres', 1);
ylabel('Scaled S residuals');
xlabel('bdp');

if prin==1
    % print to postscript
    print -depsc fatilr_S_mon.eps;
end


%% Fig. A.56
%% VT: (Body measurements  data): Monitoring MM estimtes
clearvars;close all;
load ('fatilr.txt');

y = fatilr(:,10);
X = fatilr(:,1:9);

prin=1;

[out]=MMregeda(y,X);
fground = struct;
fground.Color={'r'};
fground.flabstep = '';
fground.fthresh=2.0;
resfwdplot(out, 'fground', fground, 'datatooltip','', 'corres', 1);
ylabel('Scaled S residuals');
xlabel('Efficiency');

if prin==1
    % print to postscript
    print -depsc fatilr_MM_mon.eps;
end

