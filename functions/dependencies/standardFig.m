function [currFig] = standardFig(currFig,opts)
%Apply some standard properties to a figure;
base_opts.FontSize = 12;

if nargin < 2
    opts = base_opts;
else
    opts = merge_structs(base_opts,opts);
end

if nargin == 0
    currFig = gcf;
end
set(currFig,'Color','w')

for ii = 1:numel(currFig.Children)
    if isa(currFig.Children(ii),'matlab.graphics.axis.Axes')
        currAx = currFig.Children(ii);
        standardAx(currAx,opts);
    end
    if isa(currFig.Children(ii),...
            'matlab.graphics.illustration.ColorBar')
        currBar = currFig.Children(ii);

       standardBar(currBar,opts);
    end

end

end

