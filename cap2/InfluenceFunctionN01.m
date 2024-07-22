%% Influence Function at N(0,1) for different estimators.
%
% This file creates Figure 2.2.

%% Create input for Figure 2.2
close all
% Show the IF at N(0,1) for mean, median and trimmed mean
% Suppose mu=0;
y=(-3:0.01:3)';
% Compute the IF for the mean
IFmean=y;
% Compute the IF for the median
IFmedian= sqrt(2*pi)*sign(y)/2;
alpha=0.1;
phiminus1oneminusalpha=norminv(1-alpha);
% Compute the IF for the trimmed mean
IFyalpha=zeros(length(y),1);
for i=1:length(y)
    IFyalpha(i)=(sign(y(i))/(1-2*alpha))*min([abs(y(i)); phiminus1oneminusalpha]);
end

%% Create Figure 2.2

LineWidth=2;
FontSize=16;
hold('on')
plot(y,IFmean,'Color','r','LineStyle','-','LineWidth',LineWidth)
plot(y,IFmedian,'Color','b','LineStyle','-.','LineWidth',LineWidth)
plot(y,IFyalpha,'Color','k','LineStyle','--','LineWidth',LineWidth)
legend({'IF$_{\overline y}$' 'IF$_{\mbox{med}}$' 'IF$_{\overline y_{0.1}}$'},'FontSize',20,'Location','southeast','Interpreter','latex')
xlabel('$\it y$','FontSize',FontSize,'Interpreter','latex')
ylabel('IF','FontSize',FontSize,'Interpreter','latex')

prin=0;
if prin==1
    % print to postscript
    print -depsc IF.eps;
else
    title('Figure 2.2')
    set(gcf,"Name",'Figure 2.2')

end

%InsideREADME