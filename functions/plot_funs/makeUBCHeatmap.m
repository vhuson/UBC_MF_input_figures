function [ax] = makeUBCHeatmap(ax, currTraces, Fs, opts)
%MAKEUBCHEATMAP Takes in a matrix of traces and plots a heatmap UBC style
%   Detailed explanation goes here
base_opts.XLim = [0 size(currTraces,2)/Fs];
base_opts.XTick = false;
base_opts.XTickLabel = false;
base_opts.YTick = false;
base_opts.YLabel = 'Cell #';
base_opts.XLabel = 'Time (s)';
base_opts.XTickLabelRotation = 0;
base_opts.colormap = "gray";

if nargin < 4 
    opts = base_opts;
else
    opts = merge_structs(base_opts,opts);
end

limX = opts.XLim;
x_tick = opts.XTick;
x_tick_labels = opts.XTickLabel;

%Check for ticks and if not autmatically decide
if islogical(x_tick)
    tick_diff = min([ceil(diff(limX)/5), 5]);
    x_tick = 0:tick_diff:limX(end);
end

%Same but for xtick labels
if islogical(x_tick_labels)
    x_tick_labels = arrayfun(@num2str,x_tick,'UniformOutput',false);
end




imagesc(currTraces);
% caxis([0 max(mAmp)+mean(mBaseline)])
caxis([0 1.2])
xlabel(opts.XLabel)

if ~islogical(opts.YTick)
    yticks(opts.YTick)
end

ylabel(opts.YLabel)
xlim(Fs*limX)


xticks(Fs*x_tick)
xticklabels(x_tick_labels)

% yticks([1 numel(ONidx)-numel(OFFidx) numel(ONidx)]);
set(ax,'TickDir','out','FontName','Arial','FontSize',8.0,'LineWidth',1,...
    'XTickLabelRotation',opts.XTickLabelRotation)
box off
standardAx(ax);
% title('Firing rate')
colormap(ax,opts.colormap);
end

