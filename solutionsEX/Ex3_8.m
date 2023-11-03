%% Comparison of the distribution of squared deletion residuals
% and squared studentized residuals

close all
prin=0;

%% Create Figure A.4
n=50;
p=5;
x=0.001:0.001:0.6;
nr=2;
nc=1;
% subplot(nr,nc,1)
betap=betapdf(x,0.5,(n-p-1)/2);
fp=fpdf(x,1,n-p-1);
plot(x,betap,'--',x,fp,':','LineWidth',2)
legend({'Beta(0.5,22)' 'F(1,44)'})
ylabel('Beta and F densities')
ylim([0 20])

title('Figure A.4')
set(gcf,"Name",'Figure A.4')

if prin==1
    % print to postscript
    print -depsc compBetaF.eps;
end