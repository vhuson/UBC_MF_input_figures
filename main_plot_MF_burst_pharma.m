%% Make burst pharma figure

all_burst_durs      = [0.01 0.02 0.05 0.10 0.2];
all_burst_tails     = [2.9    3    10   10   10];
washin_state = [0 1 1 0 0];

%Get traces
[all_mean_pharma_bursts3,~] = ...
    get_burst_data(allData,Fs,all_burst_durs, all_burst_tails,...
    washin_state);

washin_fltr = ~isnan(all_mean_pharma_bursts3{end}(:,1));

washin_state = [1 0 0 0 0];

%Get traces 1
[all_mean_pharma_bursts1,all_full_pharma_bursts1] = ...
    get_burst_data(allData(washin_fltr),Fs,all_burst_durs, all_burst_tails,...
    washin_state);

%Get UBC parameters 1
[all_pharma_slow_amp1,all_pharma_slow_HD1,all_pharma_pause1,...
    all_pharma_n_spikes1] = get_allburst_parameters(...
    all_mean_pharma_bursts1,all_baseline(washin_fltr),Fs);

%Get UBC parameters


washin_state = [0 1 0 0 0];

%Get traces 2
[all_mean_pharma_bursts2,all_full_pharma_bursts2] = ...
    get_burst_data(allData(washin_fltr),Fs,all_burst_durs, all_burst_tails,...
    washin_state);

%Get UBC parameters 2
[all_pharma_slow_amp2,all_pharma_slow_HD2,all_pharma_pause2,...
    all_pharma_n_spikes2] = get_allburst_parameters(...
    all_mean_pharma_bursts2,all_baseline(washin_fltr),Fs);



washin_state = [0 1 1 0 0];

%Get traces 3
[all_mean_pharma_bursts3,all_full_pharma_bursts3] = ...
    get_burst_data(allData(washin_fltr),Fs,all_burst_durs, all_burst_tails,...
    washin_state);

%Get UBC parameters 3
[all_pharma_slow_amp3,all_pharma_slow_HD3,all_pharma_pause3,...
    all_pharma_n_spikes3] = get_allburst_parameters(...
    all_mean_pharma_bursts3,all_baseline(washin_fltr),Fs);


washin_state = [0 1 1 1 0];

%Get traces 4
[all_mean_pharma_bursts4,all_full_pharma_bursts4] = ...
    get_burst_data(allData(washin_fltr),Fs,all_burst_durs, all_burst_tails,...
    washin_state);

%Get UBC parameters 4
[all_pharma_slow_amp4,all_pharma_slow_HD4,all_pharma_pause4,...
    all_pharma_n_spikes4] = get_allburst_parameters(...
    all_mean_pharma_bursts4,all_baseline(washin_fltr),Fs);
%% pharma plot typ cell1

f_burst_pharma = figure('Position', [488 1.8000 936.8000 857.8909],...
    'Color','w');


[fltr_ONidx] = get_fltr_ONidx(ONidx,find(washin_fltr));

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

%%

plot_log = 1;
norm_idx = 0;

base_width = 0.11;
bar_width = 0.06;
base_space = 0.06;
height_space = 0.0417;
graph_height = 0.14;

n_spikes_min = 1;

pos_ax = [0.1 0.2549 base_width graph_height];

input_idx = 1;
all_1x_n_spikes = {all_pharma_n_spikes1{input_idx},...
                    all_pharma_n_spikes2{input_idx},...
                    all_pharma_n_spikes3{input_idx},...
                    all_pharma_n_spikes4{input_idx}};
[ax_pharm_n1] = UBC_par_line_plot(...
    select_cells,[],all_1x_n_spikes,[norm_idx plot_log 0],n_spikes_min,f_burst_pharma,pos_ax,...
    [1 2 3 4]);
ylabel("Response spikes (n)")
% title('1x')


