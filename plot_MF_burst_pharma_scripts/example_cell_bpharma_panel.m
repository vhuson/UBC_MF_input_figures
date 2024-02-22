%% Typical examples script

f_burst_pharma = figure('Position', [488 1.8000 680.3150 857.9636],...
    'Color','w');

curr_cells = [5, 9, 18];

num_rows = numel(curr_cells);
num_cols = 5; %Number of burst types

left_edge = 0.08;
top_edge = 0.96;
total_height = 0.3;
total_width = 0.4;
height_space = 0.015;
base_space = 0.015;


bottom_edge = top_edge - total_height;



graph_height = (total_height - height_space*(num_rows-1)) / num_rows;
base_width = (total_width - base_space*(num_cols-1)) / num_cols;



all_left_edge = (base_width + base_space) .* (0:(num_cols-1)) + left_edge;
all_bottom_edge = (graph_height + height_space) .* (0:(num_rows-1)) + bottom_edge;
all_bottom_edge = fliplr(all_bottom_edge);




select_cells = fltr_ONidx;



all_lim_x = {[-0.21 0.7], [-0.6 2], [-1.5 5]};
all_x_scales = [0.2 1 2];


seed_colors_pharma = [0 0 0;
                1 0.6 0;
                0.8 0 0;
                0   0   1];


all_colors_pharma = seed_map(seed_colors_pharma,4);

trace_labels = {'Baseline','−mGluR2','−AMPAR','−mGluR1'};
all_titles = {'1x' '2x' '5x' '10x' '20x'};

opts = struct();
opts.axis_off = true;

ax_pharm_typ = {};

for ii = 1:numel(curr_cells)
    curr_cell = curr_cells(ii);
    lim_x = all_lim_x{ii};

    for pharm_burst_idx = 1:5

        pos_ax = [all_left_edge(pharm_burst_idx) all_bottom_edge(ii)...
            base_width graph_height];


        trace_array = {all_mean_pharma_bursts1{pharm_burst_idx},...
            all_mean_pharma_bursts2{pharm_burst_idx},...
            all_mean_pharma_bursts3{pharm_burst_idx},...
            all_mean_pharma_bursts4{pharm_burst_idx}};




        [ax_pharm_typ{ii,pharm_burst_idx}] = plot_burst_traces_overlay(trace_array,Fs,...
            select_cells,curr_cell,all_colors_pharma,repmat(0.5,1,4),...
            [],lim_x,f_burst_pharma,pos_ax,opts);

        ylabel(['Cell #',num2str(curr_cell),'\newlineResponse (spk/s)'])

        if ii == 1
            title(all_titles{pharm_burst_idx})
        end


        opts.scale_xlabel = [];
        opts.scale_ylabel = [];
    end

    text(ax_pharm_typ{ii,1},0,0,['Cell\newline#',num2str(curr_cell)],'Units','normalized',...
                'Position',[-0.01 0.5],'VerticalAlignment','middle',...
                'HorizontalAlignment','right')

    same_ylim(ax_pharm_typ(ii,:))

    scale_opts = struct();
    scale_opts.xlabel = 's';
    % scale_opts.xscale_factor = 1e3;
    % scale_opts.ylabel = 'spk/s';
    add_scale_bar(ax_pharm_typ{ii,end},[all_x_scales(ii) 0],scale_opts);

end


%%
pos_ax(1) = sum(pos_ax([1,3]))+base_space;
pharm_burst_idx = 2;
trace_array = {all_mean_pharma_bursts1{pharm_burst_idx},...
                all_mean_pharma_bursts2{pharm_burst_idx},...
                all_mean_pharma_bursts3{pharm_burst_idx},...
                all_mean_pharma_bursts4{pharm_burst_idx}};

[ax_pharm_typ2] = plot_burst_traces_overlay(trace_array,Fs,...
    select_cells,curr_cell,all_colors_pharma,repmat(0.51,1,4),...
    [],lim_x,f_burst_pharma,pos_ax,opts);
title('2x')

pos_ax(1) = sum(pos_ax([1,3]))+base_space;
pharm_burst_idx = 3;
trace_array = {all_mean_pharma_bursts1{pharm_burst_idx},...
                all_mean_pharma_bursts2{pharm_burst_idx},...
                all_mean_pharma_bursts3{pharm_burst_idx},...
                all_mean_pharma_bursts4{pharm_burst_idx}};

[ax_pharm_typ3] = plot_burst_traces_overlay(trace_array,Fs,...
    select_cells,curr_cell,all_colors_pharma,repmat(0.54,1,4),...
    [],lim_x,f_burst_pharma,pos_ax,opts);
title('5x')

pos_ax(1) = sum(pos_ax([1,3]))+base_space;
pharm_burst_idx = 4;
trace_array = {all_mean_pharma_bursts1{pharm_burst_idx},...
                all_mean_pharma_bursts2{pharm_burst_idx},...
                all_mean_pharma_bursts3{pharm_burst_idx},...
                all_mean_pharma_bursts4{pharm_burst_idx}};

[ax_pharm_typ4] = plot_burst_traces_overlay(trace_array,Fs,...
    select_cells,curr_cell,all_colors_pharma,repmat(0.59,1,4),...
    [],lim_x,f_burst_pharma,pos_ax,opts);
title('10x')

pos_ax(1) = sum(pos_ax([1,3]))+base_space;
pharm_burst_idx = 5;
trace_array = {all_mean_pharma_bursts1{pharm_burst_idx},...
                all_mean_pharma_bursts2{pharm_burst_idx},...
                all_mean_pharma_bursts3{pharm_burst_idx},...
                all_mean_pharma_bursts4{pharm_burst_idx}};

[ax_pharm_typ5] = plot_burst_traces_overlay(trace_array,Fs,...
    select_cells,curr_cell,all_colors_pharma,repmat(0.69,1,4),...
    [],lim_x,f_burst_pharma,pos_ax,opts);
title('20x')
same_ylim({ax_pharm_typ, ax_pharm_typ2, ax_pharm_typ3, ax_pharm_typ4,...
    ax_pharm_typ5})
    
%Add a scale bar
cellfun(@(x) add_scale_bar(x,[0.1 50]),...
    {ax_pharm_typ, ax_pharm_typ2, ax_pharm_typ3, ax_pharm_typ4});


legend(ax_pharm_typ5,flipud(ax_pharm_typ5.Children(end-3:end)),...
    trace_labels,'Box','off');
standardAx(ax_pharm_typ5);
