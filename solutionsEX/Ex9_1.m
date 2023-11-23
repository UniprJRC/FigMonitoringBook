%% This file creates Figure A.57, A.57 and Table A.20

% Load Ozone data (reduced data)
X=load('ozone.txt');
% Transform the response using logs
X(:,end)=log(X(:,end));
% Add a time trend
X=[(-40:39)' X];
% Define y
y=X(:,end);
% Define X
X=X(:,1:end-1);
labels={'Time','1','2','3','4','5','6','7','8'};
% Select Time + variables 4,5, and 6
sel=[1 [ 4 5 6]+1];
Xsel=X(:,sel);
nameX="X"+string(labels(sel));
nameXy=[nameX "y"];
nameXy(1)="Time";

prin=0;

%% Prepare input for Figures A.56 and A.57
out=avasms(y,Xsel,'plots',0);
j=1;
outjm=out{j,"Out"};
outm=outjm{:};

%% Create Figures A.56 and A.57
aceplot(outm,'VarNames',nameXy)
pl_ty=findobj(0, 'type', 'figure','tag','pl_ty');
figure(pl_ty(1))
sgtitle('Figure A.56')
set(gcf,"Name",'Figure A.56')

pl_tX=findobj(0, 'type', 'figure','tag','pl_tX');
figure(pl_tX(1))
sgtitle('Figure A.57')
set(gcf,"Name",'Figure A.57')


disp("number of outliers found")
disp(length(outm.outliers))

if prin==1
    % print to postscript
    print -depsc ozoneredRAVAS.eps;
      print -depsc ozoneredRAVAStX.eps;
end

%% Create Table A.20
outLM=fitlm(outm.tX,outm.ty,'Exclude',outm.outliers,'VarNames',nameXy);
disp("Table A.20")
disp(outLM)
