%% Score test and fan plot 2.
%
% This file creates Figures A.24-A.29 and Tables A.11-A.14

%% D2 Data loading
XX=load('D2.txt');
X=XX(:,1:end-1);
y=XX(:,end);
n=length(y);
prin=0;

%% Create Figure A.24
% D2 yXplot
yXplot(y,X,'tag','pl_yini');

if prin==1
    legend off
    print -depsc D2yX.eps
else
    sgtitle('Figure A.24')
    set(gcf,"Name",'Figure A.24')
end

%% Create Table A.11
disp('Table A.11: ANOVA in the original scale for y')
outl=fitlm(X,y);
disp(outl)

%% Create Table A.12
% Score test
la=-1:0.25:1;
outS=ScoreYJ(y,X,'la',la);
varn=["lambda" "Score test"];
ScoreT=array2table([la' outS.Score],'VariableNames',varn);
disp("Table A.12")
disp(ScoreT)

%%  Create Figure A.25 (left panel)
% D2 fanplot just one lambda
la=[0 0.25 0.5 1];
ylimy='';
out=FSRfan(y,X,'la',la,'family','YJ','plots',1,'init',round(n/2), 'ylimy',[-ylimy ylimy],'msg',0);

if prin==1
    print -depsc figs\D2fan.eps
else
    title('Figure A.25 (left panel)')
    set(gcf,"Name",'Figure A.25 (left panel)')

end

%%  Create Figure A.25 (right panel)
% D2 fanplotpn
la=[0 0.25 0.5 1];
ylimy='';
out=FSRfan(y,X,'la',la,'family','YJpn','plots',1,'init',round(n/2), ...
    'ylimy',[-ylimy ylimy],'msg',0,'tag','pl_scopn');

if prin==1
    print -depsc D2fanpn.eps
else
    title('Figure A.25 (right panel)')
    set(gcf,"Name",'Figure A.25 (right panel)')
end

%% Create Figure A.26
% automatic procedure
[outFSRfan]=FSRfan(y,X,'plots',0,'init',round(n*0.3),'nsamp',10000,'la',-1:0.25:1,'msg',0,'family','YJ');
[outini]=fanBIC(outFSRfan,'plots',1);

% labest is the best value imposing the constraint that positive and
% negative observations must have the same transformation parameter.
disp('Automatic value of lambda (just on lambda)')
labest=outini.labest;
disp(labest);

if prin==1
    % print to postscript
    print -depsc D2auto.eps;
else
    sgtitle('Figure A.26')
    set(gcf,"Name",'Figure A.26')
end

%% Prepare input for Figure A.27
labest=0.25;
ytra=normYJ(y,[],labest,'inverse',false);
% FSR on ytra
outf=FSR(ytra,X,'plots',0,'init',n/2);


%% Create Figure A.27
% yXplot after transforming y
group=ones(n,1);
group(outf.outliers)=2;
yXplot(ytra,X,'group',group);


if prin==1
    print -depsc D2ytraX.eps
else
    sgtitle('Figure A.27')
    set(gcf,"Name",'Figure A.27')
end


%% Create Table A.13
% D2 anova table after transforming y
disp('Table A.13: ANOVA in the transformed scale for y (after removing the outliers)')
outTRA=fitlm(X,ytra,'Exclude',outf.outliers);
disp(outTRA)

%% Create Figures A.28 and A.29
% heatmaps
[outFSRfanpn]=FSRfan(y,X,'msg',0,'family','YJpn','la',labest,'plots',0);
out1=fanBICpn(outFSRfanpn);

fig=findobj(0,'tag','pl_BIC');
figure(fig(1))
if prin==1
    % print to postscript
    print -depsc D2autopnBIC.eps;
else
    sgtitle('Figure A.28 (left panel)')
    set(gcf,'Name', 'Figure A.28 (left panel)');
end

fig=findobj(0,'tag','pl_AGI');
figure(fig(1))

if prin==1
    % print to postscript
    print -depsc D2autopnh.eps;
else
    sgtitle('Figure A.28 (right panel)')
    set(gcf,'Name', 'Figure A.28 (right panel)');
end


fig=findobj(0,'tag','pl_nobs');
figure(fig(1))
if prin==1
    % print to postscript
    print -depsc D2autopnh.eps;
else
    sgtitle('Figure A.29 (left panel)')
    set(gcf,'Name', 'Figure A.29 (left panel)');
end

fig=findobj(0,'tag','pl_R2c');
figure(fig(1))

if prin==1
    print -depsc D2autopnR2.eps;
else
    sgtitle('Figure A.29 (right panel)')
    set(gcf,'Name', 'Figure A.29 (right panel)');
end

%InsideREADME