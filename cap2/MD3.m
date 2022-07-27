%% Breakdown point and efficiency for PD link.
% Create: Power divergence: breakdown point and efficiency as functions of 𝛼.
%Analysis of breakdown point and asymptotic efficiency
%at the normal distribution as a function of alpha in regression.
c=0.01:0.01:3;
[bdp,eff]=PDc(c);
subplot(2,1,1)
plot(c,bdp)
xlabel('$\alpha$','Interpreter','Latex','FontSize',16)
ylabel('Breakdown point','Interpreter','none')
grid on
subplot(2,1,2)
plot(c,eff)
xlabel('$\alpha$','Interpreter','Latex','FontSize',16)
ylabel('Asymptotic efficiency','Interpreter','none')
grid on
prin=0;
if prin==1
    % print to postscript
    print -depsc figs\MD3.eps;
end
