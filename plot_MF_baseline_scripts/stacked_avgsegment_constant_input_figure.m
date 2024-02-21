f_super_stack = figure('Position', [145 1.8727 118.6909 857.8909]);


select_cells = ONidx;


%Normalize per cell
norm_on = max([all_full_traces{:}],[],2);
norm_on(norm_on < 1) = 1;




pos1 = [0.0500    0.0500    0.90    0.9300];

full_ax = axes(f_super_stack,"Position",pos1);

hold(full_ax,'on')
%Populate axes
for idx = 1:3
    [norm_avg_traces] = norm_UBC(mean_segments{idx},norm_on,norm_off,norm_OFFidx);
    norm_avg_traces = norm_avg_traces(select_cells,:);
    
    x_data = (1:numel(norm_avg_traces(1,:)))/Fs;
    for ii = 1:disp_num
        y_data = norm_avg_traces(ii,:);
        zero_idx = y_data == 0;
        if ~all(zero_idx)
            y_data(zero_idx) = NaN;
        end
        y_data(~isnan(y_data)) = y_data(~isnan(y_data)) + (ii-1);

        
        plot(full_ax,x_data,y_data,'k','LineWidth',1)

        
    end
end
xlim([0 0.2])
ylim([0 disp_num+1])
hold(full_ax,'off')


