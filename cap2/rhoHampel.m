%% Details of Huber link for different values of c

% Plot of rho function.
close all
a=2;
b=4;
c=8;
subplot(2,2,1)
hold('on')
x=-9:0.1:9;
rhoHA=HArho(x,1);
maxrho=max(rhoHA);
% rhoHA=rhoHA/maxrho;
plot(x,rhoHA,'LineWidth',2)
xlabel('$u$','Interpreter','Latex')
ylabel('$\rho(u,c=1,c_1=2, c_2=4, c_3=8) $','Interpreter','Latex','FontSize',14)
stem(a,a^2/2,'LineWidth',1,'LineStyle',':','Color','r')
stem(b,a*b-a^2/2,'LineWidth',1,'LineStyle',':','Color','r')
stem(-a,a^2/2,'LineWidth',1,'LineStyle',':','Color','r')
stem(-b,a*b-a^2/2,'LineWidth',1,'LineStyle',':','Color','r')


% stem(c,a*(b+c-a),'LineWidth',1,'LineStyle',':','Color','r')
% stem(-c,a*(b+c-a),'LineWidth',1,'LineStyle',':','Color','r')
stem(c,a*b -0.5*a^2+(c-b)*a/2,'LineWidth',1,'LineStyle',':','Color','r')
stem(-c,a*b -0.5*a^2+(c-b)*a/2,'LineWidth',1,'LineStyle',':','Color','r')
kk=0.25;
text(a,kk,{'$c_1$'},'Interpreter','latex','FontSize',14,'HorizontalAlignment','left')
text(b,kk,{'$c_2$'},'Interpreter','latex','FontSize',14,'HorizontalAlignment','left')
text(c,kk,{'$c_3$'},'Interpreter','latex','FontSize',14,'HorizontalAlignment','left')

text(-a,kk,{'$-c_1$'},'Interpreter','latex','FontSize',14,'HorizontalAlignment','right')
text(-b,kk,{'$-c_2$'},'Interpreter','latex','FontSize',14,'HorizontalAlignment','right')
text(-c,kk,{'$-c_3$'},'Interpreter','latex','FontSize',14,'HorizontalAlignment','right')

subplot(2,2,3)
hold('on')
psiHA=HApsi(x,1);
% psiHA=psiHA/maxrho;
plot(x,psiHA,'LineWidth',2)
xlabel('$u$','Interpreter','Latex','FontSize',14)
ylabel('$\psi(u,c=1,c_1=2, c_2=4, c_3=8) $','Interpreter','Latex','FontSize',14)

stem(a,a,'LineWidth',1,'LineStyle',':','Color','r')
stem(b,a,'LineWidth',1,'LineStyle',':','Color','r')
stem(-a,-a,'LineWidth',1,'LineStyle',':','Color','r')
stem(-b,-a,'LineWidth',1,'LineStyle',':','Color','r')
stem(c,0,'LineWidth',1,'LineStyle',':','Color','r')
stem(-c,0,'LineWidth',1,'LineStyle',':','Color','r')

ax=axis;
ylim([ax(3)-0.1 ax(4)+0.1])
kk=0.2;
text(a,-kk,{'$c_1$'},'Interpreter','latex','FontSize',14,'HorizontalAlignment','left')
text(b,-kk,{'$c_2$'},'Interpreter','latex','FontSize',14,'HorizontalAlignment','left')
text(c,-kk,{'$c_3$'},'Interpreter','latex','FontSize',14,'HorizontalAlignment','left')

text(-a,kk,{'$-c_1$'},'Interpreter','latex','FontSize',14,'HorizontalAlignment','right')
text(-b,kk,{'$-c_2$'},'Interpreter','latex','FontSize',14,'HorizontalAlignment','right')
text(-c,kk,{'$-c_3$'},'Interpreter','latex','FontSize',14,'HorizontalAlignment','right')


