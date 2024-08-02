%% Power comparison
% This file creates Figures 5.7-5.12
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



%% Create figure 5.7

% no. of variables
p=5;

% data size
n=500;

% level of contamination
contamrate=0.05;

% shifting
shift=[1 2 3 4 5 6 7];

% call the function that performs the calculation
StatPOW=power_calc(nsimul, nsamp, n, p, contamrate, shift);

%% Plot section

close all

% this line to achieve the sdame results on PC and Mac
set(0, 'DefaultFigureRenderer', 'painters');

hold('on')
Y=StatPOW(:,2:6);

col=repmat({'b';'b';'r';'r';'k'},3,1);
linst=repmat({'--';'--';'-.';':';'-'},3,1);
LineWidth=4;


fsize=25;

X=shift;

% Plot curves
plot(X,Y(:,5),'LineWidth',LineWidth,'LineStyle',linst{5}, 'Color',col{5})
plot(X,Y(:,1),'LineWidth',LineWidth,'LineStyle',linst{1}, 'Color',col{1},'Marker','o')
plot(X,Y(:,2),'LineWidth',LineWidth,'LineStyle',linst{2}, 'Color',col{2},'Marker','v')
plot(X,Y(:,3),'LineWidth',LineWidth,'LineStyle',linst{3}, 'Color',col{3})
plot(X,Y(:,4),'LineWidth',LineWidth,'LineStyle',linst{4}, 'Color',col{4})




legend('FS', 'S','MM', 'LTS', 'LTSr','FontSize',fsize, 'Location','northwest')



% Create axes labels
xlabel('Shift','FontSize',fsize);
ylabel('Average power','FontSize',fsize);

x1=5.5;
y1=0.2;
gap=0.070;

text(x1,y1+gap*0,'LTS','FontSize',fsize)
text(x1,y1+gap*1,'LTSr','FontSize',fsize)
text(x1,y1+gap*2,'MM','FontSize',fsize)
text(x1,y1+gap*3,'S','FontSize',fsize)
text(x1,y1+gap*4,'FS','FontSize',fsize)


xlim([1 7])

set(gca,'XTick',1:7)
% set(gca,'YTick',-10:5:10)
set(gca,'YTick',0:0.2:1)
set(gca,'FontSize',25)



%% figure 5.8

close all

% this line to achieve the sdame results on PC and Mac
set(0, 'DefaultFigureRenderer', 'painters');

hold('on')
Ylog=log(StatPOW(:,2:6)./(1-StatPOW(:,2:6)));

col=repmat({'b';'b';'r';'r';'k'},3,1);
linst=repmat({'--';'--';'-.';':';'-'},3,1);
LineWidth=4;


fsize=25;

X=shift;

% Plot curves
plot(X,Ylog(:,5),'LineWidth',LineWidth,'LineStyle',linst{5}, 'Color',col{5})
plot(X,Ylog(:,1),'LineWidth',LineWidth,'LineStyle',linst{1}, 'Color',col{1},'Marker','o')
plot(X,Ylog(:,2),'LineWidth',LineWidth,'LineStyle',linst{2}, 'Color',col{2},'Marker','v')
plot(X,Ylog(:,3),'LineWidth',LineWidth,'LineStyle',linst{3}, 'Color',col{3})
plot(X,Ylog(:,4),'LineWidth',LineWidth,'LineStyle',linst{4}, 'Color',col{4})




legend( 'FS', 'S','MM', 'LTS', 'LTSr','FontSize',fsize, 'Location','northwest')



% Create axes labels
xlabel('Shift','FontSize',fsize);
ylabel('Logit average power','FontSize',fsize);

x1=5.5;
y1=-5;
gap=0.90;

text(x1,y1+gap*0,'LTS','FontSize',fsize)
text(x1,y1+gap*1,'LTSr','FontSize',fsize)
text(x1,y1+gap*2,'MM','FontSize',fsize)
text(x1,y1+gap*3,'S','FontSize',fsize)
text(x1,y1+gap*4,'FS','FontSize',fsize)


xlim([1 7])

% % set(gca,'XTick',1:7)
 set(gca,'YTick',-14:5:12)
% set(gca,'YTick',0:0.2:1)

set(gca,'XTick',1:7)
%set(gca,'YTick',-12:5:10)

