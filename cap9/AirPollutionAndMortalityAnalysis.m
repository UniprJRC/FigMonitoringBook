clear all
close all
load('myMat.mat') 
RowNames = myTable.CITY;
myTable2 = rmfield( myTable , 'CITY' );
T = struct2table(myTable2);
X = double(table2array(T));
T2 = array2table(X,'VariableNames',T.Properties.VariableNames);
typespm=struct;
typespm.lower="circle";
typespm.upper="circle";
plo = struct;
plo.TickLabels = false;
spmplot(T2,'typespm',typespm,'dispopt','box', 'plo',plo);
