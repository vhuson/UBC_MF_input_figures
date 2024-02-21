function [] = plot_fs(yData,Fs)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
xData = 1:numel(yData);
xData = xData/Fs;

plot(xData,yData);

end