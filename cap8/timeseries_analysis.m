%% Figure 8.30 on airline data

% The analysis of the dataset with LTSts is introduced in the Examples 4
% and 5 of the paper: 

% Peter Rousseeuw, Domenico Perrotta, Marco Riani, Mia Hubert (2019),
% Robust Monitoring of Time Series with Application to Fraud Detection,
% Econometrics and Statistics, Volume 9, Pages 108-121, 
% https://doi.org/10.1016/j.ecosta.2018.05.001
% https://www.sciencedirect.com/science/article/pii/S2452306218300303

% The script also includes instructions to load the trade datasets
% discussed in the same paper.

close all; clear all;
rng(12345);

%% load data

% airline data
airlines = ...
    [112  115  145  171  196  204  242  284  315  340  360  417    % Jan
    118  126  150  180  196  188  233  277  301  318  342  391    % Feb
    132  141  178  193  236  235  267  317  356  362  406  419    % Mar
    129  135  163  181  235  227  269  313  348  348  396  461    % Apr
    121  125  172  183  229  234  270  318  355  363  420  472    % May
    135  149  178  218  243  264  315  374  422  435  472  535    % Jun
    148  170  199  230  264  302  364  413  465  491  548  622    % Jul
    148  170  199  242  272  293  347  405  467  505  559  606    % Aug
    136  158  184  209  237  259  312  355  404  404  463  508    % Sep
    119  133  162  191  211  229  274  306  347  359  407  461    % Oct
    104  114  146  172  180  203  237  271  305  310  362  390    % Nov
    118  140  166  194  201  229  278  306  336  337  405  432 ]; % Dec
airlines=(airlines(:));

% Trade datasets
load('P12119085');
load('P17049075');

% To choose the dataset to analyse in the scripts, set one of the following:
% userdata = 1; % for airline
% userdata = 2; % for trade dataset P12119085
% userdata = 3; % for trade dataset P17049075


%% Plot cap8fig/ch8_ts_airline and cap8fig/ch8_ts_airline_LScont

% select the airline data
userdata = 1;

% contaminate the data as done in the book
airlinesLS=airlines;
LSpos = 80; UPpos = 35; DOWNpos = 100:105;
airlinesLS(LSpos:end)=airlinesLS(LSpos:end)+130;
airlinesLS(DOWNpos)=airlinesLS(DOWNpos)-200;
airlinesLS(UPpos)=airlinesLS(UPpos)+200;

% figure generation
figure;
plot(airlines,'Linewidth',1.5);
%numpar = {'model parameters:' , 'A=1, B=2, G=1, $\delta_1=0$'};
%title(gca,'Airline data','FontSize',20);
xlabel('Month index, from 1949 to 1960','FontSize',18);
ylabel('Thousands of passengers','FontSize',18);
set(gca,'FontSize',18)

figure;
plot(airlinesLS,'Linewidth',1.5);
hold on
yl = ylim; yaxlim = [yl(1) ; yl(2)];
line(LSpos*ones(2,1) , yaxlim , 'LineStyle' , ':' , 'LineWidth' , 2 , 'Color' , 'r');
text(LSpos , yaxlim(1) , num2str(LSpos) , 'Color' , 'r','FontSize',12 , 'HorizontalAlignment' , 'Center' , 'VerticalAlignment' ,  'Top');
text(UPpos , airlinesLS(UPpos) , ['+' num2str(200)] , 'Color' , 'r','FontSize',12, 'HorizontalAlignment' , 'Center', 'VerticalAlignment','Bottom');
text(UPpos   , airlinesLS(UPpos)   , '*' , 'Color' , 'r','FontSize',25, 'HorizontalAlignment' , 'Center');
text(DOWNpos , airlinesLS(DOWNpos) , '*' , 'Color' , 'r','FontSize',25, 'HorizontalAlignment' , 'Center');
text(round(median(DOWNpos)) , airlinesLS(round(median(DOWNpos))) , ['-' num2str(200)] , 'Color' , 'r','FontSize',12, 'HorizontalAlignment' , 'Center', 'VerticalAlignment','Top');
%text(DOWNpos , airlinesLS(DOWNpos) , ['-' num2str(200)] , 'Color' , 'r','FontSize',12, 'HorizontalAlignment' , 'Center', 'VerticalAlignment','Top');
%numpar = {'model parameters:' , 'A=1, B=2, G=1, $\delta_1=0$'};
%title(gca,'Airline data','FontSize',20);
xlabel('Month index, from 1949 to 1960','FontSize',18);
ylabel('Thousands of passengers','FontSize',18);
set(gca,'FontSize',18)

