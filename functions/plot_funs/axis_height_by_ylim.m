function [all_graph_heights,all_bottoms] = axis_height_by_ylim(cell_of_axes)
%Take in an collumn of axes and shrink axes down to ylim
%   Detailed explanation goes here
cell_of_axes = cell_of_axes(:);

all_diff_ylims = cellfun(@(x)diff(x.YLim),cell_of_axes);

%Get axis spaces
all_gaps = nan(1,numel(cell_of_axes)-1);
for ii = 1:numel(cell_of_axes)-1
    curr_bottom = cell_of_axes{ii}.Position(2);

    next_top = sum(cell_of_axes{ii+1}.Position([2,4]));

    all_gaps(ii) = curr_bottom-next_top;
end
mean_gap = mean(all_gaps);

all_heights = cellfun(@(x) x.Position(4),cell_of_axes);

total_height = sum(all_gaps) + sum(all_heights);

curr_bottom = min(cellfun(@(x) x.Position(2),cell_of_axes));


%Recalculate heights
base_height = total_height - mean_gap * (numel(cell_of_axes)-1);
base_height = base_height / sum(all_diff_ylims);

all_graph_heights = base_height .* all_diff_ylims;

all_bottoms = [0; cumsum(flipud(all_graph_heights(2:end))+mean_gap)];
all_bottoms = flipud(all_bottoms + curr_bottom);

%Reposition graphs
for ii = 1:numel(cell_of_axes)
    cell_of_axes{ii}.Position(2) = all_bottoms(ii);
    cell_of_axes{ii}.Position(4) = all_graph_heights(ii);
end


end