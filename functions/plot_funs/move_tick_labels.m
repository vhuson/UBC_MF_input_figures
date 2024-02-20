function [curr_ax] = move_tick_labels(curr_ax,move_amount)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

num_spaces_first = repmat(' ',1,...
    round(abs(move_amount)*numel(curr_ax.XTickLabel{1})));
num_spaces_last = repmat(' ',1,...
    round(abs(move_amount)*numel(curr_ax.XTickLabel{end})));

if move_amount > 0
    curr_ax.XTickLabel{1} = [num_spaces_first, curr_ax.XTickLabel{1}];
    curr_ax.XTickLabel{end} = [curr_ax.XTickLabel{end}, num_spaces_last];
else
    curr_ax.XTickLabel{1} = [curr_ax.XTickLabel{1}, num_spaces_first];
    curr_ax.XTickLabel{end} = [num_spaces_last, curr_ax.XTickLabel{end}];
end

end