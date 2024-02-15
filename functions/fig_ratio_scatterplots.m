
%%
fig_ratio = figure('Color','w','Position', [749.8000 94.3818 545.4545 404.9455]);


ax_height = 0.3347;
ax_width = 0.3412;

ax_pos = [0.1300 0.5838 ax_height ax_width];

axr1 = plot_UBC_par_ratio_scatter(all_burst_n_spikes,all_burst_slow_HD,fig_ratio,ax_pos);
ylabel('#Spikes ratio')
xlabel('')

ax_pos(1) = 0.5703;
axr2 = plot_UBC_par_ratio_scatter(all_burst_slow_amp,all_burst_slow_HD,fig_ratio,ax_pos);
ylabel('Peak ratio')
xlabel('')

ax_pos(1:2) = [0.1300 0.1400];
axr3 = plot_UBC_par_ratio_scatter(all_burst_slow_HD,all_burst_slow_HD,fig_ratio,ax_pos);
ylabel('Half-width ratio')

ax_pos(1) = 0.5703;
axr4 = plot_UBC_par_ratio_scatter(all_burst_pause,all_burst_slow_HD,fig_ratio,ax_pos);
ylabel('Pause ratio')

% linkaxes([axr1,axr2,axr3,axr4],'y')

all_x_tick = [0.1 1 10];
arrayfun(@(x) set(x,'XTick',all_x_tick,'XLim',[0.1 10]),[axr1,axr2,axr3,axr4])
