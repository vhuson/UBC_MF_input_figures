function [fltr_ONidx] = get_fltr_ONidx(ONidx,cell_fltr)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

ONidx_hits = ismember(ONidx,cell_fltr);

fltr_ONidx = ONidx(ONidx_hits);
% fltr_ONidx = tiedrank(fltr_ONidx);
[~, fltr_ONidx] =ismember(fltr_ONidx,sort(fltr_ONidx));

end