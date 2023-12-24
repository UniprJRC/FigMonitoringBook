%% Exercise 9.2
%
% Analysis of air pollution and mortality data.
% This file creates Figures A.59

%% Load air pollution data 
load air_pollution.mat
typespm=struct;
% What to show in the lower part
typespm.lower='circle';
% What to show in the upper part
typespm.upper='circle';
% What to show in the main diagonal
dispopt='box';
% Perosnalized label rotation, maximum label length and ticklabels
plo=struct;
plo.nameYrot=0;
plo.TickLabels=[]; 
spmplot(air_pollution,'typespm',typespm,'dispopt',dispopt,'plo',plo);

%InsideREADME 