%% Figure 8.31 - top panel

% the model
model           = struct;
model.trend     = 1;
model.seasonal  = 102;             
model.s         = 12;
model.lshift    = LSpos-10:LSpos+10;

% % Using the notation of the paper RPRH: A=1, B=2, G=1 and $\delta_1>0$.
% str=strcat('A=1, B=2, G=1, $\delta_2=',num2str(out.posLS),'$');
% numpar = {'model parameters:' , str};
% title(gca,numpar,'interpreter','LaTeX','FontSize',16);

switch userdata
    case 1
        Y = airlinesLS;
        titl = 'Airline data';
        nT = length(Y);
    case 2
        Y = P12119085{:,1};
        titl = 'P12119085, imports of plants from KN to UK';
    case 3
        Y = P17049075{:,1};
        titl = 'P17049075, imports of sugars from UA to LT';
end

% The default value for h is 75 per cent of the data, i.e. 'h',round(nT*0.75)
% This corresponds to a 25% breakdown point.
outLTS = LTSts(Y,'model',model,'plots',1,'conflev',0.99,'msg',0,'dispresults',true);
title(findobj(gcf,'Tag','LTSts:ts'),[titl ' - LTS with conflev=0.99 and bdp=25%'] );

% this is LTsts with 5% bdp
outLTS05 = LTSts(Y,'model',model,'plots',1,'bdp',0.05,'conflev',0.99,'msg',0,'dispresults',true);
title(findobj(gcf,'Tag','LTSts:ts'),[titl ' - LTS with conflev=0.99 and bdp=5%'] );

% this is FS with default 0.99 conlev 
outFSR = FSRts(Y,'model',model,'init',25,'plots',1,'msg',0);
title(findobj(gcf,'Tag','FSRts:ts'),[titl ' - FSR with default conflev (0.99)']);

%% wedgeplot for the LTSts: figure 8.31 bottom panels

% the wedgeplot with the time series, the detected outliers and level shift
wedgeplot(outLTS,'titl',titl);
xlim([0,150])

% the wedgeplot with the time series, the detected outliers and level shift
wedgeplot(outLTS05,'titl',titl);
xlim([0,150])

%%  Forecasts with a 99.9 per cent confidence level

nfore=10;
outforeLTS = forecastTS(outLTS,'model',model,'nfore',nfore,'conflev',0.999,'titl',[titl ' - LTSts forecast']);


%% Exercise 8.5 - Analysis of transformed Airline data

% the original airline data (not contaminated)
airlines = ...
    [112  115  145  171  196  204  242  284  315  340  360  417    % Jan
    118  126  150  180  196  188  233  277  301  318  342  391    % Feb
    132  141  178  193  236  235  267  317  356  362  406  419    % Mar
    129  135  163  181  235  227  269  313  348  348  396  461    % Apr
    121  125  172  183  229  234  270  318  355  363  420  472    % May
    135  149  178  218  243  264  315  374  422  435  472  535    % Jun
    148  170  199  230  264  302  364  413  465  491  548  622    % Jul
    148  170  199  242  272  293  347  405  467  505  559  606    % Aug
    136  158  184  209  237  259  312  355  404  404  463  508    % Sep
    119  133  162  191  211  229  274  306  347  359  407  461    % Oct
    104  114  146  172  180  203  237  271  305  310  362  390    % Nov
    118  140  166  194  201  229  278  306  336  337  405  432 ]; % Dec
