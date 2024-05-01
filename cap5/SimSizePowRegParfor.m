function SimSizePowRegParfor(p, n, lambda, nsimul)

%% Compute size for S MM estimators, LS, FS, LTS(r) in regression
%parpool

% p= number of explanatory variables (including the intercept)
% n = samples size
% lambda = shift contamination (so far not used)
% nsimul = number of simulations


% nest = Number of estimators which will be considered
% Estimators which will be considered are as follows:
% 1.	OLS
%
% LEAST TRIMMED SQUARES
% 2.	LTS bdp=0.5
% 3.	LTS bdp=0.25
% 4.	LTSr bdp=0.5 0.975
% 5.	LTSr bdp=0.25 0.975
%
% 6.	FS (FORWARD SEARCH)
%
% TUKEY BIWEIGHT
% 7.	S with Tukey biweight bdp =0.25
% 8.	S with Tukey biweight bdp =0.5
% 9.	MM with Tukey biweight eff =0.85  bdp=0.5
% 10.	MM with Tukey biweight eff =0.90  bdp=0.5
% 11.	MM with Tukey biweight eff =0.95  bdp=0.5
% HYPERBOLIC
% 12.	S with hyperbolic tangent bdp =0.25
% 13.	S with hyperbolic tangent bdp =0.5
% 14.	MM with hyperbolic tangent eff =0.85  bdp=0.5
% 15.	MM with hyperbolic tangent eff =0.90  bdp=0.5
% 16.	MM with hyperbolic tangent eff =0.95  bdp=0.5
% HAMPEL
% 17.	S with Hampel bdp =0.25
% 18.	S with Hampel bdp =0.5
% 19.	MM with Hampel eff =0.85  bdp=0.5
% 20.	MM with Hampel eff =0.90  bdp=0.5
% 21.	MM with Hampel eff =0.95  bdp=0.5
%  OPTIMAL
% 22.	S with optimal bdp =0.25
% 23.	S with optimal bdp =0.5
% 24.	MM with optimal eff =0.85  bdp=0.5
% 25.	MM with optimal eff =0.90  bdp=0.5
% 26.	MM with optimal eff =0.95  bdp=0.5
%  Power divergence
% 27.	S with optimal bdp =0.25
% 28.	S with optimal bdp =0.5
% 29.	MM with optimal eff =0.85  bdp=0.5
% 30.	MM with optimal eff =0.90  bdp=0.5
% 31.	MM with optimal eff =0.95  bdp=0.5



% Store scaled residuals (first n columns) individual size (column
% n+1)simultaneous size (column n+2) and median of scaled squared residuals
% (column n+3)
% estimate of scale (column n+4)
OLSbdp0=zeros(nsimul,n+4);
LTSbdp050=OLSbdp0;
LTSbdp025=OLSbdp0;
LTSrbdp050=OLSbdp0;
LTSrbdp025=OLSbdp0;
% Tukey biweght
Sbdp025TB=OLSbdp0;
Sbdp050TB=OLSbdp0;
MMeff085TB=OLSbdp0;
MMeff090TB=OLSbdp0;
MMeff095TB=OLSbdp0;
% Optimal
Sbdp025OP=OLSbdp0;
Sbdp050OP=OLSbdp0;
MMeff085OP=OLSbdp0;
MMeff090OP=OLSbdp0;
MMeff095OP=OLSbdp0;
% Hyperbolic
Sbdp025HY=OLSbdp0;
Sbdp050HY=OLSbdp0;
MMeff085HY=OLSbdp0;
MMeff090HY=OLSbdp0;
MMeff095HY=OLSbdp0;
% Hampel
Sbdp025HA=OLSbdp0;
Sbdp050HA=OLSbdp0;
MMeff085HA=OLSbdp0;
MMeff090HA=OLSbdp0;
MMeff095HA=OLSbdp0;
% Power Divergence
Sbdp025PD=OLSbdp0;
Sbdp050PD=OLSbdp0;
MMeff085PD=OLSbdp0;
MMeff090PD=OLSbdp0;
MMeff095PD=OLSbdp0;

