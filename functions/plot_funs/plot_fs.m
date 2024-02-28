function [] = plot_fs(yData,Fs,curr_fig)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
if nargin < 2
    Fs = 20000;
end

if nargin < 3
    curr_fig = figure;
end
xData = 1:numel(yData);
xData = xData/Fs;

curr_ax = axes(curr_fig);
plot(curr_ax,xData,yData);

end