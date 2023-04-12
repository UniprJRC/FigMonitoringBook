
%% Parameter setting

% In this program we fix
% the centroid of the ellipsoid (containing the outliers)
% and we determine the distance from the plane containing the
% regression model

close all;

% pri = dummy variables which controls whether we need to print postcript
% the figures
prin=0;


%
%-----------------------------------------------------------------------
%---------------------------------Beginning of paramter setting
%-----------------------------------------------------------------------

% set random number generator
s = rng(44123,'twister');

% p = is the size of the hyperplane which contains the explanatory
% variables
p=1;


% beta=(1:p)'; %
% beta = true set of regression coefficients for good observations
%beta=[ 2 4 1]';
% As the values of the beta tend to become smaller the probability of
% overlapping increases
% When values of beta increase the probability fo overlapping decreases
% See the interaction with the starting point of the loop for lam
beta=[ 4 2 3]';
beta=1*ones(p,1);
%  beta=0.01*[ 1 2 3]';
% beta=100*[ 1 2 3]';
beta=beta(1:p);

% Define \Sigma (true covariance matrix of the [X] variables)
SigmaX=eye(p);

% Set the std deviation of the y
% When sigmay increases the probability of overlapping increases
sigmay=10;

% bunif = upper extreme of each coordinate of X
% As the range of the explanatory variables increases the probability of
% intersection tends to stay on high values and then suddenly decrease
% (like a panettone)
% bunif=[1000 400 1500];
%bunif=[1 4 5];
bunif=10*[1 1 1 1*ones(1,12)];
bunif=2*[1 1 1 1*ones(1,12)];

%bunif=[2 12 13 3*ones(1,12)];
bunif=bunif(1:p);

% aunif = lower extreme of each coordinate of X
aunif=[0 0 0 zeros(1,12)];
aunif=aunif(1:p);

% n1 and n2 = number of observations belonging to two populations
% n1 = regression plane population P1 (good units)
% n2 = ellipsoid population P2 (outliers)
n1=100;
n2=20;


% alpha = constant of the plane with equation beta'x-y+alpha=0 Increasing
% (in absolute value) the constant causes the probability of overlapping
% and the empirical frequency of overlapping to behave like a triangle
% with a very small basis. On the other hand, as alpha gets closer to 0 the
% area of the triangle becomes wider and wider
alpha=10;

% Initial location of the outliers
mu2ini=10*ones(p+1,1);
mu2ini=3.4*ones(p+1,1);
%mu2ini=10*ones(p+1,1);

% mu2ini=[2;-20]/5;


% The centroid of the ellipsoid containing the outliers will be computed
% for each value of the sequence lam
% lam=[-4 -3 -2  2 3 4 5];
% lam=[-7:0.5:-5 5:0.5:7];

% lam=[-3:0.5:5];

lam=[-1.3:0.5:3.7];
lam=[-4:0.5:-0.5 1.5:0.5:5];
lam=[-3.1:0.2:-0.5 2.1:0.2:3.5];
lam=[-1:0.3:2.6];
lam=[-1:0.5:2.6];
lam=[4.5:0.5:7];
lam=[-3:0.5:4];
lam=[1.5:0.5:9];


% Sigmaout = covariance matrix of the outliers
% of size p+1
% Notice that increasing the coefficient in front of the identity matrix
% decreases both the probability and the empirical frequency of overlapping
Sigmaout=20*eye(p+1);
Sigmaout=eye(p+1);
% Sigmaout(3,3)=0.1;
% Sigmaout(4,4)=0.1;
% Sigmaout(5,5)=0.1;
% Sigmaout(1,1)=20;
%
% Sigmaout(1,2:end)=2;
% Sigmaout(2:end,1)=2;
% Sigmaout(1,1)=100;
 Sigmaout(2,2)=0.1;
 Sigmaout(1,1)=4;

% Compute the shifted point where the centroid of the
% ellipsoid has to pass when lam=1
% kk controls the amount of shifting
kk=2;


% nsimul = total number of simulations which have to be run
nsimul=100;

% nsamp = number of samples to extract
nsamp=2000;
Snsamp=2000;

% est = dummy variable
% If est = 1 estimation method
% else only the plot
est=1;

%
%-----------------------------------------------------------------------
%---------------------------------End of paramter setting
%-----------------------------------------------------------------------


% n total number of observations = good units + outliers
n=n1+n2;


% Compute 1/variance of the uniform distribution which was used to generate
% the design matrix
varunif=12./((bunif-aunif).^2);


% design matrix X (generate once and for all)
Xsim = rand(n1,p);
Xsim = bsxfun(@times,Xsim, bunif-aunif);
Xsim = bsxfun(@plus,Xsim, aunif);
Xsim = Xsim*chol(SigmaX);


% Compute yxmean (that is [y(\overline x) \overline x ]), average of y in
% correspondence of average of x and average of each elements of x This
% value will be used to compute the MD from the plane to the centroid of
% the ellipsoid (mud), for each value of lambda
xmean=0.5*(aunif+bunif);
ymean=xmean*beta+alpha;
yxmean=[ymean,xmean]';

% Compute the shifted point where the centroid of the
% ellipsoid has to pass when lam=1
% kk controls the amount of shifting
xmean1=0.5*(aunif+bunif)+kk;
ymean1=xmean1*beta+alpha;
yxmean1=[ymean1,xmean1]';


% llam= length of vector lama
llam=length(lam);
lamx=lam';
lamxlab=num2str(lamx);

% pro will contain the probability of overlapping as a function of \lambda
pro=zeros(llam,1);

% mala will contain
% 1st col = Mahalanobis distance between yxmean (centroid of the hyperplane)
% and mud (centroid of the ellipsoid containing the outliers) in the metric
% of mud (Sigmaout is used)
mala=zeros(llam,2);

% Remark: the first element of b is associated with y

ij=0;
% vector of size p+1
b=[1;-beta];


% frover = vector which will contain the relative frequencey of
% intersection of the units  generated by PI2 with the portion of the space
% in which (y x) lie
frover=zeros(llam,1);


% 1st column = simultaneous power
% 2nd column = average power
% 3th column = lower value of boxplot for beta
% 4th column = upper value of boxplot for beta
% 5th column = median of beta values
% 6th column = (empirical bias of alpha)^2
% 7th column = empirical variance of alpha hat
% 8th column = (empirical bias of beta)^2
% 9th column = empirical variance of beta hat
% 10th colum =
% 11th colum =
% 12th colum =
% 13th colum =
StoFS=zeros(llam,13);
StoLT=StoFS;
StoLTr=StoFS;
StoS=StoFS;
StoMM=StoFS;


% Store for each simulation the distribution of values of the intercept
% and of the slope for the three methods
FSAA=zeros(nsimul,llam);
FSBB=zeros(nsimul,p,llam);

LTAA=FSAA;
LTBB=FSBB;

LTAAr=FSAA;
LTBBr=FSBB;

SAA=FSAA;
SBB=FSBB;

MMAA=FSAA;
MMBB=FSBB;


conflev=[0.99, 1-0.01/n];
%clev=0.99;
% clev=0.975;
clev=conflev(2);

seq=(1:n)';
% indout = indexes of the units forming the group of outliers
indout=(n1+1):n;

one=ones(n,1);

% Xysto = 3 dimensional matrix which contains the simulated values for the first
% simulation just to have an idea about the pattern of the data
Xysto=zeros(n,p+1,length(lam));


ijl=0;

% sel=round(length(lam)*[0.05 0.35 0.65 0.95]);
sel=round(quantile(1:llam,9));
sel(1)=1;
sel(end)=llam;