Y=(airlines(:));


% figure generation
figure;
plot(Y,'Linewidth',1.5);
%numpar = {'model parameters:' , 'A=1, B=2, G=1, $\delta_1=0$'};
%title(gca,'Airline data','FontSize',20);
xlabel('Month index, from 1949 to 1960','FontSize',18);
ylabel('Thousands of passengers','FontSize',18);
set(gca,'FontSize',18)

% the model
model           = struct;
model.trend     = 1;     % linear trend
model.seasonal  = 102;   % two harmonics with time varying seasonality           
model.s         = 12;    % monthly time series
model.lshift    = 0;     % no level shift

% Default h is round(nT*0.75), i.e 25% breakdown point
outLTS102 = LTSts(Y,'model',model,'plots',1,'conflev',0.99,'msg',0,'dispresults',true);
titl = {'model parameters for Airline data:' , 'A=1, B=2, G=1, $\delta_1=0$'};
title(findobj(gcf,'Tag','LTSts:ts'),titl,'interpreter','LaTeX','FontSize',16);

% quadratic grow of amplitude is too much
model.seasonal  = 202;
outLTS202 = LTSts(Y,'model',model,'plots',1,'conflev',0.99,'msg',0,'dispresults',true);
titl = {'model parameters for Airline data:' , 'A=1, B=2, G=2, $\delta_1=0$'};
title(findobj(gcf,'Tag','LTSts:ts'),titl,'interpreter','LaTeX','FontSize',16);

% then, transform the data and go back to linear grow of amplitude
model.seasonal  = 102;
Ylog = log(Y);
outLTSlog102 = LTSts(Ylog,'model',model,'plots',1,'conflev',0.99,'msg',0,'dispresults',true);
titl = {'model parameters for log-transformed Airline data:' , 'A=1, B=2, G=1, $\delta_1=0$'};
title(findobj(gcf,'Tag','LTSts:ts'),titl,'interpreter','LaTeX','FontSize',16);

% or simply no grow of amplitude
model.seasonal  = 2;
Ylog = log(Y);
outLTSlog2 = LTSts(Ylog,'model',model,'plots',1,'conflev',0.99,'msg',0,'dispresults',true);
titl = {'model parameters for log-transformed Airline data:' , 'A=1, B=2, G=0, $\delta_1=0$'};
title(findobj(gcf,'Tag','LTSts:ts'),titl,'interpreter','LaTeX','FontSize',16);


%% Exercise 8.5 - Monitoring the constructed variable and Box-Cox on the Airline data

% the original airline data (not contaminated)
airlines = ...
    [112  115  145  171  196  204  242  284  315  340  360  417    % Jan
    118  126  150  180  196  188  233  277  301  318  342  391    % Feb
    132  141  178  193  236  235  267  317  356  362  406  419    % Mar
    129  135  163  181  235  227  269  313  348  348  396  461    % Apr
    121  125  172  183  229  234  270  318  355  363  420  472    % May
    135  149  178  218  243  264  315  374  422  435  472  535    % Jun
    148  170  199  230  264  302  364  413  465  491  548  622    % Jul
    148  170  199  242  272  293  347  405  467  505  559  606    % Aug
    136  158  184  209  237  259  312  355  404  404  463  508    % Sep
    119  133  162  191  211  229  274  306  347  359  407  461    % Oct
    104  114  146  172  180  203  237  271  305  310  362  390    % Nov
    118  140  166  194  201  229  278  306  336  337  405  432 ]; % Dec
Y = airlines(:);

% true for bottm panel of the Figure, false for the top panel 
%applylog = true;
applylog = false;
if applylog
    Y = log(Y);
end

T = numel(Y);

% The time series model
% Remark: model.X is set in the loop
model           = struct;
model.trend     = 1;     % linear trend
model.seasonal  = 102;   % two harmonics with time varying seasonality
model.s         = 12;    % monthly time series
model.lshift    = 0;     % no level shift

