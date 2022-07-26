function meantrimmed = trimmeanFS(y,alpha)
%trimmeanFS trims a proportion alpha of observations from both ends
n=length(y);
ysor=sort(y);
m=floor((n-1)*alpha);
meantrimmed=mean(ysor(m+1:n-m));
end