% This is the main loop
% We are going to store a series of measures for each value of la
for la=lam;
    
    % mud  = (muout) new centroid  of the ellipsoid which contains the outliers as a
    % function of la. Note that when la=1 then mud coincides with yxmean1
    mud=la*yxmean1+(1-la)*mu2ini;
    
    % variable ij is associated with the rows of matrix lam
    ij=ij+1;
    
    % pro = probability of overlapping for each value of la
    pro(ij)=prover1(b,mud,Sigmaout,alpha,sigmay);
    
    % Find the distance of the two centroids in the metric of PI2
    % (outlier population) for each value of la
    mal=mahalFS(yxmean',mud',Sigmaout);
    mala(ij,:)=[mal,1-chi2cdf(mal,p+1)];
    
    % fremp = initialization of the empirical frequency of overlapping
    % computed for each vlaue of la
    fremp=0;
    
    
    % FSab contains
    % 1st column : (p+1)th column = estimate of the estimated regr
    % coefficients
    % (p+2)-th column = total number of units declared as outliers
    % (p+3)-th column = total number of true units declared as outliers
    % (p+4)-th column = total number of outliers with positive sign among total
    % number of outliers
    % (p+5)-th column = total number of outliers with positive sign among total
    % number of true outliers
    % (p+6)-th column = total number of outliers with negative sign among total
    % number of outliers
    % (p+7)-th column = total number of outliers with negative sign among total
    % number of true outliers
    
    FSab=zeros(nsimul,p+7);
    LTab=FSab;
    LTabr=FSab;
    Sab=FSab;
    MMab=FSab;
    
    % For each value of la there is the simulation study
    for j=1:nsimul
        
        
        % Xout = matrix which contains the coordinates of the outliers
        % Note that the first column of matrix Xout is associated with the
        % response and the other columns with the explanatory variables
        yXout = mvnrnd(mud,Sigmaout,n2);
        
        % Xsimj = design matrix for simulation j
        % The first part of the design matrix refers to the hyperplane and is
        % fixed once and for all
        % The second part is associated with the x coordinates of the group of
        % outliers
        Xsimj=[Xsim;yXout(:,2:end)];
        
        % ysimj = response for simulation j
        ysim = Xsim*beta +alpha+sigmay*randn(n1,1);
        ysimj = [ysim; yXout(:,1)];
        
        % Now compute empirically the frequency of observations from PI2 which
        % fall inside the space determined by (aj bj) j=1, ..., p and
        for i=1:n2
            rt=yXout(i,:)';
            
            % Construct the limits of the portion of the
            % (p+1)-dimensional hyperspace which contains
            % the values of (y x)
            yxminy=yXout(i,2:end)*beta+alpha-2*sigmay;
            yxmaxy=yXout(i,2:end)*beta+alpha+2*sigmay;
            
            yxmin=[yxminy,aunif]';
            yxmax=[yxmaxy,bunif]';
            
            
            % [rt yxmin yxmax  (rt>yxmin & rt<yxmax)]
            if sum(rt>yxmin & rt<yxmax)==p+1
                fremp=fremp+1;
            end
        end
        
        
        % Store simulated values just for the first simulation
        if j==1
            Xysto(:,:,ij)=[Xsimj ysimj];
        end
        
        if est==1
            % FSR for simulation j
            [out]=FSR(ysimj,Xsimj,'nsamp',nsamp,'plots',0,'msg',0,'init',n/2);
            good=setdiff(seq,out.ListOut);
            Xgood=[ones(length(good),1) Xsimj(good,:)];
            ygood=ysimj(good);
            bgood=Xgood\ygood;
            
            % Store a and b of the estimated regression line (plane)
            FSab(j,1:p+1)=bgood';
            if ~isnan(out.ListOut)
                
                res=ysimj-[one Xsimj]*bgood;
                % Number of positive residuals among the outliers
                outpos=sum(res(out.ListOut)>0);
                % Number of positive residuals among the outliers
                outneg=sum(res(out.ListOut)<0);
                
                % List of true outliers
                trueout=intersect(out.ListOut,indout);
                % Number of positive residuals among the true outliers
                outtruepos=sum(res(trueout)>0);
                % Number of negative residuals among the true outliers
                outtrueneg=sum(res(trueout)<0);
                
                % Store
                % (p+2)-th col total number of units declared as outliers in third column
                % (p+3)-th col total number of true outliers
                % (p+4)-th col total number of positive outliers
                % (p+5)-thcol total number of true positive outliers
                % (p+6)-th col total number of negative outliers
                % (p+7)-th col total number of true negative outliers
                FSab(j,p+2:p+7)=[length(out.ListOut) length(trueout) outpos outtruepos outneg outtrueneg];
                
            end
            
            % LTS raw
            [outLTS]=LXS(ysimj,Xsimj,'nsamp',nsamp,'conflev',clev,'lms',0,'msg',0);
            %pause;
            good=setdiff(seq,outLTS.outliers);
            Xgood=[ones(length(good),1) Xsimj(good,:)];
            ygood=ysimj(good);
            bgood=Xgood\ygood;
%             LTab(j,1:p+1)=bgood';
            LTab(j,1:p+1)=outLTS.beta';
            
            if ~isempty(outLTS.outliers)
                res=ysimj-[one Xsimj]*bgood;
                % Number of positive residuals among the outliers
                outpos=sum(res(outLTS.outliers)>0);
                % Number of positive residuals among the outliers
                outneg=sum(res(outLTS.outliers)<0);
                
                
                % List of true outliers
                trueout=intersect(outLTS.outliers,indout);
                % Number of positive residuals among the true outliers
                outtruepos=sum(res(trueout)>0);
                % Number of negative residuals among the true outliers
                outtrueneg=sum(res(trueout)<0);
                
                
                % Store
                % total number of units declared as outliers in third column
                % total number of true outliers
                LTab(j,p+2:p+7)=[length(outLTS.outliers) length(trueout) outpos outtruepos outneg outtrueneg];
            end
            
            
            % LTS with reweighting
            [outLTSr]=LXS(ysimj,Xsimj,'nsamp',nsamp,'conflev',clev,'rew',1,'lms',0,'msg',0);
            good=setdiff(seq,outLTSr.outliers);
            Xgood=[ones(length(good),1) Xsimj(good,:)];
            ygood=ysimj(good);
            bgood=Xgood\ygood;
