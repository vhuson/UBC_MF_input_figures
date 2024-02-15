function [select_cells] = trunc_ONidx(select_cells)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
sorted_idxs = sort(select_cells);

for ii = 1:numel(select_cells)
    select_cells(select_cells == sorted_idxs(ii)) = ii;
end
end