
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
beta=zeros(p,1);


% Set the std deviation of the y
% When sigmay increases the probability of overlapping increases
sigmay=0.5/2;

% bunif = upper extreme of each coordinate of X
% As the range of the explanatory variables increases the probability of
% intersection tends to stay on high values and then suddenly decrease
% (like a panettone)
bunif=1-0.5;

% aunif = lower extreme of each coordinate of X
aunif=[0 0 0 zeros(1,12)];
aunif=aunif(1:p)-0.5;

% n1 and n2 = number of observations belonging to two populations
% n1 = regression plane population P1 (good units)
% n2 = ellipsoid population P2 (outliers)
n1=100;
n2=30;


% alpha = constant of the plane with equation beta'x-y+alpha=0 Increasing
% (in absolute value) the constant causes the probability of overlapping
% and the empirical frequency of overlapping to behave like a triangle
% with a very small basis. On the other hand, as alpha gets closer to 0 the
% area of the triangle becomes wider and wider
alpha=0;


% pmx = x coordinate of POINT MASS contamination
% pmy = y coordinate of POINT MASS contamination
pmx=-3:0.5:3;
pmy=pmx;


% nsimul = total number of simulations which have to be run
nsimul=100;

% nsamp = number of samples to extract
nsamp=2000;
Snsamp=2000;
nsamp=200;
Snsamp=200;

% est = dummy variable
% If est = 1 estimation method
% else only the plot
est=1;
sel=100000;
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
xmean1=0.5*(aunif+bunif);
ymean1=xmean1*beta+alpha;
yxmean1=[ymean1,xmean1]';


% llam= length of vector lama
llam=length(pmx);
lamx=pmx';
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
StoFS=zeros(llam,9);
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
Xysto=zeros(n,p+1,length(pmx));


ijl=0;
lamxy=zeros(length(pmx)*length(pmy),2);

% This is the main loop
% We are going to store a series of measures for each value of la


for jpm=1:length(pmy)
    
    for ipm=1:length(pmx);
        
        % variable ij is associated with the rows of matrix lam
        ij=ij+1;
        
        lamxy(ij,:)=[pmx(ipm) pmy(jpm)];
        
        % FSab contains
        % 1st column : (p+1)th column = estimate of the estimated regr
        % coefficients
        % (p+2)-th column = total number of units declared as outliers
        % (p+3)-th column = total number of true units declared as outliers
        FSab=zeros(nsimul,p+3);
        LTab=FSab;
        LTabr=FSab;
        Sab=FSab;
        MMab=FSab;
        
        % For each value of la there is the simulation study
        for j=1:nsimul
            
            
            
            % Xsimj = design matrix for simulation j
            % The first part of the design matrix refers to the hyperplane and is
            % fixed once and for all
            % The second part is associated with the x coordinate of the point mass contamination
            
            % ysimj = y values for simulation j
            % The first part of the design matrix refers to the hyperplane and is
            % fixed once and for all
            % The second part is associated with the y coordinate of the point mass contamination
            Xsimj=[Xsim;pmx(ipm)*ones(n2,1)];
            ysimj=[(Xsim*beta+alpha+sigmay*randn(n1,1));pmy(jpm)*ones(n2,1)];
            
            % Store simulated values just for the first simulation
            if j==1
                Xysto(:,:,ij)=[Xsimj ysimj];
            end
            
            if est==1
                % FSR for simulation j
                [out]=FSR(ysimj,Xsimj,'nsamp',nsamp,'plots',0,'msg',0,'init',n/2);