pos_ax(1) = sum(pos_ax([1,3]))+base_space;
input_idx = 2;
all_2x_n_spikes = {all_pharma_n_spikes1{input_idx},...
                    all_pharma_n_spikes2{input_idx},...
                    all_pharma_n_spikes3{input_idx},...
                    all_pharma_n_spikes4{input_idx}};
[ax_pharm_n2] = UBC_par_line_plot(...
    select_cells,[],all_2x_n_spikes,[norm_idx plot_log 0],n_spikes_min,f_burst_pharma,pos_ax,...
    [1 2 3 4]);
% title('2x')

pos_ax(1) = sum(pos_ax([1,3]))+base_space;
input_idx = 3;
all_5x_n_spikes = {all_pharma_n_spikes1{input_idx},...
                    all_pharma_n_spikes2{input_idx},...
                    all_pharma_n_spikes3{input_idx},...
                    all_pharma_n_spikes4{input_idx}};
[ax_pharm_n3] = UBC_par_line_plot(...
    select_cells,[],all_5x_n_spikes,[norm_idx plot_log 0],n_spikes_min,f_burst_pharma,pos_ax,...
    [1 2 3 4]);
% ylabel("Response spikes (n)")
% title('5x')


pos_ax(1) = sum(pos_ax([1,3]))+base_space;
input_idx = 4;
all_10x_n_spikes = {all_pharma_n_spikes1{input_idx},...
                    all_pharma_n_spikes2{input_idx},...
                    all_pharma_n_spikes3{input_idx},...
                    all_pharma_n_spikes4{input_idx}};
[ax_pharm_n4] = UBC_par_line_plot(...
    select_cells,[],all_10x_n_spikes,[norm_idx plot_log 0],n_spikes_min,f_burst_pharma,pos_ax,...
    [1 2 3 4]);
% title('10x')

pos_ax(1) = sum(pos_ax([1,3]))+base_space;
pos_ax(3) = base_width + bar_width;
input_idx = 5;
all_20x_n_spikes = {all_pharma_n_spikes1{input_idx},...
                    all_pharma_n_spikes2{input_idx},...
                    all_pharma_n_spikes3{input_idx},...
                    all_pharma_n_spikes4{input_idx}};
[ax_pharm_n5] = UBC_par_line_plot(...
    select_cells,[],all_20x_n_spikes,[norm_idx plot_log 1],n_spikes_min,f_burst_pharma,pos_ax,...
    [1 2 3 4]);
% title('20x')


all_axes = {ax_pharm_n1, ax_pharm_n2, ax_pharm_n3, ax_pharm_n4, ax_pharm_n5};
arg_names = {'XScale', 'XTickLabel'};
% val_pairs = {'linear',    {'Baseline','−mGluR2','−AMPAR','−mGluR1'}};
val_pairs = {'linear',    {''}};
arg_names{end+1} = 'XLabel';
val_pairs{end+1} = xlabel('');


set_to_axes(all_axes,arg_names,val_pairs)
% for ii = 1:numel(all_axes); all_axes{ii}.YLim(1) = 0; end


amp_min = 1;

pos_ax(1) = 0.1;
pos_ax(2) = pos_ax(2)-graph_height-height_space;
pos_ax(3) = base_width;


input_idx = 1;
all_1x_amp = {all_pharma_slow_amp1{input_idx},...
                    all_pharma_slow_amp2{input_idx},...
                    all_pharma_slow_amp3{input_idx},...
                    all_pharma_slow_amp4{input_idx}};
[ax_pharm_amp1] = UBC_par_line_plot(...
    select_cells,[],all_1x_amp,[norm_idx plot_log 0],amp_min,f_burst_pharma,pos_ax,...
    [1 2 3 4]);
ylabel('Peak (\Deltaspk/s)')


pos_ax(1) = sum(pos_ax([1,3]))+base_space;

input_idx = 2;
all_2x_amp = {all_pharma_slow_amp1{input_idx},...
                    all_pharma_slow_amp2{input_idx},...
                    all_pharma_slow_amp3{input_idx},...
                    all_pharma_slow_amp4{input_idx}};
