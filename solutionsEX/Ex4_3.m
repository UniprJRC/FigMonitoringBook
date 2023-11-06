%% Surgical Unit data: 
% Analysis to test difference between two groups
% This file creates Figures A.10-A.12 and Table A.6
close all;
y=hospitalFS(:,5);
X=hospitalFS(:,1:4);

% Set dummy variable for surgical unit 1
group=ones(n,1);
group(55:n)=0;
n=length(y);
prin=0;

Xgroup=[X group];
nameXy={'X1','X2','X3' 'X4' 'dum' 'y'};
Xyt=array2table([Xgroup y],'VariableNames',nameXy);

%% Create Table A.6 
mdl=fitlm(Xyt);
disp('Table A.6')
disp(mdl)

%% Create Figure A.10
[out]=FSRaddt(y,[X group],'plots',1,'nameX',{'X1','X2','X3' 'X4' 'dum'},'lwdenv',2,'lwdt',2);
title('Figure A.10')
set(gcf,"Name",'Figure A.10')

if prin==1
    % print to postscript
    print -depsc SPaddvarDUM.eps;
end

%% Create Figure A.11
% TB rho function: analysis using S estimators with 2 values of breakdown
% point 
% Using bdp=0.5 it is clear that the first 54 units have a pattern of residuals
% which is different from the remaining 54

% 95 and 99 conflev
conflev=[0.95 0.99];

figure;
h1=subplot(2,1,1);
bdp=0.25;
[out]=Sreg(y,X,'nsamp',3000,'bdp',bdp,'rhofunc','bisquare');
resindexplot(out,'h',h1,'conflev',conflev);
ylabel(['Breakdown point =' num2str(bdp)])
h2=subplot(2,1,2);
bdp=0.5;
[out]=Sreg(y,X,'nsamp',3000,'bdp',bdp,'rhofunc','bisquare');
resindexplot(out,'h',h2,'conflev',conflev);
ylabel(['Breakdown point =' num2str(bdp)])
sgtitle('Figure A.11')
set(gcf,"Name",'Figure A.11')

if prin==1
    % print to postscript
    print -depsc SPStwobdp.eps;
end

%% Create Figure A.12
% PD rho function: analysis using S estimators with 2 values of breakdown
% point 
% Using bdp=0.5 it is clear that the first 54 units have a pattern of residuals
% which is different from the remaining 54
figure;
h1=subplot(2,1,1);
bdp=0.25;
[out]=Sreg(y,X,'nsamp',3000,'bdp',bdp,'rhofunc','mdpd');
resindexplot(out,'h',h1,'conflev',conflev);
ylabel(['Breakdown point =' num2str(bdp)])
h2=subplot(2,1,2);
bdp=0.5;
[out]=Sreg(y,X,'nsamp',3000,'bdp',bdp,'rhofunc','mdpd');
resindexplot(out,'h',h2,'conflev',conflev);
ylabel(['Breakdown point =' num2str(bdp)])
sgtitle('Figure A.12')
set(gcf,"Name",'Figure A.12')

if prin==1
    % print to postscript
    print -depsc SPStwobdpPD.eps;
end