function [] = fix_powered_ylabels(curr_ax)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

add_symbol = curr_ax.YTickLabel{1}(1);
y_min = curr_ax.YTick(1);

curr_ax.YTick = 10.^(-4:4);
curr_ax.YTickLabel = string(10.^(-4:4));

if ~any(ismember(curr_ax.YTick,y_min))
    %y_min is not present
    ymin_idx = find(curr_ax.YTick>y_min,1,'first');
    curr_ax.YTick = [curr_ax.YTick(1:ymin_idx-1), y_min,...
        curr_ax.YTick(ymin_idx:end)];
    curr_ax.YTickLabel = [curr_ax.YTickLabel(1:ymin_idx-1); string(y_min);...
        curr_ax.YTickLabel(ymin_idx:end)];
end

if strcmp(add_symbol,'<')
    curr_ax.YTickLabel{curr_ax.YTick == y_min} = ...
        [add_symbol,curr_ax.YTickLabel{curr_ax.YTick == y_min}];
end

curr_ax.YRuler.MinorTickValues = 10.^(-4:4);

end