%% This file is referred to dataset Income2
% Univariate analysis of the response for dataset Income2 
% It creates Figure 1.6
% and Tables 1.3, 1.4 

%% Data loading
clear
close all
load Income2;
y=Income2{:,"Income"};
X=Income2{:,1:end-1};

% y and X in table format
yt=Income2(:,end);
Xt=Income2(:,1:end-1);
Xytable=Income2;

n=length(y);
one=ones(n,1);
% prin = 
prin=0;

%% Analysis of the score test
% Table 1.3
la=[-2  -1.5 -1 -0.5 0 1];
out=Score(y,one, 'la',la);
disp([la' out.Score])

Score=out.Score;
rownam=["-2" "-1.5" "Inverse" "Reciprocal square root" "Logarithmic" "None"];
colnam=["lambda" "Score test"];

ScoreT=array2table([la' Score],"RowNames",rownam,"VariableNames",colnam);
format bank
disp('Table 1.3')
disp(ScoreT)

%% Compute statistics in the original and transformed scale
% Table 1.4 with lambda=1, lambda=-1 or lambda=-1.5

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
yori=y;


laj=-1;
y1=100000*(yori.^laj);

ysor=sort(y1);
alpha=0.10;
m=floor((n-1)*alpha);
meanTri1=mean(ysor(m+1:n-m));
mea1=mean(y1);
medi1=median(y1);
sta1=std(y1);
madn1=consfact*mad(y1,1);

loc1=[mea1; meanTri1; medi1; sta1; madn1];


laj=-1.5;
y1=10000000*(yori.^laj);
ysor=sort(y1);
meanTri1=mean(ysor(m+1:n-m));
mea1=mean(y1);
medi1=median(y1);
sta1=std(y1);
madn1=consfact*mad(y1,1);

loc2=[mea1; meanTri1; medi1; sta1; madn1];

LOC=[loc loc1 loc2];

rn=["Mean" "Trimmed mean" "Median" "Standard Deviation" "MADN"];
vn=["Original data" "Inverse transf" "la=-1.5"];
LOCt=array2table(LOC,'RowNames',rn,'VariableNames',vn);
format bank
disp(LOCt)


%% Create Figure 1.6 fanplot
% Fanplot using just the intercept
outFSRfanUNI=FSRfan(y,one,'intercept',0,'la',[-2 -1.5 -1 -0.5],'tag','fanplotnoExpl');
title('Figure 1.6')
if prin==1
    % print to postscript
    print -depsc fanIncome2.eps;
end







