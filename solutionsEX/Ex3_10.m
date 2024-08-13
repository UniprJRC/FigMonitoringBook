%% First truncated moment in folded normal distribution.
%
% This file solves Exercise 3.10.


%% Beginning of code

% Check the simplification in equation A.30
c=2.5; b=1.2; 
m1=sqrt(2/pi)*(chi2cdf(c^2,2)-chi2cdf(b^2,2));

m1chk=2*(normpdf(b)-normpdf(c));

assert(abs(m1-m1chk)<eps,"Simplification not correct");

%InsideREADME 