% FS has an additional column because it also contains the interval (simultaneous) size
FS=zeros(nsimul,n+5);

% nest= number of estimators
nest=31;


% sest = scalar which indicates if it is necessary ot use sample estimate
% of sigma (sest=1) or true sigma (sest not equal 1)
sigmaest=1;



% distrib = scalar which specified distribution used to generate response
% in each simulation
% distrib=1 ===> normal
% distrib=2 ===> Student T
% distrib=3 ===> chi squared
distrib =1;

% df = degrees of freedom of student T distribution o chi squared used to generate y
df=5;

% truesigma2 = true variance of y
if distrib==1
    truesigma2=1;
    distribs='n';
elseif distrib==2
    truesigma2 = df/(df-2);
    distribs='t';
elseif distrib==3
    truesigma2 = 2*df;
    distribs='c';
end


X=randn(n,p-1);

% Use the following instruction just in case you want to use to generate
% the explanatory variables from a chi2 distribution
%X=chi2rnd(df,n,p-1)

XX=[ones(n,1) X];

% XX1=inv(XX'*XX)*(XX');
XX1=(XX'*XX)\(XX');

% thresh and treshBonf = individual and simultaneous thresholds to declare
% outliers
thresh=chi2inv(0.99,1);
threshBonf=chi2inv(1-0.01/n,1);
treshF=finv(0.99,1,n-p-1);
treshFBonf=finv(1-0.01/n,1,n-p-1);

% nsamp = number of subset used to find robust estimators
nsamp=1000;

seq=1:n;

% R2thresh = scalar which specifies the average value of R2 of the
% regression model you wish to generate
R2thresh=0.7;


if distrib ==1 % generate data from normal
    yysim=randn(n,nsimul);
elseif distrib==2 % generate data from Student T
    % generate data from T
    yysim=trnd(df,n,nsimul);
elseif distrib==3 % generate data from chi2 distribution
    yysim=chi2rnd(df,n,nsimul);
else
    error('Not implemented yet')
end

pwaitbar = ProgressBar(nsimul);

parfor j=1:nsimul

    ysim=yysim(:,j);


    % Uncomment the following instruction if you want to generate
    % simulated data with a prefixed value of R2 as established in scalar
    % R2thresh
    % ysim=simfixedR2(X,ysim,R2thresh);



    % TODO in the future contaminate data
    % ysim(trueout,:)=ysim(trueout,:)+lambda;


    %% 1.	OLS
    bOLS= XX1*ysim;

    if sigmaest==1
        resOLS2=(ysim-XX*bOLS).^2;
        sOLS2=sum(resOLS2)/(n-p-1);
    else
        sOLS2=truesigma2;
    end
    [res,sizeind,sizesim,medres2]=ResandSize(ysim,XX,bOLS,sOLS2,thresh,threshBonf);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%     residui=regstats();
