%% This file is referred to dataset Customer Loyalty
% It creates Figures 10.22 ---- 10.36
% and Tables 10.5 ----- 10.7
% Figures 10.22 and 10.24 are created in a non interactive way.
% In order to create them interactively, please use file
% CustomerLoyaltyInteractive.m



%% Data loading

load ConsLoyaltyRet.mat
Xytable=ConsLoyaltyRet(:,2:end);
nameXy=Xytable.Properties.VariableNames;
nameX=nameXy(1:end-1);
X=Xytable{:,1:end-1};
y=Xytable{:,end};
n=length(y);

%% yXplot (Created not interactively)
group=ones(n,1);
group([7:9 13 17 21 22 41])=2;
[H,AX,BigAx]=yXplot(Xytable(:,end),Xytable(:,1:end-1),'group',group);
add2yX(H,AX,BigAx,'labeladd','1')
prin=0;
if prin==1
    % print to postscript
    print -depsc figs\regf1.eps;
end
sgtitle('Figure 10.22')
set(gcf,"Name",'Figure 10.22')




%% Standard regression with all variables
% Create Table 10.5
disp("Table 10.5")
mdl=fitlm(Xytable);
disp(mdl)



%% Create Figure 10.23: qqplots
h1=subplot(2,1,1);
res=mdl.Residuals{:,3};
qqplotFS(res,'X',X,'plots',1,'h',h1,'conflev',0.95);
% title('qqplot of stud. res.')
title('')
subplot(2,1,2)
plotResiduals(mdl,'symmetry')
title('')
if prin==1
    % print to postscript
    print -depsc figs\regf3.eps;
end

sgtitle('Figure 10.23')
fig=findobj(0,'tag','pl_resfwd');


%% Create Figure 10.26 (NOT INTERACTIVE)
% In order to create it interactively see file CustomerLoyaltyInteractive.m

% LMS using 1000 subsamples
%{
[out]=LXS(y,X,'nsamp',500000,'lms',2);
%}
% Forward Search
out.bs=[1471  625 692 64 1456 688 1112];
[outFS]=FSReda(y,X,out.bs);
% Create scaled squared residuals
fground=struct;
fground.funit=[7:9 13 17 21 22 41];
fground.Color={'r'};
fground.LineWidth=2;
resfwdplot(outFS,'fground',fground); % ,'bground',bground)

if prin==1
    % print to postscript
    print -depsc figs\regf4.eps;
    print -depsc figs\regf5.eps;
end

%% Interactive part
databrush=struct;
databrush.Label='on'; % Write labels of trajectories while selecting
databrush.RemoveLabels='off'; % Do not remove labels after selection
databrush.selectionmode='Rect'; % Rectangular selection
databrush.labeladd='1';
resfwdplot(outFS,'databrush',databrush,'datatooltip',0)


%% Create Figure 10.25
%  Automatic outlier detection
% 28 outliers found
out=FSR(y,X,'plots',0);
disp('Number of outliers found')
disp(out.ListOut)

% FSRaddt in the model without the interactions
outADDt=FSRaddt(y,X,'plots',0);


fanplotFS(outADDt,'highlight',out.outliers,'ylimy',[-15 20])
title('Figure 10.25')
set(gcf,"Name",'Figure 10.25')

if prin==1
    % print to postscript
    print -depsc figs\regf6.eps;
end


%%  Create Figure 10.26 
% Not clear what is the best transformation
outFSRfan=FSRfan(y,X);
fanplotFS(outFSRfan,'highlight',out.outliers, ...
    'xlimx',[30 n+100],'ylimy',[-8 35]);

if prin==1
    % print to postscript
    print -depsc figs\transff1.eps;
end
title('Figure 10.26')
set(gcf,"Name",'Figure 10.26')

%% Table 10.6
% This table will be created later in the file


%% Units highlighting in the different trajectories using fanBIC
Highl=NaN(1000,5);
la=[-1 -0.5 0 0.5 1];
seq=1:n;
for j=1:length(la)

    oultlj=seq(outBIC.BBla(:,j)<2);
    Highl(1:length(oultlj),j)=oultlj;
end

close all
fanplot(outFSRfan,'highlight',Highl,'ylimy',[-8 35])
title('')

if prin==1
    % print to postscript
    print -depsc figs\transf1.eps;
end


%% Units highlighting in the different trajectories using FSR
Highl=NaN(1000,5);
la=[-1 -0.5 0 0.5 1];

for j=1:length(la)
    if abs(la(j))>1e-06
        outlaj=FSR(y.^la(j),X,'init',round(n/2));
    else
        outlaj=FSR(log(y),X,'init',round(n/2));
    end
    oultlj=outlaj.outliers;
    Highl(1:length(oultlj),j)=oultlj;
end

close all
fanplot(outFSRfan,'highlight',Highl,'ylimy',[-8 35])
title('')

if prin==1
    % print to postscript
    print -depsc figs\transf1.eps;
end


%%  Analysis in the sqrt scale
outsqrty=FSR(sqrt(y),X);

if prin==1
    % print to postscript
    print -depsc figs\transf4bis.eps;
end
fitlm(X,sqrt(y),'Exclude',outsqrty.ListOut,'VarNames',nameXy)

%%  Analysis in the sqrt scale fitlm excluding outliers
% Many untis are declared as outliers
mdl=fitlm(X,sqrt(y),'Exclude',outsqrty.outliers,'VarNames',nameXy);


%% Analysis in sqrt scale: Plot residuals
close all
subplot(2,2,1)
histfit(mdl.Residuals{:,3},[],'kernel')
subplot(2,2,2)
plotResiduals(mdl,'fitted','ResidualType','standardized')

