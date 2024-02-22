%% pharma plot typ cell1

f_burst_pharma = figure('Position', [488 1.8000 936.8000 857.8909],...
    'Color','w');




select_cells = fltr_ONidx;


seed_colors_pharma = [0 0 0;
                1 0.6 0;
                0.8 0 0;
                0   0   1];


all_colors_pharma = seed_map(seed_colors_pharma,4);
trace_labels = {'Baseline','−mGluR2','−AMPAR','−mGluR1'};
curr_cell = 5;
lim_x = [-0.21 0.7];

base_width = 0.14;
graph_height = 0.10;
height_space = 0.0417;
base_space = 0.03;

pos_ax = [0.1 0.8 base_width graph_height];

pharm_burst_idx = 1;
trace_array = {all_mean_pharma_bursts1{pharm_burst_idx},...
                all_mean_pharma_bursts2{pharm_burst_idx},...
                all_mean_pharma_bursts3{pharm_burst_idx},...
                all_mean_pharma_bursts4{pharm_burst_idx}};

opts = struct();
opts.axis_off = true;


[ax_pharm_typ1] = plot_burst_traces_overlay(trace_array,Fs,...
    select_cells,curr_cell,all_colors_pharma,repmat(0.5,1,4),...
    [],lim_x,f_burst_pharma,pos_ax,opts);
ylabel(['Cell #',num2str(curr_cell),'\newlineResponse (spk/s)'])
title('1x')
opts.scale_xlabel = [];
opts.scale_ylabel = [];


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
same_ylim({ax_pharm_typ1, ax_pharm_typ2, ax_pharm_typ3, ax_pharm_typ4,...
    ax_pharm_typ5})

%Add a scale bar
cellfun(@(x) add_scale_bar(x,[0.1 50]),...
    {ax_pharm_typ1, ax_pharm_typ2, ax_pharm_typ3, ax_pharm_typ4});
scale_opts = struct();
scale_opts.xlabel = 'ms';
scale_opts.xscale_factor = 1e3;
scale_opts.ylabel = 'spk/s';
add_scale_bar(ax_pharm_typ5,[0.1 50],scale_opts);

legend(ax_pharm_typ5,flipud(ax_pharm_typ5.Children(end-3:end)),...
    trace_labels,'Box','off');
standardAx(ax_pharm_typ5);

%% Line plot of just cell1
pos_ax(1) = 0.1;
pos_ax(2) = pos_ax(2)-graph_height-height_space;

plot_log = 0;
norm_idx = 0;

% base_width = 0.11;
% bar_width = 0.06;
% base_space = 0.06;
% height_space = 0.0417;
% graph_height = 0.14;

n_spikes_min = -Inf;

% pos_ax = [0.1 0.2549 base_width graph_height];

input_idx = 1;
all_1x_n_spikes = {all_pharma_n_spikes1{input_idx}(select_cells(curr_cell)),...
                    all_pharma_n_spikes2{input_idx}(select_cells(curr_cell)),...
                    all_pharma_n_spikes3{input_idx}(select_cells(curr_cell)),...
                    all_pharma_n_spikes4{input_idx}(select_cells(curr_cell))};
ax_single1 = {};
[ax_single1{input_idx}] = UBC_par_line_plot(...
    1,[],all_1x_n_spikes,[norm_idx plot_log 0],n_spikes_min,f_burst_pharma,pos_ax,...
    [1 2 3 4]);
ax_single1{input_idx}.Children.Color = 'k';
ylabel("#Spikes (n)")
xlabel('')
xticklabels([])


pos_ax(1) = sum(pos_ax([1,3]))+base_space;

input_idx = 2;
all_2x_n_spikes = {all_pharma_n_spikes1{input_idx}(select_cells(curr_cell)),...
                    all_pharma_n_spikes2{input_idx}(select_cells(curr_cell)),...
                    all_pharma_n_spikes3{input_idx}(select_cells(curr_cell)),...
                    all_pharma_n_spikes4{input_idx}(select_cells(curr_cell))};
