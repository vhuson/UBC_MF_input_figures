function [] = fix_powered_ylabels(curr_ax)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

add_symbol = curr_ax.YTickLabel{1}(1);
y_min = curr_ax.YTick(1);

curr_ax.YTick = 10.^(-4:4);
curr_ax.YTickLabel = string(10.^(-4:4));

if strcmp(add_symbol,'<')
    curr_ax.YTickLabel{curr_ax.YTick == y_min} = ...
        [add_symbol,curr_ax.YTickLabel{curr_ax.YTick == y_min}];
end

curr_ax.YRuler.MinorTickValues = 10.^(-4:4);

end