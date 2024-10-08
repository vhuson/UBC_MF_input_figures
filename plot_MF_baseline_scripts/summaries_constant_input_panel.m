% f_base = figure('Position', [488 1.8000 680.3150 857.9636],...
%     'Color','w');


left_edge = 0.08;
bottom_edge = 0.055;
total_width = 0.8610;
panel_gap = 0.09;
graph_height = 0.14;

num_panels = 4;
base_width = (total_width - (panel_gap*(num_panels-1))) / num_panels;



ax_base_par = {};

%Use peak response as point 0
use_peak = false;

%add baseline firing = 1, don't add = 2;
point_0 = 1;

input_n = [1 2 3 4];
XTickLabel = {'0' '1' '2.5' '5'};


% UBC line plot for steady state n_spikes including baseline (0 Hz)
p_idx = 2;

pos_ax = [left_margin+(base_width+panel_gap)*(p_idx-1),...
        bottom_edge, base_width, graph_height];


% Get n_spikes data;
all_baseline_n_spikes = all_baseline .* (min_trace_leng/Fs);
base_n_spikes_ss_uncorr = cellfun(@(x) {x+all_baseline_n_spikes},base_n_spikes_ss);

base_n_spikes_ss_uncorr = [{all_baseline_n_spikes} base_n_spikes_ss_uncorr];

if use_peak
    base_n_spikes_peak_uncorr = {base_n_spikes_peak{1} + all_baseline_n_spikes};
    base_n_spikes_ss_uncorr(1) = base_n_spikes_peak_uncorr;
    XTickLabel{1} = 'First';
end


opts = struct();
opts.input_n = input_n(point_0:end);
% opts.input_n = [0 1 2.5 5];
opts.YScale = 'log';
% opts.XScale = 'log';
opts.XLabel = "Constant input (Hz)";
opts.YLabel = "Response spikes (n)";
opts.XTickLabel = XTickLabel(point_0:end);
opts.min_val = 0.1;



[ax_base_par{p_idx}] = UBC_par_line_plot2(...
    ONidx,[],base_n_spikes_ss_uncorr(point_0:end),f_base,pos_ax,opts);

%Offset XLim a little bit
ax_base_par{p_idx}.XLim(1) = ax_base_par{p_idx}.XLim(1)...
    - diff(ax_base_par{p_idx}.XLim) * 0.05;

fix_powered_ylabels(ax_base_par{p_idx})


p_idx = 1;

pos_ax = [left_margin+(base_width+panel_gap)*(p_idx-1),...
        bottom_edge, base_width, graph_height];

% Get peak data
base_peak_ss_uncorr = cellfun(@(x) {x+all_baseline},base_amplitude_ss);

base_peak_ss_uncorr = [{all_baseline} base_peak_ss_uncorr];

if use_peak
    base_peak_peak_uncorr = {base_amplitude_peak{1} + all_baseline};
    base_peak_ss_uncorr(1) = base_peak_peak_uncorr;
end

opts.YLabel = "Peak firing rate (spk/s)";
[ax_base_par{p_idx}] = UBC_par_line_plot2(...
    ONidx,[],base_peak_ss_uncorr(point_0:end),f_base,pos_ax,opts);

%Offset XLim a little bit
ax_base_par{p_idx}.XLim(1) = ax_base_par{p_idx}.XLim(1)...
    - diff(ax_base_par{p_idx}.XLim) * 0.05;

fix_powered_ylabels(ax_base_par{p_idx})


p_idx = 3;

pos_ax = [left_margin+(base_width+panel_gap)*(p_idx-1),...
        bottom_edge, base_width, graph_height];

% Get steady state data
base_async_ss_uncorr = cellfun(@(x) {x+all_baseline},base_async_ss);
base_async_ss_uncorr = [{all_baseline} base_async_ss_uncorr];

if use_peak
    base_async_peak_uncorr = {base_async_peak{1} + all_baseline};
    base_async_ss_uncorr(1) = base_async_peak_uncorr;
end

opts.YLabel = "Steady state (spk/s)";
[ax_base_par{p_idx}] = UBC_par_line_plot2(...
    ONidx,[],base_async_ss_uncorr(point_0:end),f_base,pos_ax,opts);

%Offset XLim a little bit
ax_base_par{p_idx}.XLim(1) = ax_base_par{p_idx}.XLim(1)...
    - diff(ax_base_par{p_idx}.XLim) * 0.05;

fix_powered_ylabels(ax_base_par{p_idx})



p_idx = 4;

pos_ax = [left_margin+(base_width+panel_gap)*(p_idx-1),...
        bottom_edge, base_width, graph_height];

% Get ratio data
base_ratio_ss_uncorr = cellfun(@(x,y) {x./y},base_async_ss_uncorr,base_peak_ss_uncorr);

point_0 = 2;

if use_peak
    point_0 = 1;
end

opts_ratio = opts;
opts_ratio.YLabel = "Steady state (ratio)";
opts_ratio.input_n = input_n(point_0:end);
opts_ratio.XTickLabel = XTickLabel(point_0:end);
opts_ratio.min_val = 0.01;

[ax_base_par{p_idx}] = UBC_par_line_plot2(...
    ONidx,[],base_ratio_ss_uncorr(point_0:end),f_base,pos_ax,opts_ratio);

%Offset XLim a little bit
ax_base_par{p_idx}.XLim(1) = ax_base_par{p_idx}.XLim(1)...
    - diff(ax_base_par{p_idx}.XLim) * 0.05;


fix_powered_ylabels(ax_base_par{p_idx})

for ii =1:numel(ax_base_par)
    ax_base_par{ii}.XTickLabelRotation = 0;
end