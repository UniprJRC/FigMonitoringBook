%% Confidence interval for transformation parameter lambda
% Create Figure A.17

prin=0;
%  Confidence interval for lambda
nr=2;
nc=1;
subplot(nr,nc,1)
load('wool.txt','wool');
y=wool(:,4);
X=wool(:,1:3);
% Plot the profile loglikelihood in the interval [-1 1]
laseq=-1:0.0001:1;
out=boxcoxR(y,X,'plots',1,'laseq',laseq);
title('')

% poison data
load('poison.txt');
y=poison(:,end); %#ok<SUSENS>
X=poison(:,1:6);
subplot(nr,nc,2)

% Plot the profile loglikelihood in the interval [-1 1]
laseq=-1.5:0.0001:0.5;
out=boxcoxR(y,X,'plots',1,'laseq',laseq,'intercept',0');
title('')
if prin==1
    print -depsc lambdaconfint.eps
end


sgtitle('Figure A.17')
set(gcf,"Name",'Figure A.17')

