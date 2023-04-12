%statpowSMM(:,4)=StatPOW(:,4)

%statpowSMM(:,5:6)=statpow(:,5:6)

% shifting
shift=[1 2 3 4 5 6 7];

%% Plotting part 005 contam.

% saving in StatPOW
%StatPOW=statpowSMM;
% data table order
%  1   2      3      4       5
% 'S','MM', 'LTS', 'LTSr', 'FS'
% plot order
% 'FS','S','MM','LTS','LTSR'
XX=[StatPOW(:,6) StatPOW(:,2) StatPOW(:,3) StatPOW(:,4) StatPOW(:,5)];

 % XX=statpowSMM(:,2:6);
 YY=log(XX./(1-XX));

fsize=25;
%axis square;
plot1 = plot(shift, YY,'LineWidth',4,'Parent',axes);


% FS black
set(plot1(1),'LineStyle','-','Color',[0 0 0]);
% S
set(plot1(2),'LineStyle','--','Color',[0 0 1], 'Marker','o');
% LTS 
set(plot1(4),'LineStyle','-.','Color','red');
% MM col blue
set(plot1(3),'LineStyle','--','Color',[0 0 1], 'Marker','v');
% LTSr red
set(plot1(5),'LineStyle',':','Color','red', 'LineWidth',8);



% Create ylabel
xlabel('shift','FontSize',fsize);
ylabel('logit average power','FontSize',fsize);

Ylabel=-3;

text(5.5,Ylabel-0,'FS','FontSize',fsize)
text(5.5,Ylabel-1,'S','FontSize',fsize)
text(5.5,Ylabel-2,'MM','FontSize',fsize)
text(5.5,Ylabel-3,'LTS','FontSize',fsize)
text(5.5,Ylabel-4,'LTSr','FontSize',fsize)




legend('FS','S', 'MM','LTS', 'LTSr', 'FontSize',fsize, 'Location','northwest')



xlim([1 7])

% % set(gca,'XTick',1:7)
 set(gca,'YTick',-10:5:10)
% set(gca,'YTick',0:0.2:1)

set(gca,'XTick',1:7)
%set(gca,'YTick',-12:5:10)

set(gca,'FontSize',25)
