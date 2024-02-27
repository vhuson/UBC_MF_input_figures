% f_train = figure('Position', [488 1.8000 680.3150 857.9636],...
%     'Color','w');


%Set axis position
pos_bottom = 0.06;
pos_height = 0.6155;
pos_left = 0.1;
full_width = 0.7864;
base_space = 0.01;


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
lim_x = [0 40];

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




%setup axes and plot
ax_sp_hm{ax_idx} = axes(f_train,'Position',pos_ax);

makeUBCHeatmap(ax_sp_hm{ax_idx}, norm_traces, Fs, opts);
    


% cellfun(@(x) move_tick_labels(x,2),ax_sp_hm);