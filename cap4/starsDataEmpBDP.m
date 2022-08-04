
%% ST: Stars dataset (analysis using FS, automatic outlier detection)
clearvars;close all;
stars=load('stars.txt');
y=stars(:,2);
X=stars(:,1);

%% Monitoring tau regression for four values of efficiency

rhofunc='mdpd';
rhofunc='bisquare';
rhofunc='optimal';
rhofunc='hyperbolic';
rhofunc='hampel';
close all
bdp=0.5:-0.01:0.01;
REStau=zeros(n,length(bdp));

eff=0.80;
if eff==0.80
    nomeff=0.8;
elseif eff==.85
    nomeff=0.85;
elseif eff==.90
    nomeff=0.90;
elseif eff==0.95
    nomeff=0.95;
end

for j=1:length(bdp)
    [out]=Taureg(y,X,'rhofunc',rhofunc,'bdp',bdp(j),'eff',nomeff,'conflev',1-0.01/n);
    REStau(:,j)=out.residuals;
end

out=struct;
out.RES=REStau;
out.Un=1;
out.X=X;
out.y=y;
out.class='Sregeda';
out.bdp=bdp;
resfwdplot(out);



%% MM monitoring
[out]=MMregeda(y,X,'rhofunc',rhofunc);
resfwdplot(out)