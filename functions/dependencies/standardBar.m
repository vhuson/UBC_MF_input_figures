function [currBar] = standardBar(currBar,opts)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
base_opts.FontSize = 12;

if nargin < 2
    opts = base_opts;
else
    opts = merge_structs(base_opts,opts);
end

base_font_size = opts.FontSize;

temp_units = currBar.Units;
currBar.Units = 'pixels';

% currAx.FontUnits = 'normalized';
currBar.FontName = 'Arial';
currBar.YLabel.FontName = 'Arial';
currBar.XLabel.FontName = 'Arial';
currBar.Title.FontName = 'Arial';
currBar.Title.FontWeight = 'normal';

if currBar.XColor(1) == 0.15
    currBar.XColor = [0 0 0];
    currBar.YColor = [0 0 0];
    currBar.XLabel.Color = [0 0 0];
    currBar.YLabel.Color = [0 0 0];
end
currBar.FontSize = base_font_size;
currBar.YLabel.FontSize = base_font_size;
currBar.XLabel.FontSize = base_font_size;
% currAx.FontSize = 0.11;
% currAx.YLabel.FontSize = 0.11;
% currAx.XLabel.FontSize = 0.11;


currBar.Title.FontSize = base_font_size;
% currAx.Title.FontSize = 0.11;
currBar.LineWidth = 1;
currBar.TickDirection = 'out';
% currBar.Box = 'off';

%Make half the ticks minor if not log
%Get longest axis direction
axLength = max(currBar.Position(3:4));
currBar.TickLength = 4/axLength;

currBar.Units = temp_units;
end