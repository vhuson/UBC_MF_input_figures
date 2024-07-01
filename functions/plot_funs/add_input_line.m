function [curr_ax] = add_input_line(curr_ax,input_dur,opts)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
base_opts = struct();
base_opts.input_color = [0.7 0.7 0.7];
base_opts.LineWidth = 2;
base_opts.LineHeight_factor = 1;

if nargin < 3
    opts = base_opts;
else
    opts = merge_structs(base_opts,opts);
end

yPos = curr_ax.YLim(1) + diff(curr_ax.YLim)*opts.LineHeight_factor;

hold(curr_ax,'on')
line(curr_ax, input_dur,[yPos yPos],...
        'LineWidth',2,'Color',opts.input_color);
hold(curr_ax,'off')

% curr_ax.Children = [curr_ax.Children(2:end);...
%                         curr_ax.Children(1)];
end