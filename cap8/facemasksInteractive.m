%% Facemasks data: interactive part.
% This file creates Figures 8.21 and 8.23

%% Data  loading
load facemasks.mat
y=facemasks.V;
X=facemasks.W;

n = size(y,1);

% Random start 
% The trajectories are unstable at the beginning, but converge quickly to a
% reduced number of trajectories in the central part.
% The instability generates many messages of
% 'Warning: Value of S2 at step 10 is zero, mdr is NaN' 
warning('off');  
[outFM0]=FSRmdrrs(y,X,'init',2,'intercept',0,'nsimul',5000,'plots',1,'numpool',0);
warning('on')

% Random start from m=80
% We start from 80 because before that step the trajectories are unstable
% and the plot is less clear. But there is no change in the results.
[outFM]=FSRmdrrs(y,X,'init',80,'intercept',0,'nsimul',5000,'plots',0,'numpool',0);

% Brush three times to produce the plot
databrush = struct;
databrush.persist='on';
[brushedUnits,BrushedUnits]=mdrrsplot(outFM,'databrush',databrush,...
    'FontSize',14,'SizeAxesNum',18,'lwd',2, ...
    'namey',{'V'},'nameX',{'W'});


%% Figure 8.24: iterative application of random starts on facemasks data

% Step 0: Brush once using the output of FSRmdrrs on all data

% ch8_a_2_ms_a
mdrrsplot(outFM,'databrush',[],...
    'FontSize',14,'SizeAxesNum',18,'lwd',2, ...
    'namey',{'V'},'nameX',{'W'},'ColorTrj',0);

% ch8_a_2_ms_b and ch8_a_2_ms_c
brushedUnits0 = mdrrsplot(outFM,'databrush',1,...
    'FontSize',14,'SizeAxesNum',18,'lwd',2, ...
    'namey',{'V'},'nameX',{'W'});


% Step 1: Brush once the data after removing the brushed component

% The dataset after removimg the brushed component 
id = (1:length(y))';
s1 = setdiff(id,brushedUnits0);
y1 = y(s1); X1 = X(s1);

% random start FS: monitoring from step 20 gives already stable trajectories
[outFM1]=FSRmdrrs(y1,X1,'init',20,'intercept',0,'nsimul',5000,'plots',0,'numpool',0);

% ch8_a_3_ms_a
mdrrsplot(outFM1,'databrush',[],...
    'FontSize',14,'SizeAxesNum',18,'lwd',2, ...
    'namey',{'V'},'nameX',{'W'},'ColorTrj',0);

% ch8_a_3_ms_b and ch8_a_3_ms_c
brushedUnits1 = mdrrsplot(outFM1,'databrush',1,...
    'FontSize',14,'SizeAxesNum',18,'lwd',2, ...
    'namey',{'V'},'nameX',{'W'});

% Step 2: Brush once the data after removing the brushed component

% The dataset after removimg the brushed component 
id1 = (1:length(y1))';
s2  = setdiff(id1,brushedUnits1);
y2  = y1(s2); X2 = X1(s2);

% random start FS: monitoring from step 20 
[outFM2]=FSRmdrrs(y2,X2,'init',20,'intercept',0,'nsimul',5000,'plots',0,'numpool',0);

% ch8_a_4_ms_a
mdrrsplot(outFM2,'databrush',[],...
    'FontSize',14,'SizeAxesNum',18,'lwd',2, ...
    'namey',{'V'},'nameX',{'W'},'ColorTrj',0);

% ch8_a_4_ms_b and ch8_a_4_ms_c
brushedUnits2 = mdrrsplot(outFM2,'databrush',1,...
    'FontSize',14,'SizeAxesNum',18,'lwd',2, ...
    'namey',{'V'},'nameX',{'W'});

% Step 3: Brush once the data after removing the brushed component

% The dataset after removimg the brushed component 
id2 = (1:length(y2))';
s3  = setdiff(id2,brushedUnits2);
y3  = y2(s3); X3 = X2(s3);

% random start FS: monitoring from step 20 
[outFM3]=FSRmdrrs(y3,X3,'init',20,'intercept',0,'nsimul',5000,'plots',0,'numpool',0);

% ch8_a_5_ms_a
mdrrsplot(outFM3,'databrush',[],...
    'FontSize',14,'SizeAxesNum',18,'lwd',2, ...
    'namey',{'V'},'nameX',{'W'},'ColorTrj',0);

% ch8_a_5_ms_b and ch8_a_5_ms_c
brushedUnits3 = mdrrsplot(outFM3,'databrush',1,...
    'FontSize',14,'SizeAxesNum',18,'lwd',2, ...
    'namey',{'V'},'nameX',{'W'});

% Step 4: Brush once the data after removing the brushed component

% The dataset after removimg the brushed component 
id3 = (1:length(y3))';
s4  = setdiff(id3,brushedUnits3);
y4  = y3(s4); X4 = X3(s4);

% random start FS: monitoring from step 20 
[outFM4]=FSRmdrrs(y4,X4,'init',20,'intercept',0,'nsimul',5000,'plots',0,'numpool',0);

% ch8_a_6_ms_a
mdrrsplot(outFM4,'databrush',[],...
    'FontSize',14,'SizeAxesNum',18,'lwd',2, ...
    'namey',{'V'},'nameX',{'W'},'ColorTrj',0);

% ch8_a_6_ms_b and ch8_a_6_ms_c
brushedUnits4 = mdrrsplot(outFM4,'databrush',1,...
    'FontSize',14,'SizeAxesNum',18,'lwd',2, ...
    'namey',{'V'},'nameX',{'W'});

%InsideREADME 
