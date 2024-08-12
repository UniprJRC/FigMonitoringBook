%% Customer Loyalty data
%
% This file creates Figures 10.22-10.36
% and Tables 10.5-10.6.
% Figures 10.22 and 10.24 are created in a non interactive way.
% In order to create them interactively, please use file
% CustomerLoyaltyInteractive.m



%% Data loading
close all
clear
load ConsLoyaltyRet.mat
Xytable=ConsLoyaltyRet(:,2:end);
nameXy=Xytable.Properties.VariableNames;
nameX=nameXy(1:end-1);
X=Xytable{:,1:end-1};
y=Xytable{:,end};
ytra=sqrt(y);
n=length(y);

%% Figure 10.22 yXplot (Created not interactively)
group=ones(n,1);
group([7:9 13 17 21 22 41])=2;
[H,AX,BigAx]=yXplot(Xytable(:,end),Xytable(:,1:end-1),'group',group);
add2yX(H,AX,BigAx,'labeladd','1')
drawnow
prin=0;
if prin==1
    % print to postscript
    print -depsc figs\regf1.eps;
else
    sgtitle('Figure 10.22')
    set(gcf,"Name",'Figure 10.22')
end




%% Standard regression with all variables
% Create Table 10.5
disp("Table 10.5")
mdl=fitlm(Xytable);
disp(mdl)



%% Create Figure 10.23: qqplots
figure
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
else
    sgtitle('Figure 10.23')
    fig=findobj(0,'tag','pl_resfwd');
end

drawnow

%% Create Figure 10.24 (NOT INTERACTIVE)
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
resfwdplot(outFS,'fground',fground,'tag','plfwdresini'); % ,'bground',bground)

if prin==1
    % print to postscript
    print -depsc figs\regf4.eps;
    print -depsc figs\regf5.eps;
else
    title('Figure 10.24')
    set(gcf,"Name",'Figure 10.24')

end

drawnow

%% Create Figure 10.25: monitoring six added variable t stats
%  Automatic outlier detection
% 28 outliers found
out=FSR(y,X,'plots',0);
disp('Number of outliers found')
disp(out.ListOut)

% FSRaddt in the model without the interactions
outADDt=FSRaddt(y,X,'plots',0);


fanplotFS(outADDt,'highlight',out.outliers,'ylimy',[-15 20],'tag','1025')
if prin==1
    % print to postscript
    print -depsc figs\regf6.eps;
else
    title('Figure 10.25')
    set(gcf,"Name",'Figure 10.25')
end
drawnow


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
drawnow

%% Table 10.6
% This table will be created later in the file



%% Create Figure 10.29
% Analysis in the sqrt scale
outsqrty=FSR(ytra,X);

pl_fsr=findobj(0, 'type', 'figure','tag','pl_fsr');
close(pl_fsr(end))
pl_yXplot=findobj(0, 'type', 'figure','tag','fsr_yXplot');
figure(pl_yXplot(end))

if prin==1
    % print to postscript
    print -depsc figs\transf4bis.eps;
else
    sgtitle('Figure 10.29')
    set(gcf,"Name",'Figure 10.29')
end


%% Create Figure 10.27
mdlysqrt=fitlm(X,ytra,'Exclude',outsqrty.ListOut,'VarNames',nameXy);

figure
% Analysis in sqrt scale qqplots
h1=subplot(2,1,1);
res=mdlysqrt.Residuals{:,3};
qqplotFS(res,'X',X,'plots',1,'h',h1);
% title('qqplot of stud. res.')
title('')
subplot(2,1,2)
plotResiduals(mdlysqrt,'symmetry','ResidualType','standardized')
title('')
if prin==1
    % print to postscript
    print -depsc figs\transf4.eps;
else
    sgtitle('Figure 10.27')
    set(gcf,"Name",'Figure 10.27')
end
drawnow


%% Create Figure 10.28
% Analysis in sqrt scale FS res
% LMS using 100000 subsamples
[outLXS]=LXS(ytra,X,'nsamp',100000,'lms',2);
% Forward Search
[out]=FSReda(ytra,X,outLXS.bs);

% Options for the trajectories in foreground
fground=struct;
fground.Color={'r'};
fground.LineWidth=2;
fground.funit=outsqrty.outliers;
fground.flabstep='';

resfwdplot(out,'fground',fground,'tag','pl_ysqrt');

if prin==1
    % print to postscript
    print -depsc figs\transf5.eps;
else
    title('Figure 10.28')
    set(gcf,"Name",'Figure 10.28')
end
drawnow



%% Create Figure 10.30 and 10.31
% Non parametric transformation
outAV=avas(y,X);
aceplot(outAV,'VarNames',nameXy,'notitle',true)
pl_ty=findobj(0, 'type', 'figure','tag','pl_ty');
figure(pl_ty(1))
if prin==1
    % print to postscript
    print -depsc figs\AV1.eps;
else
    sgtitle('Figure 10.30')
    set(gcf,"Name",'Figure 10.30')
end
drawnow

pl_tX=findobj(0, 'type', 'figure','tag','pl_tX');
figure(pl_tX(1))
if prin==1
    print -depsc figs\AV2.eps;
