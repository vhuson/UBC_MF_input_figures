function [trace_segments] = segment_freqs_trace(freqs_trace,Fs,freq)
%segment_freqs_trace Takes in a trace and segments based on a frequency
%   Detailed explanation goes here
num_samples = numel(freqs_trace);
seg_samples = round(Fs/freq);

starts = 1:seg_samples:num_samples;
ends = seg_samples:seg_samples:num_samples;

%Truncate to the same length
num_segments = min([numel(starts),numel(ends)]);
starts = starts(1:num_segments);
ends = ends(1:num_segments);


trace_segments = arrayfun(@(x,y) {freqs_trace(x:y)},starts,ends);
trace_segments = vertcat(trace_segments{:});
end