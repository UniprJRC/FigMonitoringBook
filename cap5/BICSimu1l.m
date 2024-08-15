%% This files produces the bands for BIC for
% S and MM with TB, LTS, and FS.
% The output of this file is the input of file BICSimulFigures.m
nsimul=200;
n=200;
p1=4;
p=p1+1;

% S, MM and LTS 3
BICall=zeros(50,nsimul,3);

init=min(3*p+1,floor(0.5*(n+p+1)));
BICFS=zeros(n-init,nsimul);
rng(100)
msg=0;
rhofunc='bisquare';

close all
bdp=0.5:-0.01:0.01;
lbdp=length(bdp);
logn=log(n);
eff=0.5:0.01:0.99;
leff=length(eff);

for jj=1:nsimul

    % Simulated data no correlation between X and y
    y=randn(n,1);
    X=randn(n,p1);
    % Alternatively simulate data with correlation between X and y
    % n=200;
    % [y, X]=simulateLM(n,'R2',0.80,'nexpl',4);

    % Add a level shift of 5 to the first 20 obs of y (10 per cent
    % contamination)
    y(1:20)=y(1:20)+5;

    %% S monitoring regression TB
    [outSS]=Sregeda(y,X,'rhofunc',rhofunc,'conflev',1-0.01/length(y),'msg',msg);

    % S create BIC
    BIC=[bdp' zeros(lbdp,1)];
    for j=1:lbdp
        % cj=TBbdp(bdp(j),1);
        resj=outSS.RES(:,j)*outSS.Scale(j);
        wj=outSS.Weights(:,j);
        sumwj=sum(wj);
        barrho=resj'*(resj.*wj)/sumwj;
         % Implementation of BICw
        BIC(j,2)=-n*log(barrho) -(p+sum(1-outSS.Weights(:,j)))*logn ;
    end

    BICall(:,jj,1)=BIC(:,2);

    %% MM monitoring regression TB
    [outMM]=MMregeda(y,X,'conflev',1-0.01/n,'Srhofunc',rhofunc);
    % MM estimation create BIC
    BIC=[eff' zeros(leff,1)];
    for j=1:leff
        resj=outMM.RES(:,j)*outMM.auxscale;
        RSS=resj'*(resj.*outMM.Weights(:,j));
        BIC(j,2)=-n*log(RSS/sum(outMM.Weights(:,j)))-logn*(p+sum(1-outMM.Weights(:,j)));
    end
    BICall(:,jj,2)=BIC(:,2);

    %% Monitoring LTS
    BIC=[bdp' zeros(lbdp,1)];

    Xwithintercept=[ones(n,1) X];
    for j=1:lbdp
        [out]=LXS(y,X,'lms',2,'bdp',bdp(j),'msg',msg);

        hh=out.h;
        if hh<n
            resj=(y-Xwithintercept*out.beta).*(out.weights);
            % RES(:,j)=out.residuals;
            % Apply Tallis consistency factor
            vt = norminv(0.5*(1+hh/n));
            factor = 1/(1-2*(n/hh)*vt.*normpdf(vt));
            RSS=factor*resj'*(resj); % /hh;
            BIC(j,2)=-n*log(RSS/hh)-logn*(p+n-hh);
        else
            beta=Xwithintercept\y;
            res=y-Xwithintercept*beta;
            RSS=res'*res;
            BIC(j,2)=-n*log(RSS/hh)-logn*p;
            BIC(j,2)=-Inf;
        end

    end
    BICall(:,jj,3)=BIC(:,2);

    %% FS
    outpre=LXS(y,X,'nsamp',5000,'msg',msg);
    [Un,BB]=FSRbsb(y,X,outpre.bs);
    BIC=[Un(:,1), zeros(size(Un,1),1)];

    for j=2:size(BB,2)
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
            BIC(j-1,2)=-n*log(RSS/hh)-logn*(p+n-hh);
        else
            factor=1;
            BIC(j-1,2)=-Inf;
        end
    end

    BICFS(:,jj)=BIC(:,2);
    disp(['Simulation nr. ' num2str(jj)])
end

%% Show the results for the four estimators
figure;
hold('on');
quant=[0.01 0.5 0.99];
sel=round(nsimul*quant);
if sel(1)==0
    sel(1)=1;
end
nr=2;
nc=2;
for j=1:4

    if j<=3
        % Sort rows of matrix BICall
        mdrStore=sort(BICall(:,:,j),2);
    else
        % Sort rows of BICFS
        mdrStore=sort(BICFS,2);
    end
    % Create figure which compares empirical and theoretical forward envelopes

    subplot(nr,nc,j)

    if j==1
        % Plot lines of empirical quantiles
        plot(bdp,mdrStore(:,sel),'LineStyle','--','Color','k');
        xlabel('bdp');
        title('S estimator TB')
        set(gca,'XDir','rev')
    elseif j==2
        plot(eff,mdrStore(:,sel),'LineStyle','--','Color','k');
        xlabel('eff');
        title('MM estimator TB')
    elseif j==3
        plot(bdp,mdrStore(:,sel),'LineStyle','--','Color','k');
        xlabel('bdp');
        title('LTS')
        set(gca,'XDir','rev')
    elseif j==4
        plot(Un(:,1),mdrStore(:,sel),'LineStyle','--','Color','k');
        xlabel('Subset size m');
        title('FS')
        xlim([round(n/2) n])
    else
    end
end

%% Boxplots in order to show where the maximum takes place

POS=zeros(nsimul,4);
for jj=1:3
    BIC1=BICall(:,:,jj);
    pos=zeros(nsimul,1);
    for j=1:nsimul
        [~,posmaxj]=max(BIC1(:,j));
        pos(j)=posmaxj;
    end
    if jj==2
        poseff=eff(pos)';
        POS(:,jj)=poseff;
    else
        posbdp=bdp(pos)';
        POS(:,jj)=posbdp;
    end
end

BIC1=BICFS;
pos=zeros(nsimul,1);
for j=1:nsimul
    [~,posmaxj]=max(BIC1(:,j));
    pos(j)=posmaxj;
end
mm=BIC(:,1);
POS(:,4)=mm(pos);
POS(:,4)=(n-POS(:,4))/n;
lab={'S', 'MM', 'LTS', 'FS'};
for j=1:4
    subplot(2,2,j)
    boxplot(POS(:,j))
    ylim([min(POS(:,j))*0.95,max(POS(:,j))*1.05])
    title(lab{j})
end

saveResults=false;
if saveResults==true
    save bandswith5LSContn200p5.mat
end