%     residui^2
% 
%     n=length(y);
% res=y-X*b;
% res2=res.^2;
% 
% reschi2=res2/sigma2;
% 
% 
% % sizeind = indidividual size for simulation j
% sizeind=sum(reschi2>thresh)/n;
% % sizesim = simultaneous size for simulation j
% if sum(reschi2>threshBonf)>0
%     sizesim=1;
% else
%     sizesim =0;
% end
% 
% %medres2 = median of squared scaled residuals
% medres2=median(reschi2);
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



    % STORING FOR OLS
    OLSbdp0(j,:)=[res' sizeind sizesim medres2 sOLS2];

    %% 2.LTS bdp=0.5
    outLXS=LXS(ysim,X,'nsamp',nsamp,'lms',0,'msg',0,'bdp',0.5);
    [res,sizeind,sizesim,medres2]=ResandSize(ysim,XX,outLXS.beta,outLXS.scale^2,thresh,threshBonf);

    % STORING FOR LTS
    LTSbdp050(j,:)=[res' sizeind sizesim medres2 outLXS.scale^2];

    %% 3.LTS bdp=025
    outLXS=LXS(ysim,X,'nsamp',nsamp,'lms',0,'msg',0,'bdp',0.25);
    [res,sizeind,sizesim,medres2]=ResandSize(ysim,XX,outLXS.beta,outLXS.scale^2,thresh,threshBonf);

    % STORING FOR LTS
    LTSbdp025(j,:)=[res' sizeind sizesim medres2 outLXS.scale^2];

    %% 4.LTS (reweighted)  bdp=0.5
    outLXSr=LXS(ysim,X,'nsamp',nsamp,'lms',0,'msg',0,'bdp',0.5,'rew',1);
    [res,sizeind,sizesim,medres2]=ResandSize(ysim,XX,outLXSr.beta,outLXSr.scale^2,thresh,threshBonf);

    % STORING FOR LTSreweighted
    LTSrbdp050(j,:)=[res' sizeind sizesim medres2 outLXSr.scale^2];

    %% 5.LTS (reweighted)  bdp=0.25
    outLXSr=LXS(ysim,X,'nsamp',nsamp,'lms',0,'msg',0,'bdp',0.25,'rew',1);
    [res,sizeind,sizesim,medres2]=ResandSize(ysim,XX,outLXSr.beta,outLXSr.scale^2,thresh,threshBonf);

    % STORING FOR LTSreweighted
    LTSrbdp025(j,:)=[res' sizeind sizesim medres2 outLXSr.scale^2];


    %%  6.	FS
    outFS=FSR(ysim,X,'nsamp',nsamp,'msg',0,'plots',0,'init',round(n/2));

    good=setdiff(seq,outFS.ListOut);
    Xgood=XX(good,:);
    ygood=ysim(good);
    bgood=Xgood\ygood;

    resbsb=ygood-Xgood*bgood;
    res2=resbsb.^2;
    sFS2=sum(res2)/(length(ygood)-p-1);

    [res,sizeind,sizesim,medres2]=ResandSize(ysim,XX,bgood,sFS2,thresh,threshBonf);

    % STORING FOR FS
    if ~isnan(outFS.ListOut)
        sizeFS=1;
    else
        sizeFS=0;
    end

    FS(j,:)=[res' sizeind sizesim medres2 sFS2 sizeFS];

    %%  7.	S with Tukey biweight bdp =0.25
    outS=Sreg(ysim,X,'nsamp',nsamp,'msg',0,'rhofunc','bisquare','bdp',0.25);
    [res,sizeind,sizesim,medres2]=ResandSize(ysim,XX,outS.beta,outS.scale^2,thresh,threshBonf);

    % STORING FOR S bdp =0.25
    Sbdp025TB(j,:)=[res' sizeind sizesim medres2 outS.scale^2];

    %%  8.	S with Tukey biweight bdp =0.5
    outS=Sreg(ysim,X,'nsamp',nsamp,'msg',0,'rhofunc','bisquare','bdp',0.5);
    [res,sizeind,sizesim,medres2]=ResandSize(ysim,XX,outS.beta,outS.scale^2,thresh,threshBonf);

    % STORING FOR S bdp =0.5
    Sbdp050TB(j,:)=[res' sizeind sizesim medres2 outS.scale^2];

    %% 9.	MM with Tukey biweight eff =0.85  bdp=0.5
    outMM=MMregcore(ysim,X,outS.beta,outS.scale,'rhofunc','bisquare','eff',0.85);

    [res,sizeind,sizesim,medres2]=ResandSize(ysim,XX,outMM.beta,outS.scale^2,thresh,threshBonf);

    % STORING FOR MM eff =0.85
    MMeff085TB(j,:)=[res' sizeind sizesim medres2 outS.scale^2];

    %% 10.	MM with Tukey biweight eff =0.90  bdp=0.5
    outMM=MMregcore(ysim,X,outS.beta,outS.scale,'rhofunc','bisquare','eff',0.90);

    [res,sizeind,sizesim,medres2]=ResandSize(ysim,XX,outMM.beta,outS.scale^2,thresh,threshBonf);

    % STORING FOR MM eff =0.90
    MMeff090TB(j,:)=[res' sizeind sizesim medres2 outS.scale^2];

    %% 11.	MM with Tukey biweight eff =0.95  bdp=0.5
    outMM=MMregcore(ysim,X,outS.beta,outS.scale,'rhofunc','bisquare','eff',0.95);

    [res,sizeind,sizesim,medres2]=ResandSize(ysim,XX,outMM.beta,outS.scale^2,thresh,threshBonf);

    % STORING FOR MM eff =0.95
    MMeff095TB(j,:)=[res' sizeind sizesim medres2 outS.scale^2];

    %%  12.	S with Optimal bdp =0.25
    outS=Sreg(ysim,X,'nsamp',nsamp,'msg',0,'rhofunc','optimal','bdp',0.25);
    [res,sizeind,sizesim,medres2]=ResandSize(ysim,XX,outS.beta,outS.scale^2,thresh,threshBonf);

    % STORING FOR S bdp =0.25
    Sbdp025OP(j,:)=[res' sizeind sizesim medres2 outS.scale^2];

    %%  13.	S with Optimal bdp =0.5
    outS=Sreg(ysim,X,'nsamp',nsamp,'msg',0,'rhofunc','optimal','bdp',0.5);
    [res,sizeind,sizesim,medres2]=ResandSize(ysim,XX,outS.beta,outS.scale^2,thresh,threshBonf);

    % STORING FOR S bdp =0.5
    Sbdp050OP(j,:)=[res' sizeind sizesim medres2 outS.scale^2];

    %% 14.	MM with Optimal eff =0.85  bdp=0.5
    outMM=MMregcore(ysim,X,outS.beta,outS.scale,'rhofunc','optimal','eff',0.85);

    [res,sizeind,sizesim,medres2]=ResandSize(ysim,XX,outMM.beta,outS.scale^2,thresh,threshBonf);

    % STORING FOR MM eff =0.85
    MMeff085OP(j,:)=[res' sizeind sizesim medres2 outS.scale^2];

    %% 15.	MM with Optimal eff =0.90  bdp=0.5
    outMM=MMregcore(ysim,X,outS.beta,outS.scale,'rhofunc','optimal','eff',0.90);

    [res,sizeind,sizesim,medres2]=ResandSize(ysim,XX,outMM.beta,outS.scale^2,thresh,threshBonf);

    % STORING FOR MM eff =0.90
    MMeff090OP(j,:)=[res' sizeind sizesim medres2 outS.scale^2];

    %% 16.	MM with Optimal eff =0.95  bdp=0.5
    outMM=MMregcore(ysim,X,outS.beta,outS.scale,'rhofunc','optimal','eff',0.95);

    [res,sizeind,sizesim,medres2]=ResandSize(ysim,XX,outMM.beta,outS.scale^2,thresh,threshBonf);

    % STORING FOR MM eff =0.95
    MMeff095OP(j,:)=[res' sizeind sizesim medres2 outS.scale^2];

    %%  17. S with Hyperbolic bdp =0.25
    outS=Sreg(ysim,X,'nsamp',nsamp,'msg',0,'rhofunc','hyperbolic','bdp',0.25);
    [res,sizeind,sizesim,medres2]=ResandSize(ysim,XX,outS.beta,outS.scale^2,thresh,threshBonf);

    % STORING FOR S bdp =0.25
    Sbdp025HY(j,:)=[res' sizeind sizesim medres2 outS.scale^2];

    %%  18. S with Hyperbolic bdp =0.5
    outS=Sreg(ysim,X,'nsamp',nsamp,'msg',0,'rhofunc','hyperbolic','bdp',0.5);
    [res,sizeind,sizesim,medres2]=ResandSize(ysim,XX,outS.beta,outS.scale^2,thresh,threshBonf);

    % STORING FOR S bdp =0.5
    Sbdp050HY(j,:)=[res' sizeind sizesim medres2 outS.scale^2];

    %% 19.  MM with Hyperbolic eff =0.85  bdp=0.5
    outMM=MMregcore(ysim,X,outS.beta,outS.scale,'rhofunc','hyperbolic','eff',0.85);

    [res,sizeind,sizesim,medres2]=ResandSize(ysim,XX,outMM.beta,outS.scale^2,thresh,threshBonf);

    % STORING FOR MM eff =0.85
    MMeff085HY(j,:)=[res' sizeind sizesim medres2 outS.scale^2];

    %% 20.  MM with Hyperbolic eff =0.90  bdp=0.5
    outMM=MMregcore(ysim,X,outS.beta,outS.scale,'rhofunc','hyperbolic','eff',0.90);

    [res,sizeind,sizesim,medres2]=ResandSize(ysim,XX,outMM.beta,outS.scale^2,thresh,threshBonf);

    % STORING FOR MM eff =0.90
    MMeff090HY(j,:)=[res' sizeind sizesim medres2 outS.scale^2];

    %% 21.  MM with Hyperbolic eff =0.95  bdp=0.5
    outMM=MMregcore(ysim,X,outS.beta,outS.scale,'rhofunc','hyperbolic','eff',0.95);

    [res,sizeind,sizesim,medres2]=ResandSize(ysim,XX,outMM.beta,outS.scale^2,thresh,threshBonf);

    % STORING FOR MM eff =0.95
    MMeff095HY(j,:)=[res' sizeind sizesim medres2 outS.scale^2];

    %%  22. S with Hampel bdp =0.25
    outS=Sreg(ysim,X,'nsamp',nsamp,'msg',0,'rhofunc','hampel','bdp',0.25);
    [res,sizeind,sizesim,medres2]=ResandSize(ysim,XX,outS.beta,outS.scale^2,thresh,threshBonf);

    % STORING FOR S bdp =0.25
    Sbdp025HA(j,:)=[res' sizeind sizesim medres2 outS.scale^2];

    %%  23. S with Hampel bdp =0.5
    outS=Sreg(ysim,X,'nsamp',nsamp,'msg',0,'rhofunc','hampel','bdp',0.5);
    [res,sizeind,sizesim,medres2]=ResandSize(ysim,XX,outS.beta,outS.scale^2,thresh,threshBonf);

    % STORING FOR S bdp =0.5
    Sbdp050HA(j,:)=[res' sizeind sizesim medres2 outS.scale^2];

    %% 24.  MM with Hampel eff =0.85  bdp=0.5
    outMM=MMregcore(ysim,X,outS.beta,outS.scale,'rhofunc','hampel','eff',0.85);

    [res,sizeind,sizesim,medres2]=ResandSize(ysim,XX,outMM.beta,outS.scale^2,thresh,threshBonf);

    % STORING FOR MM eff =0.85
    MMeff085HA(j,:)=[res' sizeind sizesim medres2 outS.scale^2];

    %% 25.  MM with Hampel eff =0.90  bdp=0.5
    outMM=MMregcore(ysim,X,outS.beta,outS.scale,'rhofunc','hampel','eff',0.90);

    [res,sizeind,sizesim,medres2]=ResandSize(ysim,XX,outMM.beta,outS.scale^2,thresh,threshBonf);

    % STORING FOR MM eff =0.90
    MMeff090HA(j,:)=[res' sizeind sizesim medres2 outS.scale^2];

    %% 26.  MM with Hampel eff =0.95  bdp=0.5
    outMM=MMregcore(ysim,X,outS.beta,outS.scale,'rhofunc','hampel','eff',0.95);

    [res,sizeind,sizesim,medres2]=ResandSize(ysim,XX,outMM.beta,outS.scale^2,thresh,threshBonf);

    % STORING FOR MM eff =0.95
    MMeff095HA(j,:)=[res' sizeind sizesim medres2 outS.scale^2];


    %%  27. S with PowerDivergence bdp =0.25
    outS=Sreg(ysim,X,'nsamp',nsamp,'msg',0,'rhofunc','mdpd','bdp',0.25);
    [res,sizeind,sizesim,medres2]=ResandSize(ysim,XX,outS.beta,outS.scale^2,thresh,threshBonf);

    % STORING FOR S bdp =0.25
    Sbdp025PD(j,:)=[res' sizeind sizesim medres2 outS.scale^2];

    %%  28. S with PowerDivergence bdp =0.5
    outS=Sreg(ysim,X,'nsamp',nsamp,'msg',0,'rhofunc','mdpd','bdp',0.5);
    [res,sizeind,sizesim,medres2]=ResandSize(ysim,XX,outS.beta,outS.scale^2,thresh,threshBonf);

    % STORING FOR S bdp =0.5
    Sbdp050PD(j,:)=[res' sizeind sizesim medres2 outS.scale^2];

    %% 29.  MM with PowerDivergence eff =0.85  bdp=0.5
    outMM=MMregcore(ysim,X,outS.beta,outS.scale,'rhofunc','mdpd','eff',0.85);

    [res,sizeind,sizesim,medres2]=ResandSize(ysim,XX,outMM.beta,outS.scale^2,thresh,threshBonf);

    % STORING FOR MM eff =0.85
    MMeff085PD(j,:)=[res' sizeind sizesim medres2 outS.scale^2];

    %% 30.  MM with PowerDivergence eff =0.90  bdp=0.5
    outMM=MMregcore(ysim,X,outS.beta,outS.scale,'rhofunc','mdpd','eff',0.90);

    [res,sizeind,sizesim,medres2]=ResandSize(ysim,XX,outMM.beta,outS.scale^2,thresh,threshBonf);

    % STORING FOR MM eff =0.90
    MMeff090PD(j,:)=[res' sizeind sizesim medres2 outS.scale^2];

    %% 31.  MM with PowerDivergence eff =0.95  bdp=0.5
    outMM=MMregcore(ysim,X,outS.beta,outS.scale,'rhofunc','mdpd','eff',0.95);

    [res,sizeind,sizesim,medres2]=ResandSize(ysim,XX,outMM.beta,outS.scale^2,thresh,threshBonf);

    % STORING FOR MM eff =0.95
    MMeff095PD(j,:)=[res' sizeind sizesim medres2 outS.scale^2];

    pwaitbar.progress; %#ok<PFBNS>
    %     if j==nsimul/2 || j==nsimul/4  || j==nsimul*0.75 || j==nsimul*0.9;
    %         disp(['Simul nr. ' num2str(j) ' n=' num2str(n)])
    %     end
end

pwaitbar.stop;

%% Compute size of the different estimators

% SIZ = matrix which contains the size of the 26 estimators which have been considered
% 1st col = individual size
% 2nd col = simultaneous size
% 3rd col = mean of medians of squared scaled residuals
SIZ=zeros(nest,4);
SIZ(1,:)=mean(OLSbdp0(:,n+1:end));
SIZ(2,:)=mean(LTSbdp050(:,n+1:end));
SIZ(3,:)=mean(LTSbdp025(:,n+1:end));
SIZ(4,:)=mean(LTSrbdp050(:,n+1:end));
SIZ(5,:)=mean(LTSrbdp025(:,n+1:end));
SIZ(6,:)=mean(FS(:,n+1:end-1));

% Tukey biweight
SIZ(7,:)=mean(Sbdp025TB(:,n+1:end));
SIZ(8,:)=mean(Sbdp050TB(:,n+1:end));
SIZ(9,:)=mean(MMeff085TB(:,n+1:end));
SIZ(10,:)=mean(MMeff090TB(:,n+1:end));
SIZ(11,:)=mean(MMeff095TB(:,n+1:end));

% Optimal
SIZ(12,:)=mean(Sbdp025OP(:,n+1:end));
SIZ(13,:)=mean(Sbdp050OP(:,n+1:end));
SIZ(14,:)=mean(MMeff085OP(:,n+1:end));
SIZ(15,:)=mean(MMeff090OP(:,n+1:end));
SIZ(16,:)=mean(MMeff095OP(:,n+1:end));

% Hyperbolic
SIZ(17,:)=mean(Sbdp025HY(:,n+1:end));
SIZ(18,:)=mean(Sbdp050HY(:,n+1:end));
SIZ(19,:)=mean(MMeff085HY(:,n+1:end));
SIZ(20,:)=mean(MMeff090HY(:,n+1:end));
SIZ(21,:)=mean(MMeff095HY(:,n+1:end));

% Hampel
SIZ(22,:)=mean(Sbdp025HA(:,n+1:end));
SIZ(23,:)=mean(Sbdp050HA(:,n+1:end));
SIZ(24,:)=mean(MMeff085HA(:,n+1:end));
SIZ(25,:)=mean(MMeff090HA(:,n+1:end));
SIZ(26,:)=mean(MMeff095HA(:,n+1:end));

% Power divergence
SIZ(27,:)=mean(Sbdp025PD(:,n+1:end));
SIZ(28,:)=mean(Sbdp050PD(:,n+1:end));
SIZ(29,:)=mean(MMeff085PD(:,n+1:end));
SIZ(30,:)=mean(MMeff090PD(:,n+1:end));
SIZ(31,:)=mean(MMeff095PD(:,n+1:end));



SIZ=real(SIZ);

% SizeFSint = size of FS which comes the internal procedure
SizeFSint=mean(FS(:,end));

savestring = ['save n' num2str(n) 'p' num2str(p) 'd' distribs 'df' num2str(df) 's' num2str(sigmaest) '.mat'];


% Clear all variables inside workspace except those which contain the
% strings bdp or eff or FS or SIZ or nsimul or savestring
clearvars -except *bdp* *eff* FS nsimul SIZ savestring p nest

% save the current workspace into nxpxdxdfxsx.mat
eval(savestring)


%% Plotting part
SIZZ=SIZ;
lab={'OLS','LTSbdp050','LTSbdp025','LTSrbdp050','LTSrbdp025','FS',...
    'Sbdp025TB','Sbdp050TB','MMeff085TB','MMeff090TB','MMeff095TB','Sbdp025OP','Sbdp050OP',...
    'MMeff085OP','MMeff090OP','MMeff095OP','Sbdp025HY','Sbdp050HY','MMeff085HY',...
    'MMeff090HY','MMeff095HY','Sbdp025HA','Sbdp050HA','MMeff085HA','MMeff090HA','MMeff095HA',...
    'Sbdp025PD','Sbdp050PD','MMeff085PD','MMeff090PD','MMeff095PD'};
% reshuffle=[1 8 23 13 18   7 22 12 17    9 24 14 19   10 25 15 20    11 26 16 21  2 3 4 5 6];
reshuffle=[1 8 23 13 18 28  7 22 12 17 27    9 24 14 19 29  10 25 15 20 30   11 26 16 21 31 2 3 4 5 6];

% old reshuffle
% reshuffle=[1:5 7:length(lab) 6];
lab=lab(reshuffle);
SIZZ=SIZZ(reshuffle,:,:);


% Plot individual size or simultaneous size
close all

% ind=1 ==> individual size    ind==2 ==>sim size
ind=1;

%FontSize= scalar controlling font size of x labels;
FontSize=8;
% sel = vector which selects the estimators to plot
sel=1:nest;
xaxis=sel';

color='r';
%subplot(2,1,1)

positionVector1 = [0.13 0.62+0.07 0.775 0.301163];
subplot('Position',positionVector1)


hold('on')
labsor=lab;
for j=1:1
    sel1=2:11;
    lwd=3;
    plot(xaxis(sel1),SIZZ(sel1,ind,j),'o','MarkerFaceColor','k','MarkerSize',7,'LineWidth',lwd)
    sel1=12:26;
    plot(xaxis(sel1),SIZZ(sel1,ind,j),'o','MarkerFaceColor','k','MarkerSize',7,'LineWidth',lwd)
    sel1=27:30;
    plot(xaxis(sel1),SIZZ(sel1,ind,j),'o','MarkerFaceColor','k','MarkerSize',7,'LineWidth',lwd)
    sel1=[1 nest];
    plot(xaxis(sel1),SIZZ(sel1,ind,j),'o','MarkerFaceColor','k','MarkerSize',7)

    v=axis;
    % ylim([0.005, v(4)])
    ylim([min(min(SIZZ(:,ind,j))),max(max(SIZZ(:,ind,j)))])

    annotation('doublearrow',[0.15 0.39],[0.9 0.9]);
    text(0.2,0.85,'S estimators','Units','normalized','HorizontalAlignment','center','FontSize',16)

    annotation('doublearrow',[0.40 0.775],[0.9 0.9]);
    text(0.56,0.85,'MM estimators','Units','normalized','HorizontalAlignment','center','FontSize',16)

    annotation('doublearrow',[0.80 0.875],[0.9 0.9]);
    text(0.89,0.85,'LTS','Units','normalized','HorizontalAlignment','center','FontSize',16)


end
xaxis=1:nest;
line(xaxis,0.01*ones(length(xaxis),1),'Color',color)
xlim([xaxis(1) xaxis(end)])
set(gca,'Xtick',xaxis)
set(gca,'Xticklabel',labsor,'FontSize',14)
ylabel(['p= ' num2str(p) ' ind size'],'FontSize',16)
set(gca,'XGrid','on')


%if v(4)>0.05
%end
% title(pddfs)

%subplot(2,1,2)

positionVector1 = [0.13 0.20 0.775 0.291163];

subplot('Position',positionVector1)

% ind=1 ==> individual size    ind==2 ==>sim size
ind=2;

color='r';
%subplot(2,1,1)

hold('on')
labsor=lab;
for j=1:1
    sel1=2:11;
    lwd=3;
    plot(xaxis(sel1),SIZZ(sel1,ind,j),'o','MarkerFaceColor','k','MarkerSize',7,'LineWidth',lwd)
    sel1=12:26;
    plot(xaxis(sel1),SIZZ(sel1,ind,j),'o','MarkerFaceColor','k','MarkerSize',7,'LineWidth',lwd)
    sel1=27:30;
    plot(xaxis(sel1),SIZZ(sel1,ind,j),'o','MarkerFaceColor','k','MarkerSize',7,'LineWidth',lwd)
    sel1=[1 nest];
    plot(xaxis(sel1),SIZZ(sel1,ind,j),'o','MarkerFaceColor','k','MarkerSize',7)

    v=axis;
    % ylim([0.005, v(4)])
    ylim([min(min(SIZZ(:,ind,j))),max(max(SIZZ(:,ind,j)))])

    annotation('doublearrow',[0.15 0.39],[0.4 0.4]);
    text(0.2,0.85,'S estimators','Units','normalized','HorizontalAlignment','center','FontSize',16)

    annotation('doublearrow',[0.40 0.775],[0.4 0.4]);
    text(0.56,0.85,'MM estimators','Units','normalized','HorizontalAlignment','center','FontSize',16)

    annotation('doublearrow',[0.80 0.875],[0.4 0.4]);
    text(0.89,0.85,'LTS','Units','normalized','HorizontalAlignment','center','FontSize',16)


end
xaxis=1:nest;
line(xaxis,0.01*ones(length(xaxis),1),'Color',color)
xlim([xaxis(1) xaxis(end)])
set(gca,'Xtick',xaxis)
set(gca,'Xticklabel',labsor,'FontSize',14)
ylabel(['p= ' num2str(p) ' sim size'],'FontSize',16)
set(gca,'XGrid','on')


% prin=0;
% if prin==1
%
%       %  print -depsc figs\sizen50p2-10ind.eps;
%       if ind==1
%         printstring=['figs\sizen' num2str(n) 'p2-10ind.eps'];
%       else
%          printstring=['figs\sizen' num2str(n) 'p2-10sim.eps'];
%       end
%         print('-depsc',printstring);
% end

end