%             LTabr(j,1:p+1)=bgood';
            LTabr(j,1:p+1)=outLTSr.beta';
            
            if ~isempty(outLTSr.outliers)
                res=ysimj-[one Xsimj]*bgood;
                % Number of positive residuals among the outliers
                outpos=sum(res(outLTSr.outliers)>0);
                % Number of negative residuals among the outliers
                outneg=sum(res(outLTSr.outliers)<0);
                
                % List of true outliers
                trueout=intersect(outLTSr.outliers,indout);
                % Number of positive residuals among the true outliers
                outtruepos=sum(res(trueout)>0);
                % Number of negative residuals among the true outliers
                outtrueneg=sum(res(trueout)<0);
                
                
                % Store
                % total number of units declared as outliers in third column
                % total number of true outliers
                LTabr(j,p+2:p+7)=[length(outLTSr.outliers) length(trueout) outpos outtruepos outneg outtrueneg];
            end
            
            
            % S estimators
            [outS]=Sreg(ysimj,Xsimj,'nsamp',Snsamp,'conflev',clev,'msg',0);
            Sab(j,1:p+1)=outS.beta';
            
            if ~isempty(outS.outliers)
                res=ysimj-[one Xsimj]*(outS.beta);
                % Number of positive residuals among the outliers
                outpos=sum(res(outS.outliers)>0);
                % Number of positive residuals among the outliers
                outneg=sum(res(outS.outliers)<0);
                
                
                % List of true outliers
                trueout=intersect(outS.outliers,indout);
                % Number of positive residuals among the true outliers
                outtruepos=sum(res(trueout)>0);
                % Number of negative residuals among the true outliers
                outtrueneg=sum(res(trueout)<0);
                
                
                % Store
                % total number of units declared as outliers in third column
                % total number of true outliers
                Sab(j,p+2:p+7)=[length(outS.outliers) length(trueout) outpos outtruepos outneg outtrueneg];
            end
            
            
            
            outMM=MMregcore(ysimj,Xsimj,outS.beta,outS.scale,'conflev',clev,'eff',0.85);
            MMab(j,1:p+1)=outMM.beta';
            
            if ~isempty(outMM.outliers)
                res=ysimj-[one Xsimj]*(outMM.beta);
                % Number of positive residuals among the outliers
                outpos=sum(res(outMM.outliers)>0);
                % Number of positive residuals among the outliers
                outneg=sum(res(outMM.outliers)<0);
                
                
                % List of true outliers
                trueout=intersect(outMM.outliers,indout);
                % Number of positive residuals among the true outliers
                outtruepos=sum(res(trueout)>0);
                % Number of negative residuals among the true outliers
                outtrueneg=sum(res(trueout)<0);
                
                
                % Store
                % total number of units declared as outliers in third column
                % total number of true outliers
                MMab(j,p+2:p+7)=[length(outMM.outliers) length(trueout) outpos outtruepos outneg outtrueneg];
            end
            
            
            
            if j==round(nsimul/2)
                disp(['Simulation nr ' num2str(round(nsimul/2))])
            end
            
        end
    end
    disp(['Simulations finished for  la=' num2str(la)])
    
    
    if ~isempty(intersect(sel,ij))
        ijl=ijl+1;
        
        if p==1
            subplot(3,3,ijl)
            
            hold('on')
            plot(Xsimj(1:n1,1),ysimj(1:n1),'o')
            plot(Xsimj(n1+1:end,1),ysimj(n1+1:end),'r+')
            
            y1=alpha+beta*aunif;
            y2=alpha+beta*bunif;
            
            plot([aunif;bunif],[y1;y2])
            yxminya=aunif*beta+alpha-2*sigmay;
            yxmaxya=aunif*beta+alpha+2*sigmay;
            
            plot([aunif;aunif],[yxminya;yxmaxya])
            
            
            yxminyb=bunif*beta+alpha-2*sigmay;
            yxmaxyb=bunif*beta+alpha+2*sigmay;
            
            plot([bunif;bunif],[yxminyb;yxmaxyb])
            
            plot([aunif;bunif],[yxminya;yxminyb])
            plot([aunif;bunif],[yxmaxya;yxmaxyb])
            ylabel(['\lambda=' num2str(lam(ij))])
            
            if prin==1
                % print to postscript
                print -depsc figs\sim1sca.eps;
            end
        else
            
            for i=1:p
                subplot(9,p,ijl+i-1)
                hold('on')
                plot(Xsimj(1:n1,i),ysimj(1:n1),'o')
                plot(Xsimj(n1+1:end,i),ysimj(n1+1:end),'r+')
                % set(gca,'OuterPosition',[0 0 0.2 0.2])
                if ijl+i-1< 8*p+1;
                    set(gca,'XTicklabel','')
                end
                if i==1
                    ylabel(['\lambda=' num2str(la)])
                    yl2=ceil(max(ysimj));
                    yl1=floor(min(ysimj));
                    ylim([yl1 yl2])
                    ax=axis;
                else
                     set(gca,'YTicklabel','')
                end
                
                xlim([-0.5 6.5]);
            end
            ijl=ijl+p-1;
        end
    end
    
    if est==1
        % STORE QUANTITIES FOR FS
        % Now store a and b
        % simultaneous power = number of simulations with at least one unit
        % declared as outlier
        % average power
        simpow=sum(FSab(:,p+2)>0);
        avpow=mean(FSab(:,p+3))/n2;
        % simult power among positive outliers
        simpowpos=sum(FSab(:,p+4)>0);
        % average power among positive outliers
        avpowpos=mean(FSab(:,p+5))/n2;
        % simult power among negative outliers
        simpowneg=sum(FSab(:,p+6)>0);
        % average power among negative outliers
        avpowneg=mean(FSab(:,p+7))/n2;
        
        
        % get quartiles
        quan = quantile(FSab(:,2),3);
        DI=quan(3)-quan(1);
        ptsup=quan(3)+1.5*DI;
        ptinf=quan(1)-1.5*DI;
        ptsupf=max(FSab(FSab(:,2)<ptsup,2));
        ptinff=min(FSab(FSab(:,2)>ptinf,2));
        
        % Compute empirical bias and variance for a and b
        empbiasa=(mean(FSab(:,1))-alpha)^2;
        empvara=var(FSab(:,1));
        
        if p==1
            empbiasb=(mean(FSab(:,2))-beta(1))^2;
            empvarb=var(FSab(:,2));
        else
            empvarb=0;
            empbiasb=0;
            betahatbar=mean(FSab(:,2:p+1));
            for i=1:nsimul
                meansc=(FSab(i,2:p+1)-beta');
                bia=(FSab(i,2:p+1)-betahatbar);
                empbiasb=empbiasb+bia.*varunif*(bia');
                empvarb=empvarb+meansc.*varunif*(meansc');
            end
        end
        
        % 1st column = simultaneous power
        % 2nd column = average power
        % 3th column = lower value of boxplot for beta
        % 4th column = upper value of boxplot for beta
        % 5th column = median of beta values
        % 6th column = (empirical bias of alpha)^2
        % 7th column = empirical variance of alpha hat
        % 8th column = (empirical bias of beta)^2
        % 9th column = empirical variance of beta hat
        % 10th column = simultaneous power among positive outliers
        % 11th column = average power among positive outliers
        % 12th column = simultaneous power among negative outliers
        % 13th column = average power among negative outliers
        StoFS(ij,:)=[simpow avpow ptinff ptsupf quan(2) empbiasa empvara empbiasb empvarb simpowpos avpowpos simpowneg avpowneg];
        
        
        % STORE QUANTITIES FOR LT
        % Now store a and b
        % simultaneous power = number of simulations with at least one unit
        % declared as outlier
        % average power
        simpow=sum(LTab(:,p+2)>0);
        avpow=mean(LTab(:,p+3))/n2;
        % simult power among positive outliers
        simpowpos=sum(LTab(:,p+4)>0);
        % average power among positive outliers
        avpowpos=mean(LTab(:,p+5))/n2;
        % simult power among negative outliers
        simpowneg=sum(LTab(:,p+6)>0);
        % average power among negative outliers
        avpowneg=mean(LTab(:,p+7))/n2;
        
        
        % get quartiles
        quan = quantile(LTab(:,2),3);
        DI=quan(3)-quan(1);
        ptsup=quan(3)+1.5*DI;
        ptinf=quan(1)-1.5*DI;
        ptsupf=max(LTab(LTab(:,2)<ptsup,2));
        ptinff=min(LTab(LTab(:,2)>ptinf,2));
        
        % Compute empirical bias and variance for a and b
        empbiasa=(mean(LTab(:,1))-alpha)^2;
        empvara=var(LTab(:,1));
        if p==1
            empbiasb=(mean(LTab(:,2))-beta(1))^2;
            empvarb=var(LTab(:,2));
        else
            empvarb=0;
            empbiasb=0;
            betahatbar=mean(LTab(:,2:p+1));
            for i=1:nsimul
                meansc=(LTab(i,2:p+1)-beta');
                bia=(LTab(i,2:p+1)-betahatbar);
                empbiasb=empbiasb+bia.*varunif*(bia');
                empvarb=empvarb+meansc.*varunif*(meansc');
            end
        end
        
        
        StoLT(ij,:)=[simpow avpow ptinff ptsupf quan(2) empbiasa empvara empbiasb empvarb ...
            simpowpos avpowpos  simpowneg avpowneg];
        
        % STORE QUANTITIES FOR LTr
        simpow=sum(LTabr(:,p+2)>0);
        avpow=mean(LTabr(:,p+3))/n2;
        % simult power among positive outliers
        simpowpos=sum(LTabr(:,p+4)>0);
        % average power among positive outliers
        avpowpos=mean(LTabr(:,p+5))/n2;
        % simult power among negative outliers
        simpowneg=sum(LTabr(:,p+6)>0);
        % average power among negative outliers
        avpowneg=mean(LTabr(:,p+7))/n2;
        
        
        % get quartiles
        quan = quantile(LTabr(:,2),3);
        DI=quan(3)-quan(1);
        ptsup=quan(3)+1.5*DI;
        ptinf=quan(1)-1.5*DI;
        ptsupf=max(LTabr(LTabr(:,2)<ptsup,2));
        ptinff=min(LTabr(LTabr(:,2)>ptinf,2));
        
        % Compute empirical bias and variance for a and b
        empbiasa=(mean(LTabr(:,1))-alpha)^2;
        empvara=var(LTabr(:,1));
        if p==1
            empbiasb=(mean(LTabr(:,2))-beta(1))^2;
            empvarb=var(LTabr(:,2));
        else
            empvarb=0;
            empbiasb=0;
            betahatbar=mean(LTabr(:,2:p+1));
            for i=1:nsimul
                meansc=(LTabr(i,2:p+1)-beta');
                bia=(LTabr(i,2:p+1)-betahatbar);
                empbiasb=empbiasb+bia.*varunif*(bia');
                empvarb=empvarb+meansc.*varunif*(meansc');
            end
        end
        
        
        StoLTr(ij,:)=[simpow avpow ptinff ptsupf quan(2) empbiasa empvara empbiasb empvarb simpowpos avpowpos  simpowneg avpowneg];
        
        
        % STORE QUANTITIES FOR S estimation
        % Now store a and b
        % simultaneous power = number of simulations with at least one unit
        % declared as outlier
        % average power
        simpow=sum(Sab(:,p+2)>0);
        avpow=mean(Sab(:,p+3))/n2;
        % simult power among positive outliers
        simpowpos=sum(Sab(:,p+4)>0);
        % average power among positive outliers
        avpowpos=mean(Sab(:,p+5))/n2;
        % simult power among negative outliers
        simpowneg=sum(Sab(:,p+6)>0);
        % average power among negative outliers
        avpowneg=mean(Sab(:,p+7))/n2;
        
        
        % get quartiles
        quan = quantile(Sab(:,2),3);
        DI=quan(3)-quan(1);
        ptsup=quan(3)+1.5*DI;
        ptinf=quan(1)-1.5*DI;
        ptsupf=max(Sab(Sab(:,2)<ptsup,2));
        ptinff=min(Sab(Sab(:,2)>ptinf,2));
        
        % Compute empirical bias and variance for a and b
        empbiasa=(mean(Sab(:,1))-alpha)^2;
        empvara=var(Sab(:,1));
        if p==1
            empbiasb=(mean(Sab(:,2))-beta(1))^2;
            empvarb=var(Sab(:,2));
        else
            empvarb=0;
            empbiasb=0;
            betahatbar=mean(Sab(:,2:p+1));
            for i=1:nsimul
                meansc=(Sab(i,2:p+1)-beta');
                bia=(Sab(i,2:p+1)-betahatbar);
                empbiasb=empbiasb+bia.*varunif*(bia');
                empvarb=empvarb+meansc.*varunif*(meansc');
            end
        end
        
        StoS(ij,:)=[simpow avpow ptinff ptsupf quan(2) empbiasa empvara empbiasb empvarb ...
            simpowpos avpowpos  simpowneg avpowneg];
        
        % STORE QUANTITIES FOR MM estimation
        % Now store a and b
        % simultaneous power = number of simulations with at least one unit
        % declared as outlier
        % average power
        simpow=sum(MMab(:,p+2)>0);
        avpow=mean(MMab(:,p+3))/n2;
        % simult power among positive outliers
        simpowpos=sum(MMab(:,p+4)>0);
        % average power among positive outliers
        avpowpos=mean(MMab(:,p+5))/n2;
        % simult power among negative outliers
        simpowneg=sum(MMab(:,p+6)>0);
        % average power among negative outliers
        avpowneg=mean(MMab(:,p+7))/n2;
        
        
        % get quartiles
        quan = quantile(MMab(:,2),3);
        DI=quan(3)-quan(1);
        ptsup=quan(3)+1.5*DI;
        ptinf=quan(1)-1.5*DI;
        ptsupf=max(MMab(MMab(:,2)<ptsup,2));
        ptinff=min(MMab(MMab(:,2)>ptinf,2));
        
        % Compute empirical bias and variance for a and b
        empbiasa=(mean(MMab(:,1))-alpha)^2;
        empvara=var(MMab(:,1));
        if p==1
            empbiasb=(mean(MMab(:,2))-beta(1))^2;
            empvarb=var(MMab(:,2));
        else
            empvarb=0;
            empbiasb=0;
            betahatbar=mean(MMab(:,2:p+1));
            for i=1:nsimul
                meansc=(MMab(i,2:p+1)-beta');
                bia=(MMab(i,2:p+1)-betahatbar);
                empbiasb=empbiasb+bia.*varunif*(bia');
                empvarb=empvarb+meansc.*varunif*(meansc');
            end
        end
        
        
        
        StoMM(ij,:)=[simpow avpow ptinff ptsupf quan(2) empbiasa empvara empbiasb empvarb ...
            simpowpos avpowpos  simpowneg avpowneg];
        
        % Store for each simulation the distribution of values of the intercept
        % and of the slope for the three methods
        FSAA(:,ij)=FSab(:,1);
        FSBB(:,:,ij)=FSab(:,2:p+1);
        
        LTAA(:,ij)=LTab(:,1);
        LTBB(:,:,ij)=LTab(:,2:p+1);
        
        LTAAr(:,ij)=LTabr(:,1);
        LTBBr(:,:,ij)=LTabr(:,2:p+1);
        
        SAA(:,ij)=Sab(:,1);
        SBB(:,:,ij)=Sab(:,2:p+1);
        
        MMAA(:,ij)=MMab(:,1);
        MMBB(:,:,ij)=MMab(:,2:p+1);
        
        
    end
    
    fremp=fremp/(n2*nsimul);
    frover(ij)=fremp;
end


disp('Loop on la finished')
disp('-------------------------')


%% Plot of probability of overlapping
kk=3;
figure('Name','Theoretical and empirical probability of overlapping');
subplot(3,1,1)
plot(lam,pro,'LineWidth',kk);
ylabel('Probability of overlapping')
pval=0;
if pval==1
    
    subplot(3,1,2)
    plot(lam,mala(:,2),'LineWidth',kk);
    ylabel('pvalue of Squared MD')
else
    
    subplot(3,1,2)
    plot(lam,mala(:,1),'LineWidth',kk);
    ylabel('Squared MD between the two centroids')
end

subplot(3,1,3)
plot(lam,frover(:,1),'LineWidth',kk);
ylabel('Empirical frequencey of overlapping')


%% Plot of probability of overlapping
kk=3;
figure('Name','Theoretical and empirical probability of overlapping');
xl1=lamx(1); % -2; % lower xlim
xl2=lamx(end); % 3;  % upper xlim
fzizla=14; % size of xlabel



subplot(2,2,1:2)
plot(lam,pro,'LineWidth',kk);
hold('on')
plot(lam,frover(:,1),'LineWidth',kk,'LineStyle','-.');
xlim([xl1 xl2])
ylabel('Probability of overlapping')
ylabel('Overlapping index')
xlabel('\lambda','Fontsize',fzizla)
legend('Theoretical','Empirical')
subplot(2,2,3)
plot(lam,mala(:,2),'LineWidth',kk);
ylabel('p-value of MD')
xlim([xl1 xl2])
xlabel('\lambda','Fontsize',fzizla)

subplot(2,2,4)
plot(lam,mala(:,1),'LineWidth',kk);
ylabel('MD')
xlim([xl1 xl2])
xlabel('\lambda','Fontsize',fzizla)

if prin==1
    % print to postscript
    print -depsc figs\sim1overlap.eps;
end


% print -depsc figs\sim2scatter.eps;

% print -depsc figs\sim2avpow3panels.eps

%% Plot simultaneous power
figure
ij=1;
% plot(Sto(:,1),StoFS(:,ij),'-r')

plot(lamx,[StoFS(:,ij) StoLT(:,ij) StoLTr(:,ij) StoS(:,ij) StoMM(:,ij)])
legend('FS','LTS','LTSr','S','MM','Location','Best')
title('Simultaneous power')

%% Plot average power
figure
fsizla=14;
ij=2;
hold('on')
box('on')
LineWidth=2;
plot(lamx(:,1),StoFS(:,ij),'LineWidth',LineWidth,'LineStyle','-')
plot(lamx(:,1),StoLT(:,ij),'LineWidth',LineWidth,'LineStyle','-.')
plot(lamx(:,1),StoLTr(:,ij),'LineWidth',LineWidth,'LineStyle',':')
plot(lamx(:,1),StoS(:,ij),'LineWidth',LineWidth,'LineStyle','--','Marker','o')
plot(lamx(:,1),StoMM(:,ij),'LineWidth',LineWidth,'LineStyle','-','Marker','v')
legend('FS','LTS','LTSr','S','MM','Location','Best')
xlim([lamx(1,1) lamx(end,1)])
ylabel('Average power','Fontsize',fzizla)
xlabel('\lambda','Fontsize',fzizla)

%% 2 panels plot average power + empirical frequency of overlapping
figure('Name','Av power and emp. freq. of overlapping')
subplot(2,2,1)
ij=2;
LineWidth=2;
hold('on')
box('on')
plot(lamx(:,1),StoFS(:,ij),'LineWidth',LineWidth,'LineStyle','-')
plot(lamx(:,1),StoLT(:,ij),'LineWidth',LineWidth,'LineStyle','-.')
plot(lamx(:,1),StoLTr(:,ij),'LineWidth',LineWidth,'LineStyle',':')
plot(lamx(:,1),StoS(:,ij),'LineWidth',LineWidth,'LineStyle','--','Marker','o')
plot(lamx(:,1),StoMM(:,ij),'LineWidth',LineWidth,'LineStyle','-','Marker','v')

xlim([lamx(1,1) lamx(end,1)])

% set(gca,'LineStyleOrder', '-*|:|o')
fontsizexlab=14;
fontsizetitl=18;
legend('FS','LTS','LTSr','S','MM','Location','Best')
xlabel('lambda','FontSize',fontsizexlab)
title('Average power','FontSize',fontsizetitl)

subplot(2,2,2)
plot(lamx(:,1),frover,'b','LineWidth',LineWidth)
xlabel('lambda','FontSize',fontsizexlab)
title('Empirical frequency of overlapping','FontSize',fontsizetitl)
xlim([lamx(1,1) lamx(end,1)])


if prin==1
    % print to postscript
    % print -depsc figs\sim1avpow.eps;
    print -depsc figs\sim1avpow.eps;
    print -depsc figs\sim3avpow.eps;
end

%% Plot average power of positive values
% figure
% ij=11;
% avpos=[StoFS(:,ij) StoLT(:,ij) StoLTr(:,ij)];
% plot(lamx(:,1),avpos)
% hold('on')
% ij=13;
% avneg=[StoFS(:,ij) StoLT(:,ij) StoLTr(:,ij)];
% plot(lamx(:,1),avneg)
%
% legend('FS','LTS','LTSr','Location','Best')
% title('Average power (divided into positive and negative outliers)')

%% Compare curves of boxplots as a function of overlapping index
figure('Name','Extremes of the boxplot for beta')
yl1=min(min([StoFS(:,3:5) StoLT(:,3:5) StoLTr(:,3:5) StoS(:,3:5) StoMM(:,3:5)]));
yl2=max(max([StoFS(:,3:5) StoLT(:,3:5) StoLTr(:,3:5) StoS(:,3:5) StoMM(:,3:5)]));

% StoFS
% 3th column = lower value of boxplot for beta
% 4th column = upper value of boxplot for beta
% 5th column = median of beta values

ff=5;
subplot(1,ff,1)
plot(lamx(:,1),StoFS(:,3:5),'b')
ylim([yl1 yl2])
xlim([lamx(1) lamx(end)])
title('FS')

subplot(1,ff,2)
plot(lamx(:,1),StoLT(:,3:5),'b')
title('LTS raw')
ylim([yl1 yl2])
xlim([lamx(1) lamx(end)])

subplot(1,ff,3)
plot(lamx(:,1),StoLTr(:,3:5),'b')
title('LTS reweighted')
ylim([yl1 yl2])
xlim([lamx(1) lamx(end)])

subplot(1,ff,4)
plot(lamx(:,1),StoS(:,3:5),'b')
title('S')
ylim([yl1 yl2])
xlim([lamx(1) lamx(end)])

subplot(1,ff,5)
plot(lamx(:,1),StoMM(:,3:5),'b')
title('MM')
ylim([yl1 yl2])
xlim([lamx(1) lamx(end)])



%% Compare BANDS of boxplots as a function of overlapping index (1 plot and different lines)
figure('Name','Extremes of the boxplot for beta')
yl1=min(min([StoFS(:,3:5) StoLT(:,3:5) StoLTr(:,3:5) StoS(:,3:5) StoMM(:,3:5)]));
yl2=max(max([StoFS(:,3:5) StoLT(:,3:5) StoLTr(:,3:5) StoS(:,3:5) StoMM(:,3:5)]));

% StoFS
% 3th column = lower value of boxplot for beta
% 4th column = upper value of boxplot for beta
% 5th column = median of beta values

hold('on')
plot(lamx(:,1),StoFS(:,3:5),'LineWidth',LineWidth,'LineStyle','-','Color','Blue')
plot(lamx(:,1),StoLT(:,3:5),'LineWidth',LineWidth,'LineStyle','-.','Color','Red')
plot(lamx(:,1),StoLTr(:,3:5),'LineWidth',LineWidth,'LineStyle',':','Color','Green')
% plot(lamx(:,1),StoS(:,3:5),'LineWidth',LineWidth,'LineStyle','--','Marker','o')
% plot(lamx(:,1),StoMM(:,3:5),'LineWidth',LineWidth,'LineStyle','-','Marker','v')

legend('FS','LTS','LTSr','S','MM','Location','Best')

title('MM')
ylim([yl1 yl2])
xlim([lamx(1) lamx(end)])


%% Compare medians of \hat alpha and \hat \beta from nominal values \alpha and \beta
figure('Name','Cum sum of deviand medians from noimnal values')

fontsizexlab=14;
fontsizetitl=18;

% First panel (cumulative sum of absolute deviation from true value of the slope)
subplot(2,2,1)
% Second panel (cumulative sum of absolute deviation from true value of the intercept)
medAA=[median(FSAA)' median(LTAA)' median(LTAAr)' median(SAA)' median(MMAA)'];
medAA=cumsum(abs(medAA-alpha));
hold('on')
box('on')
plot(lamx(:,1),medAA(:,1),'LineWidth',LineWidth,'LineStyle','-')
plot(lamx(:,1),medAA(:,2),'LineWidth',LineWidth,'LineStyle','-.')
plot(lamx(:,1),medAA(:,3),'LineWidth',LineWidth,'LineStyle',':')
plot(lamx(:,1),medAA(:,4),'LineWidth',LineWidth,'LineStyle','--','Marker','o')
plot(lamx(:,1),medAA(:,5),'LineWidth',LineWidth,'LineStyle','-','Marker','v')

title('Sum of abs. deviations from $\alpha_1$','Interpreter','LaTeX','FontSize',fontsizetitl)
xlabel('lambda','FontSize',fontsizexlab)
legend('FS','LTS','LTSr','S','MM','Location','Best')
xlim([lamx(1,1) lamx(end,1)])

subplot(2,2,2)
ij=5; % 5th column contains information about the slope
medBB=cumsum(abs([StoFS(:,ij) StoLT(:,ij) StoLTr(:,ij) StoS(:,ij) StoMM(:,ij)]-beta));
hold('on')
box('on')
plot(lamx(:,1),medBB(:,1),'LineWidth',LineWidth,'LineStyle','-')
plot(lamx(:,1),medBB(:,2),'LineWidth',LineWidth,'LineStyle','-.')
plot(lamx(:,1),medBB(:,3),'LineWidth',LineWidth,'LineStyle',':')
plot(lamx(:,1),medBB(:,4),'LineWidth',LineWidth,'LineStyle','--','Marker','o')
plot(lamx(:,1),medBB(:,5),'LineWidth',LineWidth,'LineStyle','-','Marker','v')


title('Sum of abs. deviations from $\beta_1$','Interpreter','LaTeX','FontSize',fontsizetitl)
xlabel('lambda','FontSize',fontsizexlab)
legend('FS','LTS','LTSr','Location','Best')
xlim([lamx(1,1) lamx(end,1)])


if prin==1
    % print to postscript
    print -depsc figs\simdevab.eps;
end


%% Compare boxplots (slope distribution)
figure('Name','Boxplots of the slope')
sel=1:llam;
yl1=min(min([squeeze(FSBB(:,:,sel)) squeeze(LTBB(:,:,sel)) squeeze(LTBBr(:,:,sel)) squeeze(SBB(:,:,sel)) squeeze(MMBB(:,:,sel))]));
yl2=max(max([squeeze(FSBB(:,:,sel)) squeeze(LTBB(:,:,sel)) squeeze(LTBBr(:,:,sel)) squeeze(SBB(:,:,sel)) squeeze(MMBB(:,:,sel))]));

% FSBB is a 3 dimensional matrix
% rows = nsimul
% columns = number of values of vector beta
% trd dimension = number of elements of la
ff=5;

subplot(1,ff,1)
boxplot(squeeze(FSBB(:,:,sel)),'label',lamxlab)
v=axis;
line(v(1:2)',[beta(1);beta(1)],'LineStyle','-.')

ylim([yl1 yl2])
title('FS')

subplot(1,ff,2)
boxplot(squeeze(LTBB(:,:,sel)),'label',lamxlab)
v=axis;
line(v(1:2)',[beta(1);beta(1)],'LineStyle','-.')
title('LTS raw')
ylim([yl1 yl2])

subplot(1,ff,3)
boxplot(squeeze(LTBBr(:,:,sel)),'label',lamxlab)
v=axis;
line(v(1:2)',[beta(1);beta(1)],'LineStyle','-.')
title('LTS reweighted')
ylim([yl1 yl2])

subplot(1,ff,4)
boxplot(squeeze(SBB(:,:,sel)),'label',lamxlab)
v=axis;
line(v(1:2)',[beta(1);beta(1)],'LineStyle','-.')
title('S')
ylim([yl1 yl2])

subplot(1,ff,5)
boxplot(squeeze(MMBB(:,:,sel)),'label',lamxlab)
v=axis;
line(v(1:2)',[beta(1);beta(1)],'LineStyle','-.')
title('MM')
ylim([yl1 yl2])


%% Boxplots side by side for each value of Sto(:,1)
figure;
ij=1;
% Select the element of beta you want to show
jj=1;
seli=2:10;
% seli=10:18;
% seli=10:17;
%
seli=(1:9)+9;
namx={'FS' 'LTS' 'LTSr' 'S' 'MM'};
for sel=seli
    
    subplot(3,3,ij)
    ij=ij+1;
    boxplot([FSBB(:,jj,sel) LTBB(:,jj,sel) LTBBr(:,jj,sel) SBB(:,jj,sel) MMBB(:,jj,sel)],'labels',namx)
    v=axis;
    line(v(1:2)',[beta(jj);beta(jj)],'LineStyle','-.')
    
    % ylim([2.7 3.3])
    title(['lam=' num2str(lamx(sel,1))])
end

%% Boxplots side by side with scatters for 3 selected value of Sto(:,1)
sel1=(3:5);
% sel1=[9 14 18];
namx={'FS' 'LTS' 'LTSr' 'S' 'MM'};
sel1=([4 8 9 14]);
sel1=(1:3)+3;
lsel1=length(sel1);

figure('Name','Boxplot of slope and scatter');
ij=1;
% Select the element of beta you want to show
jj=1;
for sel=sel1
    subplot(lsel1,2,ij)
    boxplot([FSBB(:,jj,sel) LTBB(:,jj,sel) LTBBr(:,jj,sel) SBB(:,jj,sel) MMBB(:,jj,sel)],'labels',namx)
    v=axis;
    
    line(v(1:2)',[3;3],'LineStyle','-.')
    % ylim([2.7 3.3])
    ylabel('$\widehat \beta$','Interpreter','LaTeX','FontSize',16)
    %  title(['\lambda = ' num2str(lamx(sel))])
    
    ij=ij+1;
    
    subplot(lsel1,2,ij)
    plot(Xysto(1:n1,jj,sel),Xysto(1:n1,p+1,sel),'o');
    hold('on')
    plot(Xysto(n1+1:end,jj,sel),Xysto(n1+1:end,p+1,sel),'+','color','r');
    
    y1=alpha+beta*aunif;
    y2=alpha+beta*bunif;
    
    plot([aunif;bunif],[y1;y2])
    yxminya=aunif*beta+alpha-2*sigmay;
    yxmaxya=aunif*beta+alpha+2*sigmay;
    
    plot([aunif;aunif],[yxminya;yxmaxya])
    
    
    yxminyb=bunif*beta+alpha-2*sigmay;
    yxmaxyb=bunif*beta+alpha+2*sigmay;
    
    plot([bunif;bunif],[yxminyb;yxmaxyb])
    
    plot([aunif;bunif],[yxminya;yxminyb])
    plot([aunif;bunif],[yxmaxya;yxmaxyb])
    
    
    title(['\lambda = ' num2str(lamx(sel))])
    
    ij=ij+1;
    
end


if prin==1
    % print to postscript
    print -depsc figs\sim1boxsca.eps;
end

%% Compare boxplots (alpha distribution)
figure('Name','boxplot of intercept')
ff=5;

yl1=min(min([FSAA LTAA LTAAr SAA MMAA]));
yl2=max(max([FSAA LTAA LTAAr SAA MMAA]));


subplot(1,ff,1)
boxplot(FSAA,'label',lamxlab)
v=axis;

line(v(1:2)',[alpha;alpha],'LineStyle','-.')

ylim([yl1 yl2])
title('FS')

subplot(1,ff,2)
boxplot(LTAA,'label',lamxlab)
v=axis;
line(v(1:2)',[alpha;alpha],'LineStyle','-.')
title('LTS raw')
ylim([yl1 yl2])

subplot(1,ff,3)
boxplot(LTAAr,'label',lamxlab)
v=axis;
line(v(1:2)',[alpha;alpha],'LineStyle','-.')
title('LTS reweighted')
ylim([yl1 yl2])

subplot(1,ff,4)
boxplot(SAA,'label',lamxlab)
v=axis;
line(v(1:2)',[alpha;alpha],'LineStyle','-.')
title('S')
ylim([yl1 yl2])

subplot(1,ff,5)
boxplot(MMAA,'label',lamxlab)
v=axis;
line(v(1:2)',[alpha;alpha],'LineStyle','-.')
title('MM')
ylim([yl1 yl2])



%% Plot bias and variance for alpha
figure('Name','Bias and variance for alpha and beta')
ij=6;
% plot(Sto(:,1),StoFS(:,ij),'-r')
subplot(2,2,1)
hold('on')
box('on')
plot(lamx(:,1),StoFS(:,ij),'LineWidth',LineWidth,'LineStyle','-')
plot(lamx(:,1),StoLT(:,ij),'LineWidth',LineWidth,'LineStyle','-.')
plot(lamx(:,1),StoLTr(:,ij),'LineWidth',LineWidth,'LineStyle',':')
plot(lamx(:,1),StoS(:,ij),'LineWidth',LineWidth,'LineStyle','--','Marker','o')
plot(lamx(:,1),StoMM(:,ij),'LineWidth',LineWidth,'LineStyle','-','Marker','v')

legend('FS','LTS','LTSr','S','MM','Location','Best')
title('Squared bias for \hat \alpha')

ij=7;
subplot(2,2,2)

hold('on')
box('on')
plot(lamx(:,1),StoFS(:,ij),'LineWidth',LineWidth,'LineStyle','-')
plot(lamx(:,1),StoLT(:,ij),'LineWidth',LineWidth,'LineStyle','-.')
plot(lamx(:,1),StoLTr(:,ij),'LineWidth',LineWidth,'LineStyle',':')
plot(lamx(:,1),StoS(:,ij),'LineWidth',LineWidth,'LineStyle','--','Marker','o')
plot(lamx(:,1),StoMM(:,ij),'LineWidth',LineWidth,'LineStyle','-','Marker','v')
legend('FS','LTS','LTSr','S','MM','Location','Best')
title('Empirical variance of \hat \alpha')


% Plot bias and variance for beta
% figure('Name','Bias and variance for beta')
ij=8;
% plot(Sto(:,1),StoFS(:,ij),'-r')
subplot(2,2,3)
hold('on')
plot(lamx(:,1),StoFS(:,ij),'LineWidth',LineWidth,'LineStyle','-')
plot(lamx(:,1),StoLT(:,ij),'LineWidth',LineWidth,'LineStyle','-.')
plot(lamx(:,1),StoLTr(:,ij),'LineWidth',LineWidth,'LineStyle',':')
plot(lamx(:,1),StoS(:,ij),'LineWidth',LineWidth,'LineStyle','--','Marker','o')
plot(lamx(:,1),StoMM(:,ij),'LineWidth',LineWidth,'LineStyle','-','Marker','v')
legend('FS','LTS','LTSr','S','MM','Location','Best')
title('Squared bias for \beta')

ij=9;
subplot(2,2,4)
hold('on')
plot(lamx(:,1),StoFS(:,ij),'LineWidth',LineWidth,'LineStyle','-')
plot(lamx(:,1),StoLT(:,ij),'LineWidth',LineWidth,'LineStyle','-.')
plot(lamx(:,1),StoLTr(:,ij),'LineWidth',LineWidth,'LineStyle',':')
plot(lamx(:,1),StoS(:,ij),'LineWidth',LineWidth,'LineStyle','--','Marker','o')
plot(lamx(:,1),StoMM(:,ij),'LineWidth',LineWidth,'LineStyle','-','Marker','v')

legend('FS','LTS','LTSr','S','MM','Location','Best')
title('Empirical variance of \beta')


%% Intercept: compare bias  and variance (cumulative sum)
figure('Name','Bias and variance for alpha (cumulative sum)')
ij=6;
% plot(Sto(:,1),abs([StoFS(:,ij) StoLT(:,ij) StoLTr(:,ij)]-3))
subplot(2,1,1)
hold('on')
plot(lamx(:,1),cumsum(abs(StoFS(:,ij))),'LineWidth',LineWidth,'LineStyle','-')
plot(lamx(:,1),cumsum(abs(StoLT(:,ij))),'LineWidth',LineWidth,'LineStyle','-.')
plot(lamx(:,1),cumsum(abs(StoLTr(:,ij))),'LineWidth',LineWidth,'LineStyle',':')
plot(lamx(:,1),cumsum(abs(StoS(:,ij))),'LineWidth',LineWidth,'LineStyle','--','Marker','o')
plot(lamx(:,1),cumsum(abs(StoMM(:,ij))),'LineWidth',LineWidth,'LineStyle','-','Marker','v')


% plot(lamx(:,1),cumsum(abs([StoFS(:,ij) StoLT(:,ij) StoLTr(:,ij)  StoS(:,ij) StoMM(:,ij)])))
title('Cumulative sum of bias for intercept')
xlabel('lambda')
legend('FS','LTS','LTSr','S','MM','Location','Best')
ij=7;
subplot(2,1,2)
hold('on')
plot(lamx(:,1),cumsum(abs(StoFS(:,ij))),'LineWidth',LineWidth,'LineStyle','-')
plot(lamx(:,1),cumsum(abs(StoLT(:,ij))),'LineWidth',LineWidth,'LineStyle','-.')
plot(lamx(:,1),cumsum(abs(StoLTr(:,ij))),'LineWidth',LineWidth,'LineStyle',':')
plot(lamx(:,1),cumsum(abs(StoS(:,ij))),'LineWidth',LineWidth,'LineStyle','--','Marker','o')
plot(lamx(:,1),cumsum(abs(StoMM(:,ij))),'LineWidth',LineWidth,'LineStyle','-','Marker','v')
title('Cumulative sum of empirical variance for intercept')
xlabel('lambda')
legend('FS','LTS','LTSr','S','MM','Location','Best')


%% Slope: compare bias and variance (cumulative sum)
figure('Name','Bias and variance for beta (cumulative sum)')
ij=8;
% plot(Sto(:,1),abs([StoFS(:,ij) StoLT(:,ij) StoLTr(:,ij)]-3))
subplot(2,1,1)
hold('on')
plot(lamx(:,1),cumsum(abs(StoFS(:,ij))),'LineWidth',LineWidth,'LineStyle','-')
plot(lamx(:,1),cumsum(abs(StoLT(:,ij))),'LineWidth',LineWidth,'LineStyle','-.')
plot(lamx(:,1),cumsum(abs(StoLTr(:,ij))),'LineWidth',LineWidth,'LineStyle',':')
plot(lamx(:,1),cumsum(abs(StoS(:,ij))),'LineWidth',LineWidth,'LineStyle','--','Marker','o')
plot(lamx(:,1),cumsum(abs(StoMM(:,ij))),'LineWidth',LineWidth,'LineStyle','-','Marker','v')

title('Cumulative sum of bias for slope')
xlabel('lambda')
legend('FS','LTS','LTSr','S','MM','Location','Best')
ij=9;
subplot(2,1,2)
hold('on')
plot(lamx(:,1),cumsum(abs(StoFS(:,ij))),'LineWidth',LineWidth,'LineStyle','-')
plot(lamx(:,1),cumsum(abs(StoLT(:,ij))),'LineWidth',LineWidth,'LineStyle','-.')
plot(lamx(:,1),cumsum(abs(StoLTr(:,ij))),'LineWidth',LineWidth,'LineStyle',':')
plot(lamx(:,1),cumsum(abs(StoS(:,ij))),'LineWidth',LineWidth,'LineStyle','--','Marker','o')
plot(lamx(:,1),cumsum(abs(StoMM(:,ij))),'LineWidth',LineWidth,'LineStyle','-','Marker','v')
title('Cumulative sum of empirical variance for slope')
xlabel('lambda')
legend('FS','LTS','LTSr','S','MM','Location','Best')


%% Compare bias and variance both for intercept and slope  cum sum and 4 panel plot
figure('Name','Bias and variance for alpha and beta (cumulative sum)')
% genera Figura 5.19 (in questo caso non è uguale identica)
fontsizexlab=25;
fontsizetitl=18;
LineWidth=4;

xl1=lamx(1,1);
xl2=lamx(end,1);


% First panel (cumulative sum of absolute deviation from true value of the slope)

ij=6; % 6th column contains information about the bias of the intercept
subplot1=subplot(2,2,1)
box('on')
biasAA=cumsum(abs([StoMM(:,ij) StoLTr(:,ij) StoS(:,ij) StoFS(:,ij) StoLT(:,ij) ]));
hold('on')

% MM col blue
plot(lamx(:,1),biasAA(:,1),'LineWidth',LineWidth,'LineStyle','--','Marker','v','Color',[0 0 1])
% LTSr red
plot(lamx(:,1),biasAA(:,2),'LineWidth',LineWidth,'LineStyle',':','Color','red')
% S col blue
plot(lamx(:,1),biasAA(:,3),'LineWidth',LineWidth,'LineStyle','--','Marker','o','Color',[0 0 1])
% FS black
plot(lamx(:,1),biasAA(:,4),'LineWidth',LineWidth,'LineStyle','-','Color',[0 0 0])
% LTS 
plot(lamx(:,1),biasAA(:,5),'LineWidth',LineWidth,'LineStyle','-.','Color','red')

title('$(\overline{ \hat \alpha} - \alpha)^2$','Interpreter','LaTeX','FontSize',fontsizetitl)
%xlabel('lambda','FontSize',fontsizexlab)
legend('MM','LTSr','S', 'FS','LTS','Location','Best')
xlim([xl1 xl2-2])
ylim([0 160])
set(subplot1,'FontSize',16);


subplot2=subplot(2,2,2)
ij=7; % 7th column contains information about the variance of the intercept
varAA=cumsum(abs([StoFS(:,ij) StoLT(:,ij) StoLTr(:,ij)  StoS(:,ij) StoMM(:,ij)]));
hold('on')
box('on')
% FS black
plot(lamx(:,1),varAA(:,1),'LineWidth',LineWidth,'LineStyle','-','Color',[0 0 0])
% LTS 
plot(lamx(:,1),varAA(:,2),'LineWidth',LineWidth,'LineStyle','-.','Color','red')
% LTSr red
plot(lamx(:,1),varAA(:,3),'LineWidth',LineWidth,'LineStyle',':','Color','red')
% S col blue
plot(lamx(:,1),varAA(:,4),'LineWidth',LineWidth,'LineStyle','--','Marker','o','Color',[0 0 1])
% MM col blue
plot(lamx(:,1),varAA(:,5),'LineWidth',LineWidth,'LineStyle','--','Marker','v','Color',[0 0 1])

title('var$(\hat \alpha)$','Interpreter','LaTeX','FontSize',fontsizetitl)
xlim([xl1 5])
ylim([0 150])
set(subplot2,'FontSize',16);


ij=8; % 6th column contains information about the bias of the slope
% plot(Sto(:,1),abs([StoFS(:,ij) StoLT(:,ij) StoLTr(:,ij)]-3))
subplot3=subplot(2,2,3)
biasBB=cumsum(abs([StoFS(:,ij) StoLT(:,ij) StoLTr(:,ij)  StoS(:,ij) StoMM(:,ij)]));

hold('on')
box('on')
% FS black
plot(lamx(:,1),biasBB(:,1),'LineWidth',LineWidth,'LineStyle','-','Color',[0 0 0])
% LTS 
plot(lamx(:,1),biasBB(:,2),'LineWidth',LineWidth,'LineStyle','-.','Color','red')
% LTSr red
plot(lamx(:,1),biasBB(:,3),'LineWidth',LineWidth,'LineStyle',':','Color','red')
% S col blue
plot(lamx(:,1),biasBB(:,4),'LineWidth',LineWidth,'LineStyle','--','Marker','o','Color',[0 0 1])
% MM col blue
plot(lamx(:,1),biasBB(:,5),'LineWidth',LineWidth,'LineStyle','--','Marker','v','Color',[0 0 1])

title('$(\overline{ \hat \beta} - \beta)^2$','Interpreter','LaTeX','FontSize',fontsizetitl)
% title('Squared bias','Interpreter','LaTeX','FontSize',fontsizetitl)


xlabel('\lambda','FontSize',fontsizexlab)
%legend('FS','LTS','LTSr','S','MM','Location','Best')
xlim([xl1 5.7])
ylim([0 420])
set(subplot3,'FontSize',16);


subplot4=subplot(2,2,4)
ij=9; % 9th column contains information about the variance of the slope
varBB=cumsum(abs([StoFS(:,ij) StoLT(:,ij) StoLTr(:,ij)  StoS(:,ij) StoMM(:,ij)]));
hold('on')
box('on')
% FS black
plot(lamx(:,1),varBB(:,1),'LineWidth',LineWidth,'LineStyle','-','Color',[0 0 0])
% LTS 
plot(lamx(:,1),varBB(:,2),'LineWidth',LineWidth,'LineStyle','-.','Color','red')
% LTSr red
plot(lamx(:,1),varBB(:,3),'LineWidth',LineWidth,'LineStyle',':','Color','red')
% S col blue
plot(lamx(:,1),varBB(:,4),'LineWidth',LineWidth,'LineStyle','--','Marker','o','Color',[0 0 1])
% MM col blue
plot(lamx(:,1),varBB(:,5),'LineWidth',LineWidth,'LineStyle','--','Marker','v','Color',[0 0 1])
ylim([0 200])
title('var$(\hat \beta)$','Interpreter','LaTeX','FontSize',fontsizetitl)
xlabel('\lambda','FontSize',fontsizexlab)
xlim([xl1 xl2])
set(subplot4,'FontSize',16);

if prin==1
    % print to postscript
    print -depsc figs\sim1biasvar.eps;
    print -depsc figs\sim2biasvar.eps;
    print -depsc figs\sim3biasvar.eps;
end


