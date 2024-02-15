function [all_mean_traces,all_full_traces,all_idx] = get_mean_by_filecode(...
    allData,file_match,washin)
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here
% file_match = 'TRAIN10';

all_mean_traces = cell(size(allData));
all_full_traces = cell(size(allData));
all_idx         = cell(size(allData));

for ii = 1:numel(allData)
    currData = allData{ii};
    [curr_trace,all_split_idx] = select_by_prot_code(currData,file_match,washin);
    mean_trace = mean(vertcat(curr_trace{:}),1);
    % flt_trace = medfilt1(mean_trace,Fs*0.1);

    all_mean_traces{ii} = mean_trace;
    all_full_traces{ii} = curr_trace;
    all_idx{ii}         = all_split_idx;
end

end