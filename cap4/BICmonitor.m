%% CONTAMINATED ILLNESS DATA
load('illnessx07.txt');
y=illnessx07(:,4);
X=illnessx07(:,2:3);
listout=[17 53 30];
y(listout)=1;
y=log(y);

stars=load('stars.txt');
y=stars(:,2);
X=stars(:,1);

load('multiple_regression.txt');
y=multiple_regression(:,4);
X=multiple_regression(:,1:3);

load('hawkins.txt');
y=hawkins(:,9);
X=hawkins(:,1:8);

%% FIGURE CI1
% Monitoring LXS
% Find LMS and LTS residuals
bdp=0.5:-0.01:0.01;
lbdp=length(bdp);
BIClxs=[bdp' zeros(lbdp,1)];
n=length(y);
p=size(X,2)+1;
logn=log(n);
RES=zeros(n,length(bdp));

Xwithintercept=[ones(n,1) X];
for j=1:length(bdp)
    [out]=LXS(y,X,'lms',2,'bdp',bdp(j),'nsamp',100000);
    
    hh=out.h;
    if hh<n
        resj=(y-Xwithintercept*out.beta).*(out.weights);
        RES(:,j)=out.residuals;
        % Apply Tallis consistency factor
        vt = norminv(0.5*(1+hh/n));
        factor = 1/(1-2*(n/hh)*vt.*normpdf(vt));
        RSS=factor*resj'*(resj); % /hh;
        BIClxs(j,2)=-n*log(RSS/hh)-logn*(p+n-hh);
    else
        beta=Xwithintercept\y;
        res=y-Xwithintercept*beta;
        RSS=res'*res;
        BIClxs(j,2)=-n*log(RSS/hh)-logn*p;
    end
    
end

% Plot BIC FOR LTS
close all
subplot(2,2,1)
plot(BIClxs(:,1),BIClxs(:,2))
xlabel('Break down point')
ylabel('BIC')
[~,indmax]=max(BIClxs(:,2));
ylim([min(BIClxs(:,2)) max(BIClxs(:,2))])
ax=axis;
xlim([0 0.5])

line(bdp(indmax)*ones(2,1), [ax(3); BIClxs(indmax,2)],'Color','r')
set(gca,'XDir','rev')

%%%%%%%%%%%%%%%%%%%%%%
% FS
n=length(y);
outpre=LXS(y,X,'nsamp',5000);
[Un,BB]=FSRbsb(y,X,outpre.bs,'init',round(n/2));
BICfs=[Un(:,1), zeros(size(Un,1),1)];
p=size(X,2)+1;
logn=log(n);
Xwithintercept=[ones(n,1) X];

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
    else
        RSS=resj'*resj;
    end
        BICfs(j-1,2)=-n*log(RSS/hh)-logn*(p+n-hh);
end

% Plot BIC FOR FS
subplot(2,2,2)
plot(BICfs(:,1),BICfs(:,2))
xlabel('Subset size m')
ylabel('BIC')
[~,indmax]=max(BICfs(:,2));
ax=axis;

line(BICfs(indmax,1)*ones(2,1), [ax(3); BICfs(indmax,2)],'Color','r')
xlim([n/2 n])
ylim([min(BICfs(:,2)) max(BICfs(:,2))])

prin=0;
if prin==1
    % print to postscript
    print -depsc figs\CI1.eps;
    
end





%% Hawkins data 
load('hawkins.txt');
y=hawkins(:,9);
X=hawkins(:,1:8);


% Monitoring LXS
% Find LMS and LTS residuals
bdp=0.5:-0.01:0.01;
lbdp=length(bdp);
BIClxs=[bdp' zeros(lbdp,1)];
n=length(y);
p=size(X,2)+1;
logn=log(n);
RES=zeros(n,length(bdp));

Xwithintercept=[ones(n,1) X];
for j=1:length(bdp)
    [out]=LXS(y,X,'lms',2,'bdp',bdp(j),'nsamp',100000);
    
    hh=out.h;
    if hh<n
        resj=(y-Xwithintercept*out.beta).*(out.weights);
        RES(:,j)=out.residuals;
        % Apply Tallis consistency factor
        vt = norminv(0.5*(1+hh/n));
        factor = 1/(1-2*(n/hh)*vt.*normpdf(vt));
        RSS=factor*resj'*(resj); % /hh;
        BIClxs(j,2)=-n*log(RSS/hh)-logn*(p+n-hh);
    else
        beta=Xwithintercept\y;
        res=y-Xwithintercept*beta;
        RSS=res'*res;
        BIClxs(j,2)=-n*log(RSS/hh)-logn*p;
    end
    
end


%% Plot BIC FOR LTS
close all
subplot(2,2,1)
plot(BIClxs(:,1),BIClxs(:,2))
xlabel('Break down point')
ylabel('BIC')
[~,indmax]=max(BIClxs(:,2));
ylim([min(BIClxs(:,2)) max(BIClxs(:,2))])
ax=axis;
xlim([0 0.5])

% line(bdp(indmax)*ones(2,1), [ax(3); BIClxs(indmax,2)],'Color','r')
set(gca,'XDir','rev')

%%%%%%%%%%%%%%%%%%%%%%
% FS
n=length(y);
outpre=LXS(y,X,'nsamp',10000);
[Un,BB]=FSRbsb(y,X,outpre.bs,'init',round(n/2));
BICfs=[Un(:,1), zeros(size(Un,1),1)];
p=size(X,2)+1;
logn=log(n);
Xwithintercept=[ones(n,1) X];

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
    else
        RSS=resj'*resj;
    end
        BICfs(j-1,2)=-n*log(RSS/hh)-logn*(p+n-hh);
end

% Plot BIC FOR FS
subplot(2,2,2)
plot(BICfs(:,1),BICfs(:,2))
xlabel('Subset size m')
ylabel('BIC')
[~,indmax]=max(BICfs(:,2));
ax=axis;

% line(BICfs(indmax,1)*ones(2,1), [ax(3); BICfs(indmax,2)],'Color','r')
xlim([n/2 n])
ylim([min(BICfs(:,2)) max(BICfs(:,2))])

prin=0;
if prin==1
    % print to postscript
    print -depsc Hbic.eps;
    
end