[ax_single1{input_idx}] = UBC_par_line_plot(...
    1,[],all_2x_n_spikes,[norm_idx plot_log 0],n_spikes_min,f_burst_pharma,pos_ax,...
    [1 2 3 4]);
ax_single1{input_idx}.Children.Color = 'k';
% ylabel("Response spikes (n)")
xlabel('')
xticklabels([])


pos_ax(1) = sum(pos_ax([1,3]))+base_space;

input_idx = 3;
all_5x_n_spikes = {all_pharma_n_spikes1{input_idx}(select_cells(curr_cell)),...
                    all_pharma_n_spikes2{input_idx}(select_cells(curr_cell)),...
                    all_pharma_n_spikes3{input_idx}(select_cells(curr_cell)),...
                    all_pharma_n_spikes4{input_idx}(select_cells(curr_cell))};
[ax_single1{input_idx}] = UBC_par_line_plot(...
    1,[],all_5x_n_spikes,[norm_idx plot_log 0],n_spikes_min,f_burst_pharma,pos_ax,...
    [1 2 3 4]);
ax_single1{input_idx}.Children.Color = 'k';
% ylabel("Response spikes (n)")
xlabel('')
xticklabels([])


pos_ax(1) = sum(pos_ax([1,3]))+base_space;

input_idx = 4;
all_10x_n_spikes = {all_pharma_n_spikes1{input_idx}(select_cells(curr_cell)),...
                    all_pharma_n_spikes2{input_idx}(select_cells(curr_cell)),...
                    all_pharma_n_spikes3{input_idx}(select_cells(curr_cell)),...
                    all_pharma_n_spikes4{input_idx}(select_cells(curr_cell))};
[ax_single1{input_idx}] = UBC_par_line_plot(...
    1,[],all_10x_n_spikes,[norm_idx plot_log 0],n_spikes_min,f_burst_pharma,pos_ax,...
    [1 2 3 4]);
ax_single1{input_idx}.Children.Color = 'k';
% ylabel("Response spikes (n)")
xlabel('')
xticklabels([])


pos_ax(1) = sum(pos_ax([1,3]))+base_space;

input_idx = 4;
all_20x_n_spikes = {all_pharma_n_spikes1{input_idx}(select_cells(curr_cell)),...
                    all_pharma_n_spikes2{input_idx}(select_cells(curr_cell)),...
                    all_pharma_n_spikes3{input_idx}(select_cells(curr_cell)),...
                    all_pharma_n_spikes4{input_idx}(select_cells(curr_cell))};
[ax_single1{input_idx}] = UBC_par_line_plot(...
    1,[],all_20x_n_spikes,[norm_idx plot_log 0],n_spikes_min,f_burst_pharma,pos_ax,...
    [1 2 3 4]);
ax_single1{input_idx}.Children.Color = 'k';
% ylabel("Response spikes (n)")
xlabel('')
xticklabels([])

% same_ylim(ax_single1);

% xticklabels({'Baseline','-mGluR2','-AMPAR','-mGluR1'})

%%  pharma plot typ cell2
pos_ax(1) = 0.1;
pos_ax(2) = pos_ax(2)-graph_height-height_space;


curr_cell = 9;
lim_x = [-0.6 2];

pharm_burst_idx = 1;
trace_array = {all_mean_pharma_bursts1{pharm_burst_idx},...
                all_mean_pharma_bursts2{pharm_burst_idx},...
                all_mean_pharma_bursts3{pharm_burst_idx},...
                all_mean_pharma_bursts4{pharm_burst_idx}};

opts = struct();
opts.axis_off = true;
[ax_pharm_typ1] = plot_burst_traces_overlay(trace_array,Fs,...
    select_cells,curr_cell,all_colors_pharma,repmat(0.5,1,4),...
    [],lim_x,f_burst_pharma,pos_ax,opts);
ylabel(['Cell #',num2str(curr_cell),'\newlineResponse (spk/s)'])

