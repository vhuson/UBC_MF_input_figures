% f_base = figure('Position', [488 1.8000 680.3150 857.9636],...
%     'Color','w');


left_edge = 0.7607;
bottom_edge = 0.2050;
total_width = 0.1629;
panel_gap = 0.02;
total_height = 0.355;

num_panels = 3;
base_width = total_width;
graph_height = (total_height - (panel_gap*(num_panels-1))) / num_panels;

all_left_edges = repmat(left_edge,1,num_panels);
all_bottom_edge = (graph_height + panel_gap) .* (0:(num_panels-1)) + bottom_edge;
all_bottom_edge = fliplr(all_bottom_edge);


ax_base_par = {};

%Use peak response as point 0
use_peak = false;

%add baseline firing = 1, don't add = 2;
point_0 = 2;

input_n = [1 2 3 4];
XTickLabel = {'0' '1' '2.5' '5'};


% UBC line plot for steady state n_spikes including baseline (0 Hz)
p_idx = 2;

pos_ax = [all_left_edges(p_idx), all_bottom_edge(p_idx), base_width, graph_height];


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
opts.XLabel = "";
opts.YLabel = "#Spikes";
opts.XTick = opts.input_n;
opts.XTickLabel = [];
opts.min_val = 0.1;



[ax_base_par{p_idx}] = UBC_par_line_plot2(...
    ONidx,[],base_n_spikes_ss_uncorr(point_0:end),f_base,pos_ax,opts);

%Offset lims a little bit
ax_base_par{p_idx}.XLim(1) = ax_base_par{p_idx}.XLim(1)...
    - diff(ax_base_par{p_idx}.XLim) * 0.05;
ax_base_par{p_idx}.YLim(1) = ax_base_par{p_idx}.YLim(1) * 0.85;

fix_powered_ylabels(ax_base_par{p_idx})



% Peak data

p_idx = 1;

pos_ax = [all_left_edges(p_idx), all_bottom_edge(p_idx), base_width, graph_height];


% Get peak data
base_peak_ss_uncorr = cellfun(@(x) {x+all_baseline},base_amplitude_ss);

base_peak_ss_uncorr = [{all_baseline} base_peak_ss_uncorr];

if use_peak
    base_peak_peak_uncorr = {base_amplitude_peak{1} + all_baseline};
    base_peak_ss_uncorr(1) = base_peak_peak_uncorr;
end

opts.YLabel = "Peak rate (spk/s)";
[ax_base_par{p_idx}] = UBC_par_line_plot2(...
    ONidx,[],base_peak_ss_uncorr(point_0:end),f_base,pos_ax,opts);

%Offset lims a little bit
ax_base_par{p_idx}.XLim(1) = ax_base_par{p_idx}.XLim(1)...
    - diff(ax_base_par{p_idx}.XLim) * 0.05;
ax_base_par{p_idx}.YLim(1) = ax_base_par{p_idx}.YLim(1) * 0.85;

fix_powered_ylabels(ax_base_par{p_idx})


% Steady state rate
% p_idx = 3;
% 
% pos_ax = [left_margin+(base_width+panel_gap)*(p_idx-1),...
%         bottom_edge, base_width, graph_height];
% 

% if use_peak
%     base_async_peak_uncorr = {base_async_peak{1} + all_baseline};
%     base_async_ss_uncorr(1) = base_async_peak_uncorr;
% end
% 
% opts.YLabel = "Steady state (spk/s)";
% [ax_base_par{p_idx}] = UBC_par_line_plot2(...
%     ONidx,[],base_async_ss_uncorr(point_0:end),f_base,pos_ax,opts);
% 
% %Offset XLim a little bit
% ax_base_par{p_idx}.XLim(1) = ax_base_par{p_idx}.XLim(1)...
%     - diff(ax_base_par{p_idx}.XLim) * 0.05;
% 
% fix_powered_ylabels(ax_base_par{p_idx})



% Steady state ratio

p_idx = 3;

pos_ax = [all_left_edges(p_idx), all_bottom_edge(p_idx), base_width, graph_height];

% % Get steady state data
base_async_ss_uncorr = cellfun(@(x) {x+all_baseline},base_async_ss);
base_async_ss_uncorr = [{all_baseline} base_async_ss_uncorr];

% Get ratio data
base_ratio_ss_uncorr = cellfun(@(x,y) {x./y},base_async_ss_uncorr,base_peak_ss_uncorr);

point_0 = 2;

if use_peak
    point_0 = 1;
end

opts_ratio = opts;
opts_ratio.YLabel = "Steady state (ratio)";
opts_ratio.XLabel = "Constant input (spk/s)";
opts_ratio.input_n = input_n(point_0:end);
opts_ratio.XTickLabel = XTickLabel(point_0:end);
opts_ratio.min_val = 0.01;
opts_ratio.bar = true;

[ax_base_par{p_idx},cb1] = UBC_par_line_plot2(...
    ONidx,[],base_ratio_ss_uncorr(point_0:end),f_base,pos_ax,opts_ratio);

%Adjust color bar
cb1.Position(1) = 0.9397; %Left edge
cb1.Units = 'pixels';
cb1.Position(3:4) = [8.7326 59.5984];
cb1.Units = 'normalized';
cb1.Position(2) = pos_ax(2)+pos_ax(4)/2-cb1.Position(4)/2; 

%Offset XLim a little bit
ax_base_par{p_idx}.XLim(1) = ax_base_par{p_idx}.XLim(1)...
    - diff(ax_base_par{p_idx}.XLim) * 0.05;


fix_powered_ylabels(ax_base_par{p_idx})

for ii =1:numel(ax_base_par)
    ax_base_par{ii}.XTickLabelRotation = 0;
end