set(gca,'FontSize',25)



%% figure 5.9


% no. of variables
p=2;

% data size
n=50;

% level of contamination
contamrate=0.3;

% shifting
shift=[1 2 3 4 5 6 7];

% call the function that performs the calculation
StatPOW=power_calc(nsimul, nsamp, n, p, contamrate, shift);

%% Plot section
close all

% this line to achieve the sdame results on PC and Mac
set(0, 'DefaultFigureRenderer', 'painters');

hold('on')
Y=StatPOW(:,2:6);

col=repmat({'b';'b';'r';'r';'k'},3,1);
linst=repmat({'--';'--';'-.';':';'-'},3,1);
LineWidth=4;


fsize=25;

X=shift;

% Plot curves
plot(X,Y(:,5),'LineWidth',LineWidth,'LineStyle',linst{5}, 'Color',col{5})
plot(X,Y(:,1),'LineWidth',LineWidth,'LineStyle',linst{1}, 'Color',col{1},'Marker','o')
plot(X,Y(:,2),'LineWidth',LineWidth,'LineStyle',linst{2}, 'Color',col{2},'Marker','v')
plot(X,Y(:,3),'LineWidth',LineWidth,'LineStyle',linst{3}, 'Color',col{3})
plot(X,Y(:,4),'LineWidth',LineWidth,'LineStyle',linst{4}, 'Color',col{4})




legend( 'FS', 'S','MM', 'LTS', 'LTSr','FontSize',fsize, 'Location','northwest')



% Create axes labels
xlabel('Shift','FontSize',fsize);
ylabel('Average power','FontSize',fsize);

x1=5.5;
y1=0.05;
gap=0.070;

text(x1,y1+gap*0,'LTS','FontSize',fsize)
text(x1,y1+gap*1,'LTSr','FontSize',fsize)
text(x1,y1+gap*8,'MM','FontSize',fsize)
text(x1,y1+gap*9,'S','FontSize',fsize)
text(x1,y1+gap*10,'FS','FontSize',fsize)


xlim([1 7])

set(gca,'XTick',1:7)
% set(gca,'YTick',-10:5:10)
set(gca,'YTick',0:0.2:1)
set(gca,'FontSize',25)



%% figure 5.10

close all

% this line to achieve the sdame results on PC and Mac
set(0, 'DefaultFigureRenderer', 'painters');

hold('on')
Ylog=log(StatPOW(:,2:6)./(1-StatPOW(:,2:6)));

col=repmat({'b';'b';'r';'r';'k'},3,1);
linst=repmat({'--';'--';'-.';':';'-'},3,1);
LineWidth=4;


fsize=25;

X=shift;

% Plot curves
plot(X,Ylog(:,5),'LineWidth',LineWidth,'LineStyle',linst{5}, 'Color',col{5})
plot(X,Ylog(:,1),'LineWidth',LineWidth,'LineStyle',linst{1}, 'Color',col{1},'Marker','o')
plot(X,Ylog(:,2),'LineWidth',LineWidth,'LineStyle',linst{2}, 'Color',col{2},'Marker','v')
plot(X,Ylog(:,3),'LineWidth',LineWidth,'LineStyle',linst{3}, 'Color',col{3})
plot(X,Ylog(:,4),'LineWidth',LineWidth,'LineStyle',linst{4}, 'Color',col{4})




legend( 'FS', 'S','MM', 'LTS', 'LTSr','FontSize',fsize, 'Location','northwest')



% Create axes labels
xlabel('Shift','FontSize',fsize);
ylabel('Logit average power','FontSize',fsize);

x1=5.5;
y1=-7;
gap=0.90;

text(x1,y1+gap*0,'LTS','FontSize',fsize)
text(x1,y1+gap*1,'LTSr','FontSize',fsize)
text(x1,y1+gap*2,'MM','FontSize',fsize)
text(x1,y1+gap*3,'S','FontSize',fsize)
text(x1,y1+gap*4,'FS','FontSize',fsize)


xlim([1 7])

% % set(gca,'XTick',1:7)
 set(gca,'YTick',-14:5:12)
% set(gca,'YTick',0:0.2:1)

set(gca,'XTick',1:7)
%set(gca,'YTick',-12:5:10)

