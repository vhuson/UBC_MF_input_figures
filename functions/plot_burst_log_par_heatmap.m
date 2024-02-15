function [ax_base] = plot_burst_log_par_heatmap(...
    ONidx,burst_par,f1,ax_position,norm_bolean)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
if nargin < 3
    f1 = figure('Position', [488 1.8000 406.6000 780.8000]);
end
if nargin < 4
    ax_position = [0.1300 0.1100 0.7750 0.8150];
end
if nargin <5
    norm_bolean = false;
end

curr_cdata = [burst_par{:}];
%Normalize
if norm_bolean
    curr_cdata = curr_cdata./max(curr_cdata,[],2);
end

curr_cdata = curr_cdata(ONidx,:);
curr_cdata(curr_cdata<0.05) = 0.05;
curr_cdata = log(curr_cdata)/log(10);



ax_base = axes(f1,'Position',ax_position);

% hm = heatmap(curr_cdata,'Colormap',flipud(adj_map));
hm = imagesc(curr_cdata);
colormap(ax_base,"gray");
cb = colorbar;

standard_colorbar(cb,ax_base)

log_marks = [0.01:0.01:0.1, 0.2:0.1:1, 2:1:10,...
    20:10:100, 200:100:1000];
cb.Ticks = log10(log_marks);
cb.TickLabels = 10.^cb.Ticks;
cb.TickLabels = cellstr(cb.TickLabels);
cb.TickLabels(mod(cb.Ticks,1) ~= 0) = {''};

% ylabel('Sorted cell (#)')
yticklabels({''});
xticklabels({'1×','2×','5×', '10×', '20×'})
if nargin == 3
    standardFig(f1);
else
    standardAx(ax_base);
end
end