[ax_pharm_amp2] = UBC_par_line_plot(...
    select_cells,[],all_2x_amp,[norm_idx plot_log 0],amp_min,f_burst_pharma,pos_ax,...
    [1 2 3 4]);

pos_ax(1) = sum(pos_ax([1,3]))+base_space;

input_idx = 3;
all_5x_amp = {all_pharma_slow_amp1{input_idx},...
                    all_pharma_slow_amp2{input_idx},...
                    all_pharma_slow_amp3{input_idx},...
                    all_pharma_slow_amp4{input_idx}};
[ax_pharm_amp3] = UBC_par_line_plot(...
    select_cells,[],all_5x_amp,[norm_idx plot_log 0],amp_min,f_burst_pharma,pos_ax,...
    [1 2 3 4]);


pos_ax(1) = sum(pos_ax([1,3]))+base_space;

input_idx = 4;
all_10x_amp = {all_pharma_slow_amp1{input_idx},...
                    all_pharma_slow_amp2{input_idx},...
                    all_pharma_slow_amp3{input_idx},...
                    all_pharma_slow_amp4{input_idx}};
[ax_pharm_amp4] = UBC_par_line_plot(...
    select_cells,[],all_10x_amp,[norm_idx plot_log 0],amp_min,f_burst_pharma,pos_ax,...
    [1 2 3 4]);

pos_ax(1) = sum(pos_ax([1,3]))+base_space;
pos_ax(3) = base_width + bar_width;
input_idx = 5;
all_20x_amp = {all_pharma_slow_amp1{input_idx},...
                    all_pharma_slow_amp2{input_idx},...
                    all_pharma_slow_amp3{input_idx},...
                    all_pharma_slow_amp4{input_idx}};
[ax_pharm_amp5] = UBC_par_line_plot(...
    select_cells,[],all_20x_amp,[norm_idx plot_log 1],amp_min,f_burst_pharma,pos_ax,...
    [1 2 3 4]);



all_axes = {ax_pharm_amp1, ax_pharm_amp2, ax_pharm_amp3, ax_pharm_amp4,...
    ax_pharm_amp5};
arg_names = {'XScale', 'XTickLabel'};
val_pairs = {'linear',    {'Baseline','−mGluR2','−AMPAR','−mGluR1'}};
% val_pairs = {'linear',    {''}};
arg_names{end+1} = 'XLabel';
val_pairs{end+1} = xlabel('');

set_to_axes(all_axes,arg_names,val_pairs)
same_ylim(all_axes)
%%


YTick = [1    10 100];
YTickLabel = {'<1', '10', '100'};
YMinorTicks = [0.01 0.1 1 10 100 1000];
same_ylim({ax_pharm_n1, ax_pharm_n2, ax_pharm_n3,ax_pharm_n4},...
    'YTick',YTick,'YTickLabel',YTickLabel,'YMinorTicks',YMinorTicks)


pos_ax(1) = 0.1;
pos_ax(2) = pos_ax(2)-graph_height-height_space;
pos_ax(3) = base_width;

[ax_pharm_n1] = UBC_par_line_plot(...
    select_cells,[1],all_pharma_slow_HD1,[0 1 0],0.01,f_burst_pharma,pos_ax);
ylabel('Half-width (s)')

pos_ax(1) = sum(pos_ax([1,3]))+base_space;

[ax_pharm_n2] = UBC_par_line_plot(...
    select_cells,[1],all_pharma_slow_HD2,[0 1 0],0.01,f_burst_pharma,pos_ax);

pos_ax(1) = sum(pos_ax([1,3]))+base_space;

[ax_pharm_n3] = UBC_par_line_plot(...
    select_cells,[1],all_pharma_slow_HD3,[0 1 0],0.01,f_burst_pharma,pos_ax);


