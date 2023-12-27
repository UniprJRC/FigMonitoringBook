%% Consistency factor, break down point and efficiency. 
% 
% This file createa Figure 3.6, 3.7, Table 3.2 and 3.3.

%%
% lwd = LineWidth
lwd=3;
% fs = FontSize
fs=16;

prin=0;
close all

%% Create Figure 3.6
% bdp varies: compute consistency factor c and efficiency
bdpseq=0.001:0.001:0.5;

TB=[bdpseq' zeros(length(bdpseq),1)];
ij=0;

for i=bdpseq

    ij=ij+1;
    TB(ij,2)=TBbdp(i,1);

    [~,eff]=TBc(TB(ij,2),1);
    TB(ij,3)=eff;
end

subplot(2,1,1);
plot(TB(:,1),TB(:,2),'LineWidth',lwd)
ylim([min(TB(:,2)) max(TB(:,2))]);
ylabel('c','FontSize',fs)
xlabel('Breakdown point (bdp)','FontSize',fs)
set(gca,'FontSize',fs)

subplot(2,1,2);
plot(TB(:,1),TB(:,3),'LineWidth',lwd)
ylim([min(TB(:,3)) max(TB(:,3))]);
xlabel('Breakdown point (bdp)','FontSize',fs)
ylabel('Efficiency (eff)','FontSize',fs')
set(gca,'FontSize',fs)

sgtitle('Figure 3.6')
set(gcf,"Name",'Figure 3.6')


if prin==1
    % print to postscript
    print -depsc TBrhox.eps;
end

%% Create Figure 3.7
% eff varies: compute consistency factor c and e bdp
effseq=0.5:0.001:0.99;
TB=[effseq' zeros(length(effseq),1)];
ij=0;

for i=effseq

    ij=ij+1;
    TB(ij,2)=TBeff(i,1);

    [bdp,~]=TBc(TB(ij,2),1);
    TB(ij,3)=bdp;
end

figure
subplot(2,1,1);
plot(TB(:,1),TB(:,2),'LineWidth',lwd)
ylim([min(TB(:,2)) max(TB(:,2))]);
ylabel('c','FontSize',fs)
xlabel('Efficiency (eff)','FontSize',fs)
set(gca,'FontSize',fs)

subplot(2,1,2);
plot(TB(:,1),TB(:,3),'LineWidth',lwd)
ylim([min(TB(:,3)) max(TB(:,3))]);
xlabel('Efficiency (eff)','FontSize',fs)
ylabel('Breakdown point (bdp)','FontSize',fs')
set(gca,'FontSize',fs)

sgtitle('Figure 3.7')
set(gcf,"Name",'Figure 3.7')

if prin==1
    % print to postscript
    print -depsc TBeffx.eps;
end

%%  Create Tables 3.2 and 3.3
% Create Table 3.2
bdpseq=0.05:0.05:0.5;
TBinputbdp=[bdpseq' zeros(length(bdpseq),1)];
ij=0;

for i=bdpseq
    ij=ij+1;
    TBinputbdp(ij,2)=TBbdp(i,1);

    [~,eff]=TBc(TBinputbdp(ij,2),1);
    TBinputbdp(ij,3)=eff;
end

varNames=["Breakdown point bdp" "Consistency factor c" "Efficiency eff"];
T32=array2table(TBinputbdp,"VariableNames",varNames);
disp("Table 3.2")
disp(T32)

% Create Table 3.3
% eff varies: compute consistency factor c and e bdp
effseq=[0.5 0.6 0.7:0.05:0.95 0.99];
TBinputeff=[effseq' zeros(length(effseq),1)];
ij=0;

for i=effseq

    ij=ij+1;
    TBinputeff(ij,2)=TBeff(i,1);

    [bdp,~]=TBc(TBinputeff(ij,2),1);
    TBinputeff(ij,3)=bdp;
end

disp("Table 3.3")
varNames=["Asymptotic efficiency at the normal model" "Consistency factor c" "Efficiency eff"];
T33=array2table(TBinputeff,"VariableNames",varNames);
disp(T33)

%InsideREADME 