pos_ax(1) = sum(pos_ax([1,3]))+base_space;
pharm_burst_idx = 2;
trace_array = {all_mean_pharma_bursts1{pharm_burst_idx},...
                all_mean_pharma_bursts2{pharm_burst_idx},...
                all_mean_pharma_bursts3{pharm_burst_idx},...
                all_mean_pharma_bursts4{pharm_burst_idx}};

[ax_pharm_typ2] = plot_burst_traces_overlay(trace_array,Fs,...
    select_cells,curr_cell,all_colors_pharma,repmat(0.51,1,4),...
    [],lim_x,f_burst_pharma,pos_ax,opts);

pos_ax(1) = sum(pos_ax([1,3]))+base_space;
pharm_burst_idx = 3;
trace_array = {all_mean_pharma_bursts1{pharm_burst_idx},...
                all_mean_pharma_bursts2{pharm_burst_idx},...
                all_mean_pharma_bursts3{pharm_burst_idx},...
                all_mean_pharma_bursts4{pharm_burst_idx}};

[ax_pharm_typ3] = plot_burst_traces_overlay(trace_array,Fs,...
    select_cells,curr_cell,all_colors_pharma,repmat(0.54,1,4),...
    [],lim_x,f_burst_pharma,pos_ax,opts);

pos_ax(1) = sum(pos_ax([1,3]))+base_space;
pharm_burst_idx = 4;
trace_array = {all_mean_pharma_bursts1{pharm_burst_idx},...
                all_mean_pharma_bursts2{pharm_burst_idx},...
                all_mean_pharma_bursts3{pharm_burst_idx},...
                all_mean_pharma_bursts4{pharm_burst_idx}};

[ax_pharm_typ4] = plot_burst_traces_overlay(trace_array,Fs,...
    select_cells,curr_cell,all_colors_pharma,repmat(0.59,1,4),...
    [],lim_x,f_burst_pharma,pos_ax,opts);

pos_ax(1) = sum(pos_ax([1,3]))+base_space;
pharm_burst_idx = 5;
trace_array = {all_mean_pharma_bursts1{pharm_burst_idx},...
                all_mean_pharma_bursts2{pharm_burst_idx},...
                all_mean_pharma_bursts3{pharm_burst_idx},...
                all_mean_pharma_bursts4{pharm_burst_idx}};

[ax_pharm_typ5] = plot_burst_traces_overlay(trace_array,Fs,...
    select_cells,curr_cell,all_colors_pharma,repmat(0.69,1,4),...
    [],lim_x,f_burst_pharma,pos_ax,opts);

same_ylim({ax_pharm_typ1, ax_pharm_typ2})

%Add a scale bar
scalexy = [0.5 20];
cellfun(@(x) add_scale_bar(x,scalexy),...
    {ax_pharm_typ1, ax_pharm_typ2, ax_pharm_typ3, ax_pharm_typ4});
scale_opts = struct();
scale_opts.xlabel = 's';
scale_opts.xscale_factor = 1;
scale_opts.ylabel = 'spk/s';
add_scale_bar(ax_pharm_typ5,scalexy,scale_opts);

%% Line plot of just cell2
pos_ax(1) = 0.1;
pos_ax(2) = pos_ax(2)-graph_height-height_space;

plot_log = 0;
norm_idx = 0;

% base_width = 0.11;
% bar_width = 0.06;
% base_space = 0.06;
% height_space = 0.0417;
% graph_height = 0.14;

n_spikes_min = -Inf;

% pos_ax = [0.1 0.2549 base_width graph_height];

input_idx = 1;
all_1x_n_spikes = {all_pharma_n_spikes1{input_idx}(select_cells(curr_cell)),...
                    all_pharma_n_spikes2{input_idx}(select_cells(curr_cell)),...
                    all_pharma_n_spikes3{input_idx}(select_cells(curr_cell)),...
                    all_pharma_n_spikes4{input_idx}(select_cells(curr_cell))};
ax_single2 = {};
[ax_single2{input_idx}] = UBC_par_line_plot(...
    1,[],all_1x_n_spikes,[norm_idx plot_log 0],n_spikes_min,f_burst_pharma,pos_ax,...
    [1 2 3 4]);
