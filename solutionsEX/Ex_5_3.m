%% Theoretical individual and simultaneous size
% Create Figures A.15 and A.16


%% Create Figure A.15: plot of the size when p=2
close all
p=2;
n=30:5000;
lwd=2;
pro=1000*(1-betacdf(n*chi2inv(0.99,1)./(n-p).^2,0.5,(n-p-1)/2));
plot(n,pro,'--','LineWidth',lwd)
ylim([0 10.1])
xlabel('Sample size')
hold('on')
pstar=(betacdf(n.*chi2inv(1-0.01./n,1)./((n-p).^2),0.5,(n-p-1)/2));
ps=1000*(1-pstar.^n);
disp(1000*ps)
plot(n,ps,'-.','LineWidth',lwd)
ylabel('Theoretical size p=2')
yline(10)
legend({'Individual test' 'Simultaneous test' '10=Nominal size'},'Location','best')

prin=0;
if prin==1
    % print to postscript
    print -depsc theosizep2.eps;
else
    title("Figure A.15")
end

%% Create Figure A.16: plot of the size when p=10
close all
p=10;
n=30:5000;
lwd=2;
pro=1000*(1-betacdf(n*chi2inv(0.99,1)./(n-p).^2,0.5,(n-p-1)/2));
plot(n,pro,'--','LineWidth',lwd)
ylim([0 10.1])
xlabel('Sample size')
hold('on')
pstar=(betacdf(n.*chi2inv(1-0.01./n,1)./((n-p).^2),0.5,(n-p-1)/2));
ps=1000*(1-pstar.^n);
disp(1000*ps)
plot(n,ps,'-.','LineWidth',lwd)
ylabel('Theoretical size p=10')
yline(10)
legend({'Individual test' 'Simultaneous test' '10=Nominal size'},'Location','best')
prin=0;
if prin==1
    % print to postscript
    print -depsc theosizep10.eps;
else
    title("Figure A.16")
end

%InsideREADME 