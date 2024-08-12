if exist('burst_data_analyzed','var') && burst_data_analyzed
    disp('Analyzed burst data already in workspace')
else %No workspace setup time to load
%% Gather all mean burst data
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
    all_mean_bursts,all_baseline,Fs,struct('post_stim_amp',true));


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

burst_data_analyzed = true;
end