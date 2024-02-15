function set_sensible_ylim(ax_stack_1)


for ii  = 1:numel(ax_stack_1)
    curr_trace =  ax_stack_1{ii}.Children.YData;
    %Check if YLim is sensible
    [counts,edges] = histcounts(curr_trace,1000);
    edges(counts == 0) = [];
    edges(edges > mean(curr_trace)+std(curr_trace)*4) = [];

    last_real_YLim = round(edges(end)*1.2,2,"significant");

    if last_real_YLim > 0
        ax_stack_1{ii}.YLim(2) = min([ax_stack_1{ii}.YLim(2),...
            last_real_YLim]);
    end
end

end