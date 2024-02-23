%% Get files, general means, and ONidx

setup_workspace_alldata


%% Gather burst pharma data

%First need to gather baseline data for all washin states
washin_states = {[1 0 0 0 0],[0 1 0 0 0],[0 1 1 0 0],[0 1 1 1 0]};
[washin_base_rates] = get_washin_baselines(allData,washin_states,Fs);

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
    all_mean_pharma_bursts1,washin_base_rates{1}(washin_fltr),Fs);

%Get UBC parameters


washin_state = [0 1 0 0 0];

%Get traces 2
[all_mean_pharma_bursts2,all_full_pharma_bursts2] = ...
    get_burst_data(allData(washin_fltr),Fs,all_burst_durs, all_burst_tails,...
    washin_state);

%Get UBC parameters 2
[all_pharma_slow_amp2,all_pharma_slow_HD2,all_pharma_pause2,...
    all_pharma_n_spikes2] = get_allburst_parameters(...
    all_mean_pharma_bursts2,washin_base_rates{2}(washin_fltr),Fs);



washin_state = [0 1 1 0 0];

%Get traces 3
[all_mean_pharma_bursts3,all_full_pharma_bursts3] = ...
    get_burst_data(allData(washin_fltr),Fs,all_burst_durs, all_burst_tails,...
    washin_state);

%Get UBC parameters 3
[all_pharma_slow_amp3,all_pharma_slow_HD3,all_pharma_pause3,...
    all_pharma_n_spikes3] = get_allburst_parameters(...
    all_mean_pharma_bursts3,washin_base_rates{3}(washin_fltr),Fs);


washin_state = [0 1 1 1 0];

%Get traces 4
[all_mean_pharma_bursts4,all_full_pharma_bursts4] = ...
    get_burst_data(allData(washin_fltr),Fs,all_burst_durs, all_burst_tails,...
    washin_state);

%Get UBC parameters 4
[all_pharma_slow_amp4,all_pharma_slow_HD4,all_pharma_pause4,...
    all_pharma_n_spikes4] = get_allburst_parameters(...
    all_mean_pharma_bursts4,washin_base_rates{4}(washin_fltr),Fs);

% Just pharma onidx
[fltr_ONidx] = get_fltr_ONidx(ONidx,find(washin_fltr));


%Use baseline for NaNs
all_mean_pharma_bursts_all = {all_mean_pharma_bursts1,...
                              all_mean_pharma_bursts2,...
                              all_mean_pharma_bursts3,...
                              all_mean_pharma_bursts4};

for jj = 1:numel(all_mean_pharma_bursts_all)
    curr_mean_pharma_bursts = all_mean_pharma_bursts_all{jj};
    curr_baseline = washin_base_rates{jj}(washin_fltr);
    for ii = 1:size(curr_mean_pharma_bursts{1},1)
        curr_trace = curr_mean_pharma_bursts{1}(ii,:);

        %Fill with zeros
        curr_trace(isnan(curr_trace)) = 0;

        %Fill up to first spike with baseline
        first_nozero = find(curr_trace ~= 0,1,"first");
        curr_trace(1:first_nozero) = curr_baseline(ii);

        %Put back into array
        curr_mean_pharma_bursts{1}(ii,:) = curr_trace;

    end
    all_mean_pharma_bursts_all{jj} = curr_mean_pharma_bursts;
end
all_mean_pharma_bursts1 = all_mean_pharma_bursts_all{1};
all_mean_pharma_bursts2 = all_mean_pharma_bursts_all{2};
all_mean_pharma_bursts3 = all_mean_pharma_bursts_all{3};
all_mean_pharma_bursts4 = all_mean_pharma_bursts_all{4};

%% Main figure
f_burst_pharma = figure('Position', [488 1.8000 680.3150 857.9636],...
    'Color','w');



example_cell_bpharma_panel

example_line_bpharma_panel

summaries_bpharma_panel

%Tweak figure
fig_opts = struct();
fig_opts.FontSize = 10;
standardFig(f_burst_pharma,fig_opts);

washin_graphic_panel

%Add labels
plot_labels = repmat({[]},1,58);
plot_labels{1} = 'a';
plot_labels{26} = 'b';
plot_labels{52} = 'c';
plot_labels{57} = 'd';
labelPlots(f_burst_pharma,plot_labels);

%% Supplement heatmap figure

f_burst_pharma_hmsupp = figure('Position', [488 1.8000 680.3150 857.9636],...
    'Color','w');


all_heatmaps_bpharma_figure



%Tweak figure
fig_opts = struct();
fig_opts.FontSize = 10;
standardFig(f_burst_pharma_hmsupp,fig_opts);

plot_labels = repmat({[]},1,20);
plot_labels{1} = 'a';
plot_labels{6} = 'b';
plot_labels{11} = 'c';
plot_labels{16} = 'd';
labelPlots(f_burst_pharma_hmsupp,plot_labels,fig_opts);


%% Other figures
example_cellslines_bpharma_figure

summaries_bpharma_figure

