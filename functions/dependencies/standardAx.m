function [currAx] = standardAx(currAx,opts)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
base_opts.FontSize = 12;

if nargin < 2
    opts = base_opts;
else
    opts = merge_structs(base_opts,opts);
end

base_font_size = opts.FontSize;

temp_units = currAx.Units;
currAx.Units = 'pixels';

% currAx.FontUnits = 'normalized';
currAx.FontName = 'Arial';
currAx.YLabel.FontName = 'Arial';
currAx.XLabel.FontName = 'Arial';
currAx.Title.FontName = 'Arial';
currAx.Title.FontWeight = 'normal';

currAx.XColor = [0 0 0];
currAx.YColor = [0 0 0];

currAx.FontSize = base_font_size;
currAx.YLabel.FontSize = base_font_size;
currAx.XLabel.FontSize = base_font_size;
currAx.XRuler.TickLabelGapOffset = -1;
% currAx.FontSize = 0.11;
% currAx.YLabel.FontSize = 0.11;
% currAx.XLabel.FontSize = 0.11;

currAx.XLabel.Color = [0 0 0];
currAx.YLabel.Color = [0 0 0];
currAx.Title.FontSize = base_font_size;
% currAx.Title.FontSize = 0.11;

currAx.LineWidth = 1;

currAx.TickDir = 'out';
currAx.Box = 'off';

% if strcmp(currAx.XScale,'linear')
%     currTicksX = currAx.XTick;
%     currAx.XTick = currTicksX(1:2:end);
%     currAx.XMinorTick = 'on';
%     currAx.XRuler.MinorTickValues = currTicksX;
% end
% 
% if strcmp(currAx.YScale,'linear')
%     currTicksY = currAx.YTick;
%     currAx.YTick = currTicksY(1:2:end);
%     currAx.YMinorTick = 'on';
%     currAx.YRuler.MinorTickValues = currTicksY;
% end

%Make half the ticks minor if not log
%Get longest axis direction
axLength = max(currAx.Position(3:4));
currAx.TickLength = [4/axLength 0.025];

for jj = 1:numel(currAx.Children)
    if isa(currAx.Children(jj),'matlab.graphics.primitive.Text')
        currAx.Children(jj).FontName = 'Arial';
        currAx.Children(jj).FontSize = base_font_size;
    end
    if isa(currAx.Children(jj),'matlab.graphics.chart.primitive.Line')...
            || isa(currAx.Children(jj),'matlab.graphics.chart.primitive.Stair')
        
        if currAx.Children(jj).LineWidth == 0.5
            currAx.Children(jj).LineWidth = 1;
        end

    end
    if isa(currAx.Children(jj),'matlab.graphics.chart.primitive.Histogram')
        currAx.Children(jj).LineWidth = 1;
        
    end
    if isa(currAx.Children(jj),'matlab.graphics.chart.primitive.Bar')
        currAx.Children(jj).LineWidth = 1;
%         currAx.XTick = currTicksX;
    end
    if isa(currAx.Children(jj),'matlab.graphics.chart.primitive.Scatter')
        currAx.Children(jj).LineWidth = 1;
    end
end



currAx.Units = temp_units;

end

