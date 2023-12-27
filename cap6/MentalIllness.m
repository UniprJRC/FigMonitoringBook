%% Mental Illness data.
% This file creates Figure 6.7.

%% Beginning of code
clearvars;close all;
load('illnessx07.txt');
y=illnessx07(:,4);
X=illnessx07(:,2:3);
[n,p]=size(X);
prin=0;


%% Create Figure  
% Compare LM and GLM predictions
logy=log(y);
MLfit_LM = fitlm(X,logy);
ypredLM=predict(MLfit_LM,X,'Simultaneous',true);

subplot(2,2,1)
la=-1;
MLfit_GLM =  fitglm(X,y,'linear','Distribution','gamma','link',la);
ypredGLM=predict(MLfit_GLM,X,'Simultaneous',true);

plot(exp(ypredLM),ypredGLM,'o')
xlabel('LM predictions')
ylabel(['GLM predictions \lambda=' num2str(la)])

subplot(2,2,2)
la=0;
MLfit_GLM =  fitglm(X,y,'linear','Distribution','gamma','link',la);
ypredGLM=predict(MLfit_GLM,X,'Simultaneous',true);

plot(exp(ypredLM),ypredGLM,'o')
xlabel('LM predictions')
ylabel(['GLM predictions \lambda=' num2str(la)])
refline

sgtitle('Figure 6.7')
set(gcf,"Name",'Figure 6.7')

if prin==1
    % print to postscript
  print -depsc figs\I3.eps;
end

%InsideREADME   
