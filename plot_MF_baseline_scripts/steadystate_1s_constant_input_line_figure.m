f_line_plot = figure;
pos_ax = [0.15 0.15 0.7 0.7];

point_0 = 1;
input_n = [1 2 3 4];
XTickLabel = {'0' '1' '2.5' '5'};

opts = struct();
opts.input_n = input_n(point_0:end);
% opts.input_n = [0 1 2.5 5];
opts.YScale = 'log';
% opts.XScale = 'log';
opts.XLabel = "Constant input (Hz)";
opts.YLabel = "Response spikes (n)";
opts.XTickLabel = XTickLabel(point_0:end);
opts.min_val = 0.1;




base_async_ss_uncorr = base_async_end1s;
base_async_ss_uncorr = [{all_baseline} base_async_ss_uncorr];

opts.YLabel = "Steady state (spk/s)";
[ax_base_line] = UBC_par_line_plot2(...
    ONidx,[],base_async_ss_uncorr(point_0:end),f_line_plot,pos_ax,opts);


%Offset XLim a little bit
ax_base_line.XLim(1) = ax_base_line.XLim(1)...
    - diff(ax_base_line.XLim) * 0.05;

fix_powered_ylabels(ax_base_line)

standardFig(f_line_plot);