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

