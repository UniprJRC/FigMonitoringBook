%% Variance comparison under the contamination model.
%
% This file creates Figure 2.4.

%% General settings
% Computes the variance of the sample mean and of the sample median
% (multiplied by n) under the contamination model (not all measurements are
% equally precise).
tau=(1:0.001:10)';
lwd=3;
FontSize=14;

%% Create plots
subplot(2,2,1)
eps=0.05;
nvarmean=(1-eps)+eps*(tau.^2);
nvarMe=pi./(2*((1-eps +eps./tau).^2));
hold('on')
plot(tau,nvarmean,'r-','LineWidth',lwd)
plot(tau,nvarMe,'b-.','LineWidth',lwd)
xlabel('\tau','FontSize',FontSize)
set(gca,'FontSize',FontSize)
if ispc
    title('\epsilon=0.05','FontSize',FontSize)
else
    title('\varepsilon=0.05','FontSize',FontSize)
end
xlim([tau(1) tau(end)])
ylim([1 11])

subplot(2,2,2)
eps=0.10;
nvarmean1=(1-eps)+eps*(tau.^2);
nvarMe1=pi./(2*((1-eps +eps./tau).^2));
hold('on')
plot(tau,nvarmean1,'r-','LineWidth',lwd)
plot(tau,nvarMe1,'b-.','LineWidth',lwd)
xlabel('\tau','FontSize',FontSize)
set(gca,'FontSize',FontSize)
if ispc
    title('\epsilon=0.10','FontSize',FontSize)
else
    title('\varepsilon=0.10','FontSize',FontSize)
end

xlim([tau(1) tau(end)])
ylim([1 11])
legend({'$n \times$ var($\overline y$)' '$n \times$ var(med)'},'Interpreter','latex')
vv=[tau,nvarmean nvarMe];
vv1=[tau,nvarmean1 nvarMe1];

prin=0;
if prin==1
    % print to postscript
    print -depsc AREcont.eps;
else
        set(gcf,"Name",'Figure 2.4')
end

%InsideREADME