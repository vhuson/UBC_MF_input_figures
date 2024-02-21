f_super_impose = figure('Position', [145 320 973 284.0545]);


x_margin = 0.15;
y_margin = 0.17;
x_gap = 0.05;
n_panels = 3;

total_width = 1-x_margin*2;
total_height = 1-y_margin*2;

base_width = (total_width-x_gap*(n_panels-1)) / n_panels;



%Get colormap
seed_colors = [1 0 0;
    1 0.5 0.2;
    0.4 1 0.4;
    0.2 0.5 1;
    0 0 1];

all_colors = seed_map(seed_colors,numel(ONidx));

%Normalize per cell
norm_on = max([all_full_traces{:}],[],2);
norm_on(norm_on < 1) = 1;

curr_cell_idx = ONidx;

plot_labels = {'1 Hz','2.5 Hz','5 Hz'};

super_ax = {};
for ax_idx = 1:3
    ax_pos = [x_margin + (base_width+x_gap)*(ax_idx-1),...
                y_margin, base_width, total_height];

    [norm_avg_traces] = norm_UBC(mean_segments{ax_idx},norm_on,norm_off,norm_OFFidx);
    norm_avg_traces = norm_avg_traces(curr_cell_idx,:);


    rng(2);
    cell_order = randperm(numel(curr_cell_idx));

    super_ax{ax_idx} = axes(f_super_impose,"Position",ax_pos);
    hold(super_ax{ax_idx},"on")

    x_data = (1:numel(norm_avg_traces(1,:)))/Fs;
    for cell_n = cell_order
        y_data = norm_avg_traces(cell_n,:);
        zero_idx = y_data == 0;
        if ~all(zero_idx)
            y_data(zero_idx) = NaN;
        end
        plot(x_data,y_data,'Color',all_colors(cell_n,:),...
            'LineWidth',1)
    end
    hold(super_ax{ax_idx},"off")
    
    super_ax{ax_idx}.XLim = [0.002 0.2];
    super_ax{ax_idx}.YLim = [0 1];

    % super_ax{ax_idx}.XScale = 'log';
    % super_ax{ax_idx}.XTick = [0.002 0.01 0.2];

    super_ax{ax_idx}.XRuler.Visible = 'off';
    super_ax{ax_idx}.YRuler.Visible = 'off';

    title(plot_labels{ax_idx});
    xlabel('Time (s)')
end
scale_opts = struct('xlabel','ms','xscale_factor',1000);
add_scale_bar(super_ax{end},[0.05 0],scale_opts);

super_ax{1}.YLabel.String = 'Spike trig. avg. (norm.)';


standardFig(f_super_impose);