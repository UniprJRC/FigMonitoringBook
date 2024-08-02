function prover=prover(b,mud,Sigmaout,alpha,sigmay,varargin)

if nargin<6
    kk=2;
end


mu_z1=b'*mud-alpha;
%mu_z1=0;
sigma2_z1=b'*Sigmaout*b;


c=alpha+kk*sigmay;
% Compute d_\mu
d=(c-b'*mud)/(b'*b);


c1=alpha-kk*sigmay;
% Compute d_\mu
d1=(c1-b'*mud)/(b'*b);

% Compute the probability in a univariate normal distribution with mean
% mu_z1 and variance sigma2_z1 to obtain values between d1 and d
% pr_over = probability of overlapping;

prover= ( normcdf(d,mu_z1,sqrt(sigma2_z1))- ...
    normcdf(d1,mu_z1,sqrt(sigma2_z1))); % .*(d<=0));

end
