function [ax1] = plot_UBC_par_ratio_scatter(curr_par,all_burst_slow_HD,f1,ax_pos)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
%%
if nargin <3
    f1 = figure( 'Position', [822.2364 320 295.7636 229.9455], 'Color','w');
end

if nargin < 4
    ax_pos = [0.2106 0.1471 0.6944 0.7779];
end

plot_n = 1;
if plot_n > 1
    all_colors = bbpr(plot_n);
else
    all_colors = [0 0 0];
end
ax1 = axes(f1,'Position',ax_pos);
hold on
for ii = 1:plot_n
ratio_curr_parr_x_20 = curr_par{ii}./curr_par{5};
scatter(all_burst_slow_HD{5},ratio_curr_parr_x_20,'MarkerEdgeColor',all_colors(ii,:),...
    'MarkerFaceColor','w')
set(gca,'XScale','log')
% set(gca,'YScale','log')
end
hold off
xlabel('Half-width (s)')
standardAx(ax1);

end