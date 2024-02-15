function [all_Ylims] = same_ylim_stack(cell_of_stacks,min_y,set_y)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
if nargin < 2
    min_y = 0;
end
if nargin < 3
    set_y = false;
end

all_Ylims = nan(size(cell_of_stacks{1}));

for ii = 1:numel(cell_of_stacks{1})
    if islogical(set_y)
        curr_Lim = max(...
            [cellfun(@(x) x{ii}.YLim(2),cell_of_stacks),min_y]);
    else
        curr_Lim = set_y;
    end
    all_Ylims(ii) = curr_Lim;
    for jj = 1:numel(cell_of_stacks)
        cell_of_stacks{jj}{ii}.YLim(2) = curr_Lim;
    end
end
end