pos_ax(1) = sum(pos_ax([1,3]))+base_space;
pos_ax(3) = base_width + bar_width;
[ax_pharm_n4] = UBC_par_line_plot(...
    select_cells,[1],all_pharma_slow_HD4,[0 1 1],0.01,f_burst_pharma,pos_ax);

ax_pharm_n1.YLim(2) = 10;
YTick = [0.01 0.1    1 10];
YTickLabel = {'<0.01', '0.1', '1', '10'};
YMinorTicks = [0.01 0.1 1 10 100 1000];
same_ylim({ax_pharm_n1, ax_pharm_n2, ax_pharm_n3,ax_pharm_n4},...
    'YTick',YTick,'YTickLabel',YTickLabel,'YMinorTicks',YMinorTicks)



pos_ax(1) = 0.1;
pos_ax(2) = pos_ax(2)-graph_height-height_space;
pos_ax(3) = base_width;

[ax_pharm_n1] = UBC_par_line_plot(...
    select_cells,[1],all_pharma_pause1,[0 1 0],0.001,f_burst_pharma,pos_ax);
ylabel('Pause (s)')

pos_ax(1) = sum(pos_ax([1,3]))+base_space;

[ax_pharm_n2] = UBC_par_line_plot(...
    select_cells,[1],all_pharma_pause2,[0 1 0],0.001,f_burst_pharma,pos_ax);

pos_ax(1) = sum(pos_ax([1,3]))+base_space;

[ax_pharm_n3] = UBC_par_line_plot(...
    select_cells,[1],all_pharma_pause3,[0 1 0],0.001,f_burst_pharma,pos_ax);


pos_ax(1) = sum(pos_ax([1,3]))+base_space;
pos_ax(3) = base_width + bar_width;
[ax_pharm_n4] = UBC_par_line_plot(...
    select_cells,[1],all_pharma_pause4,[0 1 1],0.001,f_burst_pharma,pos_ax);

ax_pharm_n1.YLim(2) = 10;
YTick = [0.001  0.1   10];
YTickLabel = {'<0.001', '0.1',  '10'};
YMinorTicks = [0.01 0.1 1 10 100 1000];
same_ylim({ax_pharm_n1, ax_pharm_n2, ax_pharm_n3,ax_pharm_n4},...
    'YTick',YTick,'YTickLabel',YTickLabel,'YMinorTicks',YMinorTicks)



%%

base_width = 0.165;
base_space = 0.02;
base_height = 0.09;
base_length = 0.38;


pos_ax = [0.05 base_height base_width base_length];
[ax_burst_pharma_par1] = plot_burst_pharma_n_spikes_heatmap(...
    select_cells,all_1x_n_spikes,f_burst_pharma,pos_ax);
title('1×');
ylabel('Sorted cell (#)')



all_2x_n_spikes = {all_pharma_n_spikes1{2},...
                    all_pharma_n_spikes2{2},...
                    all_pharma_n_spikes3{2},...
                    all_pharma_n_spikes4{2}};
pos_ax = [sum(pos_ax([1,3]))+base_space base_height base_width base_length];
[ax_burst_pharma_par2] = plot_burst_pharma_n_spikes_heatmap(...
    select_cells,all_2x_n_spikes,f_burst_pharma,pos_ax);
title('2× 100 Hz');
yticklabels({''});

all_5x_n_spikes = {all_pharma_n_spikes1{3},...
                    all_pharma_n_spikes2{3},...
                    all_pharma_n_spikes3{3},...
                    all_pharma_n_spikes4{3}};

pos_ax = [sum(pos_ax([1,3]))+base_space  base_height base_width base_length];
[ax_burst_pharma_par3] = plot_burst_pharma_n_spikes_heatmap(...
    select_cells,all_5x_n_spikes,f_burst_pharma,pos_ax);
title('5× 100 Hz');
yticklabels({''});

all_10x_n_spikes = {all_pharma_n_spikes1{4},...
                    all_pharma_n_spikes2{4},...
                    all_pharma_n_spikes3{4},...
                    all_pharma_n_spikes4{4}};

