%% Get files, general means, and ONidx

setup_workspace_cpp


%% Gather burst pharma data
%First need to gather baseline data for all washin states
washin_states = {[1 0 0],[0 1 0]};
[washin_base_rates] = get_washin_baselines(allData,washin_states,Fs);

all_burst_durs      = [0.01 0.02 0.05 0.10 0.2];
all_burst_tails     = [2.9    3    10   10   10];
washin_state = [0 1 0];

%Get traces
[all_mean_cpp_bursts2,~] = ...
    get_burst_data(allData,Fs,all_burst_durs, all_burst_tails,...
    washin_state);

washin_fltr = ~isnan(all_mean_cpp_bursts2{end}(:,1));

washin_state = [1 0 0];

%Get traces 1
[all_mean_cpp_bursts1,all_full_cpp_bursts1] = ...
    get_burst_data(allData(washin_fltr),Fs,all_burst_durs, all_burst_tails,...
    washin_state);

%Get UBC parameters 1
[all_cpp_slow_amp1,all_cpp_slow_HD1,all_cpp_pause1,...
    all_cpp_n_spikes1,~,~,~,~,all_cpp_supp_pars1] = get_allburst_parameters(...
    all_mean_cpp_bursts1,washin_base_rates{1}(washin_fltr),Fs,...
    struct('post_stim_amp',true, 'post_stim_par', true));


washin_state = [0 1 0];

%Get traces 2
[all_mean_cpp_bursts2,all_full_cpp_bursts2] = ...
    get_burst_data(allData(washin_fltr),Fs,all_burst_durs, all_burst_tails,...
    washin_state);

%Get UBC parameters 2
[all_cpp_slow_amp2,all_cpp_slow_HD2,all_cpp_pause2,...
    all_cpp_n_spikes2,~,~,~,~,all_cpp_supp_pars2] = get_allburst_parameters(...
    all_mean_cpp_bursts2,washin_base_rates{2}(washin_fltr),Fs,...
    struct('post_stim_amp',true, 'post_stim_par', true));



% Just cpp onidx
[fltr_ONidx] = get_fltr_ONidx(ONidx,find(washin_fltr));


%Use baseline for NaNs
all_mean_cpp_bursts_all = {all_mean_cpp_bursts1,...
                              all_mean_cpp_bursts2};

for jj = 1:numel(all_mean_cpp_bursts_all)
    curr_mean_cpp_bursts = all_mean_cpp_bursts_all{jj};
    curr_baseline = washin_base_rates{jj}(washin_fltr);
    for ii = 1:size(curr_mean_cpp_bursts{1},1)
        curr_trace = curr_mean_cpp_bursts{1}(ii,:);

        %Fill with zeros
        curr_trace(isnan(curr_trace)) = 0;

        %Fill up to first spike with baseline
        first_nozero = find(curr_trace ~= 0,1,"first");
        curr_trace(1:first_nozero) = curr_baseline(ii);

        %Put back into array
        curr_mean_cpp_bursts{1}(ii,:) = curr_trace;

    end
    all_mean_cpp_bursts_all{jj} = curr_mean_cpp_bursts;
end
all_mean_cpp_bursts1 = all_mean_cpp_bursts_all{1};
all_mean_cpp_bursts2 = all_mean_cpp_bursts_all{2};
%% Calculate fractional increases and decreases


nmdar_cpp_normalized_to_20base = zeros(numel(all_cpp_supp_pars1{1}),numel(all_cpp_supp_pars1));
base_cpp_normalized_to_20base = nmdar_cpp_normalized_to_20base;


for ii = 1:numel(all_cpp_supp_pars1)
    for jj = 1:numel(all_cpp_supp_pars1{1})
        
        nmdar_cpp_normalized_to_20base(jj,ii) = all_cpp_supp_pars2{ii}{jj}.n_spikes_not_normalized...
                            ./ all_cpp_supp_pars1{5}{jj}.n_spikes_not_normalized;
        base_cpp_normalized_to_20base(jj,ii) = all_cpp_supp_pars1{ii}{jj}.n_spikes_not_normalized...
                            ./ all_cpp_supp_pars1{5}{jj}.n_spikes_not_normalized;
    end
end


