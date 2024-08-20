%% Value added data: monitoring tstat
%
% This file creates Figure  8.34

%% Beginning of code
prin=0;
load valueadded.mat
XX=valueadded(:,[2:4 10]);
X=XX{:,1:3};
y=XX{:,4};
% Monitoring of added values t-stat using option ilr true
[out]=FSRaddt(y,X,'plots',1,'ilr',true,'init',20);

if prin==1
    % print to postscript
    print -depsc mvaTstat.eps;
else
    sgtitle('Figure 8.34')
    set(gcf,"Name",'Figure 8.34')
end

%InsideREADME