pos_ax = [sum(pos_ax([1,3]))+base_space  base_height base_width base_length];
[ax_burst_pharma_par4] = plot_burst_pharma_n_spikes_heatmap(...
    select_cells,all_10x_n_spikes,f_burst_pharma,pos_ax);
title('10× 100 Hz');
yticklabels({''});

all_20x_n_spikes = {all_pharma_n_spikes1{5},...
                    all_pharma_n_spikes2{5},...
                    all_pharma_n_spikes3{5},...
                    all_pharma_n_spikes4{5}};

pos_ax = [sum(pos_ax([1,3]))+base_space  base_height base_width base_length];
[ax_burst_pharma_par5] = plot_burst_pharma_n_spikes_heatmap(...
    select_cells,all_20x_n_spikes,f_burst_pharma,pos_ax);
title('20× 100 Hz');
yticklabels({''});

% save_figure_larger(f_burst,4);






%% Ratio type plots
f_burst_pharma = figure('Position', [28.9273 1.8000 1.3959e+03 857.8909],...
    'Color','w');


[fltr_ONidx] = get_fltr_ONidx(ONidx,find(washin_fltr));

select_cells = fltr_ONidx;
curr_select_cells = select_cells;
curr_select_cells(end) = [];

all_colors = bbpr(5);

base_width = 0.15;
graph_height = 0.14;
height_space = 0.08;
base_space = 0.04;

pos_ax = [0.07 0.8 base_width graph_height];

input_idx = 1;

opts = struct();
opts.title_text = '1x';
opts.ylabel_text = '#Spikes\newlineBaseline / -mGluR2';
opts.xlabel_text = '';
opts.xlim = [0 numel(numerator_par)+1];
opts.curr_color = all_colors(input_idx,:);
opts.plot_line = 1;
opts.upperbound = 1.5;
opts.lowerbound = -0.2;

ax_ratio = {};
[ax_ratio{input_idx}] = changed_par_normalized_plot(...
    all_pharma_n_spikes1{input_idx}(curr_select_cells),...
    all_pharma_n_spikes2{input_idx}(curr_select_cells),...
    1:numel(curr_select_cells),f_burst_pharma,pos_ax,opts);
opts.ylabel_text = '';


pos_ax(1) = sum(pos_ax([1,3]))+base_space;
input_idx = 2;
opts.title_text = '2x';
opts.curr_color = all_colors(input_idx,:);

[ax_ratio{input_idx}] = changed_par_normalized_plot(...
    all_pharma_n_spikes1{input_idx}(curr_select_cells),...
    all_pharma_n_spikes2{input_idx}(curr_select_cells),...
    1:numel(curr_select_cells),f_burst_pharma,pos_ax,opts);


pos_ax(1) = sum(pos_ax([1,3]))+base_space;
input_idx = 3;
opts.title_text = '5x';
opts.curr_color = all_colors(input_idx,:);

[ax_ratio{input_idx}] = changed_par_normalized_plot(...
    all_pharma_n_spikes1{input_idx}(curr_select_cells),...
    all_pharma_n_spikes2{input_idx}(curr_select_cells),...
    1:numel(curr_select_cells),f_burst_pharma,pos_ax,opts);


pos_ax(1) = sum(pos_ax([1,3]))+base_space;
input_idx = 4;
opts.title_text = '10x';
opts.curr_color = all_colors(input_idx,:);

[ax_ratio{input_idx}] = changed_par_normalized_plot(...
    all_pharma_n_spikes1{input_idx}(curr_select_cells),...
    all_pharma_n_spikes2{input_idx}(curr_select_cells),...
    1:numel(curr_select_cells),f_burst_pharma,pos_ax,opts);

pos_ax(1) = sum(pos_ax([1,3]))+base_space;
input_idx = 5;
opts.title_text = '20x';
opts.curr_color = all_colors(input_idx,:);

