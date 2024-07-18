function [] = plot_fs(yData,Fs,curr_ax)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
if nargin < 2
    Fs = 20000;
end

if nargin < 3
    curr_fig = figure;
    curr_ax = axes(curr_fig);
end
xData = 1:numel(yData);
xData = xData/Fs;


plot(curr_ax,xData,yData);

end