%% Gather all pharma train data
washin = [0 1 0];
file_match = 'TRAIN5';
[all_mean_trains_cpp2,~] = get_mean_by_filecode(...
    allData,file_match,washin);

train_cpp_fltr = ~cellfun(@isempty,all_mean_trains_cpp2);

all_mean_trains_cpp = {};
all_full_trains_cpp = {};
all_train_slow_amp_cpp = {};
all_train_slow_HD_cpp = {};
all_train_pause_cpp = {};
all_train_n_spikes_cpp = {};
all_train_burst_baseline_cpp = {};
all_n_spikes_stim_cpp = {};
all_n_spikes_post_cpp = {};




all_washin = {[1 0 0];[0 1 0]};
for ii = 1:2

    washin = all_washin{ii};
    [all_mean_trains_cpp{ii},all_full_trains_cpp{ii}] = get_mean_by_filecode(...
        allData(train_cpp_fltr),file_match,washin);

    %Get parameters (train5 hardcoded)
    [all_train_slow_amp_cpp{ii},all_train_slow_HD_cpp{ii},...
        all_train_pause_cpp{ii},all_train_n_spikes_cpp{ii},...
        ~,~,all_train_burst_baseline_cpp{ii},...
        all_n_spikes_stim_cpp{ii},all_n_spikes_post_cpp{ii},...
        ~, ~,...
        all_sum_spikes_stim_pharma{ii},all_sum_spikes_post_pharma{ii},...
        all_train_half_decay_pharma{ii}] = ...
        get_train_parameters(all_mean_trains_cpp{ii},Fs);

end


[fltr_ONidx_tcpp] = get_fltr_ONidx(ONidx,find(train_cpp_fltr));




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

%% Main cpp burst figure
f_burst_cpp = figure('Position', [488 1.8000 680.3150 857.9636],...
    'Color','w');



example_cell_cpp_panel

% example_line_bpharma_panel
% example_line_bpharma_v2_panel
% example_line_bpharma_nspikes_panel

heatmap_cpp_panel

% summaries_cpp_panel
summaries_component_cpp_panel
% summaries_bpharma_singlerow_panel

%Tweak figure
fig_opts = struct();
fig_opts.FontSize = 10;
standardFig(f_burst_cpp,fig_opts);


%Add labels
plot_labels = repmat({[]},1,120);
plot_labels{1} = 'a';
plot_labels{17} = 'b';
plot_labels{27} = 'c';
% plot_labels{31} = 'd';
% plot_labels{97} = 'e';
% plot_labels{102} = 'f';
% plot_labels{82} = 'e';
[~,t_labels] = labelPlots(f_burst_cpp,plot_labels);


for ii = 1:numel(t_labels)
    t_labels{ii}.Position(1) = -41;
end

t_labels{3}.Position(2) = 115.1273;

% exportgraphics(f_burst_cpp,'pdf\240801_supp_cpp1.pdf','ContentType','vector')

%% Main cpp train figure
f_train_cpp = figure('Position', [488 1.8000 680.3150 857.9636],...
    'Color','w');

train_example_cell_cpp_panel
train_example_bursts_cpp_panel
% 
%Heatmaps including bursts
train_heatmap_burst_cpp_panel
train_heatmap_cpp_panel

train_component_cpp_panel
% train_nspike_summary_cpp_panel


%Tweak figure
fig_opts = struct();
fig_opts.FontSize = 10;
standardFig(f_train_cpp,fig_opts);

%Add labels
plot_labels = repmat({[]},1,46);
plot_labels{11} = 'a';
plot_labels{2} = 'b';
plot_labels{16} = 'c';
plot_labels{19} = 'd';
plot_labels{22} = 'e';
% plot_labels{46} = 'f';
[~,t_labels] = labelPlots(f_train_cpp,plot_labels);
for ii = 2:numel(t_labels)
    t_labels{ii}.Position(1) = -41;
end

for ii = [1,4]
    t_labels{ii}.Position(1) = -1;
end
% exportgraphics(f_train_cpp,'pdf\240801_supp_cpp2.pdf','ContentType','vector')

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
labelPlots(f_burst_pharma_hmsupp,plot_labels);


%% Other figures
example_cellslines_bpharma_figure

summaries_bpharma_figure

