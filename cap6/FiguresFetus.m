%% Data reading

XX=load('fetus.txt');
% week length
% Define X and y
X=XX(:,1);
% X=[X X.^2];
yori=XX(:,2);
y=yori;

prin=0;
% Comparison of the two fits (TABLE 2)
% Comparison with transform both sides
% In this case both lambda and the beta coefficients are estimated
% A linear link between X and beta is assumed
% close all
subplot(2,2,1)

y=yori;
out=tBothSides(y, X);

% Confidence interval
% close all
laest=out.betaout(end);
 % close all
 plot(X,y,'o')
hold('on')
% Use la =0
laest=0;
 % confquant=1.65; % 90 per cent conf int
 confquant=2.58; % 99 per cent conf int
 
yhattra=normBoxCox(out.yhat,1,laest,'Jacobian',false);
upConfInt= normBoxCox(yhattra+confquant*out.scale,1,laest,'inverse',true,'Jacobian',false);
lowConfInt= normBoxCox(yhattra-confquant*out.scale,1,laest,'inverse',true,'Jacobian',false);
[Xsor,indXsor]=sort(X);
% Plot the estimated median recruitment
plot(Xsor,out.yhat(indXsor),'k-')
% Plot the estimated 95th percentile of recruitment
plot(Xsor,upConfInt(indXsor),'k--')
% Plot the estimated 5th percentile of recruitment
plot(Xsor,lowConfInt(indXsor),'k--')
xlabel('Gestational age (weeks)')
ylabel('Mandible length (mm)')
xlimx=[11 34];
ylimy=[6 53];
xlim(xlimx)
ylim(ylimy)

% Fit in the original scale
subplot(2,2,2)
 Xwithq=[X X.^2];
xlimx=[11 34];
ylimy=[6 53];

MLfit_without = fitlm(Xwithq,log(yori));
[ypred,yci]=predict(MLfit_without,Xwithq,'Simultaneous',false,'Alpha',0.01,'Prediction','observation');
% close all
hold('on')
plot(Xwithq(:,1),yori,'o')
plot(Xwithq(:,1), exp(ypred),'k-')
plot(Xwithq(:,1), exp(yci),'k--')
xlabel('Gestational age (weeks)')
ylabel('Mandible length (mm)')
box('on')
xlim(xlimx)
ylim(ylimy)
% MLfit_without_notout = fitlm(X,yori,'Exclude',outFSR.outliers);
% 
% % Fit in the transformed scale after excluding the outliers
% MLfit_notout = fitlm(X,ytra,'Exclude',outFSR.outliers);
% 
% % Fit in the transformed scale with the outliers
% MLfit = fitlm(X,ytra)



if prin==1
    % print to postscript
    print -depsc figsBS\ML1.eps;
end