if prin==1
    % print to postscript
    print -depsc figs\transf3.eps;
end


%% Analysis in sqrt scale qqplots
close all
h1=subplot(2,1,1);
res=mdl.Residuals{:,3};
qqplotFS(res,'X',X,'plots',1,'h',h1);
% title('qqplot of stud. res.')
title('')
subplot(2,1,2)
plotResiduals(mdl,'symmetry','ResidualType','standardized')
title('')
if prin==1
    % print to postscript
    print -depsc figs\transf4.eps;
end


%% Analysis in sqrt scale FS res
% LMS using 100000 subsamples
[outLXS]=LXS(sqrt(y),X,'nsamp',100000,'lms',2);
% Forward Search
[out]=FSReda(sqrt(y),X,outLXS.bs);

standard=struct;
standard.Color={'g'};
standard.LineWidth=1;
standard.SizeAxesNum=9;
standard.SizeAxesLab=10;

% Options for the trajectories in foreground
fground=struct;
fground.Color={'r'};
fground.LineWidth=2;
fground.funit=outsqrty.outliers;
fground.flabstep='';
% Options for the trajectories in background
bgroud=struct;
bground.bthresh=4;
bground.bstyle='greysh';

% resfwdplot(out,'standard',standard,'fground',fground) % ,'bground',bground);

resfwdplot(out,'fground',fground) % ,'bground',bground);

if prin==1
    % print to postscript
    print -depsc figs\transf5.eps;
end

%% Non parametric transformation
outAV=avas(y,X);
aceplot(outAV,'VarNames',nameXy,'notitle',true)

if prin==1
    % print to postscript
    print -depsc figs\AV1.eps;
    print -depsc figs\AV2.eps;
end


fitlm(outAV.tX,outAV.ty,'Exclude','','VarNames',nameXy)

%% RAVAS model selection with no constraint in X
outMS=avasms(y,X)
outrobAV=avas(y,X,'orderR2',true,'rob',true,'scail',true)
%% Stabilità dopo arrotondamento
rng(100)
ndec=20;
y1=round(y,ndec);
X1=round(X,ndec);
outrobAV=avas(y1,X1,'orderR2',true,'rob',true,'scail',true)
length(outrobAV.outliers)
aceplot(outrobAV)
%%
avasmsplot(outMS)

j=1;
outj=outMS{j,"Out"};
outrobAV=outj{:};
aceplot(outrobAV,'VarNames',nameX,'notitle',true)

if prin==1
    % print to postscript
    print -depsc figs\AV3.eps;
    print -depsc figs\AV4.eps;
end

%%
outlierfromFSR=true;
if outlierfromFSR==true
    outfrom=outTRA.outliers;
else
    outfrom=outrobAV.outliers;
end

% find F value
mdlrobAV=fitlm(outrobAV.tX,outrobAV.ty,'Exclude',outfrom,'VarNames',nameXy)

group=ones(length(y),1);
group(outfrom)=2;
yXplot(outrobAV.ty,outrobAV.tX,'nameX',nameX,'group',group)


%% robAVAS scale: plot residuals
close all
j=3;
subplot(2,2,1)
histfit(mdlrobAV.Residuals{:,j},[])

subplot(2,2,2)
histfit(mdlrobAV.Residuals{:,j},[],'kernel')
% plotResiduals(mdlrobAV,'fitted')

if prin==1
    % print to postscript
    print -depsc figs\AV5.eps;
end


%% robAVAS scale f4 qqplots

good=setdiff(1:n,outfrom);
Xg=X(good,:);

resg=mdlrobAV.Residuals{good,3};
close all
h1=subplot(2,1,1);
qqplotFS(resg,'X',Xg,'plots',1,'h',h1,'conflev',0.95);
title('qqplot of stud. res.')
title('')
subplot(2,1,2)
plotResiduals(mdlrobAV,'symmetry')
title('')
if prin==1
    % print to postscript
    print -depsc figs\AV6.eps;
end


%% FS final plots
% LMS using 100000 subsamples
[outLXSav]=LXS(outrobAV.ty,outrobAV.tX,'nsamp',100000,'lms',2);
% Forward Search
[outFS]=FSReda(outrobAV.ty,outrobAV.tX,outLXSav.bs);

% standard=struct;
% standard.Color={'g'};
% standard.LineWidth=1;
% standard.SizeAxesNum=9;
% standard.SizeAxesLab=10;

% Options for the trajectories in foreground
fground=struct;
fground.Color={'r'};
fground.LineWidth=2;
fground.funit=outsqrty.outliers;
fground.flabstep='';
% Options for the trajectories in background
bgroud=struct;
bground.bthresh=4;
bground.bstyle='greysh';

% resfwdplot(out,'standard',standard,'fground',fground) % ,'bground',bground);

resfwdplot(outFS,'fground',fground,'datatooltip','') % ,'bground',bground);

if prin==1
    % print to postscript
    print -depsc AV8.eps;
end


% stepwise su outrobAV
stepwiselm(outrobAV.tX,outrobAV.ty,'VarNames',nameXy,'Exclude',outrobAV.outliers)

%% Confirmation with FSR
outTRA=FSR(outrobAV.ty,outrobAV.tX,'nameX',nameX);

% Options for the trajectories in foreground
fground=struct;
fground.Color={'r'};
fground.LineWidth=2;
fground.funit=outTRA.outliers;
fground.flabstep='';
% Options for the trajectories in background
bgroud=struct;
bground.bthresh=4;
bground.bstyle='greysh';

% resfwdplot(out,'standard',standard,'fground',fground) % ,'bground',bground);

resfwdplot(outFS,'fground',fground) % ,'bground',bground);

