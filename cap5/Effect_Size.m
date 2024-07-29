%% Size comparison
% This file creates Figures 5.5-5.6
%
% Note that nsimul is set to 100. If you wish to use 10000 simulations (as
% done in the book) set nsimul to 10000

%% Beginning of code

% set the seed for random number generation
% so that the results are consistent & comparable
state1=123476;
rng(state1);


% no. of simulations
nsimul=100;

% no. of initial subsamples for S estimator
nsamp=300;


% size
sizevect=[100 200 300 400 500 1000];


%% Create figure 5.5

% no. of variables
p=2;

StatSIZE=Size_Comparison(nsimul, nsamp, p, sizevect);

close all
set(0, 'DefaultFigureRenderer', 'painters');
hold('on')

col=repmat({'b';'b';'r';'r';'k'},3,1);
linst=repmat({'--';'--';'-.';':';'-'},3,1);
LineWidth=4;

Y=StatSIZE(:,2:6);
fsize=25;

X=(1:6)';

% S, MM, LTS, LTSr, FS

plot(X,Y(:,1),'LineWidth',LineWidth,'LineStyle',linst{1}, 'Color',col{1},'Marker','o')
plot(X,Y(:,2),'LineWidth',LineWidth,'LineStyle',linst{2}, 'Color',col{2},'Marker','v')
plot(X,Y(:,3),'LineWidth',LineWidth,'LineStyle',linst{3}, 'Color',col{3})
plot(X,Y(:,4),'LineWidth',LineWidth,'LineStyle',linst{4}, 'Color',col{4})
plot(X,Y(:,5),'LineWidth',LineWidth,'LineStyle',linst{5}, 'Color',col{5})



legend( 'S','MM', 'LTS', 'LTSr','FS','FontSize',fsize, 'Location','northeast')
set(gca,'XTick',1:6,'XTickLabel', string([100:100:500 1000]))

set(gca,'YTick',0:0.005:0.030)
set(gca,'FontSize',25)


% Create ylabel
xlabel('Sample size','FontSize',fsize);
ylabel('Empirical size of outlier test','FontSize',fsize);

x1=4.0;
y1=0.015;
gap=0.0010;

text(x1,y1+gap*0,'FS','FontSize',fsize)
text(x1,y1+gap*1,'LTSr','FontSize',fsize)
text(x1,y1+gap*2,'MM','FontSize',fsize)
text(x1,y1+gap*3,'S','FontSize',fsize)
text(x1,y1+gap*4,'LTS','FontSize',fsize)




%% figure 5.6

close all
% no. of variables
p=10;

StatSIZE=Size_Comparison(nsimul, nsamp, p, sizevect);


set(0, 'DefaultFigureRenderer', 'painters');
hold('on')

col=repmat({'b';'b';'r';'r';'k'},3,1);
linst=repmat({'--';'--';'-.';':';'-'},3,1);
LineWidth=4;

Y=StatSIZE(:,2:6);
fsize=25;

X=[1 2 3 4 5 6]';

% S, MM, LTS, LTSr, FS

plot(X,Y(:,1),'LineWidth',LineWidth,'LineStyle',linst{1}, 'Color',col{1},'Marker','o')
plot(X,Y(:,2),'LineWidth',LineWidth,'LineStyle',linst{2}, 'Color',col{2},'Marker','v')
plot(X,Y(:,3),'LineWidth',LineWidth,'LineStyle',linst{3}, 'Color',col{3})
plot(X,Y(:,4),'LineWidth',LineWidth,'LineStyle',linst{4}, 'Color',col{4})
plot(X,Y(:,5),'LineWidth',LineWidth,'LineStyle',linst{5}, 'Color',col{5})



legend( 'S','MM', 'LTS', 'LTSr','FS','FontSize',fsize, 'Location','northeast')
set(gca,'XTick',1:6,'XTickLabel', string([100:100:500 1000]))


set(gca,'YTick',0:0.025:1)

set(gca,'FontSize',25)



% Create ylabel
xlabel('Sample size','FontSize',fsize);
ylabel('Empirical size of outlier test','FontSize',fsize);

x1=4.0;
y1=0.03;
gap=0.006;

text(x1,y1+gap*0,'FS','FontSize',fsize)
text(x1,y1+gap*1,'LTSr','FontSize',fsize)
text(x1,y1+gap*2,'MM','FontSize',fsize)
text(x1,y1+gap*3,'LTS','FontSize',fsize)
text(x1,y1+gap*4,'S','FontSize',fsize)

%InsideREADME




