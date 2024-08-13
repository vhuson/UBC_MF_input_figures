if exist('sptrains_data_analyzed','var') && sptrains_data_analyzed
    disp('Analyzed train data already in workspace')
else %No workspace setup time to load
%% Gather all train data
washin = [1 0 0 0 0];
file_match = 'TRAIN10';
[all_mean_trains,all_full_trains,all_idx] = get_mean_by_filecode(...
    allData,file_match,washin);

file_match = 'TRAIN5';
[all_mean_trains_5,all_full_trains_5,all_idx_5] = get_mean_by_filecode(...
    allData,file_match,washin);

train_fltr_10 = ~cellfun(@isempty,all_mean_trains);
train_fltr_5 = ~cellfun(@isempty,all_mean_trains_5);


%Get parameters (train5 hardcoded)
[all_train_slow_amp,all_train_slow_HD,all_train_pause,all_train_n_spikes,...
    ~,~,all_train_burst_baseline,all_n_spikes_stim,all_n_spikes_post,...
    all_n_spikes_stim_global_base, all_n_spikes_post_global_base,...
    all_sum_spikes_stim,all_sum_spikes_post,all_train_half_decay,all_60_fit] = ...
    get_train_parameters(all_mean_trains_5(train_fltr_5),Fs,struct('do_fit',true));

%Get specific window n_spikes
spike_windows = {[0.9 1],[3,4]};
[specific_nspikes, specific_nspikes_base_corr, specific_nspikes_global_basecorr] = ...
    get_train_nspikes(all_mean_trains_5(train_fltr_5),spike_windows,Fs);


[fltr_ONidx_t10] = get_fltr_ONidx(ONidx,find(train_fltr_10));
[fltr_ONidx_t5] = get_fltr_ONidx(ONidx,find(train_fltr_5));


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

train5_step_times = [5, 8, 12, 16, 20, 24, 28, 32, 36];

%Train10
input_train_10 = zeros(1,800001);
input_train_10(5*Fs:33*Fs) = 10;
input_train_10(8*Fs:9*Fs) = 20;
input_train_10(12*Fs:13*Fs) = 30;
input_train_10(16*Fs:17*Fs) = 40;
input_train_10(20*Fs:21*Fs) = 50;
input_train_10(24*Fs:25*Fs) = 60;
input_train_10(28*Fs:29*Fs) = 80;
input_train_10(32*Fs:33*Fs) = 40;
input_train_10(36*Fs:37*Fs) = 20;


sptrains_data_analyzed = true;
end