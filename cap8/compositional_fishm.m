%% Fish Morphology data.
% This file creates Figures  8.36-8.39

%% Beginning of code
prin=0;

load FishMorphology.mat

% Select the rows whose Habitat is 1
boo=FishMorphology.Habitat==1;
FishMorphology=FishMorphology(boo,:);
% Extract the 10 variables mentioned in the book
namX=["Bg", "Bd", "Bcw", "Jw", "Jl", "Bp", "Bac", "Bch", "Fc","Fdw"];
namy="Mass";
y=FishMorphology{:,namy};
Xori=FishMorphology(:,namX);
% Apply the ilr transformation
X=pivotCoord(Xori{:,:});


conflev=[0.95 0.99];


%% Create Figure 8.36
% S estimators with 2 values of bdp

% Note that the pattern of residuals changes completely
% Using bdp=0.25 two units are declared as outliers
% Using bdp 17 units are declared as outliers.
figure;
h1=subplot(2,1,1);
bdp=0.25;
[out]=Sreg(y,X,'nsamp',3000,'bdp',bdp);
resindexplot(out,'h',h1,'conflev',conflev);
ylabel(['Breakdown point =' num2str(bdp)])
title('')
h2=subplot(2,1,2);
bdp=0.5;
[out]=Sreg(y,X,'nsamp',3000,'bdp',bdp);
resindexplot(out,'h',h2,'conflev',conflev,'numlab',{17});
ylabel(['Breakdown point =' num2str(bdp)])
title('')
cascade;
if prin==1
    % print to postscript
    print -depsc fishmilr_S.eps;
else
    sgtitle('Figure 8.36')
    set(gcf,"Name",'Figure 8.36')
end

drawnow

%% Create Figure 8.37
% MM estimators with 2 values of efficiency
% MMreg using two different level of efficiency
% Note that the pattern of residuals changes completely
% Using eff=0.90 the outliers are correctly found, on the other hand using
% eff=0.95 the masking effect is clear
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
    print -depsc fishmilr_MM.eps;
else
    sgtitle('Figure 8.37')
    set(gcf,"Name",'Figure 8.37')
end

drawnow

%% Create Figure  8.38
% Monitoring S estimates

[out]=Sregeda(y,X,'msg',0);
fground = struct;
fground.Color={'r'};
fground.flabstep = '';
fground.fthresh=2.0;
resfwdplot(out, 'fground', fground, 'datatooltip','', 'corres', 1,'tag','pl_Sres');
ylabel('Scaled S residuals');
xlabel('bdp');

if prin==1
    % print to postscript
    print -depsc fishmilr_S_mon.eps;
else
    sgtitle('Figure 8.38')
    set(gcf,"Name",'Figure 8.38')
end
drawnow

%% Create Figure 8.39
% Monitoring MM estimtes
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
    print -depsc fishmilr_MM_mon.eps;
else
    sgtitle('Figure 8.39')
    set(gcf,"Name",'Figure 8.39')
end


%InsideREADME