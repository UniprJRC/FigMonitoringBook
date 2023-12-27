%% Exercise 7.1
%
% New updated transformed values in AVAS
% This file creates Figure A.35 and Table A.17 

%% Beginning of code
prin=0;

divisor=9.5;
x = (0:pi/divisor:pi)';
y = sin(x);
X=x;
y=exp(y);
scatter(x,y)
n=length(y);

if prin==1
    % print to postscript
    print -depsc ctsubxy.eps;
end

%% Create Table A.17
oldValuestyhat=(y-mean(y))/std(y,1);
updatedValuestyhatTfalse=ctsub(yhatord,v,oldValuestyhat,false);
updatedValuestyhatTtrue=ctsub(yhatord,v,oldValuestyhat,true);

names=["Old values tyhat" "Updated values tyhat trapeziod=false" ...
    "Updated values tyhat trapeziod=true"];
oldAndNew=[oldValuestyhat updatedValuestyhatTfalse updatedValuestyhatTtrue];
oldAndNewT=array2table(oldAndNew,"VariableNames",names);
disp('Table A.17')
disp(oldAndNewT)


%% Create Figure A.35
% load v=  reciprocal of smoothed residuals
% load yhatord = sorted fitted values
load wsctsub.mat

plot(yhatord,v,'LineWidth',2)
hold('on')
stem(yhatord,v)
scatter(oldValuestyhat,zeros(n,1),'black','filled')
set(gca,"XTickLabel",'');
yhatstr="$\widehat{ty}_{["+ string((1:(n-1))') + "]}^{(1)}$";
text(yhatord(1:n-1),zeros(n-1,1)-0.7,yhatstr,'Interpreter','latex', ...
    'FontSize',16,'VerticalAlignment','baseline','HorizontalAlignment','left')

yhatstr10="$\widehat{ty}_{["+ string(n) + "]}^{(1)}$";
text(yhatord(n)+0.03,zeros(1,1)-0.7,yhatstr10,'Interpreter','latex', ...
    'FontSize',16,'VerticalAlignment','baseline','HorizontalAlignment','left')

tyhatstr="$\widehat{ty}_{"+ string((1:n)') + "}^{(0)}$";
text(oldValuestyhat,zeros(n,1)+0.8,tyhatstr,'Interpreter','latex', ...
    'FontSize',16,'VerticalAlignment','top','HorizontalAlignment','left')
vstr="$v_{"+ string((1:n)') + "}$";

text(yhatord,v,vstr,'Interpreter','latex', ...
    'FontSize',16,'VerticalAlignment','top','HorizontalAlignment','left')
xlabel('Ordered fitted values','FontSize',14)
ylabel('Reciprocal of smoothed residuals ($v$)','Interpreter','latex', ...
    'FontName','Courier New','FontSize',16)
vec_pos = get(get(gca, 'XLabel'), 'Position');
set(get(gca, 'XLabel'), 'Position', vec_pos + [0 -0.5 0]);
set(gca,"Xtick",'')
if prin==1
    % print to postscript
    print -depsc ctsub.eps;
end

%InsideREADME 