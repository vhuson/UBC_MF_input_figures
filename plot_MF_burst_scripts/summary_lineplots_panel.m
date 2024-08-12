% f_burst = figure('Position', [488 1.8000 680.3150 857.9636],...
%     'Color','w');

num_cols = 4;

left_margin = 0.08;
bottom_margin = 0.08;
total_width = 0.8300;
base_space = 0.09;
extra_space = 0.1;

base_width = (total_width-base_space*(num_cols-1)-extra_space) / num_cols;

all_left_edges = (base_width+base_space).*(0:num_cols-1) + left_margin;
all_left_edges(2:end) = all_left_edges(2:end)+extra_space;


% base_width = 0.1515;
% bar_width = 0.07;
% base_space = 0.1877;

graph_height = 0.13;
ax_burst_par = {};

summary_off = OFFidx;
% summary_off = [];


%Panel 1
p_idx = 1;
pos_ax = [all_left_edges(1),  bottom_margin, base_width, graph_height];
% pos_ax = [0.07 0.07 base_width 0.2064];
[ax_burst_par{p_idx}] = UBC_par_line_plot(...
    ONidx,summary_off,all_burst_slow_amp,[0 1 0],1,f_burst,pos_ax);
ylabel('Peak (\Deltaspk/s)')
fix_powered_ylabels(ax_burst_par{p_idx})
ax_burst_par{p_idx}.XRuler.MinorTick = 'off';


%Panel 2
p_idx = 2;
pos_ax = [all_left_edges(3),  bottom_margin, base_width, graph_height];
[ax_burst_par{p_idx}] = UBC_par_line_plot(...
    ONidx,summary_off,all_burst_n_spikes,[0 1 0],0.03,f_burst,pos_ax);
ylabel("\DeltaSpikes (n)")
fix_powered_ylabels(ax_burst_par{p_idx})
ax_burst_par{p_idx}.XRuler.MinorTick = 'off';


%Panel 3
p_idx = 3;
pos_ax = [all_left_edges(4),  bottom_margin, base_width, graph_height];
[ax_burst_par{p_idx}] = UBC_par_line_plot(...
    ONidx,summary_off,all_burst_slow_HD,[0 1 0],-Inf,f_burst,pos_ax);
ylabel('Half-width (s)')
ax_burst_par{p_idx}.YLim(2) = 10;
fix_powered_ylabels(ax_burst_par{p_idx})
ax_burst_par{p_idx}.XRuler.MinorTick = 'off';

%Panel 4
% p_idx = 4;
% pos_ax(1) = sum(pos_ax([1,3]))+base_space;
% pos_ax(3) = base_width; % + bar_width;
% [ax_burst_par{p_idx}, cb1] = UBC_par_line_plot(...
%     ONidx,[],all_burst_pause,[0 1 1],0.01,f_burst,pos_ax);
% % cb1.Position = [0.9313 0.1078 0.0166 0.0713];

%Adjust color bar
% cb1.Position(1) = 0.2632; %Left edge
% cb1.Units = 'pixels';
% cb1.Position(3:4) = [8.7326 59.5984];
% cb1.Units = 'normalized';
% cb1.Position(2) = pos_ax(2)+pos_ax(4)/2-cb1.Position(4)/2; 
% cb1.Limits(1) = numel(OFFidx)/numel(ONidx);
% cb1.Ticks(1) = cb1.Limits(1);
% cb1.TickLabels{1} = num2str(numel(ONidx)-numel(OFFidx));
% ylabel('Pause (s)')
% % ax_burst_par{p_idx}.YLim(1) = 0.001;
% fix_powered_ylabels(ax_burst_par{p_idx})

% add legend line color bar
seed_colors = [1 0 0;
                1 0.5 0.2;
                0.4 1 0.4;
                0.2 0.5 1;
                0 0 1];

legend_colors = seed_map(seed_colors,numel(ONidx));
legend_colors = legend_colors(1:(numel(ONidx)-numel(OFFidx)),:);

legend_pos = [0.2220 0.1033 0.0128 0.0695];

legend_opts = struct();
legend_opts.n_shown = 5;
legend_opts.n_pos =[1 15 30 45 61];
[cl_ax] = colorline_legend(legend_colors,legend_pos,f_burst,legend_opts);


for ii =1:numel(ax_burst_par)
    ax_burst_par{ii}.XTickLabelRotation = 0;
end


%Fix ylabels
ax_burst_par{1}.YLabel.Units = "pixels";
ax_burst_par{1}.YLabel.Position(1:2) = [-29.5, 52.4];

ax_burst_par{2}.YLabel.Units = "pixels";
ax_burst_par{2}.YLabel.Position(1) = -34;

ax_burst_par{3}.YLabel.Units = "pixels";
ax_burst_par{3}.YLabel.Position(1) = -34;
