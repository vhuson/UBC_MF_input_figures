if exist('baseline_data_analyzed','var') && baseline_data_analyzed
    disp('Analyzed baseline data already in workspace')
else %No workspace setup time to load
%% Gather baseline data
all_base_freqs      = [1 2.5 5];
prot_spec_dur = [2 10];
washin_state = [1 0 0 0 0];

%Retrieve all data
[all_full_traces,all_peak_segments,all_ss_segments,...
    mean_peak_segments, min_trace_leng,pre_prot_baseline_traces,all_tail_traces] = ...
    get_baseline_data(allData,Fs,all_base_freqs,prot_spec_dur,...
    washin_state);

%Get peak and n-spikes info for each separate segment
[constant_input_pars, constant_input_pars_base_corr, constant_input_other] ...
    = get_all_baseline_n_spikes(...
    all_full_traces,all_baseline,Fs,all_base_freqs);

%Get spike triggered average segments
mean_segments = cellfun(@(x) {cellfun(@(y) {mean(y)},x)},...
    {constant_input_other.corr_trace_segments});
mean_segments = cellfun(@(x) {vertcat(x{:})},mean_segments);

%Calculate number of spikes at SS
[base_n_spikes_ss,base_amplitude_ss,base_async_ss,base_ratio_ss,...
    base_async_min_leng_ss] = get_baseline_n_spikes(...
    all_ss_segments,all_baseline,Fs,min_trace_leng);


%Calculate number of spikes at peak
[base_n_spikes_peak, base_amplitude_peak, base_async_peak] = get_baseline_n_spikes(...
    mean_peak_segments,all_baseline,Fs,min_trace_leng);

%Calculate async 1s after train
base_async_end1s = cellfun(@(x) {mean(x(:,Fs-50:Fs+50),2)},all_tail_traces);

baseline_data_analyzed = true;
end