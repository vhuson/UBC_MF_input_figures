function [idx_overall] = get_overall_idx(curr_file_names,idx_split)
%UNTITLED3 Summary of this function goes here
%   idx_split = [prot_set,prot_idx;
%                    prot_set2,prot_idx2];
% oformat is important
prot2_file_idx = ~contains(curr_file_names,'100Hz');

prot1_file_names = curr_file_names(~prot2_file_idx);
prot2_file_names = curr_file_names(prot2_file_idx);

idx_overall = nan(size(idx_split,1),1);
for ii = 1:size(idx_split,1)
    if idx_split(ii,1) == 1
        curr_bwprot_names = prot1_file_names(idx_split(ii,2));
    elseif idx_split(ii,1) == 2
        curr_bwprot_names = prot2_file_names(idx_split(ii,2));
    else
        disp('bad index, check format, only pass 1')
        curr_bwprot_names = 'bad_idx';
    end
    
    idx_overall(ii) = find(ismember(curr_file_names,curr_bwprot_names));
end

end