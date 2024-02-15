function [typ_cell_idxs,typ_cell_num] = UBC_cell_ID2idx(fileNames,typ_cell_IDs,ONidx)
%UNTITLED20 Summary of this function goes here
%   Detailed explanation goes here

typ_cell_idxs = nan(size(typ_cell_IDs));
typ_cell_num = typ_cell_idxs;

for ii = 1:numel(typ_cell_num)
    typ_cell_idxs(ii) = find(cellfun(@(x) contains(x,typ_cell_IDs{ii}),{fileNames.name}));
    typ_cell_num(ii) = find(ismember(ONidx,typ_cell_idxs(ii)));
end