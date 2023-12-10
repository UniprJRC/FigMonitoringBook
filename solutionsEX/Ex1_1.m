%% Exercise 1.1.
%
% Trimmed means.

%% Data loading
clear
load Income1

% y in array format
y=Income1{:,"HTOTVAL"};

% Compute the trimmed mean for the first 15 obs.for two values of alpha
y15=y(1:15);
n15=length(y15);

alphaAll=[0.05 0.10];
lalphaAll=length(alphaAll);
meanTru=zeros(lalphaAll,1);
ysor=sort(y15);
for i=1:lalphaAll
    m=floor((n15-1)*alphaAll(i));
    meanTru(i)=mean(ysor(m+1:n15-m));
    % meanTru1(i)=trimmean(y,100*alphaAll(i));
end

disp("Trimmed mean alpha=0.05")
disp(meanTru(1))

disp("Trimmed mean alpha=0.10")
disp(meanTru(2))

%InsideREADME 