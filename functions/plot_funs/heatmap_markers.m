function [hm_ax,ar] = heatmap_markers(hm_ax,mark_cells,opts)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
base_opts.color = [1 0 0];

if nargin < 3
    opts = base_opts;
else
    opts = merge_structs(base_opts,opts);
end

%set base markers
hm_ax.YTick = [1 floor(hm_ax.YLim(2))];


%Flag marked cells
arrow_color = repmat(opts.color,numel(mark_cells),1);


posAx1 = hm_ax.Position;
% posAx2 = ax2.Position;

xCords1 = [posAx1(1)-0.001 posAx1(1)];
% xCords2 = [posAx2(1)-0.001 posAx2(1)];

numCells = round(hm_ax.YLim(2)-hm_ax.YLim(1));

ar = {};
for ii = 1:numel(mark_cells)
    cellID = mark_cells(ii);
    
    rowHeight = posAx1(4)/numCells;
    currYOffset = rowHeight*cellID - rowHeight/2;
    yHeight = sum(posAx1([2,4]))-currYOffset;
    
%     xCords = [0.5 0.6];
    yCords = [yHeight yHeight];
    
    ar{ii,1} = annotation('arrow',xCords1,yCords,'Linewidth',0.7,...
        'Color',arrow_color(ii,:),...
        'HeadStyle','plain','HeadLength',4,'HeadWidth',3);
    ar{ii,1}.Units = 'pixels';
    ar{ii,1}.X = ar{ii,1}.X-1;
    ar{ii,1}.Units = 'normalized';
end




end