%% Get files, general means, and ONidx

setup_workspace_alldata

%Dirty fix for problem in cell 1774 "56"
allData{56}.spks_prot{2}{17}(14) = [];

%% Make baseline pharma figure

%First need to gather baseline data for all washin states
washin_states = {[1 0 0 0 0],[0 1 0 0 0],[0 1 1 0 0],[0 1 1 1 0]};
[washin_base_rates] = get_washin_baselines(allData,washin_states,Fs);


all_base_freqs      = [1 2.5 5];
prot_spec_dur = [2 10];
washin_state = [0 1 1 0 0];



%Retrieve all data
[all_full_pharma_base3,all_peak_pharma_base3,all_ss_pharma_base3,...
    mean_peak_pharma_base3, min_trace_leng_pharma_base3] = ...
    get_baseline_data(allData,Fs,all_base_freqs,prot_spec_dur,...
    washin_state);

washin_fltr = ~isnan(mean_peak_pharma_base3(:,1));


washin_state = [1 0 0 0 0];

%Get traces 1
[all_full_pharma_base1,all_peak_pharma_base1,all_ss_pharma_base1,...
    mean_peak_pharma_base1, min_trace_leng_pharma_base1,all_preprot_base_pharma_base1] = ...
    get_baseline_data(allData(washin_fltr),Fs,all_base_freqs,prot_spec_dur,...
    washin_state);

%Calculate number of spikes at SS
[base_n_spikes_ss_pharma1] = get_baseline_n_spikes(...
    all_ss_pharma_base1,washin_base_rates{1}(washin_fltr),Fs,min_trace_leng_pharma_base1);

%Calculate number of spikes at peak
[base_n_spikes_peak_pharma1] = get_baseline_n_spikes(...
    mean_peak_pharma_base1,washin_base_rates{1}(washin_fltr),Fs,min_trace_leng_pharma_base1);


washin_state = [0 1 0 0 0];

%Get traces 2
[all_full_pharma_base2,all_peak_pharma_base2,all_ss_pharma_base2,...
    mean_peak_pharma_base2, min_trace_leng_pharma_base2,all_preprot_base_pharma_base2] = ...
    get_baseline_data(allData(washin_fltr),Fs,all_base_freqs,prot_spec_dur,...
    washin_state);

%Calculate number of spikes at SS
[base_n_spikes_ss_pharma2] = get_baseline_n_spikes(...
    all_ss_pharma_base2,washin_base_rates{2}(washin_fltr),Fs,min_trace_leng_pharma_base2);

%Calculate number of spikes at peak
[base_n_spikes_peak_pharma2] = get_baseline_n_spikes(...
    mean_peak_pharma_base2,washin_base_rates{2}(washin_fltr),Fs,min_trace_leng_pharma_base2);




washin_state = [0 1 1 0 0];

%Get traces 3
[all_full_pharma_base3,all_peak_pharma_base3,all_ss_pharma_base3,...
    mean_peak_pharma_base3, min_trace_leng_pharma_base3,all_preprot_base_pharma_base3] = ...
    get_baseline_data(allData(washin_fltr),Fs,all_base_freqs,prot_spec_dur,...
    washin_state);

%Calculate number of spikes at SS
[base_n_spikes_ss_pharma3] = get_baseline_n_spikes(...
    all_ss_pharma_base3,washin_base_rates{3}(washin_fltr),Fs,...
    min_trace_leng_pharma_base3);

%Calculate number of spikes at peak
[base_n_spikes_peak_pharma3] = get_baseline_n_spikes(...
    mean_peak_pharma_base3,washin_base_rates{3}(washin_fltr),Fs,...
    min_trace_leng_pharma_base3);



washin_state = [0 1 1 1 0];

%Get traces 4
[all_full_pharma_base4,all_peak_pharma_base4,all_ss_pharma_base4,...
    mean_peak_pharma_base4, min_trace_leng_pharma_base4,all_preprot_base_pharma_base4] = ...
    get_baseline_data(allData(washin_fltr),Fs,all_base_freqs,prot_spec_dur,...
    washin_state);

%Calculate number of spikes at SS
[base_n_spikes_ss_pharma4] = get_baseline_n_spikes(...
    all_ss_pharma_base4,washin_base_rates{4}(washin_fltr),Fs,...
    min_trace_leng_pharma_base4);

%Calculate number of spikes at peak
[base_n_spikes_peak_pharma4] = get_baseline_n_spikes(...
    mean_peak_pharma_base4,washin_base_rates{4}(washin_fltr),Fs,...
    min_trace_leng_pharma_base4);



[fltr_ONidx] = get_fltr_ONidx(ONidx,find(washin_fltr));

select_cells = fltr_ONidx;

%% Main figure
f_base_pharma = figure('Position', [488 1.8000 680.3150 857.9636],...
    'Color','w');


example_cell_ci_pharma_panel

all_heatmaps_ci_pharma_panel

%Tweak figure
fig_opts = struct();
fig_opts.FontSize = 10;
standardFig(f_base_pharma,fig_opts);


%Add labels
% plot_labels = repmat({[]},1,58);
% plot_labels{1} = 'a';
% plot_labels{26} = 'b';
% plot_labels{52} = 'c';
% plot_labels{57} = 'd';
% labelPlots(f_base_pharma,plot_labels);


%% Supplement heatmap figure

f_base_pharma_hmsupp = figure('Position', [488 1.8000 680.3150 857.9636],...
    'Color','w');



all_heatmaps_ci_pharma_figure



%Tweak figure
fig_opts = struct();
fig_opts.FontSize = 10;
standardFig(f_base_pharma_hmsupp,fig_opts);

plot_labels = repmat({[]},1,20);
plot_labels{1} = 'a';
plot_labels{4} = 'b';
plot_labels{7} = 'c';
plot_labels{10} = 'd';
labelPlots(f_base_pharma_hmsupp,plot_labels);



%% Other figures
stacked_traces_parheatmap_figure

baseline_pharma_ratiopar_figure



