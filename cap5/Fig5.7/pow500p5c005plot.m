%statpowSMM(:,4)=StatPOW(:,4)

%statpowSMM(:,5:6)=statpow(:,5:6)

% shifting
shift=[1 2 3 4 5 6 7];

%% Plotting part 005 contam.

% saving in StatPOW
statpowSMM=StatPOW;
% data table order
%  2   3      4      5      6
% 'S','MM', 'LTS', 'LTSr', 'FS'
% plot order
% 'FS','S','MM','LTSr','LTS'
YY=[statpowSMM(:,6) statpowSMM(:,2) statpowSMM(:,3) statpowSMM(:,5) statpowSMM(:,4)];

 % XX=statpowSMM(:,2:6);
 %YY=log(XX./(1-XX));

fsize=25;
plot1 = plot(shift, YY,'LineWidth',4,'Parent',axes);


% FS black
set(plot1(1),'LineStyle','-','Color',[0 0 0]);
% S
set(plot1(2),'LineStyle','--','Color',[0 0 1], 'Marker','o');
% MM col blue
set(plot1(3),'LineStyle','--','Color',[0 0 1], 'Marker','v');
% LTSr red
set(plot1(4),'LineStyle',':','Color','red', 'LineWidth',8);
% LTS 
set(plot1(5),'LineStyle','-.','Color','red');




% Create ylabel
xlabel('shift','FontSize',fsize);
% ylabel('logit average power','FontSize',fsize);
ylabel('average power','FontSize',fsize);

Ylabel=StatPOW(5,6)-0.3;

text(5.5,Ylabel-0.11,'FS','FontSize',fsize)
text(5.5,Ylabel-0.17,'S','FontSize',fsize)
text(5.5,Ylabel-0.23,'MM','FontSize',fsize)
text(5.5,Ylabel-0.29,'LTSr','FontSize',fsize)
text(5.5,Ylabel-0.35,'LTS','FontSize',fsize)


%legend('S','MM', 'LTS', 'LTSr', 'FS','FontSize',16, 'Location','southeast')
legend('FS','S', 'MM', 'LTSr', 'LTS', 'FontSize',fsize, 'Location','northwest')



xlim([1 7])

% % set(gca,'XTick',1:7)
% % % set(gca,'YTick',-10:5:10)
 set(gca,'YTick',0:0.2:1)

set(gca,'XTick',1:7)
%set(gca,'YTick',-12:5:10)

set(gca,'FontSize',25)
