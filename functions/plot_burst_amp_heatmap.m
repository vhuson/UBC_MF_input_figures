function [ax_base] = plot_burst_log_par_heatmap(...
    ONidx,burst_par,f1,ax_position)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
if nargin < 3
    f1 = figure('Position', [488 1.8000 406.6000 780.8000]);
end
if nargin < 4
    ax_position = [0.1300 0.1100 0.7750 0.8150];
end


curr_cdata = [burst_par{:}];
curr_cdata = curr_cdata(ONidx,:);
curr_cdata = log(curr_cdata);

colormap("gray");

ax_base = axes(f1,'Position',ax_position);
% hm = heatmap(curr_cdata,'Colormap',flipud(adj_map));
hm = imagesc(curr_cdata);
cb = colorbar;

title('Log amplitude');

standard_colorbar(cb,ax_base)

ylabel('Sorted cell (#)')
xticklabels({'1×','2×','5×', '10×', '20×'})
if nargin == 3
    standardFig(f1);
else
    standardAx(ax_base);
end
end