[ax_ratio{input_idx}] = changed_par_normalized_plot(...
    all_pharma_n_spikes1{input_idx}(curr_select_cells),...
    all_pharma_n_spikes2{input_idx}(curr_select_cells),...
    1:numel(curr_select_cells),f_burst_pharma,pos_ax,opts);



same_ylim(ax_ratio,'YTick',ax_ratio{1}.YTick,'YTickLabel',ax_ratio{1}.YTickLabel)



pos_ax(1) = 0.07;
pos_ax(2) = pos_ax(2)-graph_height-height_space;



input_idx = 1;
opts.title_text = '';
opts.ylabel_text = '#Spikes\newline-AMPAR / -mGluR2';
opts.xlabel_text = 'Sorted cell #';
opts.curr_color = all_colors(input_idx,:);
% opts.upperbound = 2.5;

ax_ratio2 = {};
[ax_ratio2{input_idx}] = changed_par_normalized_plot(...
    all_pharma_n_spikes3{input_idx}(curr_select_cells),...
    all_pharma_n_spikes2{input_idx}(curr_select_cells),...
    1:numel(curr_select_cells),f_burst_pharma,pos_ax,opts);
opts.ylabel_text = '';


pos_ax(1) = sum(pos_ax([1,3]))+base_space;
input_idx = 2;
opts.curr_color = all_colors(input_idx,:);
[ax_ratio2{input_idx}] = changed_par_normalized_plot(...
    all_pharma_n_spikes3{input_idx}(curr_select_cells),...
    all_pharma_n_spikes2{input_idx}(curr_select_cells),...
    1:numel(curr_select_cells),f_burst_pharma,pos_ax,opts);


pos_ax(1) = sum(pos_ax([1,3]))+base_space;
input_idx = 3;
opts.curr_color = all_colors(input_idx,:);
[ax_ratio2{input_idx}] = changed_par_normalized_plot(...
    all_pharma_n_spikes3{input_idx}(curr_select_cells),...
    all_pharma_n_spikes2{input_idx}(curr_select_cells),...
    1:numel(curr_select_cells),f_burst_pharma,pos_ax,opts);


pos_ax(1) = sum(pos_ax([1,3]))+base_space;
input_idx = 4;
opts.curr_color = all_colors(input_idx,:);
[ax_ratio2{input_idx}] = changed_par_normalized_plot(...
    all_pharma_n_spikes3{input_idx}(curr_select_cells),...
    all_pharma_n_spikes2{input_idx}(curr_select_cells),...
    1:numel(curr_select_cells),f_burst_pharma,pos_ax,opts);

pos_ax(1) = sum(pos_ax([1,3]))+base_space;
input_idx = 5;
opts.curr_color = all_colors(input_idx,:);
[ax_ratio2{input_idx}] = changed_par_normalized_plot(...
    all_pharma_n_spikes3{input_idx}(curr_select_cells),...
    all_pharma_n_spikes2{input_idx}(curr_select_cells),...
    1:numel(curr_select_cells),f_burst_pharma,pos_ax,opts);

same_ylim(ax_ratio2,'YTick',ax_ratio2{1}.YTick,'YTickLabel',ax_ratio2{1}.YTickLabel)


%% OLD
%% Make burst pharma figure (With colored heatmaps for each type of burst)

all_burst_durs      = [0.01 0.02 0.05 0.10 0.2];
all_burst_tails     = [2.9    3    10   10   10];
washin_state = [0 1 1 0 0];

%Get traces
[all_mean_pharma_bursts3,~] = ...
    get_burst_data(allData,Fs,all_burst_durs, all_burst_tails,...
    washin_state);

washin_fltr = ~isnan(all_mean_pharma_bursts3{end}(:,1));

washin_state = [1 0 0 0 0];

%Get traces 1
[all_mean_pharma_bursts1,all_full_pharma_bursts1] = ...
    get_burst_data(allData(washin_fltr),Fs,all_burst_durs, all_burst_tails,...
    washin_state);

