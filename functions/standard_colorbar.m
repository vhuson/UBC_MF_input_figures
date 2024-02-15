function [] = standard_colorbar(cb,curr_ax)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
cb.TickDirection = 'out';
cb.FontSize = 12;
cb.LineWidth = 1;

temp_units = curr_ax.Units;
curr_ax.Units = 'pixels';

axLength = max(curr_ax.Position(3:4));
cb.TickLength = [4/axLength];

curr_ax.Units = temp_units;

end