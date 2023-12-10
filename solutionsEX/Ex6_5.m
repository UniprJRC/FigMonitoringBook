%% Exercise 6.5
%
% Score test and fan plot 1.
% This file creates Figures A.21-A.23 and Tables A.8-A.10.

%% D1 Data loading
XX=load('D1.txt');
X=XX(:,1:end-1);
y=XX(:,end);
n=length(y);
prin=0;

%% Create Figure A.21  
% D1 yXplot 
yXplot(y,X,'tag','pl_yini');
sgtitle('Figure A.21')
set(gcf,"Name",'Figure A.21')

if prin==1
    print -depsc figs\D1yX.eps
end

%% Create Table A.8
disp('Table A.8: ANOVA in the original scale for y')
outl=fitlm(X,y);
disp(outl)

%% Create Table A.9
% Score test
la=-1:0.25:1;
outS=ScoreYJ(y,X,'la',la);
varn=["lambda" "Score test"];
ScoreT=array2table([la' outS.Score],'VariableNames',varn);
disp("Table A.9")
disp(ScoreT)

%%  Create Figure A.22 (left panel)
% D1 fanplot just one lambda
la=[0 0.25 0.5 1];
ylimy='';
out=FSRfan(y,X,'la',la,'family','YJ','plots',1,'init',round(n/2),'ylimy',[-ylimy ylimy],'msg',0);
title('Figure A.22 (left panel)')
set(gcf,"Name",'Figure A.22 (left panel)')

if prin==1
    print -depsc figs\D1fan.eps
end
%%  Create Figure A.22 (right panel)
% D1 fanplotpn

la=[0 0.25 0.5 1];
ylimy='';
out=FSRfan(y,X,'la',la,'family','YJpn','plots',1,'init',round(n/2), ...
    'ylimy',[-ylimy ylimy],'msg',0,'tag','pl_scopn');
title('Figure A.22 (right panel)')
set(gcf,"Name",'Figure A.22 (right panel)')

if prin==1
    print -depsc figs\D1fanpn.eps
end
%% Create Figure A.23
% yXplot after transforming y  
labest=0.25;
ytra=normYJ(y,[],labest,'inverse',false);
yXplot(ytra,X)
sgtitle('Figure A.23')
set(gcf,"Name",'Figure A.23')

if prin==1
    print -depsc figs\D1ytraX.eps
end

%%  Create table A.10
% Anova table after transforming y  
disp('Table A.10: ANOVA in the transformed scale for y')
outTRA=fitlm(X,ytra);
disp(outTRA)

%% D1 automatic procedure
[outFSRfan]=FSRfan(y,X,'plots',0,'init',round(n*0.3),'nsamp',10000,'la',[0 0.25 0.5 0.75 1 1.25],'msg',0,'family','YJ');
[outini]=fanBIC(outFSRfan,'plots',0);
% labest is the best value imposing the constraint that positive and
% negative observations must have the same tramsformation parameter.
labest=outini.labest;
[outFSRfanpn]=FSRfan(y,X,'msg',0,'family','YJpn','la',labest,'plots',0);
out1=fanBICpn(outFSRfanpn,'plots',0);
disp('Best value of lambda from the automatic procedure')
disp(["laP" "laN"])
disp(out1.labestBIC);

%InsideREADME 