ax_single2{input_idx}.Children.Color = 'k';
ylabel("#Spikes (n)")
xlabel('')
xticklabels([])


pos_ax(1) = sum(pos_ax([1,3]))+base_space;

input_idx = 2;
all_2x_n_spikes = {all_pharma_n_spikes1{input_idx}(select_cells(curr_cell)),...
                    all_pharma_n_spikes2{input_idx}(select_cells(curr_cell)),...
                    all_pharma_n_spikes3{input_idx}(select_cells(curr_cell)),...
                    all_pharma_n_spikes4{input_idx}(select_cells(curr_cell))};
[ax_single2{input_idx}] = UBC_par_line_plot(...
    1,[],all_2x_n_spikes,[norm_idx plot_log 0],n_spikes_min,f_burst_pharma,pos_ax,...
    [1 2 3 4]);
ax_single2{input_idx}.Children.Color = 'k';
% ylabel("Response spikes (n)")
xlabel('')
xticklabels([])


pos_ax(1) = sum(pos_ax([1,3]))+base_space;

input_idx = 3;
all_5x_n_spikes = {all_pharma_n_spikes1{input_idx}(select_cells(curr_cell)),...
                    all_pharma_n_spikes2{input_idx}(select_cells(curr_cell)),...
                    all_pharma_n_spikes3{input_idx}(select_cells(curr_cell)),...
                    all_pharma_n_spikes4{input_idx}(select_cells(curr_cell))};
[ax_single2{input_idx}] = UBC_par_line_plot(...
    1,[],all_5x_n_spikes,[norm_idx plot_log 0],n_spikes_min,f_burst_pharma,pos_ax,...
    [1 2 3 4]);
ax_single2{input_idx}.Children.Color = 'k';
% ylabel("Response spikes (n)")
xlabel('')
xticklabels([])


pos_ax(1) = sum(pos_ax([1,3]))+base_space;

input_idx = 4;
all_10x_n_spikes = {all_pharma_n_spikes1{input_idx}(select_cells(curr_cell)),...
                    all_pharma_n_spikes2{input_idx}(select_cells(curr_cell)),...
                    all_pharma_n_spikes3{input_idx}(select_cells(curr_cell)),...
                    all_pharma_n_spikes4{input_idx}(select_cells(curr_cell))};
[ax_single2{input_idx}] = UBC_par_line_plot(...
    1,[],all_10x_n_spikes,[norm_idx plot_log 0],n_spikes_min,f_burst_pharma,pos_ax,...
    [1 2 3 4]);
ax_single2{input_idx}.Children.Color = 'k';
% ylabel("Response spikes (n)")
xlabel('')
xticklabels([])


pos_ax(1) = sum(pos_ax([1,3]))+base_space;

input_idx = 4;
all_20x_n_spikes = {all_pharma_n_spikes1{input_idx}(select_cells(curr_cell)),...
                    all_pharma_n_spikes2{input_idx}(select_cells(curr_cell)),...
                    all_pharma_n_spikes3{input_idx}(select_cells(curr_cell)),...
                    all_pharma_n_spikes4{input_idx}(select_cells(curr_cell))};
[ax_single2{input_idx}] = UBC_par_line_plot(...
    1,[],all_20x_n_spikes,[norm_idx plot_log 0],n_spikes_min,f_burst_pharma,pos_ax,...
    [1 2 3 4]);
ax_single2{input_idx}.Children.Color = 'k';
% ylabel("Response spikes (n)")
xlabel('')
xticklabels([])

% same_ylim(ax_single2);

% xticklabels({'Baseline','-mGluR2','-AMPAR','-mGluR1'})

%%  pharma plot typ cell3
pos_ax(1) = 0.1;
pos_ax(2) = pos_ax(2)-graph_height-height_space;


curr_cell =18;
lim_x = [-1.5 5];

%Fix this one
all_mean_pharma_bursts1{1}(select_cells(18),:) = mean(...
    all_full_pharma_bursts1{1}{select_cells(18)}(2:end,:),1);


