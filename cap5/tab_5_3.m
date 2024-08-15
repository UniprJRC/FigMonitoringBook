%% Theoretical size 
% This file creates theretical parts of Tables 5.2 and 5.3
%

%% Sample size
n=[50 100 200 2000];

%% THEORETICAL INDIVIDUAL  SIZE
p=2;

pro2=1000*(1-betacdf(   n*chi2inv(0.99,1)./(n-p).^2  ,0.5,(n-p-1)/2));
disp(pro2)

p=10;

pro10=1000*(1-betacdf(n*chi2inv(0.99,1)./(n-p).^2,0.5,(n-p-1)/2));
disp(pro10)

varn="n="+n;
rown=["p=2" "p=10"];
TAB52=array2table([pro2; pro10],"RowNames",rown,"VariableNames",varn);
disp('Theoretical individual size')
disp(TAB52)

%% THEORETICAL SIMULTANEOUS SIZE
p=2;
pstar=(betacdf(n.*chi2inv(1-0.01./n,1)./((n-p).^2),0.5,(n-p-1)/2));
pstar2=1000*(1-pstar.^n);
% disp(pstar2)

p=10;
pstar=(betacdf(n.*chi2inv(1-0.01./n,1)./((n-p).^2),0.5,(n-p-1)/2));
pstar10=1000*(1-pstar.^n);
%disp(pstar10)

TAB53=array2table([pro2; pro10],"RowNames",rown,"VariableNames",varn);
disp('Theoretical simultaneous size')
disp(TAB53)

%InsideREADME