%Get UBC parameters 1
[~,~,~,all_pharma_n_spikes1] = get_allburst_parameters(...
    all_mean_pharma_bursts1,all_baseline(washin_fltr),Fs);

washin_state = [0 1 0 0 0];

%Get traces 2
[all_mean_pharma_bursts2,all_full_pharma_bursts2] = ...
    get_burst_data(allData(washin_fltr),Fs,all_burst_durs, all_burst_tails,...
    washin_state);

%Get UBC parameters 2
[~,~,~,all_pharma_n_spikes2] = get_allburst_parameters(...
    all_mean_pharma_bursts2,all_baseline(washin_fltr),Fs);



washin_state = [0 1 1 0 0];

%Get traces 3
[all_mean_pharma_bursts3,all_full_pharma_bursts3] = ...
    get_burst_data(allData(washin_fltr),Fs,all_burst_durs, all_burst_tails,...
    washin_state);

%Get UBC parameters 3
[~,~,~,all_pharma_n_spikes3] = get_allburst_parameters(...
    all_mean_pharma_bursts3,all_baseline(washin_fltr),Fs);


washin_state = [0 1 1 1 0];

%Get traces 4
[all_mean_pharma_bursts4,all_full_pharma_bursts4] = ...
    get_burst_data(allData(washin_fltr),Fs,all_burst_durs, all_burst_tails,...
    washin_state);

%Get UBC parameters 4
[~,~,~,all_pharma_n_spikes4] = get_allburst_parameters(...
    all_mean_pharma_bursts4,all_baseline(washin_fltr),Fs);


f_burst_pharma = figure('Position', [488 1.8000 936.8000 780.8000],...
    'Color','w');


[fltr_ONidx] = get_fltr_ONidx(ONidx,find(washin_fltr));

select_cells = fltr_ONidx;


%1x
base_width = 0.035;
pos_bottom = 0.57;
pos_height = 0.39;

pos_ax = [0.0500    pos_bottom    1*base_width   pos_height];
[burst_stack_1] = plot_stacked_traces(...
    all_mean_pharma_bursts1{1},Fs,select_cells,f_burst_pharma,pos_ax);
set_axstack_par(burst_stack_1,'XLim',[0.3 1.3]);
burst_stack_1{1}.Title.String = '1x';
burst_stack_1{ceil(numel(burst_stack_1)/2)}.YLabel.String = 'Response (spk/s)';
burst_stack_1{end}.XTick = [0.5];
burst_stack_1{end}.XTickLabel = {'0'};


%2x 100Hz
pos_ax = [sum(pos_ax([1,3]))+0.01   pos_bottom    2*base_width    pos_height];
[burst_stack_2] = plot_stacked_traces(...
    all_mean_pharma_bursts1{2},Fs,select_cells,f_burst_pharma,pos_ax);
set_axstack_par(burst_stack_2,'XLim',[0.15 2.15]);
burst_stack_2{1}.Title.String = '2x 100 Hz';
burst_stack_2{end}.XTick = [0.5, 1.5];
burst_stack_2{end}.XTickLabel = {'0', '1'};


%5x 100Hz
pos_ax = [sum(pos_ax([1,3]))+0.01    pos_bottom    5*base_width    pos_height];
[burst_stack_3] = plot_stacked_traces(...
    all_mean_pharma_bursts1{3},Fs,select_cells,f_burst_pharma,pos_ax);
set_axstack_par(burst_stack_3,'XLim',[0 5]);  
burst_stack_3{1}.Title.String = '5x 100 Hz';
burst_stack_3{end}.XTick = [0.5, 2.5 4.5];
burst_stack_3{end}.XTickLabel = {'0', '2', '4'};


%10x 100Hz
pos_ax = [sum(pos_ax([1,3]))+0.01    pos_bottom    7*base_width   pos_height];
[burst_stack_4] = plot_stacked_traces(...
    all_mean_pharma_bursts1{4},Fs,select_cells,f_burst_pharma,pos_ax);
