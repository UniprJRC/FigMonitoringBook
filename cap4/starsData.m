
%% ST: Stars dataset (show the different regression lines)
clearvars;
close all;
prin=0;
stars=load('stars.txt');
y=stars(:,2);
X=stars(:,1);
plot(X,y,'o');
xlabel('Log effective surface temperature')
ylabel('Log light intensity')
set(gca,'XDir','reverse');

n=length(y);
plot(X,y,'o','MarkerFaceColor','black')
set(gca,'FontSize',12)

xlabel('Log(effective surface temperature)')
ylabel('Log(light intensity)')
sel=[ 7 9 11 20 30 34]';

text(X(sel)+0.05,y(sel),num2str(sel),'FontSize',16)
lwd=2;


% FS
[out]=FSR(y,X,'plots',0);

x1=min(X);
x2=max(X);
y1=out.beta(1)+out.beta(2)*x1;
y2=out.beta(1)+out.beta(2)*x2;
line([x1;x2],[y1;y2],'LineStyle','--','LineWidth',lwd,'Color','m')


% S estimator with bdp=0.5
rhofunc='bisquare';
[outS]=Sreg(y,X,'rhofunc',rhofunc,'bdp',0.5,'conflev',1-0.01/n);

x1=min(X);
x2=max(X);
y1=outS.beta(1)+outS.beta(2)*x1;
y2=outS.beta(1)+outS.beta(2)*x2;
line([x1;x2],[y1;y2],'LineStyle','--','LineWidth',lwd)

% MM085 = MM estimator with efficiency set to 0.85
[outMM]=MMregcore(y,X,outS.beta,outS.scale,'eff',0.85,'rhofunc',rhofunc);
x1=min(X);
x2=max(X);
y1=outMM.beta(1)+outMM.beta(2)*x1;
y2=outMM.beta(1)+outMM.beta(2)*x2;
line([x1;x2],[y1;y2],'LineStyle','-.','Color','green','LineWidth',lwd)

% MM095 = MM estimator with efficiency set to 0.95
[outMM]=MMregcore(y,X,outS.beta,outS.scale,'eff',0.95,'rhofunc',rhofunc);
x1=min(X);
x2=max(X);
y1=outMM.beta(1)+outMM.beta(2)*x1;
y2=outMM.beta(1)+outMM.beta(2)*x2;
line([x1;x2],[y1;y2],'LineStyle','-.','Color','red','LineWidth',lwd)

%  LTS with bdp=0.5
[outLXS]=LXS(y,X,'lms',0);
y1=outLXS.beta(1)+outLXS.beta(2)*x1;
y2=outLXS.beta(1)+outLXS.beta(2)*x2;
line([x1;x2],[y1;y2],'LineStyle',':','Color','black','LineWidth',lwd+2)


% LS: traditional regression
whichstats = {'beta','yhat','r','rsquare'};
stats = regstats(y, X,'linear',whichstats);
y1=stats.beta(1)+stats.beta(2)*x1;
y2=stats.beta(1)+stats.beta(2)*x2;
line([x1;x2],[y1;y2],'LineStyle','-','LineWidth',3)
xlim([x1 x2])

ylim([min(y)-0.1 max(y)+0.1])
legend('Data','FS','S','MM085','MM095','LTS','LS')

if prin==1
    % print to postscript
    print -depsc starsdatawithrobfit.eps;
end

%% Sregeda on Stars data.
rhofunc= 'mdpd';
load('stars');
X=stars{:,1};
y=stars{:,2};
[out]=Sregeda(y,X,'rhofunc',rhofunc);
resfwdplot(out)

