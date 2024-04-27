function [] = limit_plot_range(plot_obj,min_val,max_val)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
all_y_values = plot_obj.YData;

if any(all_y_values < min_val)
    %Cut off minimums
end

if any(all_y_values > max_val)
    max_idx = all_y_values > max_val;

    plot_obj.YData(max_idx) = max_val;

    plot_obj.Parent.YLim(2) = max_val;


    plot_obj.Parent.YTick = unique([plot_obj.Parent.YTick, max_val]);
    plot_obj.Parent.YTickLabel = string(plot_obj.Parent.YTick);
    plot_obj.Parent.YTickLabel{plot_obj.Parent.YTick == max_val} = ...
        ['>',plot_obj.Parent.YTickLabel{plot_obj.Parent.YTick == max_val}];
    

end
end