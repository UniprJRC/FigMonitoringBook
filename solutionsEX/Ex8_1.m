%% Frequentist analysis of the Windsor House Price data
%
% This file creates Figures A.44

%% Beginning of code
prin=0;

load hprice.txt;

% setup parameters
n=size(hprice,1);
y=hprice(:,1);
X=hprice(:,2:5);
out=FSR(y,X);
pl_yX=findobj(0, 'type', 'figure','tag','fsr_yXplot');
close(pl_yX)

plres=findobj(0, 'type', 'figure','tag','pl_res');
if prin==1
    % print to postscript
    print -depsc h7.eps;
else
    title("Figure A.44")    
    set(gcf,"Name",'Figure A.44')
end

%InsideREADME
