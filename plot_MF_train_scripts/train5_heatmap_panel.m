% f_train = figure('Position', [488 1.8000 680.3150 857.9636],...
%     'Color','w');

y_labels_on = false;

%Set axis position
pos_bottom = 0.38;
pos_top = 0.565;
pos_height = pos_top - pos_bottom;
% pos_left = 0.1;
% full_width = 0.55;
pos_left = 0.1966;
full_width = 0.5334;
base_space = 0.01;

% pos_left2 = 0.6722;
% base_width2 = 0.2921;
pos_left2 = 0.7466;
base_width2 = 0.2177;

%Gather data
curr_traces = all_mean_trains_5(train_fltr_5);
curr_traces = cellfun(@(x) {medfilt1(x,Fs*0.02)},curr_traces);
curr_traces = vertcat(curr_traces{:});
select_cells = fltr_ONidx_t5;

%Normalize per cell
norm_on = max(curr_traces,[],2);
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
lim_x = [0 36];

% all_titles = {'1 Hz', '2.5 Hz', '5 Hz'};
opts = struct();
opts.XLim = lim_x;
opts.XLabel = 'Time (s)';
opts.XTick = [0:10:40];


% Plotting routing
ax_sp_hm = {};
ax_idx = 1;


%Set axis position
pos_ax = [pos_left   pos_bottom    full_width    pos_height];




% Normalized data for plotting
[norm_traces] = norm_UBC(curr_traces,norm_on,norm_off,norm_OFFidx);
norm_traces = norm_traces(select_cells,:);


if ~y_labels_on
    opts.YTick = [];
    opts.YLabel = '';
end

%setup axes and plot
ax_sp_hm{ax_idx} = axes(f_train,'Position',pos_ax);

makeUBCHeatmap(ax_sp_hm{ax_idx}, norm_traces, Fs, opts);

%add stim onset line
hold(ax_sp_hm{ax_idx},'on')
for curr_step_time = train5_step_times(2:8)
line(ax_sp_hm{ax_idx},repmat(curr_step_time*Fs,1,2),...
    ax_sp_hm{ax_idx}.YLim,'Color',[1 0.5 0],'LineWidth',0.5,'LineStyle',':')
end
hold(ax_sp_hm{ax_idx},'off')

%plot zoom in
opts.XLim = [27.5 31];
opts.XTick = [28:31];
opts.YTick = [];
opts.YLabel = '';
opts.XLabel = '';
%setup axes and plot
pos_ax2 = [pos_left2   pos_bottom    base_width2    pos_height];
ax_sp_hm{2} = axes(f_train,'Position',pos_ax2);

makeUBCHeatmap(ax_sp_hm{2}, norm_traces, Fs, opts);

%add stim onset line
hold(ax_sp_hm{2},'on')

line(ax_sp_hm{2},repmat(train5_step_times(7)*Fs,1,2),...
    ax_sp_hm{2}.YLim,'Color',[1 0.5 0],'LineWidth',0.5,'LineStyle',':')
hold(ax_sp_hm{2},'off')    


% cellfun(@(x) move_tick_labels(x,2),ax_sp_hm);