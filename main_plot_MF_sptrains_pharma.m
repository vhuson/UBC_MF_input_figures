%% Get files, general means, and ONidx

setup_workspace_alldata

%% Gather all pharma train data
washin = [0 1 1 0 0];
file_match = 'TRAIN5';
[all_mean_trains_pharma3,~] = get_mean_by_filecode(...
    allData,file_match,washin);

train_pharma_fltr = ~cellfun(@isempty,all_mean_trains_pharma3);

all_mean_trains_pharma = {};
all_full_trains_pharma = {};
all_train_slow_amp_pharma = {};
all_train_slow_HD_pharma = {};
all_train_pause_pharma = {};
all_train_n_spikes_pharma = {};
all_train_burst_baseline_pharma = {};
all_n_spikes_stim_pharma = {};
all_n_spikes_post_pharma = {};

%Burst parameters
all_mean_pharma_bursts = {};
all_full_pharma_bursts = {};
all_burst_durs      = [0.01 0.02 0.05 0.10 0.2];
all_burst_tails     = [2.9    3    10   10   10];


all_washin = {[1 0 0 0 0];[0 1 0 0 0];[0 1 1 0 0];[0 1 1 1 0]};
for ii = 1:4

    washin = all_washin{ii};
    [all_mean_trains_pharma{ii},all_full_trains_pharma{ii}] = get_mean_by_filecode(...
        allData(train_pharma_fltr),file_match,washin);

    %Get parameters (train5 hardcoded)
    [all_train_slow_amp_pharma{ii},all_train_slow_HD_pharma{ii},...
        all_train_pause_pharma{ii},all_train_n_spikes_pharma{ii},...
        ~,~,all_train_burst_baseline_pharma{ii},...
        all_n_spikes_stim_pharma{ii},all_n_spikes_post_pharma{ii},...
        ~, ~,...
        all_sum_spikes_stim_pharma{ii},all_sum_spikes_post_pharma{ii},...
        all_train_half_decay_pharma{ii}] = ...
        get_train_parameters(all_mean_trains_pharma{ii},Fs);

    %Get burst traces
    [all_mean_pharma_bursts{ii},all_full_pharma_bursts{ii}] = ...
        get_burst_data(allData(train_pharma_fltr),Fs,all_burst_durs, all_burst_tails,...
        washin);

end


[fltr_ONidx_tpharma] = get_fltr_ONidx(ONidx,find(train_pharma_fltr));




%Protocol templates
%burst
input_burst = zeros(1,210000);
input_burst(0.5*Fs:0.7*Fs) = 100;

%Train5
input_train_5 = zeros(1,800001);
input_train_5(5*Fs:33*Fs) = 5;
input_train_5(8*Fs:9*Fs) = 10;
input_train_5(12*Fs:13*Fs) = 20;
input_train_5(16*Fs:17*Fs) = 30;
input_train_5(20*Fs:21*Fs) = 40;
input_train_5(24*Fs:25*Fs) = 50;
input_train_5(28*Fs:29*Fs) = 60;
input_train_5(32*Fs:33*Fs) = 20;
input_train_5(36*Fs:37*Fs) = 20;

train5_step_times = [5, 8, 12, 16, 20, 24, 28, 32, 36];

%% Main figure
f_train_pharma = figure('Position', [488 1.8000 680.3150 857.9636],...
    'Color','w');

train_pharma_examples_panel
train_pharma_burst_examples_panel
% 
%Heatmaps including bursts
train_pharma_burst_heatmap_panel
train_pharma_heatmap_panel
% 
% train_pharma_summary_panel_peak
train_pharma_summary_panel_stimspikes
summaries_tpharm_component_panel
% train_pharma_summary_panel_postspikes
% train_pharma_summary_panel_percentspikes
% train_pharma_summary_panel


%Tweak figure
fig_opts = struct();
fig_opts.FontSize = 10;
standardFig(f_train_pharma,fig_opts);

%Add labels
plot_labels = repmat({[]},1,51);
plot_labels{19} = 'a';
plot_labels{2} = 'b';
% plot_labels{3} = 'c';
% plot_labels{7} = 'd';
% plot_labels{24} = 'c';
% plot_labels{11} = 'f';
% plot_labels{15} = 'g';
plot_labels{28} = 'c';
plot_labels{33} = 'd';
plot_labels{40} = 'e';
plot_labels{48} = 'f';
plot_labels{50} = 'g';
plot_labels{51} = 'h';
[~,t_labels] = labelPlots(f_train_pharma,plot_labels);

for ii = [1,4]
    t_labels{ii}.Position(1) = -6;
end
for ii = [2,3,5,6]
    t_labels{ii}.Position(1) = -47;
end
t_labels{5}.Position(2) = 102;
for ii = [7,8]
    t_labels{ii}.Position(1:2) = [-69 80];
end
t_labels{6}.Position(2) = 80;
% exportgraphics(f_train_pharma,'pdf\240809_fig5.pdf','ContentType','vector')
%% other figure
train_pharma_20s_figure

