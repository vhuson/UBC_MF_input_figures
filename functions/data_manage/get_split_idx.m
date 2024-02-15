function [idx_split] = get_split_idx(curr_file_names,idx_overall)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
prot2_file_idx = ~contains(curr_file_names,'100Hz');

prot1_file_names = curr_file_names(~prot2_file_idx);
prot2_file_names = curr_file_names(prot2_file_idx);


curr_bwprot_names = curr_file_names(idx_overall);

prot1_idx = find(ismember(prot1_file_names,curr_bwprot_names));
prot2_idx = find(ismember(prot2_file_names,curr_bwprot_names));

if ~isempty(prot1_idx)
    %Its prot1
    idx_split = [1, prot1_idx];
elseif ~isempty(prot2_idx)
    %prot 2
    idx_split = [2, prot2_idx];
end

end