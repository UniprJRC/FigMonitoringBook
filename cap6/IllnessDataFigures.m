
%% illness x07
clearvars;close all;
load('illnessx07.txt');
y=illnessx07(:,4);
X=illnessx07(:,2:3);
[n,p]=size(X);
prin=0;


%% Compare LM and GLM predictions
close all
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
% refline

subplot(2,2,2)
la=0;
MLfit_GLM =  fitglm(X,y,'linear','Distribution','gamma','link',la);
ypredGLM=predict(MLfit_GLM,X,'Simultaneous',true);

plot(exp(ypredLM),ypredGLM,'o')
xlabel('LM predictions')
ylabel(['GLM predictions \lambda=' num2str(la)])
refline
if prin==1
    % print to postscript
  print -depsc figs\I3.eps;
end

