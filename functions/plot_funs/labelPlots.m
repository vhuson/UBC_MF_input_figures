function [fig1,t_labels] = labelPlots(fig1,currLabels,opts)
%UNTITLED3 Summary of this function goes here
base_opts.FontSize = 12;

if nargin < 3
    opts = base_opts;
else
    opts = merge_structs(base_opts,opts);
end



%Get children
ChildAxes = arrayfun(@(x) isa(x,'matlab.graphics.axis.Axes'),fig1.Children);

if nargin == 1
    posLabels = {'a','b','c','d','e','f','g','h','i','j','k','l','m',...
        'n','o','p','q','r','s','t','u','v','w','x','y','z',...
        'a','b','c','d','e','f','g','h','i','j','k','l','m',...
        'n','o','p','q','r','s','t','u','v','w','x','y','z'};
    currLabels = posLabels(1:sum(ChildAxes));
end


ChildAxes_idx = flipud(find(ChildAxes));

if numel(currLabels)< numel(ChildAxes_idx)
    emptyLabels = cell(size(ChildAxes_idx));
    emptyLabels(1:numel(currLabels)) = currLabels;    
    currLabels = emptyLabels;
end

t_labels = {};
for ii = 1:numel(ChildAxes_idx)
    if ~isempty(currLabels{ii})
        currAx = fig1.Children(ChildAxes_idx(ii));
        
%         xCorr = currAx.XLim(1);
%         yCorr = currAx.YLim(2);
        
        hold(currAx,'on')
        
        t_labels{end+1} = text(currAx,0,0,currLabels{ii},...
            'HorizontalAlignment','left',...
            'VerticalAlignment','bottom',...
            'FontName','Arial','FontWeight','bold','FontSize',opts.FontSize);
        t_labels{end}.Units = 'normalized';
        t_labels{end}.Position = [0 1 0];
        t_labels{end}.Units = 'pixels';
        t_labels{end}.Position(1) = t_labels{end}.Position(1)-20;
        t_labels{end}.Position(2) = t_labels{end}.Position(2)+5;
        hold(currAx,'off')
    end
end

end

