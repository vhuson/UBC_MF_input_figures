%% Gather burst pharma data
if exist('cpp_data_analyzed','var') && cpp_data_analyzed
    disp('Analyzed cpp data already in workspace')
else %No workspace setup time to load
%First need to gather baseline data for all washin states
washin_states_cpp = {[1 0 0],[0 1 0]};
[washin_base_rates_cpp] = get_washin_baselines(allData_cpp,washin_states_cpp,Fs);

all_burst_durs      = [0.01 0.02 0.05 0.10 0.2];
all_burst_tails     = [2.9    3    10   10   10];
washin_state = [0 1 0];

%Get traces
[all_mean_cpp_bursts2,~] = ...
    get_burst_data(allData_cpp,Fs,all_burst_durs, all_burst_tails,...
    washin_state);

washin_fltr_cpp = ~isnan(all_mean_cpp_bursts2{end}(:,1));

washin_state = [1 0 0];

%Get traces 1
[all_mean_cpp_bursts1,all_full_cpp_bursts1] = ...
    get_burst_data(allData_cpp(washin_fltr_cpp),Fs,all_burst_durs, all_burst_tails,...
    washin_state);

%Get UBC parameters 1
[all_cpp_slow_amp1,all_cpp_slow_HD1,all_cpp_pause1,...
    all_cpp_n_spikes1,~,~,~,~,all_cpp_supp_pars1] = get_allburst_parameters(...
    all_mean_cpp_bursts1,washin_base_rates_cpp{1}(washin_fltr_cpp),Fs,...
    struct('post_stim_amp',true, 'post_stim_par', true));


washin_state = [0 1 0];

%Get traces 2
[all_mean_cpp_bursts2,all_full_cpp_bursts2] = ...
    get_burst_data(allData_cpp(washin_fltr_cpp),Fs,all_burst_durs, all_burst_tails,...
    washin_state);

%Get UBC parameters 2
[all_cpp_slow_amp2,all_cpp_slow_HD2,all_cpp_pause2,...
    all_cpp_n_spikes2,~,~,~,~,all_cpp_supp_pars2] = get_allburst_parameters(...
    all_mean_cpp_bursts2,washin_base_rates_cpp{2}(washin_fltr_cpp),Fs,...
    struct('post_stim_amp',true, 'post_stim_par', true));



% Just cpp onidx
[fltr_ONidx_cpp] = get_fltr_ONidx(ONidx_cpp,find(washin_fltr_cpp));


%Use baseline for NaNs
all_mean_cpp_bursts_all = {all_mean_cpp_bursts1,...
                              all_mean_cpp_bursts2};

for jj = 1:numel(all_mean_cpp_bursts_all)
    curr_mean_cpp_bursts = all_mean_cpp_bursts_all{jj};
    curr_baseline = washin_base_rates_cpp{jj}(washin_fltr_cpp);
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
    allData_cpp,file_match,washin);

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
        allData_cpp(train_cpp_fltr),file_match,washin);

    %Get parameters (train5 hardcoded)
    [all_train_slow_amp_cpp{ii},all_train_slow_HD_cpp{ii},...
        all_train_pause_cpp{ii},all_train_n_spikes_cpp{ii},...
        ~,~,all_train_burst_baseline_cpp{ii},...
        all_n_spikes_stim_cpp{ii},all_n_spikes_post_cpp{ii},...
        ~, ~,...
        all_sum_spikes_stim_cpp{ii},all_sum_spikes_post_cpp{ii},...
        all_train_half_decay_cpp{ii}] = ...
        get_train_parameters(all_mean_trains_cpp{ii},Fs);

end


[fltr_ONidx_tcpp] = get_fltr_ONidx(ONidx_cpp,find(train_cpp_fltr));




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


cpp_data_analyzed = true;
end