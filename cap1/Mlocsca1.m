function outIRWLS = Mlocsca1(y,psifunc,initialmu,refsteps,reftol,initialscale)
%IRWLSregS (iterative reweighted least squares) does refsteps refining steps from initialbeta for S estimator
%
%  Required input arguments:
%
%    y:         A vector with n elements that contains the response variable.
%               It can be both a row or column vector.
%    X :        Data matrix of explanatory variables (also called 'regressors')
%               of dimension (n x p). Rows of X represent observations, and
%               columns represent variables.
% initialmu : p x 1 vector containing initial estimate of location
%     psifunc : a structure specifying the class of rho function to use, the
%               consistency factor, and the value associated with the
%               Expectation of rho in correspondence of the consistency
%               factor
%               psifunc must contain the following fields
%               c1 = consistency factor associated to required
%                    breakdown point
%               kc1= Expectation for rho associated with c1
%               class = string identyfing the rho (psi) function to use.
%                    Admissible values for class are 'bisquare', 'optimal'
%                    'hyperbolic' and 'hampel'
%               Remark: if class is 'hyperbolic' it is also necessary to
%                   specify parameters k (sup CVC), A, B and d
%               Remark: if class is 'hampel' it is also necessary to
%                   specify parameters a, b and c
%   refsteps  : scalar, number of refining (IRLS) steps
%   reftol    : relative convergence tolerance
%               Default value is 1e-7
%
%  Optional input arguments:
%
% initialscale: scalar, initial estimate of the scale. If not defined,
%               scaled MAD of residuals is used.
%
%  Output:
%
%  The output consists of a structure 'outIRWLS' containing the following fields:
%      betarw  : p x 1 vector. Estimate of beta after refsteps refining steps
%     scalerw  : scalar. Estimate of scale after refsteps refining step
%     weights  : n x 1 vector. Weights assigned to each observation
%
% In the IRWLS procedure the value of beta and the value of the scale are
% updated in each step

%% Beginning of code
c=psifunc.c1;
kc=psifunc.kc1;

if (nargin < 3)
    initialmu = median(y);
end

if nargin < 4
    refsteps = 100;
end

if nargin < 5
    reftol = 1e-07;
end

% Residuals for the initialbeta
res = y - initialmu;

% The scaled MAD of residuals is the initial scale estimate default value
if nargin < 6
    initialscale = median(abs(res))/.6745;
end


mu = initialmu;
scale = initialscale;
newmu =initialmu;


XXrho=strcat(psifunc.class,'rho');
hrho=str2func(XXrho);

XXwei=strcat(psifunc.class,'wei');
hwei=str2func(XXwei);

iter = 0;
betadiff = 9999;

% X=ones(length(y),1);

while ( (betadiff > reftol) && (iter < refsteps) )
    iter = iter + 1;


    % Solve for the scale
    meanrho=mean(feval(hrho,res/scale,c));
    oldscale=scale;
    scale = scale * sqrt(meanrho / kc );

    % Compute n x 1 vector of weights (using TB)
    weights = feval(hwei,res/scale,c);
    % weights = TBwei(res/scale,c);

    % sqweights = weights.^(1/2);

    % Xw = [X(:,1) .* sqweights X(:,2) .* sqweights ... X(:,end) .* sqweights]
    % Xw = bsxfun(@times, X, sqweights);
    % yw = y .* sqweights;

    % estimate of beta from (re)weighted regression (RWLS)
    % newbeta = Xw\yw;
    newmu=sum(y.*weights)/sum(weights);


    % betadiff is linked to the tolerance (specified in scalar reftol)
    betadiff = abs(mu - newmu) / abs(mu)+ abs(scale - oldscale) / abs(oldscale);

    % update residuals and beta
    res = y - newmu;
    mu = newmu;

end

% store final estimate of beta
outIRWLS.location = newmu;
% store final estimate of scale
outIRWLS.scale = scale;
% store final estimate of the weights for each observation
outIRWLS.weights=weights;

end