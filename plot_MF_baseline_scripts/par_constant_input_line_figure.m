%% UBC line plot for steady state n_spikes including baseline (0 Hz)


all_baseline_n_spikes = all_baseline .* (min_trace_leng/Fs);
base_n_spikes_ss_uncorr = cellfun(@(x) {x+all_baseline_n_spikes},base_n_spikes_ss);

base_n_spikes_ss_uncorr = [{all_baseline_n_spikes} base_n_spikes_ss_uncorr];



f_base = figure('Position', [378.8909 266.3091 936.4364 308.0727],...
    'Color','w');




left_margin = 0.08;
bottom_margin = 0.2;
base_width = 0.21;
bar_width = 0.07;
base_space = 0.09;

graph_height = 0.6;
ax_base_par = {};

p_idx = 1;

pos_ax = [left_margin+(base_width+base_space)*(p_idx-1),...
        bottom_margin, base_width, graph_height];


opts = struct();
opts.input_n = [1 2 3 4];
% opts.input_n = [0 1 2.5 5];
opts.YScale = 'log';
% opts.XScale = 'log';
opts.XLabel = "Constant input (Hz)";
opts.YLabel = "Response spikes (n)";
opts.XTickLabel = {'0' '1' '2.5' '5'};
opts.min_val = 0.1;

[ax_base_par{1}] = UBC_par_line_plot2(...
    ONidx,[],base_n_spikes_ss_uncorr,f_base,pos_ax,opts);
