%statpowSMM(:,4)=StatPOW(:,4)

%statpowSMM(:,5:6)=statpow(:,5:6)

%% Plotting part 005 contam.

StatPOW=statpowSMM;

% YY=statpowSMM(:,2:6);

  XX=statpowSMM(:,2:6);
 YY=log(XX./(1-XX));

fsize=25;
plot1 = plot(shift, YY,'LineWidth',4,'Parent',axes);


% S
set(plot1(1),'LineStyle','--','Color',[0 0 1], 'Marker','o');
% MM col blue
set(plot1(2),'LineStyle','--','Color',[0 0 1], 'Marker','v');
% LTS 
set(plot1(3),'LineStyle','-.','Color','red');
% LTSr red
set(plot1(4),'LineStyle',':','Color','red', 'LineWidth',8);
% FS black
set(plot1(5),'LineStyle','-','Color',[0 0 0]);
% LTScs
% set(plot1(6),'LineStyle','-.','Color', 'green');

% Create ylabel
xlabel('shift','FontSize',fsize);
ylabel('average power','FontSize',fsize);

text(StatPOW(4,1)+0.05,StatPOW(4,2)+0.10,'S','FontSize',fsize)
text(StatPOW(3,1)+0.05,StatPOW(3,3)+0.10,'MM','FontSize',fsize)
text(StatPOW(6,1)+0.05,StatPOW(6,4)+0.05,'LTS','FontSize',fsize)
text(StatPOW(5,1)+0.05,StatPOW(5,5)+0.05,'LTSr','FontSize',fsize)
text(StatPOW(5,1)+0.05,StatPOW(5,6)+0.05,'FS','FontSize',fsize)
%text(StatPOW(6,1)+0.05,StatPOW(6,7)+0.05,'LTScs','FontSize',fsize)

%legend('S','MM', 'LTS', 'LTSr', 'FS','FontSize',16, 'Location','southeast')
legend('S','MM', 'LTS', 'LTSr', 'FS', 'FontSize',fsize, 'Location','northwest')



xlim([1 7])

% % set(gca,'XTick',1:7)
% % % set(gca,'YTick',-10:5:10)

set(gca,'YTick',0:0.2:1)

set(gca,'XTick',1:7)
%set(gca,'YTick',-12:5:10)

set(gca,'FontSize',25)