burst_stack_4{1}.Title.String = '10x 100 Hz';
set_axstack_par(burst_stack_4,'XLim',[0 7]);
burst_stack_4{end}.XLabel.String = 'Time (s)';
burst_stack_4{end}.XTick = [0.5, 2.5 4.5 6.5];
burst_stack_4{end}.XTickLabel = {'0', '2', '4', '6'};


%20x 100Hz
pos_ax = [sum(pos_ax([1,3]))+0.01    pos_bottom    10*base_width    pos_height];
[burst_stack_5] = plot_stacked_traces(...
    all_mean_pharma_bursts1{5},Fs,select_cells,f_burst_pharma,pos_ax);
burst_stack_5{1}.Title.String = '20x 100 Hz';
set_axstack_par(burst_stack_5,'XLim',[0 10]);
burst_stack_5{end}.XTick = [0.5, 2.5 4.5 6.5 8.5];
burst_stack_5{end}.XTickLabel = {'0', '2', '4', '6', '8'};

same_ylim_stack({burst_stack_1, burst_stack_2, burst_stack_3,burst_stack_4,burst_stack_5});


base_width = 0.165;
base_space = 0.02;
base_height = 0.09;
base_length = 0.38;

all_1x_n_spikes = {all_pharma_n_spikes1{1},...
                    all_pharma_n_spikes2{1},...
                    all_pharma_n_spikes3{1},...
                    all_pharma_n_spikes4{1}};
pos_ax = [0.05 base_height base_width base_length];
[ax_burst_pharma_par1] = plot_burst_pharma_n_spikes_heatmap(...
    select_cells,all_1x_n_spikes,f_burst_pharma,pos_ax);
title('1×');
ylabel('Sorted cell (#)')



all_2x_n_spikes = {all_pharma_n_spikes1{2},...
                    all_pharma_n_spikes2{2},...
                    all_pharma_n_spikes3{2},...
                    all_pharma_n_spikes4{2}};
pos_ax = [sum(pos_ax([1,3]))+base_space base_height base_width base_length];
[ax_burst_pharma_par2] = plot_burst_pharma_n_spikes_heatmap(...
    select_cells,all_2x_n_spikes,f_burst_pharma,pos_ax);
title('2× 100 Hz');
yticklabels({''});

all_5x_n_spikes = {all_pharma_n_spikes1{3},...
                    all_pharma_n_spikes2{3},...
                    all_pharma_n_spikes3{3},...
                    all_pharma_n_spikes4{3}};

pos_ax = [sum(pos_ax([1,3]))+base_space  base_height base_width base_length];
[ax_burst_pharma_par3] = plot_burst_pharma_n_spikes_heatmap(...
    select_cells,all_5x_n_spikes,f_burst_pharma,pos_ax);
title('5× 100 Hz');
yticklabels({''});

all_10x_n_spikes = {all_pharma_n_spikes1{4},...
                    all_pharma_n_spikes2{4},...
                    all_pharma_n_spikes3{4},...
                    all_pharma_n_spikes4{4}};

pos_ax = [sum(pos_ax([1,3]))+base_space  base_height base_width base_length];
[ax_burst_pharma_par4] = plot_burst_pharma_n_spikes_heatmap(...
    select_cells,all_10x_n_spikes,f_burst_pharma,pos_ax);
title('10× 100 Hz');
yticklabels({''});

all_20x_n_spikes = {all_pharma_n_spikes1{5},...
                    all_pharma_n_spikes2{5},...
                    all_pharma_n_spikes3{5},...
                    all_pharma_n_spikes4{5}};

pos_ax = [sum(pos_ax([1,3]))+base_space  base_height base_width base_length];
[ax_burst_pharma_par5] = plot_burst_pharma_n_spikes_heatmap(...
    select_cells,all_20x_n_spikes,f_burst_pharma,pos_ax);
title('20× 100 Hz');
yticklabels({''});

% save_figure_larger(f_burst,4);


