%% Get files, general means, and ONidx

setup_workspace_alldata

%% Gather all pharma train data
washin = [0 1 1 0 0];
file_match = 'TRAIN5';
[all_mean_trains_pharma3,~] = get_mean_by_filecode(...
    allData,file_match,washin);

train_pharma_fltr = ~cellfun(@isempty,all_mean_trains_pharma3);

all_mean_trains_pharma = {};
all_train_slow_amp_pharma = {};
all_train_slow_HD_pharma = {};
all_train_pause_pharma = {};
all_train_n_spikes_pharma = {};
all_train_burst_baseline_pharma = {};
all_n_spikes_stim_pharma = {};
all_n_spikes_post_pharma = {};

all_washin = {[1 0 0 0 0];[0 1 0 0 0];[0 1 1 0 0];[0 1 1 1 0]};
for ii = 1:4

    washin = all_washin{ii};
    [all_mean_trains_pharma{ii},~] = get_mean_by_filecode(...
        allData(train_pharma_fltr),file_match,washin);

    %Get parameters (train5 hardcoded)
    [all_train_slow_amp_pharma{ii},all_train_slow_HD_pharma{ii},...
        all_train_pause_pharma{ii},all_train_n_spikes_pharma{ii},...
        ~,~,all_train_burst_baseline_pharma{ii},...
        all_n_spikes_stim_pharma{ii},all_n_spikes_post_pharma{ii}] = ...
        get_train_parameters(all_mean_trains_pharma{ii},Fs);

end


[fltr_ONidx_tpharma] = get_fltr_ONidx(ONidx,find(train_pharma_fltr));


% Gather all mean burst data
all_burst_durs      = [0.01 0.02 0.05 0.10 0.2];
all_burst_tails     = [2.9    3    10   10   10];
washin_state = [1 0 0 0 0];

%Get traces
[all_mean_bursts,all_full_bursts] = ...
    get_burst_data(allData,Fs,all_burst_durs, all_burst_tails,...
    washin_state);

%Get UBC parameters
[all_burst_slow_amp,all_burst_slow_HD,all_burst_pause,all_burst_n_spikes,...
    all_burst_fast_amp,all_burst_fast_HD,all_burst_baseline] = get_allburst_parameters(...
    all_mean_bursts,all_baseline,Fs);


%Use baseline for NaNs
for ii = 1:size(all_mean_bursts{1},1)
    curr_trace = all_mean_bursts{1}(ii,:);

    %Fill with zeros
    curr_trace(isnan(curr_trace)) = 0;

    %Fill up to first spike with baseline
    first_nozero = find(curr_trace ~= 0,1,"first");
    curr_trace(1:first_nozero) = all_baseline(ii);

    %Put back into array
    all_mean_bursts{1}(ii,:) = curr_trace;
    
end


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

%% Main figure
f_train_pharma = figure('Position', [488 1.8000 680.3150 857.9636],...
    'Color','w');

train_pharma_examples_panel

train_pharma_heatmap_panel

train_pharma_summary_panel


%Tweak figure
fig_opts = struct();
fig_opts.FontSize = 10;
standardFig(f_train_pharma,fig_opts);

%Add labels
plot_labels = repmat({[]},1,35);
plot_labels{3} = 'a';
plot_labels{7} = 'b';
plot_labels{11} = 'c';
plot_labels{15} = 'd';
plot_labels{19} = 'e';
plot_labels{27} = 'f';
% plot_labels{17} = 'g';
labelPlots(f_train_pharma,plot_labels);
