%% Summaries
f1 = figure('Color','w','Position',[257.5818 320 1.0909e+03 299.7636]);

base_width = 0.18;
base_space = 0.1;
bar_width = 0.05;



pos_ax = [0.1051 0.2227 base_width 0.7286];

[ax_base_n] = UBC_par_line_plot(...
    ONidx,[],base_n_spikes_ss,[0 0 0],-Inf,f1,pos_ax,...
    [1 2 3]);
xlim([0.9 3.1])
ax_base_n.XTickLabels = [1 2.5 5];
ylabel('End of train\newlineResponse spikes (n)')
xlabel('Input rate (Hz)')

pos_ax(1) = pos_ax(1)+base_width+base_space;
[ax_base_p] = UBC_par_line_plot(...
    ONidx,OFFidx,base_amplitude_ss,[0 0 0],-Inf,f1,pos_ax,...
    [1 2 3]);
xlim([0.9 3.1])
ax_base_p.XTickLabels = [1 2.5 5];
ylabel('End of train\newlinePeak (\Deltaspk/s)')
xlabel('Input rate (Hz)')
% [ax_base] = plot_baseline_spike_heatmap(...
%     ONidx,base_n_spikes_ss,base_n_spikes_peak,f1,pos_ax);


pos_ax(1) = pos_ax(1)+base_width+base_space;
pos_ax(3) = base_width+bar_width;
[ax_base_p] = UBC_par_line_plot(...
    ONidx,OFFidx,base_ratio_ss,[0 0 1],-0,f1,pos_ax,...
    [1 2 3]);
xlim([0.9 3.1])
ax_base_p.XTickLabels = [1 2.5 5];
ylabel('End of train\newlineSteady state / Peak')
xlabel('Input rate (Hz)')


% save_figure_larger(f1,4);