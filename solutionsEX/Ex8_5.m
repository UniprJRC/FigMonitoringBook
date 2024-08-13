%% Analysis of body measurements to predict percentage of body fat in males.
%
% This file creates Figures A.53-A.56.

%% Data loading
load fat
fatsel=fat{:,["neck" "chest" "abdomen" "hip" "thigh" "knee" "ankle" "bicep" "forearm" "wrist"]};
X=pivotCoord(fatsel);

body_fat=fat.body_fat;
y=log(body_fat./(100-body_fat));

conflev=[0.95 0.99];
prin=0;

%% Create Figure A.53
% S estimators with 2 values of bdp
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
else
    sgtitle('Figure A.53')
    set(gcf,"Name",'Figure A.53')
end



%% Create Figure A.54
% MM estimators with 2 values of efficiency
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
else
sgtitle('Figure A.54')
set(gcf,"Name",'Figure A.54')
end

drawnow

%% Create Figures A.55 and A.56
% Forward search
% Signal is in step m=250
[out]=LXS(y,X,'nsamp',1000);
fsout=FSR(y, X,'plots',0);
disp(fsout)

%% Create Figure A.55
% Monitoring S estimtes
[out]=Sregeda(y,X,'msg',0);
fground = struct;
fground.Color={'r'};
fground.flabstep = '';
fground.fthresh=2.0;
resfwdplot(out, 'fground', fground, 'datatooltip','', 'corres', 1,'tag','pl_Sres');

if prin==1
    % print to postscript
    print -depsc fatilr_S_mon.eps;
else
    sgtitle('Figure A.55')
    set(gcf,"Name",'Figure A.55')
    drawnow
end


%% Create Fig. A.56
% Monitoring MM estimtes

[out]=MMregeda(y,X);
fground = struct;
fground.Color={'r'};
fground.flabstep = '';
fground.fthresh=2.0;
resfwdplot(out, 'fground', fground, 'datatooltip','', 'corres', 1);

if prin==1
    % print to postscript
    print -depsc fatilr_MM_mon.eps;
else
    sgtitle('Figure A.56')
    set(gcf,"Name",'Figure A.56')
end


%InsideREADME