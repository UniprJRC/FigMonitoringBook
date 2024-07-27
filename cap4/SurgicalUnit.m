%% Surgical Unit data.
%
% This file creates Figures 4.30-4.33.

%% Beginning of code
close all;
clearvars;
load('hospitalFS.txt');
y=hospitalFS(:,5);
X=hospitalFS(:,1:4);

n=length(y);
prin=0;

%% Prepare input for Figure 4.30
% LMS using all  subsamples (very lengthy)
computeLMSusingAllSubsets=false;
if computeLMSusingAllSubsets ==true
    nsamp=0;
    [outLXS]=LXS(y,X,'nsamp',nsamp);
else
    % best out of 111,469,176 subsets
    outLXS=struct;
    outLXS.bs= [ 3   11   20   23   74];
end

p=size(X,2)+1;

outFS=FSReda(y,X,outLXS.bs);

% Tranform minimum deletion residual from standard coordinates to normal
% coordinates
outFS1=FSRinvmdr(outFS,p);

%% Create Figure 4.30
mdrplot(outFS1,'ncoord',true,'quant',[0.1 0.5 0.99 0.999 0.9999]);

if prin==1
    % print to postscript
    print -depsc SPmdrncoord.eps;
else
    title('Figure 4.30')
    set(gcf,"Name",'Figure 4.30')
end



%% Create Figure
% Automatic outlier detection
startJustSearchin1000Subsets=true;
if startJustSearchin1000Subsets ==true
    out=FSR(y,X,'plots',0);
else
    outLXS=struct;
    outLXS.bs= [ 3   11   20   23   74];
    [out]=FSR(y,X,'lms',outLXS.bs,'plots',0);
end
disp(out)


%% Create Figure 4.31
% SP data Monitoring of prop of units in bsb and tstat
figure
nr=1;
nc=2;
Prop=[(p+1:n)' zeros(n-p,1)];
[Un,BB]=FSRbsb(y,X,outLXS.bs,'init',p+1,'bsbsteps',p+1:n);
for j=1:size(BB,2)
    bj=BB(:,j);
    bj=bj(~isnan(bj));
    Prop(j,2)=sum(bj<=54)/length(bj);
end

% subplot(nr,nc,1)
plot(Prop(:,1),Prop(:,2),'LineWidth',2)
xlabel('Subset size')

if prin==1
    print -depsc  SPtmonitor.eps
else
    title('Figure 4.31 (left panel)')
    set(gcf,"Name",'Figure 4.31 (left panel)')
end

%% Create Figure 4.31 right panel
% Forward Search
[outFS]=FSReda(y,X,outLXS.bs,'init',p+1);
fanplotFS(outFS,'conflev',0.95,'flabstep',40);

if prin==1
    % print to postscript
    print -depsc SPtmonitor.eps;
else
    title('Figure 4.31 (right panel)')
    set(gcf,"Name",'Figure 4.31 (right panel)')
end

%% Create Figure 4.32 (with overlapping labels)
% Forward Search Monitoring of traditional tstat
[outFS]=FSReda(y,X,outLXS.bs,'init',p+1,'tstat','trad');
fanplotFS(outFS,'ylimy',[-5 300],'tag','ploverl','xlimx',[5 120],'flabstep',40);

if prin==1
    % print to postscript
    print -depsc SPtmonitortrad.eps;
else
    title('Figure 4.32')
    set(gcf,"Name",'Figure 4.32')
end

%% Create Figure 4.33
% SP data Forward Search Monitoring of added tstat
figure
[out]=FSRaddt(y,X,'plots',1,'nameX',{'X1','X2','X3' 'X4'},'lwdenv',2,'lwdt',2);

if prin==1
    % print to postscript
    print -depsc SPtmonitoradd.eps;
else
    title('Figure 4.33')
    set(gcf,"Name",'Figure 4.33')
end


%InsideREADME
