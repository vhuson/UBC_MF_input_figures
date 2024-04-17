% f_train = figure('Position', [488 1.8000 680.3150 857.9636],...
%     'Color','w');

y_labels_on = true;

%Set axis position
pos_bottom = 0.08;
pos_top = 0.34;
pos_height = pos_top - pos_bottom;
% pos_left = 0.1;
% full_width = 0.55;
pos_left = 0.13;
full_width = 0.8;
base_space = 0.01;

% pos_left2 = 0.6722;
% base_width2 = 0.2921;
% pos_left2 = 0.7466;
% base_width2 = 0.2177;

select_cells = ONidx_invivo;

%Gather data
curr_traces = all_mean_IVSP;
curr_traces = cellfun(@(x) {medfilt1(x,Fs*0.04)},curr_traces);
%Truncate longer traces
curr_traces = cellfun(@(x) {x(1:600000)},curr_traces);
curr_traces = [curr_traces{:}]';


%Normalize per cell
norm_on = max(curr_traces,[],2);
norm_on(norm_on < 1) = 1;
% norm_on = all_Amp;

%Don't normalize
% norm_on = max([all_full_traces{:}],[],'all')*0.3;


%Different normalization for OFFs??
norm_off = all_baseline_invivo(select_cells);
% norm_OFFidx =OFFidx(end-1:end);
norm_OFFidx = [];




%Set plot options
%Xlim
lim_x = [0 30];

% all_titles = {'1 Hz', '2.5 Hz', '5 Hz'};
opts = struct();
opts.XLim = lim_x;
opts.XLabel = 'Time (s)';
opts.XTick = [0:10:30];


% Plotting routing
ax_iv_hm = {};
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
ax_iv_hm{ax_idx} = axes(f_mf_burst,'Position',pos_ax);

makeUBCHeatmap(ax_iv_hm{ax_idx}, norm_traces, Fs, opts);


heatmap_markers(ax_iv_hm{ax_idx},find(ismember(ONidx_invivo,[10, 1, 2])));

%plot zoom in
%{
opts.XLim = [27.5 31];
opts.XTick = [28:31];
opts.YTick = [];
opts.YLabel = '';
opts.XLabel = '';
%setup axes and plot
pos_ax2 = [pos_left2   pos_bottom    base_width2    pos_height];
ax_iv_hm{2} = axes(f_train,'Position',pos_ax2);

makeUBCHeatmap(ax_iv_hm{2}, norm_traces, Fs, opts);

%add stim onset line
hold(ax_iv_hm{2},'on')

line(ax_iv_hm{2},repmat(train5_step_times(7)*Fs,1,2),...
    ax_iv_hm{2}.YLim,'Color',[1 0 0],'LineWidth',0.5,'LineStyle',':')
line(ax_iv_hm{2},repmat((train5_step_times(7)+1)*Fs,1,2),...
    ax_iv_hm{2}.YLim,'Color',[1 0 0],'LineWidth',0.5,'LineStyle',':')
hold(ax_iv_hm{2},'off')    


% cellfun(@(x) move_tick_labels(x,2),ax_sp_hm);

%}