rng(12345);  % for replicability

cont = [0 0.1];         % contamination percentage
cont = floor(T*cont);   % contaminated units
iic = 0;
for c = cont
    iic = iic+1;
    if c>0
        %ic    = randi(T,c,1);
        ic    = (T-c+1:T)';
        if applylog
            noise    = log(abs(randn(c,1)));
            m=randi([-1 ,1],c,1);
            m(~m)=-1;
            Y(ic) = Y(ic) + (0.1*median(Y(:)) * m.*noise);
        else
            noise = randn(c,1);
            Y(ic) = Y(ic) + (250 * noise);
        end
    end

    % vector of lambda values to be tested
    % la = [-1 -0.5 0 0.5 1];
    la = 1;
    nla = numel(la);

    % breakdown point values to monitor
    bdp  = 0.5:-0.02:0;
    nbdp = numel(bdp);

    % w_lambda: T*nla matrix containing the T values of each constructed
    % variable (one for each monitored lambda)
    w_lambda = zeros(T,nla);
    % w_tstat: nbdp*nla matrix containing the score test statistic of each
    % constructed variable (one for each monitored lambda)
    w_tstat = zeros(nbdp,nla);
    warning('off');

    for il = 1 : nla

        % the lambda to be tested
        la0 = la(il);

        G    = geomean(Y); % geometric mean of y
        logG = log(G);
        logY = log(Y);

        if abs(la0) < 10^(-8)
            z = G * logY;
            w = z .* (logY/2 - logG);
        else
            %z1 = (Y.^la0-1)/(la0*G^(la0-1));
            %w1 =  Y.^la0.*logY / (la0*G^(la0-1)) - z1 * (1/la0 + logG);

            laiGlaim1 =la0*exp((la0-1)*logG);
            ylai=exp(la0*logY);
            ylaim1=ylai-1;
            z=ylaim1/laiGlaim1;
            w=(ylai.*logY-ylaim1*(1/la0+logG))/laiGlaim1;
        end

        w_lambda(:,il) = w;

        % the constructed variable is added to the model as explanatory variable
        model.X = w;
        for ibdp = 1:nbdp
            outLTS = LTSts(Y,'model',model,'plots',0,'bdp',bdp(ibdp),'conflev',0.99,'msg',0,'dispresults',false);
            therow = find(ismember(outLTS.Btable.Row,'b_explX1'));
            w_tstat(ibdp,il) = -outLTS.B(therow,3);
        end
    end

    if iic==1
        figure
        lwd = 3;        % Line width
        FontSize = 18;  % Font Size
        ColorOrd=[{[0 0 1]}; {[0 0 0]} ; {[1 0 0]}; {[1 0 1]}; {[1 1 0]}; {[0 1 0]}; {[0 1 1]}];
        ColorOrd=repmat(ColorOrd,nla,1);  % Specify a color for each lambda trajectory
        StyleOrd={'-','-.'};
        BDP = repmat(bdp',1,nla);
    end

    hp = plot(BDP,w_tstat,'LineWidth',lwd);

    if bdp(end) < bdp(1)
        set(gca,'XTick',fliplr(bdp));
    end
    set(gca,'XDir','reverse');

    set(hp,{'LineStyle'}, StyleOrd(1,iic));
    set(hp,{'Color'},     ColorOrd(iic,:));

    hold on
end

set(gca,'fontsize',FontSize);
labx='Breakdown point';
laby='Test statistic for the constructed variable';
titl='Fan plot';
xlabel(labx,'Fontsize',FontSize);
ylabel(laby,'Fontsize',FontSize);
if applylog
    legend({'Log-transformed Airline data' , 'Last 10% contaminated'},'Fontsize',FontSize+5);
else
    legend({'Original Airline data' , 'Last 10% contaminated'},'Fontsize',FontSize+5);
end
hold off