else
    sgtitle('Figure 10.31')
    set(gcf,"Name",'Figure 10.31')
end
drawnow

%% Create Table 10.5
mdlAVAS=fitlm(outAV.tX,outAV.ty,'Exclude','','VarNames',nameXy);
disp('Table 10.5')
disp(mdlAVAS)

%% Prepare input for Figures 10.32 and 10.33
% RAVAS model selection with no constraint in X
disp('Note that automatic model selection in this case might take some minutes')
outMS=avasms(y,X,'plots',0);
% outrobAV=avas(y,X,'orderR2',true,'rob',true,'scail',true)


%% Create Figures 10.32 and 10.33
% avasmsplot(outMS)

j=1;
outj=outMS{j,"Out"};
outrobAV=outj{:};
aceplot(outrobAV,'VarNames',nameX,'notitle',true)

pl_ty=findobj(0, 'type', 'figure','tag','pl_ty');
figure(pl_ty(1))
if prin==1
    % print to postscript
    print -depsc figs\AV3.eps;
else
    sgtitle('Figure 10.32')
    set(gcf,"Name",'Figure 10.32')
end

pl_tX=findobj(0, 'type', 'figure','tag','pl_tX');
figure(pl_tX(1))
if prin==1
    % print to postscript
    print -depsc figs\AV4.eps;
else
    sgtitle('Figure 10.33')
    set(gcf,"Name",'Figure 10.33')
end

%%
% outlierfromFSR=false;
% if outlierfromFSR==true
%     outfromRAVAS=outsqrty.outliers;
% else
outfromRAVAS=outrobAV.outliers;
% end

%% Create Table 10.6
% mdl  = fit in original scale (all the observations)
% mdlysqrt = fit in the sqrt scale (after deleting the outliers)
% mdlAVAS = fit based on AVAS
% mdlRAVAS = fit based on best model after excluding the outliers
% find F value

mdlRAVAS=fitlm(outrobAV.tX,outrobAV.ty,'Exclude',outfromRAVAS,'VarNames',nameXy);

Original=[mdl.Coefficients{:,'tStat'}; mdl.NumObservations; mdl.Rsquared.Adjusted];
Square_root=[mdlysqrt.Coefficients{:,'tStat'}; mdlysqrt.NumObservations; mdlysqrt.Rsquared.Adjusted];
Avas=[mdlAVAS.Coefficients{:,'tStat'}; mdlAVAS.NumObservations; mdlAVAS.Rsquared.Adjusted];
Ravas=[mdlRAVAS.Coefficients{:,'tStat'}; mdlRAVAS.NumObservations; mdlRAVAS.Rsquared.Adjusted];
TBL=table(Original,Square_root,Avas,Ravas);

disp('Table 10.6')
varn=["Original" "Square-root" "AVAS" "RAVAS"];
rown=[string(mdl.CoefficientNames)'; "Observations m*"; "Adjusted R2"];
TBL.Properties.RowNames=rown;
TBL.Properties.VariableNames=varn;
disp(TBL)

%% Create Figure 10.34
figure
goodFromRAVAS=setdiff(1:n,outfromRAVAS);
Xg=X(goodFromRAVAS,:);

resg=mdlRAVAS.Residuals{goodFromRAVAS,3};
h1=subplot(2,1,1);
qqplotFS(resg,'X',Xg,'plots',1,'h',h1,'conflev',0.95);
title('qqplot of stud. res.')
title('')
subplot(2,1,2)
plotResiduals(mdlRAVAS,'symmetry')
title('')

if prin==1
    % print to postscript
    print -depsc figs\AV6.eps;
else
    sgtitle('Figure 10.34')
    set(gcf,"Name",'Figure 10.34')
end

drawnow

%% Create Figure 10.35
figure
subplot(2,2,1)
histfit(mdlRAVAS.Residuals{:,j},[])

subplot(2,2,2)
histfit(mdlRAVAS.Residuals{:,j},[],'kernel')

if prin==1
    % print to postscript
    print -depsc figs\AV5.eps;
else
    sgtitle('Figure 10.35')
    set(gcf,"Name",'Figure 10.35')
end


drawnow


%% Prepare input for Figure 10.36
outFinal=FSR(outrobAV.ty,outrobAV.tX,'plots',0);
% LMS using 100000 subsamples
[outLXSav]=LXS(outrobAV.ty,outrobAV.tX,'nsamp',10000,'lms',2);
% Forward Search
[outFS]=FSReda(outrobAV.ty,outrobAV.tX,outLXSav.bs);

%% Create Figure 10.36
% Options for the trajectories in foreground
fground=struct;
fground.Color={'r'};
fground.LineWidth=2;
fground.funit=outFinal.outliers;
fground.flabstep='';
% Options for the trajectories in background
bgroud=struct;
bground.bthresh=4;
bground.bstyle='greysh';

resfwdplot(outFS,'fground',fground,'datatooltip','') % ,'bground',bground);

if prin==1
    % print to postscript
    print -depsc AV8.eps;
else
    title('Figure 10.36')
    set(gcf,"Name",'Figure 10.36')
end



%InsideREADME