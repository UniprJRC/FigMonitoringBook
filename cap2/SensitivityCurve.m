%%  Sensistivity curve for the Income data

% Load the data
load Income1;
% Just use the first 11 observations
y=log(Income1{1:11,"HOTHVAL"});
alpha=0.10;

%% SC for mean, median and trimmed mean
% Compute median, mean and trimmed mean for all the observations
medy=median(y);
meany=mean(y);
trimean=trimmean(y,100*(alpha*2),'floor');
trimean1=trimmeanFS(y,alpha);

% Value which has to be added to compute the sensitivity curve
x=(9:0.01:13)';

% Txnmean, Txnmed and Txntrimmean will contain the value of the sensitivity
% curve based on y and x(i) i=1, 2, ..., length(x)
Txnmean=zeros(length(x),1);
Txnmed=Txnmean;
Txntrimmean=Txnmean;
for i=1:length(x)
    Txnmean(i)=mean([y;x(i)]);
    Txnmed(i)=median([y;x(i)]);
    Txntrimmean(i)=trimmean([y;x(i)],20,'floor');
end

n=length(y);
Scurvmean=(n+1)*(Txnmean-meany);
Scurvmedian=(n+1)*(Txnmed-medy);
Scurvtrimmean=(n+1)*(Txntrimmean-trimean);
%% Plotting part
FontSize=14;

LineWidth=2;
close all
hold('on')
plot(x,Scurvmean,'Color','r','LineStyle','-','LineWidth',LineWidth)
plot(x,Scurvmedian,'Color','b','LineStyle','-.','LineWidth',LineWidth)
plot(x,Scurvtrimmean,'Color','k','LineStyle','--','LineWidth',LineWidth)
xlabel('$y$','Interpreter','latex','FontSize',FontSize)
ylabel('$12 \times \left\{ T(y_1,\ldots, y_{11}, y) - T(y_1, \ldots, y_{11}) \right\}$',...
    'Interpreter','latex','FontSize',FontSize)
% title('Sensitivity curve')
ax=axis;
% add an horizontal line passing through 0
yline(0,'LineStyle',':','LineWidth',1)
% add legend
legend({'$\overline y$' '$Me$' '$\overline y_{0.1}$'},'FontSize',20,'Location','southeast','Interpreter','latex')


prin=0;
if prin==1
    % print to postscript
    print -depsc SC.eps;
end