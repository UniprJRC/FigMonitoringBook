%% Multiple tests and the Bonferroni correction
% Create Figure A.14

%% Beginning of code
close all
seq=20:200; 
alpha=0.05;
Pra05=1- (1-alpha).^(seq);
hold('on')
alpha=0.01;
Pra01=1- (1-alpha).^(seq);
plot(seq,Pra05,'--',seq,Pra01,'-.','LineWidth',2)
xlabel('Number of tests')
ylabel('Prob. at least one significant result')
legend({'\alpha=0.05' '\alpha=0.01'},'Location','best','FontSize',14)
prin=0;
if prin==1
    % print to postscript
    print -depsc bonfcorr.eps;
else
    title("Figure A.14")
end
%InsideREADME 