pharm_burst_idx = 1;
trace_array = {all_mean_pharma_bursts1{pharm_burst_idx},...
                all_mean_pharma_bursts2{pharm_burst_idx},...
                all_mean_pharma_bursts3{pharm_burst_idx},...
                all_mean_pharma_bursts4{pharm_burst_idx}};

[ax_pharm_typ1] = plot_burst_traces_overlay(trace_array,Fs,...
    select_cells,curr_cell,all_colors_pharma,repmat(0.5,1,4),...
    [],lim_x,f_burst_pharma,pos_ax);
ylabel(['Cell #',num2str(curr_cell),'\newlineResponse (spk/s)'])

pos_ax(1) = sum(pos_ax([1,3]))+base_space;
pharm_burst_idx = 2;
trace_array = {all_mean_pharma_bursts1{pharm_burst_idx},...
                all_mean_pharma_bursts2{pharm_burst_idx},...
                all_mean_pharma_bursts3{pharm_burst_idx},...
                all_mean_pharma_bursts4{pharm_burst_idx}};

[ax_pharm_typ2] = plot_burst_traces_overlay(trace_array,Fs,...
    select_cells,curr_cell,all_colors_pharma,repmat(0.51,1,4),...
    [],lim_x,f_burst_pharma,pos_ax);

pos_ax(1) = sum(pos_ax([1,3]))+base_space;
pharm_burst_idx = 3;
trace_array = {all_mean_pharma_bursts1{pharm_burst_idx},...
                all_mean_pharma_bursts2{pharm_burst_idx},...
                all_mean_pharma_bursts3{pharm_burst_idx},...
                all_mean_pharma_bursts4{pharm_burst_idx}};

[ax_pharm_typ3] = plot_burst_traces_overlay(trace_array,Fs,...
    select_cells,curr_cell,all_colors_pharma,repmat(0.54,1,4),...
    [],lim_x,f_burst_pharma,pos_ax);

pos_ax(1) = sum(pos_ax([1,3]))+base_space;
pharm_burst_idx = 4;
trace_array = {all_mean_pharma_bursts1{pharm_burst_idx},...
                all_mean_pharma_bursts2{pharm_burst_idx},...
                all_mean_pharma_bursts3{pharm_burst_idx},...
                all_mean_pharma_bursts4{pharm_burst_idx}};

[ax_pharm_typ4] = plot_burst_traces_overlay(trace_array,Fs,...
    select_cells,curr_cell,all_colors_pharma,repmat(0.59,1,4),...
    [],lim_x,f_burst_pharma,pos_ax);

pos_ax(1) = sum(pos_ax([1,3]))+base_space;
pharm_burst_idx = 5;
trace_array = {all_mean_pharma_bursts1{pharm_burst_idx},...
                all_mean_pharma_bursts2{pharm_burst_idx},...
                all_mean_pharma_bursts3{pharm_burst_idx},...
                all_mean_pharma_bursts4{pharm_burst_idx}};

[ax_pharm_typ5] = plot_burst_traces_overlay(trace_array,Fs,...
    select_cells,curr_cell,all_colors_pharma,repmat(0.69,1,4),...
    [],lim_x,f_burst_pharma,pos_ax);

same_ylim({ax_pharm_typ1, ax_pharm_typ2})
%% Line plot of just cell3
pos_ax(1) = 0.1;
pos_ax(2) = pos_ax(2)-graph_height-height_space;

plot_log = 0;
norm_idx = 0;

% base_width = 0.11;
% bar_width = 0.06;
% base_space = 0.06;
% height_space = 0.0417;
% graph_height = 0.14;

n_spikes_min = -Inf;

% pos_ax = [0.1 0.2549 base_width graph_height];

input_idx = 1;
all_1x_n_spikes = {all_pharma_n_spikes1{input_idx}(select_cells(curr_cell)),...
                    all_pharma_n_spikes2{input_idx}(select_cells(curr_cell)),...
                    all_pharma_n_spikes3{input_idx}(select_cells(curr_cell)),...
                    all_pharma_n_spikes4{input_idx}(select_cells(curr_cell))};
