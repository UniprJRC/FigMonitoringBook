%% Exercise 6.7
%
% Score test and fan plot 3.
%
% This file creates Figures A.30-A.34 and Tables A.14-A.16

%% D3 Data loading
XX=load('D3.txt');
X=XX(:,1:end-1);
y=XX(:,end);
n=length(y);
prin=0;

%% Create Figure A.30
% D2 yXplot
yXplot(y,X,'tag','pl_yini');
sgtitle('Figure A.30')
set(gcf,"Name",'Figure A.30')

if prin==1
    print -depsc figs\D3yX.eps
end

%% Create Table A.14
disp('Table A.14: ANOVA in the original scale for y')
outl=fitlm(X,y);
disp(outl)

%% Create Table A.15
% Score test
la=-1:0.25:1;
outS=ScoreYJ(y,X,'la',la);
varn=["lambda" "Score test"];
ScoreT=array2table([la' outS.Score],'VariableNames',varn);
disp("Table A.15")
disp(ScoreT)

%%  Create Figure A.31 (left panel)
% D3 fanplot just one lambda
la=[0 0.25 0.5 1];
ylimy='';
out=FSRfan(y,X,'la',la,'family','YJ','plots',1,'init',round(n/2),'ylimy',[-ylimy ylimy],'msg',0);

title('Figure A.31 (left panel)')
set(gcf,"Name",'Figure A.31 (left panel)')

if prin==1
    print -depsc figs\D3fan.eps
end
%%  Create Figure A.31 (right panel)
% D3 fanplotpn
la=[0 0.25 0.5 1];
ylimy='';
out=FSRfan(y,X,'la',la,'family','YJpn','plots',1,'init',round(n/2), ...
    'ylimy',[-ylimy ylimy],'msg',0,'tag','pl_scopn');
title('Figure A.31 (right panel)')
set(gcf,"Name",'Figure A.31 (right panel)')

if prin==1
    print -depsc figs\D3fanpn.eps
end

%% Create Figure A.32 and A.33
% automatic procedure

n=length(y);
[outFSRfan]=FSRfan(y,X,'plots',0,'init',round(n*0.3),'nsamp',10000,'la',[0 0.25 0.5 0.75 1 1.25],'msg',0,'family','YJ');
[outini]=fanBIC(outFSRfan,'plots',1);
if prin==1
    % print to postscript
    print -depsc figs\D3auto.eps;
end
% labest is the best value imposing the constraint that positive and
% negative observations must have the same transformation parameter.
disp('Automatic value of lambda (just on lambda)')
labest=outini.labest;
disp(labest);

[outFSRfanpn]=FSRfan(y,X,'msg',0,'family','YJpn','la',labest,'plots',0);
out1=fanBICpn(outFSRfanpn);

fig=findobj(0,'tag','pl_BIC');
figure(fig(1))
set(gcf,'Name', 'Figure A.32 (left panel)');

fig=findobj(0,'tag','pl_AGI');
figure(fig(1))
set(gcf,'Name', 'Figure A.32 (right panel)');

fig=findobj(0,'tag','pl_nobs');
figure(fig(1))
set(gcf,'Name', 'Figure A.33 (left panel)');

fig=findobj(0,'tag','pl_R2c');
figure(fig(1))
set(gcf,'Name', 'Figure A.33 (right panel)');

if prin==1
    % print to postscript
    print -depsc figs\D3autopnh.eps;
    print -depsc figs\D3autopnBIC.eps;
    print -depsc figs\D3autopnAGI.eps;
    print -depsc figs\D3autopnR2.eps;
    
end

%% Prepare input for Figure A.34
% yXplot after transforming y  
% lapos=0.5;
% laneg=0;

lapos=out1.labestBIC(1);
laneg=out1.labestBIC(2);
ytra=y;
ytra(y>=0)=normYJ(y(y>=0),[],lapos,'Jacobian',false,'inverse',false);
ytra(y<0)=normYJ(y(y<0),[],laneg,'Jacobian',false,'inverse',false);
ylimy=8;

% FSR on ytra
outf=FSR(ytra,X,'init',n/2,'plots',0);
if isnan(outf.outliers)
    outf.outliers=[];
end

%% Create Figure A.34
% yXplot after transforming y
group=ones(n,1);
group(outf.outliers)=2;
yXplot(ytra,X,'group',group);
sgtitle('Figure A.34')
set(gcf,"Name",'Figure A.34')

if prin==1
    print -depsc figs\D3ytraX.eps
end


%% Create Table A.16
 % D3 anova table after transforming y  
% D2 anova table after transforming y
disp('Table A.16: ANOVA in the transformed scale for y')
outTRA=fitlm(X,ytra);
disp(outTRA)

%InsideREADME 