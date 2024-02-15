function [peak_segments,ss_segments] = get_base_segments(base_traces,Fs,base_freq,ss_start)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
if nargin == 3
    ss_start = 6;
end

seg_samples = round(Fs/base_freq);

peak_segments   = nan(size(base_traces,1),seg_samples);
ss_segments     = nan(size(base_traces,1),seg_samples);


for ii = 1:size(base_traces,1)

    [trace_segments] = segment_freqs_trace(base_traces(ii,:),Fs,base_freq);


    peak_segments(ii,:)  = trace_segments(1,:);
    ss_segments(ii,:)    = mean(trace_segments(ss_start:end,:),1);
end
end