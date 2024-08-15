% This files checks as the level shift contamination increases
% the percentage of times the proper number of outliers is identified
% by LTS, and FS
% The output of this file is the input of file BICSimulFigures.m
nsimul=200;

% CreateFigure526 true creates Figure 5.26
% CreateFigure525 false creates Figure 5.25
CreateFigure526=false;

if CreateFigure526==true
    n=500;
    p1=14;
    alsoBadLeveragePoint=true;
else
    n=200;
    p1=4;
    alsoBadLeveragePoint=false;
end


p=p1+1;
init=min(3*p+1,floor(0.5*(n+p+1)));

% S and MM with TB, LTS, S and MM with mdpd
% BICall=zeros(50,nsimul,5);
msg=0;
LSHIFT=4.5:0.5:8;
bdp=0.5:-0.01:0;
lbdp=length(bdp);
logn=log(n);

ij=0;
nsamp=1000;
nout=round(n*0.10);

BICLTS=zeros(nsimul,length(LSHIFT));
BICFS=BICLTS;

% outindexes = indexes of the units declared as outliers
outindexes=1:nout;
outboo=false(n,1);
outboo(outindexes)=true;

OutliersLTS=zeros(length(LSHIFT),2);
OutliersFS=OutliersLTS;

% generate regression models with no correlation between X and y
simulnocorr=false;


for lshift=LSHIFT
    ij=ij+1;
    outliersLTS=zeros(nsimul,2);
    outliersFS=outliersLTS;
    disp(['Delta= ' num2str(lshift)])
    for jj=1:nsimul

        if simulnocorr==true
            % Simulated data no correlation between X and y
            y=randn(n,1);
            X=randn(n,p1);
            % X(outindexes+100,1:2)=X(outindexes+100,1:2)+lshift;
        else
            % Simulated data with correlation between X and y
            [outSIM]=simulateLM(n,'R2',0.80,'nexpl',p1);
            X=outSIM.X;
            y=outSIM.y;
        end

        % Contamination
        y(outindexes)=y(outindexes)+lshift;

        if alsoBadLeveragePoint ==true
            X(outindexes,:)=X(outindexes,:)+lshift;
        end

        % group=ones(n,1); group(1:nout)=2; yXplot(y,X,'group',group)

        %% Monitoring LTS
        % Find LMS and LTS residuals
        BIClts=[bdp' zeros(lbdp,1)];
        RES=true(n,lbdp);
        Xwithintercept=[ones(n,1) X];
        for j=1:lbdp
            if bdp(j)>0
                [out]=LXS(y,X,'lms',2,'bdp',bdp(j),'msg',msg,'nsamp',nsamp);
                RES(:,j)=out.weights;

                if j==1
                    outpre=out;
                end
                hh=out.h;
            else
                hh=n;
            end

            if hh<n
                resj=(y-Xwithintercept*out.beta).*(out.weights);
                % Apply Tallis consistency factor
                vt = norminv(0.5*(1+hh/n));
                factor = 1/(1-2*(n/hh)*vt.*normpdf(vt));
                RSS=factor*resj'*(resj); % /hh;
                BIClts(j,2)=-n*log(RSS/hh)-logn*(p+n-hh);
            else
                beta=Xwithintercept\y;
                res=y-Xwithintercept*beta;
                RSS=res'*res;
                BIClts(j,2)=-n*log(RSS/hh)-logn*p;
            end

        end
        [~,BICindmaxLTS]=max(BIClts(:,2));

        resbestboo=RES(:,BICindmaxLTS);
        % interesection between boolean for indexes of outliers and units
        % outside the h units which make up LTS
        GOODout=sum(outboo & ~resbestboo);
        BADout=(n-sum(resbestboo))-GOODout;

        outliersLTS(jj,:)=[GOODout BADout];
        BICLTS(jj,ij)=BIClts(BICindmaxLTS,1);


        %% FS
        % outpre=LXS(y,X,'nsamp',5000,'msg',msg);
        [Un,BB]=FSRbsb(y,X,outpre.bs,'msg',msg);
        BIC=zeros(size(BB,2),2);

        for j=1:size(BB,2)
            boo=~isnan(BB(:,j));
            hh=sum(boo);
            Xb=Xwithintercept(boo,:);
            yb=y(boo);
            beta=Xb\yb;
            resj=yb-Xb*beta;
            if hh<n
                % Apply Tallis consistency factor
                vt = norminv(0.5*(1+hh/n));
                factor = 1/(1-2*(n/hh)*vt.*normpdf(vt));
                RSS=factor*resj'*(resj);
                BIC(j,:)=[hh -n*log(RSS/hh)-logn*(p+n-hh)];
            else
                factor=1;
                BIC(j,:)=[hh -n*log(RSS/hh)-logn*p];
            end
        end
        [~,BICindmaxFS]=max(BIC(:,2));
        resbestboo=BB(:,BICindmaxFS)>0;
        GOODout=sum(outboo & ~resbestboo);
        BADout=(n-sum(resbestboo))-GOODout;

        outliersFS(jj,:)=[GOODout BADout];

        BICFS(jj,ij)=BIC(BICindmaxFS,1);
        % disp(['Simulation nr. ' num2str(jj)])
    end
    OutliersLTS(ij,:)=mean(outliersLTS,1);
    OutliersFS(ij,:)=mean(outliersFS,1);

end

%% Plotting part
maxylim=0.16;
%
figure
subplot(2,2,1)
boxplot(BICLTS,'Labels',string(LSHIFT))
xlabel('Contamination level shift')
title('LTS')
ylim([0 maxylim])


subplot(2,2,2)
boxplot((n-BICFS)/n,'Labels',string(LSHIFT))
ylim([0 maxylim])
xlabel('Contamination level shift')
title('FS')


% save bandsWithLSyContn200p5
% save bandsWithLSyContn500p15WithLev

