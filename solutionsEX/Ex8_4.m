%% Analysis of transformed Airline data. 
% 
% This file creates Figures A.50-52

prin=0;

%% Data loading
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

%% Create Figure A.50
% the model
model           = struct;
model.trend     = 1;     % linear trend
model.seasonal  = 102;   % two harmonics with time varying seasonality
model.s         = 12;    % monthly time series
model.lshift    = 0;     % no level shift

% Default h is round(nT*0.75), i.e 25% breakdown point
outLTS102 = LTSts(Y,'model',model,'plots',1,'conflev',0.99,'msg',0,'dispresults',true);
titl = {'Model parameters for Airline data:' , 'A=1, B=2, G=1, $\delta_1=0$'};
title(findobj(gcf,'Tag','LTSts:ts'),titl,'interpreter','LaTeX','FontSize',16);


if prin==1
    % print to postscript
    print -depsc ch8_problem5_102.eps;
else
    sgtitle('Figure A.50')
    set(gcf,"Name",'Figure A.50')
end


%%  Create Figure A.51
% quadratic grow of amplitude
model.seasonal  = 202;
outLTS202 = LTSts(Y,'model',model,'plots',1,'conflev',0.99,'msg',0,'dispresults',true);
titl = {'Model parameters for Airline data:' , 'A=1, B=2, G=2, $\delta_1=0$'};
title(findobj(gcf,'Tag','LTSts:ts'),titl,'interpreter','LaTeX','FontSize',16);

if prin==1
    % print to postscript
    print -depsc ch8_problem5_202.eps;
else
    sgtitle('Figure A.51')
    set(gcf,"Name",'Figure A.51')
end



%% Create Figure A.52 (left panel)
% Transform the data and go back to linear grow of amplitude
model.seasonal  = 102;
Ylog = log(Y);
outLTSlog102 = LTSts(Ylog,'model',model,'plots',1,'conflev',0.99,'msg',0,'dispresults',true);
titl = {'Model parameters for log-transformed Airline data:' , 'A=1, B=2, G=1, $\delta_1=0$'};
title(findobj(gcf,'Tag','LTSts:ts'),titl,'interpreter','LaTeX','FontSize',16);

if prin==1
    % print to postscript
    print -depsc ch8_problem5_log102;
else
    sgtitle('Figure A.52 (left panel)')
    set(gcf,"Name",'Figure A.52 (left panel)')
end

%% Create Figure A.52 (right panel)
% No grow of amplitude
model.seasonal  = 2;
outLTSlog2 = LTSts(Ylog,'model',model,'plots',1,'conflev',0.99,'msg',0,'dispresults',true);
titl = {'Model parameters for log-transformed Airline data:' , 'A=1, B=2, G=0, $\delta_1=0$'};
title(findobj(gcf,'Tag','LTSts:ts'),titl,'interpreter','LaTeX','FontSize',16);

if prin==1
    % print to postscript
    print -depsc ch8_problem5_log2
else
    sgtitle('Figure A.52 (right panel)')
    set(gcf,"Name",'Figure A.52 (right panel)')
end

%InsideREADME