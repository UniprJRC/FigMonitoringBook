%% Two variable model (section 7.5.2).
% This file creates Figures 7.6-7.9.

%% Generate the data 
rng(30)
x2 = (0:0.01:1.5)';
n=length(x2);
x1=randn(n,1);
X=[x1 x2];
y = 10*(1+sin(x1)+ exp(x2)) + 0.5*(randn(n,1)-0.5);
y=y.^3;
prin=0;


%% Two variable model: create Figure 7.6
% All options initially set to false
outNoOption=avas(y,X,'rob',false,'tyinitial',false,...
    'scail',false,'orderR2',false,'trapezoid',false);
aceplot(outNoOption,'tyOriginal',false,'oneplot',[])

disp('pvalue of DW test (no option is used)')
disp(outNoOption.pvaldw)

sgtitle('Figure 7.6')
set(gcf,"Name",'Figure 7.6')

if prin==1
    % print to postscript
    print -depsc figs\tyinitial1.eps;
end

%% Create Figure 7.7
% Two variable model: scail set to true
outScailTrue=avas(y,X,'rob',false,'tyinitial',false,...
    'scail',true,'orderR2',false,'trapezoid',false);
disp('pvalue of DW test (scail=true)')
disp(outScailTrue.pvaldw)
aceplot(outScailTrue,'tyOriginal',false,'oneplot','')
sgtitle('Figure 7.7')
set(gcf,"Name",'Figure 7.7')

if prin==1
    % print to postscript
    print -depsc figs\tyinitial2.eps;
end

%% Create Figure 7.8
% Two variable model: tyinitial true and scail true
tyinitial=struct;
tyinitial.la=[0 0.1 0.2 0.3 0.4 1/2];
outScailTruetyini=avas(y,X,'rob',false,'tyinitial',tyinitial,...
    'scail',true,'orderR2',false,'trapezoid',false);

disp('pvalue of DW test (scail=true tyinitial=true)')
disp(outScailTruetyini.pvaldw)
aceplot(outScailTruetyini,'tyOriginal',false,'oneplot','')

sgtitle('Figure 7.8')
set(gcf,"Name",'Figure 7.8')

if prin==1
    print -depsc figs\tyinitial3.eps;
end


%%  Create Figure 7.9
% Two variable model: all options set to true
tyinitial=struct;
tyinitial.la=[0 0.1 0.2 0.3 0.4 1/2];
outAllOptions=avas(y,X,'rob',true,'tyinitial',tyinitial,...
    'scail',true,'orderR2',true,'trapezoid',true);

disp('pvalue of DW test (all options)')
disp(outAllOptions.pvaldw)

aceplot(outAllOptions,'oneplot',true)

sgtitle('Figure 7.9')
set(gcf,"Name",'Figure 7.9')

if prin==1
    print -depsc figs\tyinitial4.eps;
end