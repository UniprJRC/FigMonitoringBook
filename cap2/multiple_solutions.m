%% Example to show the issue of multiple solutions problem with redescending psi functions

load Income1;
y=Income1{:,"HTOTVAL"};
% Use contaminated income data 
y=[y(1:20); 600000; 575000; 590000];

y=y';
mady=mad(y,1)/0.675;

eff=0.95;
TBc=TBeff(eff,1);
HUc=HUeff(eff,1);
HAc=HAeff(eff,1);
HYPc=HYPeff(eff,1);
OPTc=OPTeff(eff,1);
PDc=PDeff(eff);


mu=0:1000:700000;
avePSI=zeros(length(mu),6);
for i=1:length(mu)
    % aveTB(i,2)=mean(TBrho((y-mu(i))./mady,c));

    avePSI(i,1)=mean(HUpsi((y-mu(i))./mady,HUc));
    avePSI(i,2)=mean(HApsi((y-mu(i))./mady,HAc));
    avePSI(i,3)=mean(TBpsi((y-mu(i))./mady,TBc));
    avePSI(i,4)=mean(HYPpsi((y-mu(i))./mady,[HYPc,5]));
    avePSI(i,5)=mean(OPTpsi((y-mu(i))./mady,OPTc));
    avePSI(i,6)=mean(PDpsi((y-mu(i))./mady,PDc));

end
% Plotting part
close
Link={'Huber', 'Hampel', 'Tukey', 'Hyperbolic' 'Optimal' 'Power divergence'} ;
for i=1:6
    subplot(2,3,i)
    plot(mu',avePSI(:,i),'LineWidth',2,'Color','k')
    hold('on')
    yline(0) %  line([min(mu);max(mu)],[0;0],'LineStyle',':')
    title(Link(i),'FontSize',14)
    xlabel('$\mu$','FontSize',14,'Interpreter','Latex')
    ylabel('$\overline \psi \left( \frac{ y -\mu}{\hat \sigma} \right)$','FontSize',14,'Interpreter','Latex')
end

prin=0;
if prin==1
    % print to postscript
    print -depsc multsol.eps;
end
