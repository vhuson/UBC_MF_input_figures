function [currAx] = change_fontsize(currAx,base_font_size)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% base_font_size = 12;

currAx.FontSize = base_font_size;
currAx.YLabel.FontSize = base_font_size;
currAx.XLabel.FontSize = base_font_size;
currAx.Title.FontSize = base_font_size;

for jj = 1:numel(currAx.Children)
    if isa(currAx.Children(jj),'matlab.graphics.primitive.Text')
        currAx.Children(jj).FontSize = base_font_size;
    end
end



end

