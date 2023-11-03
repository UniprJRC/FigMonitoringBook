%% MR (Multiple regression data): Forward EDA datatooltip which monitors bsb
load('multiple_regression.txt');
y=multiple_regression(:,4);
X=multiple_regression(:,1:3);

%% Create Table A.3
mdl=fitlm(X,y);
disp('ANOVA table based on all the observations')
disp(mdl)

%% Create Table A.4
mdlExcl43=fitlm(X,y,'Exclude',43);
disp('ANOVA table after excluding observation 43')
disp(mdlExcl43)

%% Create Table A.5
mdlExcl24351=fitlm(X,y,'Exclude',[2 43 51]);
disp('ANOVA table after excluding observations 2, 43 and 51')
disp(mdlExcl24351)

%% Create Figure A.5 
% MMreg with hyperbolic rho function
outHYP=MMreg(y,X,'rhofunc','hyperbolic','eff',0.95);

h1=subplot(2,1,1);
% Show the weights
resindexplot(outHYP.weights,'ylimy',[0 1],'h',h1,'numlab',[2 43 51])
title('Weights')

h2=subplot(2,1,2);
% Show the scaled residuals
resindexplot(outHYP.residuals,'h',h2,'numlab',[2 43 51])
title('Scaled residuals')

sgtitle('Figure A.5')
set(gcf,"Name",'Figure A.5')

if prin==1
    % print to postscript
    print -depsc ARweiresMMhyp.eps;
end

%% Create Figure A.6
% MMreg with AS and PD  rho functions (compare residuals)
outAS=MMreg(y,X,'rhofunc','AS');
outPD=MMreg(y,X,'rhofunc','mdpd');

figure
h1=subplot(2,1,1);
resindexplot(outAS.residuals,'h',h1,'numlab',[2 43 51])
title('Scaled residuals using Andrews'' sine')
h2=subplot(2,1,2);
resindexplot(outPD.residuals,'h',h2,'numlab',[2 43 51])
title('Scaled residuals using power divergence')

sgtitle('Figure A.6')
set(gcf,"Name",'Figure A.6')


if prin==1
    % print to postscript
    print -depsc ARresMMaspd.eps;
end