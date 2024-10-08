% f_train = figure('Position', [488 1.8000 680.3150 857.9636],...
%     'Color','w');


%Set axis position
pos_bottom = 0.365;
pos_top = 0.55;
pos_height = pos_top - pos_bottom;
pos_left = 0.1;
full_width = 0.08;
base_space = 0.01;



%Gather data
curr_traces = all_mean_bursts{5}(train_fltr_5,:);

curr__train_traces = all_mean_trains_5(train_fltr_5);
curr__train_traces = cellfun(@(x) {medfilt1(x,Fs*0.02)},curr__train_traces);
%Truncate longer traces
curr__train_traces = cellfun(@(x) {x(1:800001)},curr__train_traces);
curr__train_traces = vertcat(curr__train_traces{:});
select_cells = fltr_ONidx_t5;

%Normalize per cell
% norm_on = max(curr__train_traces,[],2);
norm_on = max(medfilt1(curr_traces,Fs*0.16,[],2),[],2);
norm_on(norm_on < 1) = 1;
% norm_on = all_Amp;

%Don't normalize
% norm_on = max([all_full_traces{:}],[],'all')*0.3;


%Different normalization for OFFs??
norm_off = all_baseline(select_cells);
% norm_OFFidx =OFFidx(end-1:end);
norm_OFFidx = [];




%Set plot options
%Xlim
lim_x = [0 2.5];

% all_titles = {'1 Hz', '2.5 Hz', '5 Hz'};
opts = struct();
opts.XLim = lim_x;
opts.XLabel = '';
opts.XTick = [0.5:2:3.5];
opts.XTickLabel = arrayfun(@num2str,opts.XTick-0.5,'UniformOutput',false);


% Plotting routing
ax_sp_burst_hm = {};
ax_idx = 1;


%Set axis position
pos_ax = [pos_left   pos_bottom    full_width    pos_height];




% Normalized data for plotting
[norm_traces] = norm_UBC(curr_traces,norm_on,norm_off,norm_OFFidx);
norm_traces = norm_traces(select_cells,:);


%setup axes and plot
ax_sp_burst_hm{ax_idx} = axes(f_train,'Position',pos_ax);
% opts.colorbar = true;
[~,cb_thm] = makeUBCHeatmap(ax_sp_burst_hm{ax_idx}, norm_traces, Fs, opts);
% cb_thm.Position(1) = 0.215;

%add stim onset line
hold(ax_sp_burst_hm{ax_idx},'on')
line(ax_sp_burst_hm{ax_idx},repmat(ax_sp_burst_hm{ax_idx}.XTick(1),1,2),...
    ax_sp_burst_hm{ax_idx}.YLim,'Color',[1 0 0],'LineWidth',1,'LineStyle',':')
hold(ax_sp_burst_hm{ax_idx},'off')

for ii = 1
    if exist("typ_cell_num","var")
        [hm_ax] = heatmap_markers(ax_sp_burst_hm{ax_idx,1},typ_cell_num);
    else
        [hm_ax] = heatmap_markers(ax_sp_burst_hm{ax_idx,1},[4     6    12    15    18    22]);
    end
end

hm_ax.YLabel.Units = "pixels";
hm_ax.YLabel.Position(1) = -17;
% cellfun(@(x) move_tick_labels(x,2),ax_sp_hm);