%                 if j==1
%                 pause;
%                 end
                good=setdiff(seq,out.ListOut);
                Xgood=[ones(length(good),1) Xsimj(good,:)];
                ygood=ysimj(good);
                bgood=Xgood\ygood;
                
                % Store a and b of the estimated regression line (plane)
                FSab(j,1:p+1)=bgood';
                if ~isnan(out.ListOut)
                    
                    res=ysimj-[one Xsimj]*bgood;
                    
                    % List of true outliers
                    trueout=intersect(out.ListOut,indout);
                    
                    % Store
                    % (p+2)-th col total number of units declared as outliers in third column
                    % (p+3)-th col total number of true outliers
                    FSab(j,p+2:p+3)=[length(out.ListOut) length(trueout)];
                    
                end
                
                % LTS raw
                [outLTS]=LXS(ysimj,Xsimj,'nsamp',nsamp,'conflev',clev,'lms',0,'msg',0,'plots',0);
                
                good=setdiff(seq,outLTS.outliers);
                Xgood=[ones(length(good),1) Xsimj(good,:)];
                ygood=ysimj(good);
                bgood=Xgood\ygood;
                %             LTab(j,1:p+1)=bgood';
                LTab(j,1:p+1)=outLTS.beta';
                
                if ~isempty(outLTS.outliers)
                    res=ysimj-[one Xsimj]*bgood;
                    
                    
                    % List of true outliers
                    trueout=intersect(outLTS.outliers,indout);
                    
                    
                    % Store
                    % total number of units declared as outliers in third column
                    % total number of true outliers
                    LTab(j,p+2:p+3)=[length(outLTS.outliers) length(trueout)];
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
                    
                    % List of true outliers
                    trueout=intersect(outLTSr.outliers,indout);
                    
                    
                    % Store
                    % total number of units declared as outliers in third column
                    % total number of true outliers
                    LTabr(j,p+2:p+3)=[length(outLTSr.outliers) length(trueout)];
                end
                
                
                % S estimators
                [outS]=Sreg(ysimj,Xsimj,'nsamp',Snsamp,'conflev',clev,'msg',0,'plots',0);
                Sab(j,1:p+1)=outS.beta';
                % pause(2);
                
                if ~isempty(outS.outliers)
                    res=ysimj-[one Xsimj]*(outS.beta);
                    
                    
                    % List of true outliers
                    trueout=intersect(outS.outliers,indout);
                    
                    
                    % Store
                    % total number of units declared as outliers in third column
                    % total number of true outliers
                    Sab(j,p+2:p+3)=[length(outS.outliers) length(trueout)];
                end
                
                
                
                outMM=MMregcore(ysimj,Xsimj,outS.beta,outS.scale,'conflev',clev,'eff',0.85);
                MMab(j,1:p+1)=outMM.beta';
                
                if ~isempty(outMM.outliers)
                    res=ysimj-[one Xsimj]*(outMM.beta);
                    
                    
                    % List of true outliers
                    trueout=intersect(outMM.outliers,indout);
                    
                    
                    % Store
                    % total number of units declared as outliers in third column
                    % total number of true outliers
                    MMab(j,p+2:p+3)=[length(outMM.outliers) length(trueout)];
                end
                
                
                
                if j==round(nsimul/2)
                    disp(['Simulation nr ' num2str(round(nsimul/2))])
                end
                
            end
        end
        disp(['Simulations finished for  point mass x=' num2str(pmx(ipm)) ', y=' num2str(pmy(jpm))])
        
        
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
                ylabel(['Point mass cont=' num2str(pmx(ipm))  num2str(pmy(jpm))])
                
                % ylim([-3 3]);
                % xlim([min(pmx) max(pmx)])
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
            StoFS(ij,:)=[simpow avpow ptinff ptsupf quan(2) empbiasa empvara empbiasb empvarb];
            
            
            % STORE QUANTITIES FOR LT
            % Now store a and b
            % simultaneous power = number of simulations with at least one unit
            % declared as outlier
            % average power
            simpow=sum(LTab(:,p+2)>0);
            avpow=mean(LTab(:,p+3))/n2;
            
            
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
            
            
            StoLT(ij,:)=[simpow avpow ptinff ptsupf quan(2) empbiasa empvara empbiasb empvarb];
            
            
            % STORE QUANTITIES FOR LTr
            simpow=sum(LTabr(:,p+2)>0);
            avpow=mean(LTabr(:,p+3))/n2;
            
            
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
            
            
            StoLTr(ij,:)=[simpow avpow ptinff ptsupf quan(2) empbiasa empvara empbiasb empvarb];
            
            
            % STORE QUANTITIES FOR S estimation
            % Now store a and b
            % simultaneous power = number of simulations with at least one unit
            % declared as outlier
            % average power
            simpow=sum(Sab(:,p+2)>0);
            avpow=mean(Sab(:,p+3))/n2;
            
            
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
            
            StoS(ij,:)=[simpow avpow ptinff ptsupf quan(2) empbiasa empvara empbiasb empvarb];
            
            % STORE QUANTITIES FOR MM estimation
            % Now store a and b
            % simultaneous power = number of simulations with at least one unit
            % declared as outlier
            % average power
            simpow=sum(MMab(:,p+2)>0);
            avpow=mean(MMab(:,p+3))/n2;
            
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
            
            
            
            StoMM(ij,:)=[simpow avpow ptinff ptsupf quan(2) empbiasa empvara empbiasb empvarb];
            
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
        
    end
    
end


disp('Loop on la finished')
disp('-------------------------')


