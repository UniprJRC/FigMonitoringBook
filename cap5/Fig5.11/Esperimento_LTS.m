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
state1=123476;
rng(state1);

% max length of the array of random numbers
maxnum=10000;
% no. of simulations
nsimul=1000;
% data numerosity
n=500;
% no. of variables
p=2;
% fare grande contaminazione (30%) e piccola (5%)
%crate=0.05;
crate=0.30;

% no. of samples of S estimator
nsamp=300;



kk=round(n*crate);


% generate random normal variables
Xall=randn(maxnum,p-1);
yall=randn(maxnum,nsimul);




% X is fixed for all iterations
X=Xall(1:n,:);


% 1st col: S
% 2nd col: MM
% 3rd col: LTS
% 4th col: LTSR
% 5th col: FS
% 6yh col: LTScs

PowermatS=zeros(nsimul,5);
PowermatMM=zeros(nsimul,5);
PowermatLTS=zeros(nsimul,5);
PowermatLTSr=zeros(nsimul,5);
PowermatFS=zeros(nsimul,5);
PowermatLTScs=zeros(nsimul,5);

% index of outliers
indout=1:kk;

% shifting
shift=[1 2 3 4 5 6 7];


StatPOW=zeros(numel(shift),6);


seq=1:n;
ij=0;

% Bonferroni threshold of true outliers
bonf=1-0.01/n;

for sj=shift
    ij=ij+1;

    % For each value of la there is the simulation study
    parfor j=1:nsimul

        ysimj=yall(1:n,j);

        % ysimj contains the random data plus the shifted outliers
        ysimj(indout)=ysimj(indout)+sj;

        %%  8.	S with Tukey biweight bdp =0.5
        outS=Sreg(ysimj,X,'nsamp',nsamp,'conflev',bonf, 'msg',0,'rhofunc','bisquare','bdp',0.5);
        %[res,sizeind,sizesim,medres2]=ResandSize(ysim,XX,outS.beta,outS.scale^2,thresh,threshBonf);


       % if ~isnan(outS.outliers)
            % List of true outliers (TP)
            trueoutS=intersect(outS.outliers,indout);

            % Store number of true outliers
            PowermatS(j,1)=length(trueoutS);
       % else
       %     Powermat(j,1)=0;
       % end


        %% 10.	MM with Tukey biweight eff =0.90  bdp=0.5
        outMM=MMregcore(ysimj,X,outS.beta,outS.scale,'rhofunc','bisquare','eff',0.90,'conflev',bonf);

        %   [res,sizeind,sizesim,medres2]=ResandSize(ysim,XX,outMM.beta,outS.scale^2,thresh,threshBonf);

        % if ~isnan(outMM.outliers)
            % List of true outliers (TP)
            trueoutMM=intersect(outMM.outliers,indout);


            % Store number of true outliers
            PowermatMM(j,2)=length(trueoutMM);
        % else
        %    Powermat(j,2)=0;
        % end

        %% 2.LTS bdp=0.5
        outLXS=LXS(ysimj,X,'nsamp',nsamp,'lms',0,'msg',0,'bdp',0.5,'conflev',bonf);

        % if ~isnan(outLXS.outliers)
            % List of true outliers (TP)
            trueoutLXS=intersect(outLXS.outliers,indout);


            % Store number of true outliers
            PowermatLTS(j,3)=length(trueoutLXS);
        % else
        %    Powermat(j,3)=0;
        % end

