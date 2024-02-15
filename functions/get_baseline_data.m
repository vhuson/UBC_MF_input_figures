function [all_full_traces,all_peak_segments,all_ss_segments,...
    mean_peak_segments, min_trace_leng,all_baseline_traces] = ...
    get_baseline_data(allData,Fs,all_base_freqs,prot_spec_dur,...
    washin_state)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% all_base_freqs      = [1 2.5 5];
all_peak_segments   = cell(1,numel(all_base_freqs));
all_ss_segments     = cell(1,numel(all_base_freqs));
all_full_traces     = cell(1,numel(all_base_freqs));
all_baseline_traces = cell(1,numel(all_base_freqs));


% prot_spec_dur = [2 10];
% washin_state = [1 0 0 0 0];


for ii = 1:numel(all_base_freqs)
    base_freq = all_base_freqs(ii);
    prot_spec_freq = [0 base_freq];


    %Extract right traces
    [mean_match_traces,~,mean_match_idx] = ...
        gather_spec_prot_trace(allData,Fs,...
        prot_spec_freq,prot_spec_dur,washin_state);

    %Get a bit of baseline trace from previous recording
    [baseline_traces] = get_end_of_previous(allData,mean_match_idx,1);

    %Segment baseline stuff into individual responses(peak and steady state)
    [peak_segments,ss_segments] = ...
        get_base_segments(mean_match_traces,Fs,base_freq);


    all_peak_segments{ii}   = peak_segments;
    all_ss_segments{ii}     = ss_segments;
    all_full_traces{ii}     = mean_match_traces;
    all_baseline_traces{ii} = vertcat(baseline_traces{:});
end
min_trace_leng = cellfun(@size,all_peak_segments,'UniformOutput',false);
min_trace_leng = vertcat(min_trace_leng{:});
min_trace_leng = min(min_trace_leng(:,2));

mean_peak_segments = nan(numel(allData),min_trace_leng);


for ii = 1:numel(allData)
    mean_peak_segments(ii,:) = mean(...
        [all_peak_segments{1}(ii,1:min_trace_leng); ...
        all_peak_segments{2}(ii,1:min_trace_leng); ...
        all_peak_segments{3}(ii,1:min_trace_leng)],1);
end
end