% %% Plot simultaneous power
% figure
% ij=1;
% % plot(Sto(:,1),StoFS(:,ij),'-r')
% % x fisso
% % yvaria
% xinit=1;
% sel=xinit:length(pmy):(length(pmx)*length(pmy));
% plot(lamx,[StoFS(sel,ij) StoLT(sel,ij) StoLTr(sel,ij) StoS(sel,ij) StoMM(sel,ij)])
% legend('FS','LTS','LTSr','S','MM','Location','Best')
% title('Simultaneous power')
% 
% %% Plot average power
% figure
% fzizla=14;
% ij=2;
% hold('on')
% box('on')
% LineWidth=2;
% % x fisso
% % yvaria
% xinit=1;
% sel=xinit:length(pmy):(length(pmx)*length(pmy));
% lamx=lamxy(sel,2);
% 
% plot(lamx(:,1),StoFS(sel,ij),'LineWidth',LineWidth,'LineStyle','-','color','k')
% plot(lamx(:,1),StoLT(sel,ij),'LineWidth',LineWidth,'LineStyle','-.')
% plot(lamx(:,1),StoLTr(sel,ij),'LineWidth',LineWidth,'LineStyle',':')
% plot(lamx(:,1),StoS(sel,ij),'LineWidth',LineWidth,'LineStyle','--','Marker','o')
% plot(lamx(:,1),StoMM(sel,ij),'LineWidth',LineWidth,'LineStyle','-','Marker','v')
% legend('FS','LTS','LTSr','S','MM','Location','Best')
% xlim([lamx(1,1) lamx(end,1)])
% ylabel('Average power','Fontsize',fzizla)
% xlabel('\lambda','Fontsize',fzizla)
% 
% %% 2 panels plot average power + empirical frequency of overlapping
% figure('Name','Av power and emp. freq. of overlapping')
% subplot(2,2,1)
% ij=2;
% LineWidth=2;
% hold('on')
% box('on')
% plot(lamx(:,1),StoFS(:,ij),'LineWidth',LineWidth,'LineStyle','-')
% plot(lamx(:,1),StoLT(:,ij),'LineWidth',LineWidth,'LineStyle','-.')
% plot(lamx(:,1),StoLTr(:,ij),'LineWidth',LineWidth,'LineStyle',':')
% plot(lamx(:,1),StoS(:,ij),'LineWidth',LineWidth,'LineStyle','--','Marker','o')
% plot(lamx(:,1),StoMM(:,ij),'LineWidth',LineWidth,'LineStyle','-','Marker','v')
% 
% xlim([lamx(1,1) lamx(end,1)])
% 
% % set(gca,'LineStyleOrder', '-*|:|o')
% fontsizexlab=14;
% fontsizetitl=18;
% legend('FS','LTS','LTSr','S','MM','Location','Best')
% xlabel('lambda','FontSize',fontsizexlab)
% title('Average power','FontSize',fontsizetitl)
% 
% subplot(2,2,2)
% plot(lamx(:,1),frover,'b','LineWidth',LineWidth)
% xlabel('lambda','FontSize',fontsizexlab)
% title('Empirical frequency of overlapping','FontSize',fontsizetitl)
% xlim([lamx(1,1) lamx(end,1)])
% 
% 
% if prin==1
%     % print to postscript
%     % print -depsc figs\sim1avpow.eps;
%     print -depsc figs\sim1avpow.eps;
%     print -depsc figs\sim3avpow.eps;
% end
% 
% 
% %% Compare medians of \hat alpha and \hat \beta from nominal values \alpha and \beta
% figure('Name','Cum sum of deviand medians from noimnal values')
% 
% fontsizexlab=14;
% fontsizetitl=18;
% 
% % First panel (cumulative sum of absolute deviation from true value of the slope)
% subplot(2,2,1)
% % Second panel (cumulative sum of absolute deviation from true value of the intercept)
% medAA=[median(FSAA)' median(LTAA)' median(LTAAr)' median(SAA)' median(MMAA)'];
% medAA=cumsum(abs(medAA-alpha));
% hold('on')
% box('on')
% plot(lamx(:,1),medAA(:,1),'LineWidth',LineWidth,'LineStyle','-')
% plot(lamx(:,1),medAA(:,2),'LineWidth',LineWidth,'LineStyle','-.')
% plot(lamx(:,1),medAA(:,3),'LineWidth',LineWidth,'LineStyle',':')
% plot(lamx(:,1),medAA(:,4),'LineWidth',LineWidth,'LineStyle','--','Marker','o')
% plot(lamx(:,1),medAA(:,5),'LineWidth',LineWidth,'LineStyle','-','Marker','v')
% 
% title('Sum of abs. deviations from $\alpha_1$','Interpreter','LaTeX','FontSize',fontsizetitl)
% xlabel('lambda','FontSize',fontsizexlab)
% legend('FS','LTS','LTSr','S','MM','Location','Best')
% xlim([lamx(1,1) lamx(end,1)])
% 
% subplot(2,2,2)
% ij=5; % 5th column contains information about the slope
% medBB=cumsum(abs([StoFS(:,ij) StoLT(:,ij) StoLTr(:,ij) StoS(:,ij) StoMM(:,ij)]-beta));
% hold('on')
% box('on')
% plot(lamx(:,1),medBB(:,1),'LineWidth',LineWidth,'LineStyle','-')
% plot(lamx(:,1),medBB(:,2),'LineWidth',LineWidth,'LineStyle','-.')
% plot(lamx(:,1),medBB(:,3),'LineWidth',LineWidth,'LineStyle',':')
% plot(lamx(:,1),medBB(:,4),'LineWidth',LineWidth,'LineStyle','--','Marker','o')
% plot(lamx(:,1),medBB(:,5),'LineWidth',LineWidth,'LineStyle','-','Marker','v')
% 
% 
% title('Sum of abs. deviations from $\beta_1$','Interpreter','LaTeX','FontSize',fontsizetitl)
% xlabel('lambda','FontSize',fontsizexlab)
% legend('FS','LTS','LTSr','Location','Best')
% xlim([lamx(1,1) lamx(end,1)])
% 
% 
% if prin==1
%     % print to postscript
%     print -depsc figs\simdevab.eps;
% end
% 
% 
% 
% 
% %% Boxplots side by side for each value of Sto(:,1)
% figure;
% ij=1;
% % Select the element of beta you want to show
% jj=1;
% seli=2:10;
% % seli=10:18;
% % seli=10:17;
% %
% seli=(1:9); % +9;
% namx={'FS' 'LTS' 'LTSr' 'S' 'MM'};
% for sel=seli
% 
%     subplot(3,3,ij)
%     ij=ij+1;
%     boxplot([FSBB(:,jj,sel) LTBB(:,jj,sel) LTBBr(:,jj,sel) SBB(:,jj,sel) MMBB(:,jj,sel)],'labels',namx)
%     v=axis;
%     line(v(1:2)',[beta(jj);beta(jj)],'LineStyle','-.')
% 
%     % ylim([2.7 3.3])
%     title(['lam=' num2str(lamx(sel,1))])
% end
% 
% %% Boxplots side by side with scatters for 3 selected value of Sto(:,1)
% sel1=(3:5);
% % sel1=[9 14 18];
% namx={'FS' 'LTS' 'LTSr' 'S' 'MM'};
% sel1=([4 8 9 14]);
% sel1=(1:3)+3;
% sel1=([1 5 9 13]);
% 
% lsel1=length(sel1);
% 
% figure('Name','Boxplot of slope and scatter');
% ij=1;
% % Select the element of beta you want to show
% jj=1;
% for sel=sel1
%     subplot(lsel1,2,ij)
%     boxplot([FSBB(:,jj,sel) LTBB(:,jj,sel) LTBBr(:,jj,sel) SBB(:,jj,sel) MMBB(:,jj,sel)],'labels',namx)
%     v=axis;
% 
%     line(v(1:2)',[3;3],'LineStyle','-.')
%     % ylim([2.7 3.3])
%     ylabel('$\widehat \beta$','Interpreter','LaTeX','FontSize',16)
%     %  title(['\lambda = ' num2str(lamx(sel))])
% 
%     ij=ij+1;
% 
%     subplot(lsel1,2,ij)
%     plot(Xysto(1:n1,jj,sel),Xysto(1:n1,p+1,sel),'o');
%     hold('on')
%     plot(Xysto(n1+1:end,jj,sel),Xysto(n1+1:end,p+1,sel),'+','color','r');
% 
%     y1=alpha+beta*aunif;
%     y2=alpha+beta*bunif;
% 
%     plot([aunif;bunif],[y1;y2])
%     yxminya=aunif*beta+alpha-2*sigmay;
%     yxmaxya=aunif*beta+alpha+2*sigmay;
% 
%     plot([aunif;aunif],[yxminya;yxmaxya])
% 
% 
%     yxminyb=bunif*beta+alpha-2*sigmay;
%     yxmaxyb=bunif*beta+alpha+2*sigmay;
% 
%     plot([bunif;bunif],[yxminyb;yxmaxyb])
% 
%     plot([aunif;bunif],[yxminya;yxminyb])
%     plot([aunif;bunif],[yxmaxya;yxmaxyb])
% 
% 
%     title(['\lambda = ' num2str(lamx(sel))])
% 
%     ij=ij+1;
% 
% end
% 
% 
% if prin==1
%     % print to postscript
%     print -depsc figs\sim1boxsca.eps;
% end
% 
% %% Compare boxplots (alpha distribution)
% figure('Name','boxplot of intercept')
% ff=5;
% 
% yl1=min(min([FSAA LTAA LTAAr SAA MMAA]));
% yl2=max(max([FSAA LTAA LTAAr SAA MMAA]));
% 
% 
% subplot(1,ff,1)
% boxplot(FSAA,'label',lamxlab)
% v=axis;
% 
% line(v(1:2)',[alpha;alpha],'LineStyle','-.')
% 
% ylim([yl1 yl2])
% title('FS')
% 
% subplot(1,ff,2)
% boxplot(LTAA,'label',lamxlab)
% v=axis;
% line(v(1:2)',[alpha;alpha],'LineStyle','-.')
% title('LTS raw')
% ylim([yl1 yl2])
% 
% subplot(1,ff,3)
% boxplot(LTAAr,'label',lamxlab)
% v=axis;
% line(v(1:2)',[alpha;alpha],'LineStyle','-.')
% title('LTS reweighted')
% ylim([yl1 yl2])
% 
% subplot(1,ff,4)
% boxplot(SAA,'label',lamxlab)
% v=axis;
% line(v(1:2)',[alpha;alpha],'LineStyle','-.')
% title('S')
% ylim([yl1 yl2])
% 
% subplot(1,ff,5)
% boxplot(MMAA,'label',lamxlab)
% v=axis;
% line(v(1:2)',[alpha;alpha],'LineStyle','-.')
% title('MM')
% ylim([yl1 yl2])
% 
% 
% 
% %% Plot bias and variance for alpha
% figure('Name','Bias and variance for alpha and beta')
% ij=6;
% % plot(Sto(:,1),StoFS(:,ij),'-r')
% subplot(2,2,1)
% hold('on')
% box('on')
% plot(lamx(:,1),StoFS(:,ij),'LineWidth',LineWidth,'LineStyle','-')
% plot(lamx(:,1),StoLT(:,ij),'LineWidth',LineWidth,'LineStyle','-.')
% plot(lamx(:,1),StoLTr(:,ij),'LineWidth',LineWidth,'LineStyle',':')
% plot(lamx(:,1),StoS(:,ij),'LineWidth',LineWidth,'LineStyle','--','Marker','o')
% plot(lamx(:,1),StoMM(:,ij),'LineWidth',LineWidth,'LineStyle','-','Marker','v')
% 
% legend('FS','LTS','LTSr','S','MM','Location','Best')
% title('Squared bias for \hat \alpha')
% 
% ij=7;
% subplot(2,2,2)
% 
% hold('on')
% box('on')
% plot(lamx(:,1),StoFS(:,ij),'LineWidth',LineWidth,'LineStyle','-')
% plot(lamx(:,1),StoLT(:,ij),'LineWidth',LineWidth,'LineStyle','-.')
% plot(lamx(:,1),StoLTr(:,ij),'LineWidth',LineWidth,'LineStyle',':')
% plot(lamx(:,1),StoS(:,ij),'LineWidth',LineWidth,'LineStyle','--','Marker','o')
% plot(lamx(:,1),StoMM(:,ij),'LineWidth',LineWidth,'LineStyle','-','Marker','v')
% legend('FS','LTS','LTSr','S','MM','Location','Best')
% title('Empirical variance of \hat \alpha')
% 
% 
% % Plot bias and variance for beta
% % figure('Name','Bias and variance for beta')
% ij=8;
% % plot(Sto(:,1),StoFS(:,ij),'-r')
% subplot(2,2,3)
% hold('on')
% plot(lamx(:,1),StoFS(:,ij),'LineWidth',LineWidth,'LineStyle','-')
% plot(lamx(:,1),StoLT(:,ij),'LineWidth',LineWidth,'LineStyle','-.')
% plot(lamx(:,1),StoLTr(:,ij),'LineWidth',LineWidth,'LineStyle',':')
% plot(lamx(:,1),StoS(:,ij),'LineWidth',LineWidth,'LineStyle','--','Marker','o')
% plot(lamx(:,1),StoMM(:,ij),'LineWidth',LineWidth,'LineStyle','-','Marker','v')
% legend('FS','LTS','LTSr','S','MM','Location','Best')
% title('Squared bias for \beta')
% 
% ij=9;
% subplot(2,2,4)
% hold('on')
% plot(lamx(:,1),StoFS(:,ij),'LineWidth',LineWidth,'LineStyle','-')
% plot(lamx(:,1),StoLT(:,ij),'LineWidth',LineWidth,'LineStyle','-.')
% plot(lamx(:,1),StoLTr(:,ij),'LineWidth',LineWidth,'LineStyle',':')
% plot(lamx(:,1),StoS(:,ij),'LineWidth',LineWidth,'LineStyle','--','Marker','o')
% plot(lamx(:,1),StoMM(:,ij),'LineWidth',LineWidth,'LineStyle','-','Marker','v')
% 
% legend('FS','LTS','LTSr','S','MM','Location','Best')
% title('Empirical variance of \beta')
% 
% 
% %% Intercept: compare bias  and variance (cumulative sum)
% figure('Name','Bias and variance for alpha (cumulative sum)')
% 
% xinit=1;
% sel=xinit:length(pmy):(length(pmx)*length(pmy));
% lamx=lamxy(sel,2);
% 
% 
% ij=6;
% % plot(Sto(:,1),abs([StoFS(:,ij) StoLT(:,ij) StoLTr(:,ij)]-3))
% subplot(2,1,1)
% hold('on')
% plot(lamx(:,1),cumsum(abs(StoFS(sel,ij))),'LineWidth',LineWidth,'LineStyle','-')
% plot(lamx(:,1),cumsum(abs(StoLT(sel,ij))),'LineWidth',LineWidth,'LineStyle','-.')
% plot(lamx(:,1),cumsum(abs(StoLTr(sel,ij))),'LineWidth',LineWidth,'LineStyle',':')
% plot(lamx(:,1),cumsum(abs(StoS(sel,ij))),'LineWidth',LineWidth,'LineStyle','--','Marker','o')
% plot(lamx(:,1),cumsum(abs(StoMM(sel,ij))),'LineWidth',LineWidth,'LineStyle','-','Marker','v')
% 
% 
% % plot(lamx(:,1),cumsum(abs([StoFS(:,ij) StoLT(:,ij) StoLTr(:,ij)  StoS(:,ij) StoMM(:,ij)])))
% title('Cumulative sum of bias for intercept')
% xlabel('lambda')
% legend('FS','LTS','LTSr','S','MM','Location','Best')
% ij=7;
% subplot(2,1,2)
% hold('on')
% plot(lamx(:,1),cumsum(abs(StoFS(sel,ij))),'LineWidth',LineWidth,'LineStyle','-')
% plot(lamx(:,1),cumsum(abs(StoLT(sel,ij))),'LineWidth',LineWidth,'LineStyle','-.')
% plot(lamx(:,1),cumsum(abs(StoLTr(sel,ij))),'LineWidth',LineWidth,'LineStyle',':')
% plot(lamx(:,1),cumsum(abs(StoS(sel,ij))),'LineWidth',LineWidth,'LineStyle','--','Marker','o')
% plot(lamx(:,1),cumsum(abs(StoMM(sel,ij))),'LineWidth',LineWidth,'LineStyle','-','Marker','v')
% title('Cumulative sum of empirical variance for intercept')
% xlabel('lambda')
% legend('FS','LTS','LTSr','S','MM','Location','Best')
% 
% 
% %% Slope: compare bias and variance (cumulative sum)
% 
% xinit=1;
% sel=xinit:length(pmy):(length(pmx)*length(pmy));
% lamx=lamxy(sel,2);
% 
% 
% figure('Name','Bias and variance for beta (cumulative sum)')
% ij=8;
% % plot(Sto(:,1),abs([StoFS(:,ij) StoLT(:,ij) StoLTr(:,ij)]-3))
% subplot(2,1,1)
% hold('on')
% plot(lamx(:,1),cumsum(abs(StoFS(sel,ij))),'LineWidth',LineWidth,'LineStyle','-')
% plot(lamx(:,1),cumsum(abs(StoLT(sel,ij))),'LineWidth',LineWidth,'LineStyle','-.')
% plot(lamx(:,1),cumsum(abs(StoLTr(sel,ij))),'LineWidth',LineWidth,'LineStyle',':')
% plot(lamx(:,1),cumsum(abs(StoS(sel,ij))),'LineWidth',LineWidth,'LineStyle','--','Marker','o')
% plot(lamx(:,1),cumsum(abs(StoMM(sel,ij))),'LineWidth',LineWidth,'LineStyle','-','Marker','v')
% 
% title('Cumulative sum of bias for slope')
% xlabel('lambda')
% legend('FS','LTS','LTSr','S','MM','Location','Best')
% ij=9;
% subplot(2,1,2)
% hold('on')
% plot(lamx(:,1),cumsum(abs(StoFS(sel,ij))),'LineWidth',LineWidth,'LineStyle','-')
% plot(lamx(:,1),cumsum(abs(StoLT(sel,ij))),'LineWidth',LineWidth,'LineStyle','-.')
% plot(lamx(:,1),cumsum(abs(StoLTr(sel,ij))),'LineWidth',LineWidth,'LineStyle',':')
% plot(lamx(:,1),cumsum(abs(StoS(sel,ij))),'LineWidth',LineWidth,'LineStyle','--','Marker','o')
% plot(lamx(:,1),cumsum(abs(StoMM(sel,ij))),'LineWidth',LineWidth,'LineStyle','-','Marker','v')
% title('Cumulative sum of empirical variance for slope')
% xlabel('lambda')
% legend('FS','LTS','LTSr','S','MM','Location','Best')
% 
% 
% %% Intercept and slope: compare MSE (bias+variance) (cumulative sum)
% figure('Name','MSE for alpha  and beta (cumulative sum)')
% 
% 
% % x rimane fisso e y varia (vertical direction)
% xinit=10;
% sel=xinit:length(pmy):(length(pmx)*length(pmy));
% lamx=lamxy(sel,2);
% xlab=['y point mass for fixed x point mass=' num2str(lamxy(xinit,1))];
% 
% %x varia e y rimane fisso (horizontal direction)
% % yinit=8;
% % sel=((yinit-1)*length(pmy)+1):1:(yinit*length(pmy));
% % lamx=lamxy(sel,1);
% % xlab=['x point mass for fixed y point mass=' num2str(lamxy(yinit,1))];
% 
% 
% ij=6;
% subplot(2,1,1)
% hold('on')
% plot(lamx(:,1),cumsum(abs(StoFS(sel,ij)+StoFS(sel,ij+1))),'LineWidth',LineWidth,'LineStyle','-')
% plot(lamx(:,1),cumsum(abs(StoLT(sel,ij)+StoLT(sel,ij+1))),'LineWidth',LineWidth,'LineStyle','-.')
% plot(lamx(:,1),cumsum(abs(StoLTr(sel,ij)+StoLTr(sel,ij+1))),'LineWidth',LineWidth,'LineStyle',':')
% plot(lamx(:,1),cumsum(abs(StoS(sel,ij)+StoS(sel,ij+1))),'LineWidth',LineWidth,'LineStyle','--','Marker','o')
% plot(lamx(:,1),cumsum(abs(StoMM(sel,ij)+StoMM(sel,ij+1))),'LineWidth',LineWidth,'LineStyle','-','Marker','v')
% % title('Cumulative sum of MSE for intercept')
% xlabel(xlab)
% ylabel('MSE of intercept')
% legend('FS','LTS','LTSr','S','MM','Location','Best')
% 
% 
% subplot(2,1,2)
% ij=8;
% hold('on')
% plot(lamx(:,1),cumsum(abs(StoFS(sel,ij)+StoFS(sel,ij+1))),'LineWidth',LineWidth,'LineStyle','-')
% plot(lamx(:,1),cumsum(abs(StoLT(sel,ij)+StoLT(sel,ij+1))),'LineWidth',LineWidth,'LineStyle','-.')
% plot(lamx(:,1),cumsum(abs(StoLTr(sel,ij)+StoLTr(sel,ij+1))),'LineWidth',LineWidth,'LineStyle',':')
% plot(lamx(:,1),cumsum(abs(StoS(sel,ij)+StoS(sel,ij+1))),'LineWidth',LineWidth,'LineStyle','--','Marker','o')
% plot(lamx(:,1),cumsum(abs(StoMM(sel,ij)+StoMM(sel,ij+1))),'LineWidth',LineWidth,'LineStyle','-','Marker','v')
% %title('Cumulative sum of MSE for slope')
% xlabel(xlab)
% ylabel('MSE of slope')
% legend('FS','LTS','LTSr','S','MM','Location','Best')

%% Intercept and slope 4 directions: compare MSE (bias+variance) (cumulative sum)

 load science_sim1


figure('Name','MSE for alpha  and beta (cumulative sum) VER dir')
% Genera Figura 5.22

kk=16;
%x varia e y rimane fisso (horizontal direction)
% yinit=8;
% sel=((yinit-1)*length(pmy)+1):1:(yinit*length(pmy));
% lamx=lamxy(sel,1);
% xlab=['x point mass for fixed y point mass=' num2str(lamxy(yinit,1))];

LineWidth=4;
col=repmat({'b';'b';'r';'r';'k'},3,1);


% x rimane fisso e y varia (vertical direction)
xinit=10;

ijk=1;
for xinit=[5 6 8 9] % [13:16]
    sel=xinit:length(pmy):(length(pmx)*length(pmy));
    lamx=lamxy(sel,2);
    %xlab=['Coordinate of $y_0$ for fixed $x_0$ =' num2str(lamxy(xinit,1))];
    xlab='Coordinate of $y_0$';
    textlab=['$x_0$ =' num2str(lamxy(xinit,1))];
    
    ij=6;
    
    subplot(4,2,ijk)
    hold('on')
%     plot(lamx(:,1),cumsum(abs(StoFS(sel,ij)+StoFS(sel,ij+1))),'LineWidth',LineWidth,'LineStyle','-')
%     plot(lamx(:,1),cumsum(abs(StoLT(sel,ij)+StoLT(sel,ij+1))),'LineWidth',LineWidth,'LineStyle','-.')
%     plot(lamx(:,1),cumsum(abs(StoLTr(sel,ij)+StoLTr(sel,ij+1))),'LineWidth',LineWidth,'LineStyle',':')
%     plot(lamx(:,1),cumsum(abs(StoS(sel,ij)+StoS(sel,ij+1))),'LineWidth',LineWidth,'LineStyle','--','Marker','o')
%     plot(lamx(:,1),cumsum(abs(StoMM(sel,ij)+StoMM(sel,ij+1))),'LineWidth',LineWidth,'LineStyle','-','Marker','v')
  
    plot(lamx(:,1),cumsum(abs(StoFS(sel,ij)+StoFS(sel,ij+1))),'LineWidth',LineWidth,'LineStyle','-', 'Color',col{5})
    plot(lamx(:,1),cumsum(abs(StoS(sel,ij)+StoS(sel,ij+1))),'LineWidth',LineWidth,'LineStyle','--','Marker','o', 'Color',col{1})
    plot(lamx(:,1),cumsum(abs(StoMM(sel,ij)+StoMM(sel,ij+1))),'LineWidth',LineWidth,'LineStyle','-','Marker','v', 'Color',col{2})
    plot(lamx(:,1),cumsum(abs(StoLT(sel,ij)+StoLT(sel,ij+1))),'LineWidth',LineWidth,'LineStyle','-.', 'Color',col{3})
    plot(lamx(:,1),cumsum(abs(StoLTr(sel,ij)+StoLTr(sel,ij+1))),'LineWidth',LineWidth,'LineStyle',':', 'Color',col{4})
  
    
if xinit==9
    legend('FS','S','MM','LTS','LTSr','Location','Best','FontSize',8)
end

    % title('Cumulative sum of MSE for intercept')
    
    if ijk==7 || ijk==8
        xlabel(xlab,'Interpreter','latex','FontSize',kk-1)
    end
    
    text(0.1,0.9,textlab,'Units','normalized','Interpreter','latex','FontSize',kk-1)
    xlim([min(pmy) max(pmy)])
    
    
    if ijk==1 || ijk==3 ||  ijk==5  || ijk==7
        ylabel('MSE','Interpreter','latex','FontSize',kk-1)
    end
    
    if ijk==1
        % legend('FS','LTS','LTSr','S','MM','Location','Best')
        title('Intercept','FontSize',kk)
    end
    ijk=ijk+1;
    
    subplot(4,2,ijk)
    ij=8;
    hold('on')
%     plot(lamx(:,1),cumsum(abs(StoFS(sel,ij)+StoFS(sel,ij+1))),'LineWidth',LineWidth,'LineStyle','-')
%     plot(lamx(:,1),cumsum(abs(StoLT(sel,ij)+StoLT(sel,ij+1))),'LineWidth',LineWidth,'LineStyle','-.')
%     plot(lamx(:,1),cumsum(abs(StoLTr(sel,ij)+StoLTr(sel,ij+1))),'LineWidth',LineWidth,'LineStyle',':')
%     plot(lamx(:,1),cumsum(abs(StoS(sel,ij)+StoS(sel,ij+1))),'LineWidth',LineWidth,'LineStyle','--','Marker','o')
%     plot(lamx(:,1),cumsum(abs(StoMM(sel,ij)+StoMM(sel,ij+1))),'LineWidth',LineWidth,'LineStyle','-','Marker','v')
 
    
    

    plot(lamx(:,1),cumsum(abs(StoFS(sel,ij)+StoFS(sel,ij+1))),'LineWidth',LineWidth,'LineStyle','-', 'Color',col{5})
    plot(lamx(:,1),cumsum(abs(StoS(sel,ij)+StoS(sel,ij+1))),'LineWidth',LineWidth,'LineStyle','--','Marker','o', 'Color',col{1})
    plot(lamx(:,1),cumsum(abs(StoMM(sel,ij)+StoMM(sel,ij+1))),'LineWidth',LineWidth,'LineStyle','-','Marker','v', 'Color',col{2})
    plot(lamx(:,1),cumsum(abs(StoLT(sel,ij)+StoLT(sel,ij+1))),'LineWidth',LineWidth,'LineStyle','-.', 'Color',col{3})
    plot(lamx(:,1),cumsum(abs(StoLTr(sel,ij)+StoLTr(sel,ij+1))),'LineWidth',LineWidth+4,'LineStyle',':', 'Color',col{4})
  
    xlim([min(pmy) max(pmy)])
    
    
    if ijk==7 || ijk==8
        xlabel(xlab,'Interpreter','latex','FontSize',kk-1)
    end
    
    text(0.1,0.9,textlab,'Units','normalized','Interpreter','latex','FontSize',kk-1)
    
    
    
    if ijk==2
        title('Slope','FontSize',kk)
    end
    
    % ylabel('MSE of slope')
    ijk=ijk+1;
end

if prin==1
    % print to postscript
    print -depsc figs\pmVertDir.eps;
end



%% Intercept and slope 4 directions: compare MSE (bias+variance) (cumulative sum)
% crea la Figure 5.21
load science_sim12023.mat;
figure('Name','MSE for alpha  and beta (cumulative sum) HOr dir')
%LineWidth=2;
LineWidth=4;
col=repmat({'b';'b';'r';'r';'k'},3,1);

kk=16;
%x varia e y rimane fisso (horizontal direction)
% yinit=8;
% sel=((yinit-1)*length(pmy)+1):1:(yinit*length(pmy));
% lamx=lamxy(sel,1);
% xlab=['x point mass for fixed y point mass=' num2str(lamxy(yinit,1))];


ijk=1;
for yinit=[5 6 8 9] % [13:16] 
    sel=((yinit-1)*length(pmy)+1):1:(yinit*length(pmy));
    lamx=lamxy(sel,1);
    %xlab=['Coordinate of $y_0$ for fixed $x_0$ =' num2str(lamxy(xinit,1))];
    xlab='Coordinate of $x_0$';
    textlab=['$y_0$ =' num2str(lamxy(yinit,1))];
    
    ij=6;
    
    subplot(4,2,ijk)
    hold('on')
    plot(lamx(:,1),cumsum(abs(StoFS(sel,ij)+StoFS(sel,ij+1))),'LineWidth',LineWidth,'LineStyle','-', 'Color',col{5})
    plot(lamx(:,1),cumsum(abs(StoS(sel,ij)+StoS(sel,ij+1))),'LineWidth',LineWidth,'LineStyle','--','Marker','o', 'Color',col{1})
    plot(lamx(:,1),cumsum(abs(StoMM(sel,ij)+StoMM(sel,ij+1))),'LineWidth',LineWidth,'LineStyle','-','Marker','v', 'Color',col{2})
    plot(lamx(:,1),cumsum(abs(StoLT(sel,ij)+StoLT(sel,ij+1))),'LineWidth',LineWidth,'LineStyle','-.', 'Color',col{3})
    plot(lamx(:,1),cumsum(abs(StoLTr(sel,ij)+StoLTr(sel,ij+1))),'LineWidth',LineWidth,'LineStyle',':', 'Color',col{4})

    % title('Cumulative sum of MSE for intercept')
    
if yinit==5
    legend('FS','S','MM','LTS','LTSr','Location','Best')
end


    if ijk==7 || ijk==8
        xlabel(xlab,'Interpreter','latex','FontSize',kk-1)
    end
    
    text(0.1,0.9,textlab,'Units','normalized','Interpreter','latex','FontSize',kk-1)
    xlim([min(pmy) max(pmy)])
    
    
    if ijk==1 || ijk==3 ||  ijk==5  || ijk==7
        ylabel('MSE','Interpreter','latex','FontSize',kk-1)
    end
    
    if ijk==1
        % legend('FS','LTS','LTSr','S','MM','Location','Best')
        title('Intercept','FontSize',kk)
    end
    ijk=ijk+1;
    
    subplot(4,2,ijk)
    ij=8;
    hold('on')
    plot(lamx(:,1),cumsum(abs(StoFS(sel,ij)+StoFS(sel,ij+1))),'LineWidth',LineWidth,'LineStyle','-', 'Color',col{5})
     plot(lamx(:,1),cumsum(abs(StoS(sel,ij)+StoS(sel,ij+1))),'LineWidth',LineWidth,'LineStyle','--','Marker','o', 'Color',col{1})
    plot(lamx(:,1),cumsum(abs(StoMM(sel,ij)+StoMM(sel,ij+1))),'LineWidth',LineWidth,'LineStyle','-','Marker','v', 'Color',col{2})
    plot(lamx(:,1),cumsum(abs(StoLT(sel,ij)+StoLT(sel,ij+1))),'LineWidth',LineWidth,'LineStyle','-.', 'Color',col{3})
    plot(lamx(:,1),cumsum(abs(StoLTr(sel,ij)+StoLTr(sel,ij+1))),'LineWidth',LineWidth,'LineStyle',':', 'Color',col{4})
   
    xlim([min(pmy) max(pmy)])
    
    
    if ijk==7 || ijk==8
        xlabel(xlab,'Interpreter','latex','FontSize',kk-1)
    end
    
    text(0.1,0.9,textlab,'Units','normalized','Interpreter','latex','FontSize',kk-1)
    
    
    
    if ijk==2
        title('Slope','FontSize',kk)
    end
    
    % ylabel('MSE of slope')
    ijk=ijk+1;
end

if prin==1
    % print to postscript
    print -depsc figs\pmHorDir.eps;
end


