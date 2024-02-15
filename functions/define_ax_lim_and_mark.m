function [curr_ax] = define_ax_lim_and_mark(assign_lim,upper_bol,curr_ax,curr_children)
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here
if nargin < 3
    curr_ax = gca;
end
if nargin < 4
    curr_children = 1:numel(curr_ax.Children);
end

for ii = curr_children
    %Change YData 
    if upper_bol
        cut_fltr = curr_ax.Children(ii).YData > assign_lim;
        mark_symbol = '>';
    else
        cut_fltr = curr_ax.Children(ii).YData < assign_lim;
        mark_symbol = '<';
    end
    curr_ax.Children(ii).YData(cut_fltr) = assign_lim;

end

%Some datapoints were moved adjust scale
if any(cut_fltr)
    curr_Ticks = curr_ax.YTick;
    curr_Labels = curr_ax.YTickLabel;
    %Change YLim
    if upper_bol
        curr_ax.YLim(2) = assign_lim;
    else
        curr_ax.YLim(1) = assign_lim;
    end

    %Adjust Tick appropriately
    replace_bol = ismember(assign_lim,curr_Ticks);
    if replace_bol
        new_pos = curr_Ticks == assign_lim;
        curr_Labels(new_pos) = ...
            {[mark_symbol,num2str(assign_lim)]};

    else

        curr_Ticks = sort([curr_Ticks, assign_lim]);
        new_pos = find(curr_Ticks == assign_lim);
        new_labels = curr_ax.YTickLabel;
        curr_Labels = [curr_Labels(1:new_pos-1);...
            {[mark_symbol,num2str(assign_lim)]};...
            curr_Labels(new_pos:end)];


    end
    curr_ax.YTick = curr_Ticks;
    curr_ax.YTickLabel = curr_Labels;
end
end