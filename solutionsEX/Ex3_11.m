%% Equality of the truncated mean in a folded normal distribution
% to the MAD ina  standard normal distribution
c=sqrt(-2*log((2-sqrt(2*pi)*norminv(3/4))/2));

% Application of Equation (A.30)
Phi34chk=2*(normpdf(0)-normpdf(c));

% Phi^-1(3/4)
Phi34=norminv(0.75);

% Check that Phi34 is equal to Phi34chk
assert(abs(Phi34chk-Phi34)<eps,"Value of c wrong")