set(gca,'FontSize',25)



%% figure 5.11


% no. of variables
p=5;

% data size
n=500;

% level of contamination
contamrate=0.3;

% shifting
shift=[1 2 3 4 5 6 7];

% call the function that performs the calculation
StatPOW=power_calc(nsimul, nsamp, n, p, contamrate, shift);

%% plot section
close all

% this line to achieve the sdame results on PC and Mac
set(0, 'DefaultFigureRenderer', 'painters');

hold('on')
Y=StatPOW(:,2:6);

col=repmat({'b';'b';'r';'r';'k'},3,1);
linst=repmat({'--';'--';'-.';':';'-'},3,1);
LineWidth=4;


fsize=25;

X=shift;

% Plot curves
plot(X,Y(:,5),'LineWidth',LineWidth,'LineStyle',linst{5}, 'Color',col{5})
plot(X,Y(:,1),'LineWidth',LineWidth,'LineStyle',linst{1}, 'Color',col{1},'Marker','o')
plot(X,Y(:,2),'LineWidth',LineWidth,'LineStyle',linst{2}, 'Color',col{2},'Marker','v')
plot(X,Y(:,3),'LineWidth',LineWidth,'LineStyle',linst{3}, 'Color',col{3})
plot(X,Y(:,4),'LineWidth',LineWidth,'LineStyle',linst{4}, 'Color',col{4})




legend( 'FS', 'S','MM', 'LTS', 'LTSr','FontSize',fsize, 'Location','northwest')



% Create axes labels
xlabel('Shift','FontSize',fsize);
ylabel('Average power','FontSize',fsize);

x1=5.5;
y1=0.4;
gap=0.070;

text(x1,y1+gap*0,'LTSr','FontSize',fsize)
text(x1,y1+gap*1,'MM','FontSize',fsize)
text(x1,y1+gap*2,'LTS','FontSize',fsize)
text(x1,y1+gap*3,'S','FontSize',fsize)
text(x1,y1+gap*4,'FS','FontSize',fsize)


xlim([1 7])

set(gca,'XTick',1:7)
% set(gca,'YTick',-10:5:10)
set(gca,'YTick',0:0.2:1)
set(gca,'FontSize',25)



%% figure 5.12

close all

% this line to achieve the sdame results on PC and Mac
set(0, 'DefaultFigureRenderer', 'painters');

hold('on')
Ylog=log(StatPOW(:,2:6)./(1-StatPOW(:,2:6)));

col=repmat({'b';'b';'r';'r';'k'},3,1);
linst=repmat({'--';'--';'-.';':';'-'},3,1);
LineWidth=4;


fsize=25;

X=shift;

% Plot curves
plot(X,Ylog(:,5),'LineWidth',LineWidth,'LineStyle',linst{5}, 'Color',col{5})
plot(X,Ylog(:,1),'LineWidth',LineWidth,'LineStyle',linst{1}, 'Color',col{1},'Marker','o')
plot(X,Ylog(:,2),'LineWidth',LineWidth,'LineStyle',linst{2}, 'Color',col{2},'Marker','v')
plot(X,Ylog(:,3),'LineWidth',LineWidth,'LineStyle',linst{3}, 'Color',col{3})
plot(X,Ylog(:,4),'LineWidth',LineWidth,'LineStyle',linst{4}, 'Color',col{4})




legend( 'FS', 'S','MM', 'LTS', 'LTSr','FontSize',fsize, 'Location','northwest')



% Create axes labels
xlabel('Shift','FontSize',fsize);
ylabel('Logit average power','FontSize',fsize);

x1=6;
y1=-11;
gap=0.90;

text(x1,y1+gap*0,'LTSr','FontSize',fsize)
text(x1,y1+gap*1,'MM','FontSize',fsize)
text(x1,y1+gap*2,'LTS','FontSize',fsize)
text(x1,y1+gap*3,'S','FontSize',fsize)
text(x1,y1+gap*4,'FS','FontSize',fsize)


xlim([1 7])

% % set(gca,'XTick',1:7)
 set(gca,'YTick',-14:5:12)
% set(gca,'YTick',0:0.2:1)

set(gca,'XTick',1:7)
%set(gca,'YTick',-12:5:10)

set(gca,'FontSize',25)



%InsideREADME




