function [all_Ylims] = same_ylim(cell_of_axes,varargin)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
p = inputParser;

addParameter(p,'YTick',[]);
addParameter(p,'YTickLabel',[]);
addParameter(p,'YMinorTicks',[]);
addParameter(p,'YMinValue',0);
addParameter(p,'YMaxValue',Inf);

parse(p,varargin{:});

YTick = p.Results.YTick;
YTickLabel = p.Results.YTickLabel;
YMinorTicks = p.Results.YMinorTicks;
y_min = p.Results.YMinValue;
y_max = p.Results.YMaxValue;

cell_of_axes = cell_of_axes(:)';


best_max = max([cellfun(@(x) x.YLim(2),cell_of_axes),y_min]);
best_max = min([y_max, best_max]);
best_min = min(cellfun(@(x) x.YLim(1),cell_of_axes));

for ii = 1:numel(cell_of_axes)
    cell_of_axes{ii}.YLim = [best_min,best_max];

    if ~isempty(YTick)
        cell_of_axes{ii}.YTick = YTick;
    end
    if ~isempty(YTickLabel)
        cell_of_axes{ii}.YTickLabel = YTickLabel;
    end
    if ~isempty(YMinorTicks)
        cell_of_axes{ii}.YRuler.MinorTickValues = YMinorTicks;
    end
end

end