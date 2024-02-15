function [currFig] = change_fontsize_fig(currFig,font_size)
%Apply some standard properties to a figure;


if nargin == 0
    currFig = gcf;
end

for ii = 1:numel(currFig.Children)
    if isa(currFig.Children(ii),'matlab.graphics.axis.Axes')
        currAx = currFig.Children(ii);
        change_fontsize(currAx,font_size);
    end
   
end

end

