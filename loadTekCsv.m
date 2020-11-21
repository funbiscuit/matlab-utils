function [t, ch]=loadTekCsv(filename)
% load tektronix csv file

% probably should get it from file
skipRows = 18;

data=csvread(filename,skipRows);
t=data(:,1);
ch=data(:,2:end);