ax_single3 = {};
[ax_single3{input_idx}] = UBC_par_line_plot(...
    1,[],all_1x_n_spikes,[norm_idx plot_log 0],n_spikes_min,f_burst_pharma,pos_ax,...
    [1 2 3 4]);
ax_single3{input_idx}.Children.Color = 'k';
ylabel("#Spikes (n)")
xlabel('')
xticklabels({'Baseline','-mGluR2','-AMPAR','-mGluR1'})


pos_ax(1) = sum(pos_ax([1,3]))+base_space;

input_idx = 2;
all_2x_n_spikes = {all_pharma_n_spikes1{input_idx}(select_cells(curr_cell)),...
                    all_pharma_n_spikes2{input_idx}(select_cells(curr_cell)),...
                    all_pharma_n_spikes3{input_idx}(select_cells(curr_cell)),...
                    all_pharma_n_spikes4{input_idx}(select_cells(curr_cell))};
[ax_single3{input_idx}] = UBC_par_line_plot(...
    1,[],all_2x_n_spikes,[norm_idx plot_log 0],n_spikes_min,f_burst_pharma,pos_ax,...
    [1 2 3 4]);
ax_single3{input_idx}.Children.Color = 'k';
% ylabel("Response spikes (n)")
xlabel('')
xticklabels({'Baseline','-mGluR2','-AMPAR','-mGluR1'})


pos_ax(1) = sum(pos_ax([1,3]))+base_space;

input_idx = 3;
all_5x_n_spikes = {all_pharma_n_spikes1{input_idx}(select_cells(curr_cell)),...
                    all_pharma_n_spikes2{input_idx}(select_cells(curr_cell)),...
                    all_pharma_n_spikes3{input_idx}(select_cells(curr_cell)),...
                    all_pharma_n_spikes4{input_idx}(select_cells(curr_cell))};
[ax_single3{input_idx}] = UBC_par_line_plot(...
    1,[],all_5x_n_spikes,[norm_idx plot_log 0],n_spikes_min,f_burst_pharma,pos_ax,...
    [1 2 3 4]);
ax_single3{input_idx}.Children.Color = 'k';
% ylabel("Response spikes (n)")
xlabel('')
xticklabels({'Baseline','-mGluR2','-AMPAR','-mGluR1'})


pos_ax(1) = sum(pos_ax([1,3]))+base_space;

input_idx = 4;
all_10x_n_spikes = {all_pharma_n_spikes1{input_idx}(select_cells(curr_cell)),...
                    all_pharma_n_spikes2{input_idx}(select_cells(curr_cell)),...
                    all_pharma_n_spikes3{input_idx}(select_cells(curr_cell)),...
                    all_pharma_n_spikes4{input_idx}(select_cells(curr_cell))};
[ax_single3{input_idx}] = UBC_par_line_plot(...
    1,[],all_10x_n_spikes,[norm_idx plot_log 0],n_spikes_min,f_burst_pharma,pos_ax,...
    [1 2 3 4]);
ax_single3{input_idx}.Children.Color = 'k';
% ylabel("Response spikes (n)")
xlabel('')
xticklabels({'Baseline','-mGluR2','-AMPAR','-mGluR1'})


pos_ax(1) = sum(pos_ax([1,3]))+base_space;

input_idx = 4;
all_20x_n_spikes = {all_pharma_n_spikes1{input_idx}(select_cells(curr_cell)),...
                    all_pharma_n_spikes2{input_idx}(select_cells(curr_cell)),...
                    all_pharma_n_spikes3{input_idx}(select_cells(curr_cell)),...
                    all_pharma_n_spikes4{input_idx}(select_cells(curr_cell))};
[ax_single3{input_idx}] = UBC_par_line_plot(...
    1,[],all_20x_n_spikes,[norm_idx plot_log 0],n_spikes_min,f_burst_pharma,pos_ax,...
    [1 2 3 4]);
ax_single3{input_idx}.Children.Color = 'k';
% ylabel("Response spikes (n)")
xlabel('')
xticklabels([])

% same_ylim(ax_single3);

xticklabels({'Baseline','-mGluR2','-AMPAR','-mGluR1'})