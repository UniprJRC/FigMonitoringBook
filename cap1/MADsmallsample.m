%% Analysis of consistency factor (small sample and asymptotic for MAD)
% This file creates  fig1:simMAD

%% Take n observations from N(0,1) and compute the MAD
% Repeat the experiment nsimul times and compute the average of the MADs
nsimul=1000000;
n=5;
MAD=zeros(nsimul,1);
for j=1:nsimul
    x=randn(n,1);
    MAD(j)=mad(x,1);
end
Mea=mean(MAD);
disp(Mea)

%% Repeat the previous simulation study for each value of nn=5, 6, ..., 100
nsimul=100000;
nn=5:100;
maxnn=nn(end);
minnn=nn(1);
MADall=NaN(maxnn-minnn+1,1);

for i=nn
    MAD=zeros(nsimul,1);
    
    parfor j=1:nsimul
        % x=randn(i,1);
        MAD(j)=mad(randn(i,1),1);
    end
    Mea=mean(MAD);
    MADall(i-minnn+1)=Mea;
    disp(['sample size n=' num2str(i)])
end
%% Plotting part

close all
plot(nn,1./MADall)
xlabel('Sample size')
yline(1/norminv(0.75))
xlim([minnn maxnn])
ylabel('Empirical consistency factor')

(1./MADall(end))/(1/norminv(0.75))

prin=0;
if prin==1
    % print to postscript
    print -depsc simMAD.eps;
end