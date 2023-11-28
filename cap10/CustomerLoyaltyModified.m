%% This file is referred to dataset Customer Loyalty
% It creates Figures 10.37 ---- 10.46
% and Table 10.7

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

% Contaminate the data
ss=Xytable.Price==10 & Xytable.NegativePublicity<0.2;
kk=3;
y(ss)=y(ss)-kk;
Xytable{ss,end}= Xytable{ss,end}-kk;
prin=0;

%% Create Table 10.7 
% Standard regression with all variables
mdl=fitlm(Xytable);
disp('Table 10.7')
disp(mdl)

%% Create Figure 10.37
h1=subplot(2,2,1);
res=mdl.Residuals{:,3};
qqplotFS(res,'X',X,'plots',1,'h',h1);

subplot(2,2,2)
plotResiduals(mdl,'symmetry','ResidualType','studentized')
title('')

if prin==1
    % print to postscript
    print -depsc figs\modCL2.eps;
end
sgtitle('Figure 10.37')
set(gcf,"Name",'Figure 10.37')

drawnow

%% Figures 10.38 and 10.39
% These two Figures are created by file
% CustomerLoyaltyModifiedInteractive.m

%% Create Figure 10.40
[outLXS]=LXS(y,X,'nsamp',50000);
% Forward Search
[out]=FSReda(y,X,outLXS.bs);

resfwdplot(out,'datatooltip','')
if prin==1
    % print to postscript
    print -depsc figs\modCL5.eps;
end

title('Figure 10.40')
set(gcf,"Name",'Figure 10.40')
drawnow

%% Prepare input for Figure 10.41
% 51 outliers found
outFSR=FSR(y,X,'plots',0);

% FSRaddt in the model without the interactions
outADDt=FSRaddt(y,X,'plots',0);

%% Create Figure 10.41 
fanplotFS(outADDt,'highlight',outFSR.outliers,'tag','pl_fan1');
title('')
if prin==1
    % print to postscript
    print -depsc modCL6.eps;
end

title('Figure 10.41')
set(gcf,"Name",'Figure 10.41')

%% Prepare input for Figure 10.42

outFSRfan=FSRfan(y,X,'plots',0);
% Best automatic value of lambda is 0.5
outBIC=fanBIC(outFSRfan,'plots',0);

% Units highlighting in the different trajectories using fanBIC
Highl=NaN(1000,5);
la=[-1 -0.5 0 0.5 1];
seq=1:n;
for j=1:length(la)
    oultlj=seq(outBIC.BBla(:,j)<2);
    Highl(1:length(oultlj),j)=oultlj;
end

%% Create Figure 10.42 
% Fanplot with outliers highlighted

fanplotFS(outFSRfan,'highlight',Highl,'ylimy',[-8 35]);
title('')

if prin==1
    % print to postscript
    print -depsc figs\modCL7.eps;
end

title('Figure 10.42')
set(gcf,"Name",'Figure 10.42')



%% Non parametric transformation
outAV=avas(y,X);
aceplot(outAV,'VarNames',nameXy,'notitle',true);

if prin==1
    % print to postscript
    print -depsc modCL9.eps;
    print -depsc figs\modCL10.eps;
end
pl_ty=findobj(0, 'type', 'figure','tag','pl_ty');
figure(pl_ty(1))
sgtitle('Figure 10.43')
set(gcf,"Name",'Figure 10.43')

pl_tX=findobj(0, 'type', 'figure','tag','pl_tX');
figure(pl_tX(1))
sgtitle('Figure 10.44')
set(gcf,"Name",'Figure 10.44')
drawnow

% fitlm(outAV.tX,outAV.ty,'Exclude','','VarNames',nameXy)


%% Prepare the input for Figure 10.45 
% avas model selection with no constraint in X
disp('Note that automatic model selection in this case might more than one minute')
outMS=avasms(y,X,'plots',0);
% avasmsplot(outMS)

j=1;
outj=outMS{j,"Out"};
out=outj{:};
%% Create Figure 10.45
aceplot(out,'VarNames',nameXy,'notitle',true)

if prin==1
    % print to postscript
    print -depsc modCL11.eps;
end

pl_ty=findobj(0, 'type', 'figure','tag','pl_ty');
figure(pl_ty(1))
sgtitle('Figure 10.45')
set(gcf,"Name",'Figure 10.45')

pl_tX=findobj(0, 'type', 'figure','tag','pl_tX');
close(figure(pl_tX(1)))

%% Create Figure 10.46
% find F value
% fitlm(out.tX,out.ty,'Exclude',out.outliers,'VarNames',nameXy)

group=ones(length(y),1);
group(out.outliers)=2;
yXplot(out.ty,out.tX,'nameX',nameX,'group',group)
sgtitle('Figure 10.46')
set(gcf,"Name",'Figure 10.46')

%% Confirmation with FSR
outTRA=FSR(out.ty,out.tX);

if prin==1
    % print to postscript
    print -depsc modCL12.eps;
end




