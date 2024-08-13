if exist('baseline_pharma_data_analyzed','var') && baseline_pharma_data_analyzed
    disp('Analyzed baseline pharma data already in workspace')
else %No workspace setup time to load
%% Gather baseline pharma data
% Exclude cells that get too excitable during this protocol
bad_cell_IDs = {'1692','1720'};
[bad_cell_idxs] = UBC_cell_ID2idx(fileNames,bad_cell_IDs,ONidx);


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

washin_fltr_base = ~isnan(mean_peak_pharma_base3(:,1));
washin_fltr_base(bad_cell_idxs) = false;


washin_state = [1 0 0 0 0];

%Get traces 1
[all_full_pharma_base1,all_peak_pharma_base1,all_ss_pharma_base1,...
    mean_peak_pharma_base1, min_trace_leng_pharma_base1,all_preprot_base_pharma_base1] = ...
    get_baseline_data(allData(washin_fltr_base),Fs,all_base_freqs,prot_spec_dur,...
    washin_state);

%Calculate number of spikes at SS
[base_n_spikes_ss_pharma1,base_amplitude_ss_pharma1,base_async_ss_pharma1] = get_baseline_n_spikes(...
    all_ss_pharma_base1,washin_base_rates{1}(washin_fltr_base),Fs,min_trace_leng_pharma_base1);

%Calculate number of spikes at peak
[base_n_spikes_peak_pharma1] = get_baseline_n_spikes(...
    mean_peak_pharma_base1,washin_base_rates{1}(washin_fltr_base),Fs,min_trace_leng_pharma_base1);


washin_state = [0 1 0 0 0];

%Get traces 2
[all_full_pharma_base2,all_peak_pharma_base2,all_ss_pharma_base2,...
    mean_peak_pharma_base2, min_trace_leng_pharma_base2,all_preprot_base_pharma_base2] = ...
    get_baseline_data(allData(washin_fltr_base),Fs,all_base_freqs,prot_spec_dur,...
    washin_state);

%Calculate number of spikes at SS
[base_n_spikes_ss_pharma2,base_amplitude_ss_pharma2,base_async_ss_pharma2] = get_baseline_n_spikes(...
    all_ss_pharma_base2,washin_base_rates{2}(washin_fltr_base),Fs,min_trace_leng_pharma_base2);

%Calculate number of spikes at peak
[base_n_spikes_peak_pharma2] = get_baseline_n_spikes(...
    mean_peak_pharma_base2,washin_base_rates{2}(washin_fltr_base),Fs,min_trace_leng_pharma_base2);




washin_state = [0 1 1 0 0];

%Get traces 3
[all_full_pharma_base3,all_peak_pharma_base3,all_ss_pharma_base3,...
    mean_peak_pharma_base3, min_trace_leng_pharma_base3,all_preprot_base_pharma_base3] = ...
    get_baseline_data(allData(washin_fltr_base),Fs,all_base_freqs,prot_spec_dur,...
    washin_state);

%Calculate number of spikes at SS
[base_n_spikes_ss_pharma3,base_amplitude_ss_pharma3,base_async_ss_pharma3] = get_baseline_n_spikes(...
    all_ss_pharma_base3,washin_base_rates{3}(washin_fltr_base),Fs,...
    min_trace_leng_pharma_base3);

%Calculate number of spikes at peak
[base_n_spikes_peak_pharma3] = get_baseline_n_spikes(...
    mean_peak_pharma_base3,washin_base_rates{3}(washin_fltr_base),Fs,...
    min_trace_leng_pharma_base3);



washin_state = [0 1 1 1 0];

%Get traces 4
[all_full_pharma_base4,all_peak_pharma_base4,all_ss_pharma_base4,...
    mean_peak_pharma_base4, min_trace_leng_pharma_base4,all_preprot_base_pharma_base4] = ...
    get_baseline_data(allData(washin_fltr_base),Fs,all_base_freqs,prot_spec_dur,...
    washin_state);

%Calculate number of spikes at SS
[base_n_spikes_ss_pharma4,base_amplitude_ss_pharma4,base_async_ss_pharma4] = get_baseline_n_spikes(...
    all_ss_pharma_base4,washin_base_rates{4}(washin_fltr_base),Fs,...
    min_trace_leng_pharma_base4);

%Calculate number of spikes at peak
[base_n_spikes_peak_pharma4] = get_baseline_n_spikes(...
    mean_peak_pharma_base4,washin_base_rates{4}(washin_fltr_base),Fs,...
    min_trace_leng_pharma_base4);



[fltr_ONidx_baseline] = get_fltr_ONidx(ONidx,find(washin_fltr_base));

select_cells = fltr_ONidx_baseline;


baseline_pharma_data_analyzed = true;
end