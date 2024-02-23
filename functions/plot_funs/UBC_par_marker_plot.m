function [curr_ax] = UBC_par_marker_plot(curr_par,curr_fig,pos_ax,opts)
%UNTITLED17 Summary of this function goes here
%   Detailed explanation goes here
%Make plot with different markers

base_opts.YScale = 'linear';
base_opts.XScale = 'linear';
base_opts.XLabel = 'Input spikes (n)';
base_opts.XTickLabel = false;
base_opts.YLabel = '';
base_opts.YTickLabel = false;
base_opts.YRulerVis = "on";
base_opts.input_n = [1, 2, 3, 4];
base_opts.XTick = base_opts.input_n;
base_opts.xtick_symbols = {"o","^","square","diamond"};
base_opts.marker_sizes = [6, 6, 7, 6];

base_opts.markeredgecolor = {'k' 'k' 'k' 'k'};

if nargin < 4
    opts = base_opts;
else
    opts = merge_structs(base_opts,opts);
end

xtick_symbols = opts.xtick_symbols;
marker_sizes = opts.marker_sizes;
markeredgecolor = opts.markeredgecolor;

curr_ax = axes(curr_fig,'Position',pos_ax);
hold(curr_ax,'on');
%Line
plot(opts.input_n,curr_par,'k','LineWidth',1);
%Markers
for idx = opts.input_n
    plot(opts.input_n(idx),curr_par(idx),...
        xtick_symbols{idx},...
        'MarkerEdgeColor',markeredgecolor{idx},'MarkerFaceColor','w',...
        'MarkerSize',marker_sizes(idx))
end
hold(curr_ax,'off');

set(curr_ax,'YScale',opts.YScale)
set(curr_ax,'XScale',opts.XScale)

curr_ax.XTick = opts.XTick;

xlabel(opts.XLabel)
ylabel(opts.YLabel)

curr_ax.YRuler.Visible = opts.YRulerVis;

if ~islogical(opts.XTickLabel)
    xticklabels(opts.XTickLabel);
end

if ~islogical(opts.YTickLabel)
    yticklabels(opts.YTickLabel);
end


end