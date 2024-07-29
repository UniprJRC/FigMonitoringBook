% set the seed for random number generation
% so that the results are consistent & comparable
state1=123476;
rng(state1);


% no. of simulations
nsimul=1000;

% no. of samples of S estimator in 5.1 to 5.4 is 1000
nsamp=10;


% no. of variables
p=10;


% 1st col: S
% 2nd col: MM
% 3rd col: LTS
% 4th col: LTSR
% 5th col: FS

SizematS=zeros(nsimul,1);
SizematScheck=zeros(nsimul,1);
SizematFScheck=zeros(nsimul,1);

SizematMM=zeros(nsimul,1);
SizematLTS=zeros(nsimul,1);
SizematLTSr=zeros(nsimul,1);
SizematFS=zeros(nsimul,1);

% size
sizevect=[100 200 300 400 500 1000];


StatSIZE=zeros(numel(sizevect),6);
statSIZEchk=zeros(numel(sizevect),6);

ij=1;


for n=sizevect
    % Bonferroni threshold of true outliers
    bonf=1-0.01/n;
    ind=0.99;
    thresh=chi2inv(0.99,1);
    threshBonf=chi2inv(1-0.01/n,1);
    seq=1:n;
    % X depends on sizevect!
    X=randn(n,p-1);

    % For each value of la there is the simulation study
    % parfor
    parfor j=1:nsimul
        % ysimj contains the random data
        ysimj=randn(n,1);


        %%  8.	S with Tukey biweight bdp =0.5
        outS=SregCheck(ysimj,X,'nsamp',nsamp,'conflev',ind, 'msg',0,'rhofunc','bisquare','bdp',0.5);
        
        % outS1=Sreg(ysimj,X,'nsamp',nsamp,'msg',0,'rhofunc','bisquare','bdp',0.5);
        XX=[ones(n,1) X];
        [res,sizeind,sizesim,medres2]=ResandSize(ysimj,XX,outS.beta,outS.scale^2,thresh,threshBonf);
        SizematScheck(j,1)=sizeind;
        if ~isnan(outS.outlierscheck)
            % Store number of false outliers
            SizematS(j,1)=length(outS.outlierscheck)/n;
        else
            SizematS(j,1)=0;
        end


        %% 10.	MM with Tukey biweight eff =0.85  bdp=0.5
        outMM=MMregcore(ysimj,X,outS.beta,outS.scale,'rhofunc','bisquare','eff',0.85,'conflev',ind);
        [res,sizeind,sizesim,medres2]=ResandSize(ysimj,XX,outMM.beta,outS.scale^2,thresh,threshBonf);
        SizematMM(j,1)=sizeind;

        %% 2.LTS bdp=0.5
        outLXS=LXS(ysimj,X,'nsamp',nsamp,'lms',0,'msg',0,'bdp',0.5,'conflev',ind);

         [res,sizeind,sizesim,medres2]=ResandSize(ysimj,XX,outLXS.beta,outLXS.scale^2,thresh,threshBonf);
         SizematLTS(j,1)= sizeind;


        %% 4.LTS (reweighted)  bdp=0.5
        outLXSr=LXS(ysimj,X,'nsamp',nsamp,'lms',0,'msg',0,'bdp',0.5,'rew',1,'conflev',ind, 'conflevrew',0.99);
        [res,sizeind,sizesim,medres2]=ResandSize(ysimj,XX,outLXSr.beta,outLXSr.scale^2,thresh,threshBonf);

        SizematLTSr(j,1)=sizeind;


        %%  6.	FS
        outFS=FSR(ysimj,X,'nsamp',nsamp,'msg',0,'plots',0,'init',round(n/2));

    good=setdiff(seq,outFS.ListOut);
    Xgood=XX(good,:);
    ygood=ysimj(good);
    bgood=Xgood\ygood;

    resbsb=ygood-Xgood*bgood;
    res2=resbsb.^2;
    sFS2=sum(res2)/(length(ygood)-p-1);

    [res,sizeind,sizesim,medres2]=ResandSize(ysimj,XX,bgood,sFS2,thresh,threshBonf);

    SizematFScheck(j,1)=sizeind;
    SizematFS(j,1)=sizeind;

        

    end


    % normalization
    SizematS(SizematS(:)>1)=1;
    SizematScheck(SizematScheck(:)>1)=1;
    
    SizematMM(SizematMM(:)>1)=1;
    SizematLTS(SizematLTS(:)>1)=1;
    SizematLTSr(SizematLTSr(:)>1)=1;
    SizematFS(SizematFS(:)>1)=1;

    % calculation of SIZE of the tests
    sizeS=sum(SizematS(:,1))/nsimul;
    sizeScheck=mean(SizematScheck);
    sizeFScheck=mean(SizematFScheck);
    sizeMM=mean(SizematMM(:,1));
    sizeLXS=mean(SizematLTS(:,1));
    sizeLXSr=mean(SizematLTSr(:,1));
    sizeFS=sum(SizematFS(:,1))/nsimul;


    % store the statistics
    StatSIZE(ij,1:6)=[sizevect(ij) sizeS sizeMM sizeLXS sizeLXSr sizeFS];
    statSIZEchk(ij,1:4)=[sizevect(ij) sizeS sizeScheck sizeFScheck];
    disp(['size=' num2str(sizevect(ij))])
    ij=ij+1;
end

StatSIZE(:,2:6)
statSIZEchk(:,2:4)

%% plot
% load('size_GIUSTO_10000n1000p2eff0.85.mat')
close all
set(0, 'DefaultFigureRenderer', 'painters');
hold('on')

col=repmat({'b';'b';'r';'r';'k'},3,1);
linst=repmat({'--';'--';'-.';':';'-'},3,1);
LineWidth=4;

Y=StatSIZE(:,2:6);
% YY=log(XX./(1-XX));
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

% title({'You can do it','with a cell array'}) 

%% save part
savestring = ['save size_GIUSTO_nsamp' num2str(nsimul) 'n' num2str(n) 'p' num2str(p) 'eff0.85' '.mat, StatSIZE'];

% save the current workspace into nxpxdxdfxsx.mat
eval(savestring)

