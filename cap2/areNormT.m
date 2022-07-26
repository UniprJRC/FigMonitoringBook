%% Compute empirical and theoretical ARE(mean median)
% For N(0,1) and then for Student T with 5 degrees of freedomm.
% Then use Student T with 2, 2.1, 2.2, ..., 10 degrees of
% Plot the value of the ARE(mean,median) empirical and theoretical

%% Compare ARE(mean,median) under the normal distribution
n=100;
nsimul=10000;
meandistr=zeros(nsimul,1);
mediandistr=zeros(nsimul,1);

for j=1:nsimul
    y=randn(n,1);
    meandistr(j)=mean(y);
    mediandistr(j)=median(y);
end

disp('ARE(mean,median) empirical when N(0.1)')
disp(var(meandistr)/var(mediandistr))

%% Compare ARE(mean,median) under the Student t_5
n=100;
nsimul=10000;
meandistr=zeros(nsimul,1);
mediandistr=zeros(nsimul,1);
% nu = degrees of freedom of Student T
nu = 5;

for j=1:nsimul
    y=trnd(nu, n,1);
    meandistr(j)=mean(y);
    mediandistr(j)=median(y);
end

disp('ARE(mean,median) empirical with T(5)')
disp(var(meandistr)/var(mediandistr))

%% Compute the ARE as function of degrees of freedom
% Var(sample mean)/Var(sample median)
n=100;
nsimul=50000;
nuall=2.1:0.1:10;
lnu=length(nuall);
VarRatioE=zeros(1,lnu);
VarRatioT=zeros(1,lnu);

meandistr=zeros(nsimul,1);
mediandistr=zeros(nsimul,1);
% nu = degrees of freedom of Student T
ij=0;
for nu=nuall
    ij=ij+1;
    parfor j=1:nsimul
        y=trnd(nu, n,1);
        meandistr(j)=mean(y);
        mediandistr(j)=median(y);
    end
    disp(['Degrees of freedom: ' num2str(nu)])
    VarRatioE(ij)=var(meandistr)/var(mediandistr);
end

%% Plot the empirical ARE  as function of degrees of freedom of Student T
% Var(sample mean)/Var(sample median)
close all
ld=1.2;
fs=16;
plot(nuall,smooth(VarRatioE),'LineWidth',ld)
hline=refline(0,1);
hline.Color = 'r';
xlabel('Degrees of freedom of Student $t$','FontSize',fs-2,'Interpreter','latex')
ylabel('ARE(Me,$\overline y$)','Interpreter','latex','FontSize',fs)



%% Plot the  theoretical ARE curve as function of degrees of freedom
% Var(sample mean)/Var(sample median)
% nu = degrees of freedom of Student T
ij=0;
for nu=nuall
    ij=ij+1;
    varmedian=1/(2*tpdf(0,nu))^2;
    varmean=nu/(nu-2);
    VarRatioT(ij)=varmean/varmedian;
end


ld=1.2;
fs=16;
close all
hold('on')
% plot(nuall,(VarRatioE),'r','LineWidth',ld)
plot(nuall,VarRatioT,'b', 'LineWidth',ld)

hline=refline(0,1);
hline.Color = 'r';
xlabel('Degrees of freedom of Student $t$','FontSize',fs-2,'Interpreter','latex')
ylabel('ARE(Me,$\overline y$)','Interpreter','latex','FontSize',fs)

prin=0;
if prin==1
    % print to postscript
    print -depsc AREstudT.eps;
end