% Hampel rho function using cc=
subplot(2,2,2)
hold('on')
a=2;
b=4;
c=8;
cc=0.1981;
x=-9:0.1:9;
rhoHA=HArho(x,[cc,a,b,c]);
maxrho=max(rhoHA);
% rhoHA=rhoHA/maxrho;
plot(x,rhoHA,'LineWidth',2)
xlabel('$u$','Interpreter','Latex')
ylabel('$\rho(u,c=0.1981,c_1=2, c_2=4, c_3=8) $','Interpreter','Latex','FontSize',14)
a=a*cc;
b=b*cc;
c=c*cc;
stem(a,a^2/2,'LineWidth',1,'LineStyle',':','Color','r')
stem(b,a*b-a^2/2,'LineWidth',1,'LineStyle',':','Color','r')
stem(-a,a^2/2,'LineWidth',1,'LineStyle',':','Color','r')
stem(-b,a*b-a^2/2,'LineWidth',1,'LineStyle',':','Color','r')


% stem(c,a*(b+c-a),'LineWidth',1,'LineStyle',':','Color','r')
% stem(-c,a*(b+c-a),'LineWidth',1,'LineStyle',':','Color','r')
stem(c,a*b -0.5*a^2+(c-b)*a/2,'LineWidth',1,'LineStyle',':','Color','r')
stem(-c,a*b -0.5*a^2+(c-b)*a/2,'LineWidth',1,'LineStyle',':','Color','r')
% text(a,kk,{'$c_1$'},'Interpreter','latex','FontSize',14,'HorizontalAlignment','left')
% text(b,kk,{'$c_2$'},'Interpreter','latex','FontSize',14,'HorizontalAlignment','left')
% text(c,kk,{'$c_3$'},'Interpreter','latex','FontSize',14,'HorizontalAlignment','left')
% 
% text(-a,kk,{'$-c_1$'},'Interpreter','latex','FontSize',14,'HorizontalAlignment','right')
% text(-b,kk,{'$-c_2$'},'Interpreter','latex','FontSize',14,'HorizontalAlignment','right')
% text(-c,kk,{'$-c_3$'},'Interpreter','latex','FontSize',14,'HorizontalAlignment','right')
% 
kk=0.02;
text(c,kk,{'$c \times  c_3$'},'Interpreter','latex','FontSize',14,'HorizontalAlignment','left')
text(-c,kk,{'$-c \times c_3$'},'Interpreter','latex','FontSize',14,'HorizontalAlignment','right')

ylim([0 maxrho])

subplot(2,2,4)
hold('on')

a=2;
b=4;
c=8;
psiHA=HApsi(x,[cc,a,b,c]);
% psiHA=psiHA/maxrho;

plot(x,psiHA,'LineWidth',2)
xlabel('$u$','Interpreter','Latex','FontSize',14)
ylabel(' Hampel $\psi(u,[2,4,8]) $','Interpreter','Latex')
ylabel('$\psi(u,c=0.1981,c_1=2, c_2=4, c_3=8) $','Interpreter','Latex','FontSize',14)
stem(cc*a,cc*a,'LineWidth',1,'LineStyle',':','Color','r')
stem(cc*b,cc*a,'LineWidth',1,'LineStyle',':','Color','r')
stem(-cc*a,-cc*a,'LineWidth',1,'LineStyle',':','Color','r')
stem(-cc*b,-cc*a,'LineWidth',1,'LineStyle',':','Color','r')
stem(-cc*c,0,'LineWidth',1,'LineStyle',':','Color','r')
stem(cc*c,0,'LineWidth',1,'LineStyle',':','Color','r')


ax=axis;
 ylim([ax(3)-0.001 ax(4)+0.001])
kk=0.03;
 text(cc*c,kk,{'$c \times c_3$'},'Interpreter','latex','FontSize',14,'HorizontalAlignment','left')
text(-cc*c,kk,{'$-c \times c_3$'},'Interpreter','latex','FontSize',14,'HorizontalAlignment','right')

% text([c1*a;-c1*a],[-0.1;0.1],{'$a$';'$-a$'},'Interpreter','latex','FontSize',14)
% text([c1*b;-c1*b],[-0.1;0.1],{'$b$';'$-b$'},'Interpreter','latex','FontSize',14)
% text([c1*c;-c1*c],[-0.1;0.1],{'$c$';'$-c$'},'Interpreter','latex','FontSize',14)

prin=0;
if prin==1
    % print to postscript
    print -depsc rhoHA.eps;
end