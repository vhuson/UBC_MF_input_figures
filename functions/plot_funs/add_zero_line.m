function [curr_ax] = add_zero_line(curr_ax)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
hold(curr_ax,'on')
plot(curr_ax,[curr_ax.XLim],[0 0],...
    'Color',[0.7 0.7 0.7],'LineStyle','--')
hold(curr_ax,'off')

curr_ax.Children = [curr_ax.Children(2:end);...
                        curr_ax.Children(1)];
end