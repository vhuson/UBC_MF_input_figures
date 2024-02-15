function [ax_base] = plot_burst_par_heatmap(...
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

% curr_min = min(min(curr_cdata));
% curr_max = max(max(curr_cdata));
% 
% map_res = 1000;
% map_step = max(abs([curr_max,curr_min])) / map_res;
% 
% min_steps = ceil(abs(curr_min / map_step));
% max_steps = ceil(abs(curr_max / map_step));
% 
% curr_map = rwb(map_res*2+1);
% adj_map = [curr_map(1001-max_steps:1000,:);
%             curr_map(1001:1001+min_steps,:)];


colormap("gray");

ax_base = axes(f1,'Position',ax_position);
% hm = heatmap(curr_cdata,'Colormap',flipud(adj_map));
hm = imagesc(curr_cdata);
cb = colorbar;

cb.Label.String = 'Response spikes (n)';

standard_colorbar(cb,ax_base)

ylabel('Sorted cell (#)')
xticklabels({'Initial','1 Hz','2.5 Hz', '5 Hz'})
if nargin == 3
    standardFig(f1);
else
    standardAx(ax_base);
end
end