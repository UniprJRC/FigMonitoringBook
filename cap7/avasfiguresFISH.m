
%% Analysis of fish data
% https://www.kaggle.com/aungpyaeap/fish-market
clear
close all
prin=0;
load fish.mat
Y=fish;

% yXplot(Y{:,2},Y{:,3:end},'group',Y{:,1});


% Toglier pike e utilizzare solo le prime 3
sel=categorical(Y{:,1})~='Pike';
y=Y{sel,2};
X=Y{sel,3:5};
%% Fish Automatic model selection ALL VAR
close all
[VALtfin,CorrMat]=avasms(y,X,'l',3*ones(size(X,2),1));

avasmsplot(VALtfin,'showBars',true)
disp(VALtfin)
if prin==1
    % print to postscript
    print -depsc figs\F1.eps;
      print -depsc figs\F1bis.eps;
  
end
%% Details of  solution j ALLVAR
close all
j=1;
outj=VALtfin{j,"Out"};
out=outj{:};
disp(out)
aceplot(out)
prin=0;
 if prin==1
    % print to postscript
    print -depsc figs\F2.eps;
   %  print -depsc figs\F3.eps;
    
 end
ytra=out.ty;
Listout=out.outliers;

%%  FISH JUST one expl  
 close all
[VALtfin,CorrMat]=avasms(y,X(:,1),'l',3*ones(size(X,2),1));
close all
j=1;
outj=VALtfin{j,"Out"};
out=outj{:};
disp(out)
ytrajust1=out.ty;
Listoutjust1=out.outliers;

% aceplot(out)
 

%% comparison of transformations
close all
[~,ind]=sort(y);
clc
subplot(2,2,1)
ytheo=(y.^(1/3));
ystand=zscore(y);
ytheoz=zscore(ytheo(ind));
[ysor, ind]=sort(ystand);
[ytraz,mu,sig]=zscore(ytra(ind));
[ytrajust1z,mujust1,sigjust1]=zscore(ytrajust1(ind));

plot(ysor,ytraz,'o',ysor,ytheoz,'--')
hold('on')
 plot(ystand(Listout),(ytra(Listout)-mu)/sig,'o','Color','r','MarkerFaceColor','r')

 subplot(2,2,2)
plot(ysor,ytrajust1z,'o',ysor,ytheoz,'x')
hold('on')
 plot(ystand(Listoutjust1),(ytra(Listoutjust1)-mujust1)/sigjust1,'o','Color','r','MarkerFaceColor','r')

 if prin==1
    % print to postscript
    print -depsc figs\F4.eps;
 end

 %% R2 using y^1/3 and deleting obs. 41
 fitlm(X(:,1),ytheo,'Exclude',41)
