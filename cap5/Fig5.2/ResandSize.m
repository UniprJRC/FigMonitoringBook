function [res,sizeind,sizesim,medres2]=ResandSize(y,X,b,sigma2,thresh,threshBonf)
% ResandSize computes individual and simulatenous size given b and sigma2
%
%
%
% Required input arguments:
%
%   y:          A vector with n elements that contains the response variables.
%   X :         Data matrix of explanatory variables (also called 'regressors')
%               of dimension (n x p) including intercept. Rows of X
%               represent observations, and columns represent variables.
%   sigma2 :    scalar. Estimate or true value of sigma in the regression
%   thresh :    scalar. Threshold for chi2_1 with individual size
%   threshBonf :scalar. Threshold for chi2_1 with simultaneous size
%
% Output:
%
%      res :    column vector of size n containing scaled residuals
%  sizeind :    scalar. Individual size
% sizesim  :    scalar. Simultaneous size
% medres2  :    scalar. Median of scaled squared residuals

%% Beginning of code

n=length(y);
res=y-X*b;
res2=res.^2;

reschi2=res2/sigma2;


% sizeind = indidividual size for simulation j
sizeind=sum(reschi2>thresh)/n;
% sizesim = simultaneous size for simulation j
if sum(reschi2>threshBonf)>0
    sizesim=1;
else
    sizesim =0;
end

%medres2 = median of squared scaled residuals
medres2=median(reschi2);
end
