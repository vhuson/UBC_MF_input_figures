function marker_array = set_xlabel_symbols(curr_ax,opts)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
base_opts = struct();
base_opts.xtick_symbols = repmat({'o'},1,numel(curr_ax.XTickLabels));
base_opts.markeredgecolor = repmat({[0 0 0]},1,numel(curr_ax.XTickLabels));
base_opts.markerfacecolor = base_opts.markeredgecolor;
base_opts.marker_sizes = repmat(6,1,numel(curr_ax.XTickLabels));
base_opts.offset = 0.1;

if nargin < 2
    opts = base_opts;
else
    opts = merge_structs(base_opts,opts);
end

% Make new axes
new_ax = axes('Position',curr_ax.Position);
new_ax.Position(2) = curr_ax.Position(2) - curr_ax.Position(4)*opts.offset;
new_ax.Position(4) = curr_ax.Position(4)*(1+opts.offset);

hold(new_ax,'on')
marker_array = {};
for ii = 1:numel(curr_ax.XTickLabels)
    curr_x = curr_ax.XTick(ii);
    
    marker_array{ii} = plot(curr_x,0,...
                opts.xtick_symbols{ii},...
                'MarkerEdgeColor',opts.markeredgecolor{ii},'MarkerFaceColor',opts.markerfacecolor{ii},...
                'MarkerSize',opts.marker_sizes(ii));
    curr_ax.XTickLabel(ii) = {''};

end
hold(new_ax,'off')
ylim([0 1])
xlim(curr_ax.XLim);
new_ax.Visible = 'off';
