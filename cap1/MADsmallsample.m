%% Analysis of consistency factor (small sample and asymptotic for MAD).
% This file creates  Figure 1.1

%% Empirical consisteny factor for MAD when n=5
% Take n observations from N(0,1) and compute the MAD
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

%% Prepare the input data for Figure 1.1
% Repeat the previous simulation study for each value of nn=5, 6, ..., 100
nsimul=10000; % Use nsimul=1000000 for greater precision
nn=5:100;
maxnn=nn(end);
minnn=nn(1);
MADall=NaN(maxnn-minnn+1,1);

for i=nn
    MAD=zeros(nsimul,1);

    parfor j=1:nsimul
        MAD(j)=mad(randn(i,1),1);
    end
    Mea=mean(MAD);
    MADall(i-minnn+1)=Mea;
    disp(['sample size n=' num2str(i)])
end

disp('Empirical consistenty factor when n=100')
disp(1./MADall(end))
% Using nsimul=100,000,000 when n=100
% the empirical consistency factor is 1.4942

%% Plotting part

close all
plot(nn,1./MADall)
xlabel('Sample size')
yline(1/norminv(0.75))
xlim([minnn maxnn])
ylabel('Empirical consistency factor')

prin=0;
if prin==1
    % print to postscript
    print -depsc simMAD.eps;
else
    title('Figure 1.1')
    set(gcf,'Name','Figure 1.1')

end

%InsideREADME