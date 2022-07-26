
%% Analysis of fanplot and score test for datasets Income1 and Income2

%% Data loading
clear
inc1=1;
if  inc1==true
    load Income1;
    y=Income1{:,"HTOTVAL"};
else
    load Income2;
    y=Income2{:,"Income"};
end
n=length(y);
X=ones(n,1);

%% Score test and fanplot
outSc=Score(y,X,'intercept',0,'la',([-1.5 -1 -0.5 0 0.5 1]));
disp(outSc.Score)

[outFSR]=FSRfan(y,X,'intercept',0,'msg',0,'nsamp',0);

[outFSR]=FSRfan(y,X,'intercept',0,'msg',0,'la',[-1 -0.5 0 0.5 1],'nsamp',0);
title('')

prin=0;
if prin==1
    % print to postscript
    print -depsc fanIncome1.eps;
       print -depsc fanIncome2.eps;
end

%% Compute statistics in the original and transformed scale
ysor=sort(y);


alpha=0.10;
m=floor((n-1)*alpha);
meanTri=mean(ysor(m+1:n-m));
mea=mean(y);
medi=median(y);
sta=std(y);
consfact=1/norminv(0.75);
madn=consfact*mad(y,1);

loc=[mea; meanTri; medi; sta; madn];


if  inc1==true
    load Income1;
    yori=Income1{:,"HTOTVAL"};
else
    load Income2;
    yori=Income2{:,"Income"};
end
laj=-1.5;
% ysc=yori/max(yori);
%   y=normBoxCox(ysc,1,laj,'Jacobian',true);
if laj==-1
    y=100000*(yori.^-1);
elseif laj==-1.5
    y=10000000*(yori.^-1.5);

end

n=length(y);
ysor=sort(y);
alpha=0.10;
m=floor((n-1)*alpha);
meanTri=mean(ysor(m+1:n-m));
mea=mean(y);
medi=median(y);
sta=std(y);
consdfact=1/norminv(0.75);
madn=consfact*mad(y,1);

loc1=[mea; meanTri; medi; sta; madn];

LOC=[loc loc1]

%
%     Xori=ones(n,1);
%     % FSRfan and fanplot with all default options
%     [outFSR]=FSRfan(yori,Xori,'intercept',0,'msg',0);
%     out=fanBIC(outFSR);

