% f_burst = figure('Position', [488 1.8000 680.3150 857.9636],...
%     'Color','w');

left_margin = 0.08;
bottom_margin = 0.08;
base_width = 0.14;
bar_width = 0.07;
base_space = 0.09;

graph_height = 0.14;

pos_ax = [left_margin,  bottom_margin, base_width, graph_height];
% pos_ax = [0.07 0.07 base_width 0.2064];

[ax_burst_par1] = UBC_par_line_plot(...
    ONidx,OFFidx,all_burst_n_spikes,[0 1 0],-Inf,f_burst,pos_ax);
ylabel("Response spikes (n)")
ax_burst_par1.YTick = 10.^(-4:4);
ax_burst_par1.YTickLabel = string(10.^(-4:4));
ax_burst_par1.YRuler.MinorTickValues = 10.^(-4:4);

pos_ax(1) = sum(pos_ax([1,3]))+base_space;
[ax_burst_par2] = UBC_par_line_plot(...
    ONidx,OFFidx,all_burst_slow_amp,[0 1 0],1,f_burst,pos_ax);
ylabel('Peak response (\Deltaspk/s)')
ax_burst_par2.YTick = 10.^(-4:4);
ax_burst_par2.YTickLabel = string(10.^(-4:4));
ax_burst_par2.YTickLabel(5) = {'<1'};
ax_burst_par2.YRuler.MinorTickValues = 10.^(-4:4);

pos_ax(1) = sum(pos_ax([1,3]))+base_space;
[ax_burst_par3] = UBC_par_line_plot(...
    ONidx,OFFidx,all_burst_slow_HD,[0 1 0],-Inf,f_burst,pos_ax);
ylabel('Half-width (s)')
ax_burst_par3.YTick = 10.^(-4:4);
ax_burst_par3.YTickLabel = string(10.^(-4:4));
ax_burst_par3.YRuler.MinorTickValues = 10.^(-4:4);
ax_burst_par3.YLim(2) = 10;

pos_ax(1) = sum(pos_ax([1,3]))+base_space;
pos_ax(3) = base_width + bar_width;
[ax_burst_par4] = UBC_par_line_plot(...
    ONidx,OFFidx,all_burst_pause,[0 1 1],-Inf,f_burst,pos_ax);
ylabel('Pause (s)')
ax_burst_par4.YTick = 10.^(-4:4);
ax_burst_par4.YTickLabel = string(10.^(-4:4));
ax_burst_par4.YRuler.MinorTickValues = 10.^(-4:4);
ax_burst_par4.YLim(1) = 0.001;
