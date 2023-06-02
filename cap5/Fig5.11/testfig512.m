
% parpool('threads')
p = gcp('nocreate');

if isempty(p)
    parpool('threads');
else
    poolsize = p.NumWorkers;
    disp([num2str(poolsize) ' CPUs active'])
end
% set the seed for random number generation
% so that the results are consistent & comparable
tic;
state1=123476;
rng(state1);

% data numerosity
n=500;

% fare grande contaminazione (30%) e piccola (5%)
crate=0.30;

% no. of simulations
nsimul=10000;

% no. of samples of S estimator
nsamp=4000;

% no. of estimators
numestimators=5;

% no. of variables
p=5;


% size
sizevect=[100 200 300 400 500 1000];

StatSIZEsimult=zeros(numel(sizevect),6);
StatSIZEindiv=zeros(numel(sizevect),6);

ij=1;




for nind=1:6
    n=sizevect(nind);
    seq=1:n;
    % Store scaled residuals (first n columns) individual size (column
    % n+1)simultaneous size (column n+2) and median of scaled squared residuals
    % (column n+3)
    % estimate of scale (column n+4)
    SizematS=zeros(nsimul,n+4);
    SizematMM=zeros(nsimul,n+4);
    SizematLTS=zeros(nsimul,n+4);
    SizematLTSr=zeros(nsimul,n+4);
    SizematFS=zeros(nsimul,n+4+1);

    % thresh and treshBonf = individual and simultaneous thresholds to declare
    % outliers
    thresh=chi2inv(0.99,1);
    threshBonf=chi2inv(1-0.01/n,1);



    % X depends on sizevect!
    X=randn(n,p-1);
    XX=[ones(n,1) X];
    % For each value of la there is the simulation study
    parfor j=1:nsimul
        % ysim contains the random data
        ysim=randn(n,1);


        %%  8.	S with Tukey biweight bdp =0.5

        outS=Sreg(ysim,X,'nsamp',nsamp,'msg',0,'rhofunc','bisquare','bdp',0.5);
        [res,sizeind,sizesim,medres2]=ResandSize(ysim,XX,outS.beta,outS.scale^2,thresh,threshBonf);

        % STORING FOR S bdp =0.25
        SizematS(j,:)=[res' sizeind sizesim medres2 outS.scale^2];

        %% 10.	MM with Tukey biweight eff =0.90  bdp=0.5
        outMM=MMregcore(ysim,X,outS.beta,outS.scale,'rhofunc','mdpd','eff',0.85);

        [res,sizeind,sizesim,medres2]=ResandSize(ysim,XX,outMM.beta,outS.scale^2,thresh,threshBonf);

        % STORING FOR MM eff =0.85
        SizematMM(j,:)=[res' sizeind sizesim medres2 outS.scale^2];

        %% 2.LTS bdp=0.5
        outLXS=LXS(ysim,X,'nsamp',nsamp,'lms',0,'msg',0,'bdp',0.5);
        [res,sizeind,sizesim,medres2]=ResandSize(ysim,XX,outLXS.beta,outLXS.scale^2,thresh,threshBonf);

        % STORING FOR LTS
        SizematLTS(j,:)=[res' sizeind sizesim medres2 outLXS.scale^2];

        %% 4.LTS (reweighted)  bdp=0.5
        % outLXSr=LXS(ysim,X,'nsamp',nsamp,'lms',0,'msg',0,'bdp',0.5,'rew',1,'conflev',bonf, 'conflevrew',0.99);
        outLXSr=LXS(ysim,X,'nsamp',nsamp,'lms',0,'msg',0,'bdp',0.5,'rew',1);

        [res,sizeind,sizesim,medres2]=ResandSize(ysim,XX,outLXSr.beta,outLXSr.scale^2,thresh,threshBonf);

        % STORING FOR LTSreweighted
        SizematLTSr(j,:)=[res' sizeind sizesim medres2 outLXSr.scale^2];

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

    SizematFS(j,:)=[res' sizeind sizesim medres2 sFS2 sizeFS];

         if mod(j,1000)==0
             disp(['simulazione= ' num2str(j)])
         end

    end


    % SIZ = matrix which contains the size of the 26 estimators which have been considered
    % 1st col = individual size
    % 2nd col = simultaneous size
    % 3rd col = mean of medians of squared scaled residuals
    % 4th col = ?

    SIZ=zeros(numestimators,4);
    SIZ(1,:)=mean(SizematS(:,n+1:end));
    SIZ(2,:)=mean(SizematMM(:,n+1:end));
    SIZ(3,:)=mean(SizematLTS(:,n+1:end));
    SIZ(4,:)=mean(SizematLTSr(:,n+1:end));
    SIZ(5,:)=mean(SizematFS(:,n+1:end-1));


    % store the statistics
    StatSIZEsimult(ij,1:6)=[sizevect(ij) SIZ(1,1) SIZ(2,1) SIZ(3,1) SIZ(4,1) SIZ(5,1)];
    StatSIZEindiv(ij,1:6)=[sizevect(ij) SIZ(1,2) SIZ(2,2) SIZ(3,2) SIZ(4,2) SIZ(5,2)];

    disp(['size=' num2str(sizevect(ij))])
    ij=ij+1;
end

%% Plotting part 005 contam.
% close all

YY=StatSIZEsimult(:,2:6);
% YY=log(XX./(1-XX));



fsize=25;
plot1 = plot([1 2 3 4 5 6]', YY,'LineWidth',4,'Parent',axes);


% S
set(plot1(1),'LineStyle','--','Color',[0 0 1], 'Marker','o');
% MM col blue
set(plot1(2),'LineStyle','--','Color',[0 0 1], 'Marker','v');
% LTS
set(plot1(3),'LineStyle','-.','Color','red');
% LTSr red
set(plot1(4),'LineStyle',':','Color','red', 'LineWidth',8);
% FS black
set(plot1(5),'LineStyle','-','Color',[0 0 0]);

% Create ylabel
xlabel('Sample size','FontSize',fsize);
ylabel('Empirical size of outlier test','FontSize',fsize);

text(1,StatSIZEsimult(4,2),'S','FontSize',fsize)
text(2,StatSIZEsimult(3,3),'MM','FontSize',fsize)
text(3,StatSIZEsimult(6,4),'LTS','FontSize',fsize)
text(4,StatSIZEsimult(5,5),'LTSr','FontSize',fsize)
text(5,StatSIZEsimult(5,6),'FS','FontSize',fsize)

%legend('S','MM', 'LTS', 'LTSr', 'FS','FontSize',16, 'Location','southeast')
legend('S','MM', 'LTS', 'LTSr', 'FS','FontSize',fsize, 'Location','northeast')


%axes1 = axes('Parent',figure1);
% Set the remaining axes properties
%set(axes1,'FontSize',25,'XTick',[1 2 3 4 5 6],'XTickLabel',...
%    {'100','200','300','400','500','1000'});
%set(gca,'XTick',[1 2 3 4 5 6],'XTickLabel', {'100','200','300','400','500','1000'})
set(gca,'XTick',1:6,'XTickLabel', string([100:100:500 1000]))

set(gca,'YTick',[0 0.010 0.015 0.020 0.025 0.030])
% p==2
%set(gca,'YTick',[0.010 0.025 0.050 0.075 0.1])
%ylim([0 0.105])
set(gca,'FontSize',25)


%% save part
savestring = ['save size_nsimul_newsim' num2str(nsimul) 'n' num2str(n) 'p' num2str(p) '.mat, StatSIZEsimult'];

% save the current workspace into nxpxdxdfxsx.mat
eval(savestring)

toc