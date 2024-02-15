function [baseline_traces] = get_end_of_previous(allData,split_idx,segment_length,Fs)
%UNTITLED18 Summary of this function goes here
%   Detailed explanation goes here
if nargin < 4
    Fs = 20000;
end

% minus 1 to accomodate end idx
segment_end_idx = floor(segment_length*Fs)-1;

baseline_traces = cell(size(allData));
for ii = 1:numel(allData)
    ii_file_names = allData{ii}.curr_file_names;
    ii_freqs = allData{ii}.freqs;
    %Get previous idx
    curr_overall_idx = get_overall_idx(ii_file_names,split_idx{ii});
    prev_idx = get_split_idx(ii_file_names,curr_overall_idx-1);

    curr_trace = ii_freqs{prev_idx(1)}{prev_idx(2)};

    baseline_traces{ii} = curr_trace(end-segment_end_idx:end);

end

end