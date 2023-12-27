%% Stars data.
%
% This file creates Figures 4.1-4.4, 4.9-4.11

%% Beginning of code
clearvars;
close all;
prin=0;
stars=load('stars.txt');
y=stars(:,2);
X=stars(:,1);
n=length(y);

%% Create Figure 4.1
plot(X,y,'o');
xlabel('Log effective surface temperature')
ylabel('Log light intensity')
set(gca,'XDir','reverse');

plot(X,y,'o','MarkerFaceColor','black')
set(gca,'FontSize',12)

xlabel('Log temperature)')
ylabel('Log light intensity')
sgtitle('Figure 4.1')
set(gcf,"Name",'Figure 4.1')


%% Create Figure 4.2
% Automatic outlier detection process
[out]=FSR(y,X,'plots',1);
pl_yX=findobj(0, 'type', 'figure','tag','fsr_yXplot');
close(pl_yX(end))

pl_fsr=findobj(0, 'type', 'figure','tag','pl_fsr');
figure(pl_fsr(end))
xlabel('Subset size m')
ylabel("MDR in original coordinates")

title('Figure 4.2')
set(gcf,"Name",'Figure 4.2')

if prin==1
    % print to postscript
    print -depsc figs\STdetails.eps;
end

%% Create Figure 4.3
quan=[0.01 0.5 0.99 0.999 0.9999 0.99999];
plots=struct;
plots.conflev=quan;
plots.LineWidth=2;
plots.LineWidthEnv=2;
MDRinv=FSRinvmdr(out.mdr,size(X,2)+1,'plots',plots);
xlim([3 length(y)])

if prin==1
    % print to postscript
    print -depsc figs\STdetailsNC.eps;
end
title('Figure 4.3')
set(gcf,"Name",'Figure 4.3')

%% Create Figure 4.4
% Resuperimposing envelopes using mdr coordinates and normal
% coordinates at particular steps

n0=[42 43 44];
ninv=norminv(quan);
lwdenv=2;
supn0=max(n0);

figure;
ij=0;
for jn0=n0
    ij=ij+1;
    [MDRinv] = FSRinvmdr(out.mdr,2,'n',jn0);
    % Plot for each step of the fwd search the values of mdr translated in
    % Plot for each step of the fwd search the values of mdr translated in
    % terms of normal quantiles
    subplot(2,2,ij)
    plot(MDRinv(:,1),norminv(MDRinv(:,2)),'LineWidth',2)
    xlim([0 supn0])
    v=axis;
    line(v(1:2)',[ninv;ninv],'color','g','LineWidth',lwdenv,'LineStyle','--','Tag','env');
    text(v(1)*ones(length(quan),1),ninv',strcat(num2str(100*quan'),'%'));
    line(MDRinv(:,1),norminv(MDRinv(:,2)),'LineWidth',2)
    title(['Resuperimposed envelope n*=' num2str(jn0)]);
end


if prin==1
    % print to postscript
    print -depsc STresuperNC.eps;
end
sgtitle('Figure 4.4')
set(gcf,"Name",'Figure 4.4')

%% Create Figure 4.9
% Compare different fits
figure
lwd=2;

plot(X,y,'o','MarkerFaceColor','black')
set(gca,'FontSize',12)

xlabel('Log(effective surface temperature)')
ylabel('Log(light intensity)')

% FS line
[out]=FSR(y,X,'plots',0);

x1=min(X);
x2=max(X);
y1=out.beta(1)+out.beta(2)*x1;
y2=out.beta(1)+out.beta(2)*x2;
line([x1;x2],[y1;y2],'LineStyle','--','LineWidth',lwd,'Color','m')

% S estimator with bdp=0.5
rhofunc='bisquare';
[outS]=Sreg(y,X,'rhofunc',rhofunc,'bdp',0.5,'conflev',1-0.01/n);

x1=min(X);
x2=max(X);
y1=outS.beta(1)+outS.beta(2)*x1;
y2=outS.beta(1)+outS.beta(2)*x2;
line([x1;x2],[y1;y2],'LineStyle','--','LineWidth',lwd)

% MM085 = MM estimator with efficiency set to 0.85
[outMM]=MMregcore(y,X,outS.beta,outS.scale,'eff',0.85,'rhofunc',rhofunc);
x1=min(X);
x2=max(X);
y1=outMM.beta(1)+outMM.beta(2)*x1;
y2=outMM.beta(1)+outMM.beta(2)*x2;
line([x1;x2],[y1;y2],'LineStyle','-.','Color','green','LineWidth',lwd)

% MM095 = MM estimator with efficiency set to 0.95
[outMM]=MMregcore(y,X,outS.beta,outS.scale,'eff',0.95,'rhofunc',rhofunc);
x1=min(X);
x2=max(X);
y1=outMM.beta(1)+outMM.beta(2)*x1;
y2=outMM.beta(1)+outMM.beta(2)*x2;
line([x1;x2],[y1;y2],'LineStyle','-.','Color','red','LineWidth',lwd)

%  LTS with bdp=0.5
[outLXS]=LXS(y,X,'lms',0);
y1=outLXS.beta(1)+outLXS.beta(2)*x1;
y2=outLXS.beta(1)+outLXS.beta(2)*x2;
line([x1;x2],[y1;y2],'LineStyle',':','Color','black','LineWidth',lwd+2)

% LS: traditional regression
whichstats = {'beta','yhat','r','rsquare'};
stats = regstats(y, X,'linear',whichstats);
y1=stats.beta(1)+stats.beta(2)*x1;
y2=stats.beta(1)+stats.beta(2)*x2;
line([x1;x2],[y1;y2],'LineStyle','-','LineWidth',3)
xlim([x1 x2])

ylim([min(y)-0.1 max(y)+0.1])
legend('Data','FS','S','MM085','MM095','LTS','LS')
sel=[ 7 9 11 20 30 34]';
text(X(sel)+0.05,y(sel),num2str(sel),'FontSize',16)

sgtitle('Figure 4.9')
set(gcf,"Name",'Figure 4.9')

if prin==1
    % print to postscript
    print -depsc starsdatawithrobfit.eps;
end

%% Create Figure 4.10
% Monitoring S residuals 
[outS]=Sregeda(y,X,'msg',0);
sel=[11 20 30 34  7 9]';
fground.LineStyle={'-.','-.','-.','-.','--','--'};
fground.Color={'r';'r';'r';'r';'k';'k'};
fground.flabstep=[0.01 0.5];
fground.funit=sel;
fground.FontSize=12;
standard=struct;
standard.laby='S residuals bisquare \rho function';
resfwdplot(outS,'standard',standard,'fground',fground, ...
    'corres',true,'tag','Sres');


if prin==1
    % print to postscript
    print -depsc figs\Sres.eps;
end
sgtitle('Figure 4.10')
set(gcf,"Name",'Figure 4.10')

%% Create Figure 4.11
% Monitoring MM residuals 
[outMM]=MMregeda(y,X);

fground=struct;
sel=[11 20 30 34  7 9]';
fground.LineStyle={'-.','-.','-.','-.','--','--'};
fground.Color={'r';'r';'r';'r';'k';'k'};
fground.flabstep=[0.5 0.99];
fground.funit=sel;
fground.FontSize=12;
standard.laby='MM residuals bisquare \rho function';
resfwdplot(outMM,'standard',standard,'fground',fground, ...
    'corres',true,'tag','MMres');

prin=0;
if prin==1
    % print to postscript
    print -depsc figs\MMres.eps;
end

sgtitle('Figure 4.11')
set(gcf,"Name",'Figure 4.11')

%InsideREADME 