% %% 2.LTS bdp=0.5 with concentration steps
%         outLXS=LXS(ysimj,X,'nsamp',nsamp,'lms',2,'msg',0,'bdp',0.5,'conflev',bonf);
% 
%         % if ~isnan(outLXS.outliers)
%             % List of true outliers (TP)
%             trueoutLXS=intersect(outLXS.outliers,indout);
% 
% 
%             % Store number of true outliers
%             PowermatLTScs(j,6)=length(trueoutLXS);
%         % else
%         %    Powermat(j,3)=0;
%         % end
% 
% 
% 
% 
        %% 4.LTS (reweighted)  bdp=0.5
        outLXSr=LXS(ysimj,X,'nsamp',nsamp,'lms',0,'msg',0,'bdp',0.5,'rew',1,'conflev',bonf, 'conflevrew',0.99);

        % if ~isnan(outLXSr.outliers)
            % List of true outliers (TP)
            trueoutLXSr=intersect(outLXSr.outliers,indout);


            % Store number of true outliers
            PowermatLTSr(j,4)=length(trueoutLXSr);
        % else
        %    Powermat(j,4)=0;
        % end
% 
%      %%  6.	FS
%     outFS=FSR(ysimj,X,'nsamp',nsamp,'msg',0,'plots',0,'init',round(n/2));
% 
% 
%        % if ~isnan(outFS.outliers)
%             % List of true outliers (TP)
%             trueoutFS=intersect(outFS.outliers,indout);
% 
% 
%             % Store number of true outliers
%             PowermatFS(j,5)=length(trueoutFS);
% %         else
% %             Powermat(j,5)=0;
% %         end


         if mod(j,1000)==0
             disp(['simulazione= ' num2str(j)])
         end
    end

    % average power
     avpowS=mean(PowermatS(:,1))/kk;
     avpowMM=mean(PowermatMM(:,2))/kk;
     avpowLXS=mean(PowermatLTS(:,3))/kk;
     avpowLXSr=mean(PowermatLTSr(:,4))/kk;
     avpowFS=mean(PowermatFS(:,5))/kk;
%     avpowLXScs=mean(PowermatLTScs(:,6))/kk;

    % store the statistics
    StatPOW(ij,1:6)=[shift(ij) avpowS avpowMM avpowLXS avpowLXSr avpowFS ];
    disp(['shift=' num2str(sj)])

end

%% Plotting part 005 contam.

% NON LOGIT 
YY=StatPOW(:,2:6);

% LOGIT
% XX=StatPOW(:,2:6);
% YY=log(XX./(1-XX));

fsize=25;
plot1 = plot(shift, YY,'LineWidth',4,'Parent',axes);


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
% LTScs
% set(plot1(6),'LineStyle','-.','Color', 'green');

% Create ylabel
xlabel('shift','FontSize',fsize);
ylabel('average power','FontSize',fsize);

text(StatPOW(4,1)+0.05,StatPOW(4,2)+0.10,'S','FontSize',fsize)
text(StatPOW(3,1)+0.05,StatPOW(3,3)+0.10,'MM','FontSize',fsize)
text(StatPOW(6,1)+0.05,StatPOW(6,4)+0.05,'LTS','FontSize',fsize)
text(StatPOW(5,1)+0.05,StatPOW(5,5)+0.05,'LTSr','FontSize',fsize)
text(StatPOW(5,1)+0.05,StatPOW(5,6)+0.05,'FS','FontSize',fsize)


%legend('S','MM', 'LTS', 'LTSr', 'FS','FontSize',16, 'Location','southeast')
legend('S','MM', 'LTS', 'LTSr', 'FS','FontSize',fsize, 'Location','northwest')



xlim([1 7])

% % set(gca,'XTick',1:7)
% % % set(gca,'YTick',-10:5:10)
% % set(gca,'YTick',0:0.2:1)

set(gca,'XTick',1:7)
set(gca,'YTick',-12:5:10)

set(gca,'FontSize',25)


% %% save part
 savestring = ['save("exp_S_MM_LTS_simuls' num2str(nsimul) 'n' num2str(n) 'p' num2str(p) 'crate' num2str(crate) '.mat", "StatPOW", "shift", "p", "n", "crate")'];
% 
% % save the current workspace into nxpxdxdfxsx.mat
 eval(savestring)
% 
% saveas(figure(1),[pwd '/' 'nsamp' num2str(nsamp) num2str(n) 'p' num2str(p) 'crate' num2str(crate) '.fig']);

%% Troubleshooting error Plots do not open anymore
% clf('reset')
% figure