% set the seed for random number generation
% so that the results are consistent & comparable
state1=123456;
rng(state1);

% max length of the array of random numbers
maxnum=10000;
% no. of simulations
nsimul=100000;
% data numerosity
n=500;
% no. of samples of S estimator
nsamp=4000;


% fare grande contaminazione (30%) e piccola (5%)
%crate=0.05;
crate=0.30;

kk=round(n*crate);

% no. of variables
p=5;

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

PowermatLTSr=zeros(nsimul,1);

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

        %% 4.LTS (reweighted)  bdp=0.5
        outLXSr=LXS(ysimj,X,'nsamp',nsamp,'lms',0,'msg',0,'bdp',0.5,'rew',1,'conflev',bonf, 'conflevrew',0.99);

        %if ~isnan(outLXSr.outliers)
            % List of true outliers (TP)
            trueoutLXSr=intersect(outLXSr.outliers,indout);


            % Store number of true outliers
            PowermatLTSr(j,:)=length(trueoutLXSr);
        %else
        %    Powermat(j,4)=0;
        %end
         if mod(j,10000)==0
             disp(['simulazione= ' num2str(j)])
         end
    end

    % average power
    avpowLXSr=mean(PowermatLTSr(:,1))/kk;


    % store the statistics
    StatPOW(ij,1:2)=[shift(ij) avpowLXSr];
    
    disp(['shift=' num2str(sj)])

end


%% Create the table of robust estimators

TableStatPOW=array2table(StatPOW);
TableStatPOW.Properties.VariableNames={'Shift', 'LTSr'};
disp(TableStatPOW)

%% Plotting section 

% logit transformation
XX=statpow(:,2:6);
YY=log(XX./(1-XX));


close all
fsize=25;
plot1 = plot(shift, YY,'LineWidth',4,'Parent',axes);
% hold on
% LTSr red
set(plot1(4),'LineStyle',':','Color','red', 'LineWidth',8);

% Create ylabel
xlabel('shift','FontSize',fsize);
ylabel('logit average power','FontSize',fsize);

text(StatPOW(4,1)+0.05,StatPOW(4,2)+0.10,'S','FontSize',fsize)
text(StatPOW(3,1)+0.05,StatPOW(3,3)+0.10,'MM','FontSize',fsize)
text(StatPOW(6,1)+0.05,StatPOW(6,4)+0.05,'LTS','FontSize',fsize)
text(StatPOW(5,1)+0.05,StatPOW(5,5)+0.05,'LTSr','FontSize',fsize)
text(StatPOW(5,1)+0.05,StatPOW(5,6)+0.05,'FS','FontSize',fsize)

%legend('S','MM', 'LTS', 'LTSr', 'FS','FontSize',16, 'Location','southeast')
legend('S','MM', 'LTS', 'LTSr', 'FS','FontSize',fsize, 'Location','northwest')


set(gca,'XTick',1:7)
set(gca,'YTick',-12:5:10)

% BIG TICS!
set(gca,'FontSize',25)


%% save part
savestring = ['save logit_nsamp_LTSrn100000p4000' num2str(n) 'p' num2str(p) 'crate' num2str(crate) '.mat, StatPOW'];

% save the current workspace into nxpxdxdfxsx.mat
eval(savestring)

