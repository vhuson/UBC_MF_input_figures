function [curr_traces,all_split_idx] = select_by_prot_code(currData,file_match,washin)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
file_idx = contains(currData.curr_file_names,file_match);

if nargin == 3
    curr_washin_idx = all(currData.washinIDs == washin,2);
else
    curr_washin_idx = true(size(file_idx));
end

idx_overall = find(file_idx(:) & curr_washin_idx(:));

curr_traces = cell(size(idx_overall));

all_split_idx = curr_traces;
for ii =1:numel(idx_overall)
    [idx_split] = get_split_idx(currData.curr_file_names,idx_overall(ii));


    curr_traces{ii} = currData.freqs{idx_split(1)}{idx_split(2)};
    all_split_idx{ii} = idx_split;
end
end