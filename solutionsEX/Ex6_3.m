%% Balance sheets data
% Further analysis of the Balance sheets data: 
XX=load('BalanceSheets.txt');
% Define X and y
y=XX(:,6);
X=XX(:,1:5);
n=length(y);
ytra=normYJpn(y, [], [0.5, 1.5], 'inverse',false, 'Jacobian', false);
close all
prin=0;

%% Prepare the input for Figure A.18 
% yXplot with 3 symbols
% Brushed units
brushedun=[94 188 206 226 373 488 496 535 653 757 764 836 842 856 863 ...
         1129 1136 1207 1400];
outTRA=FSR(ytra,X,'plots',0);
outl=outTRA.outliers;
extraOUT=setdiff(outTRA.outliers,brushedun);

%% Create Figure A.18  
% yXplot with the 3 groups
group=ones(n,1);
group(brushedun)=2;
group(extraOUT)=3;
yXplot(ytra,X,group);

sgtitle('Figure A.18')
set(gcf,"Name",'Figure A.18')

if prin==1
    % print to postscript
    print -depsc BS3groups.eps;
end