% f_base = figure('Position', [488 1.8000 680.3150 857.9636],...
%     'Color','w');


pos_bottom = 0.1;
pos_height = 0.47;
pos_left = 0.07;
full_width = 0.560;
base_space = 0.01;


%Normalize per cell
norm_on = max([all_full_traces{:}],[],2);
norm_on(norm_on < 1) = 1;
% norm_on = all_Amp;

%Don't normalize
% norm_on = max([all_full_traces{:}],[],'all')*0.3;


%Different normalization for OFFs??
norm_off = all_baseline;
% norm_OFFidx =OFFidx(end-1:end);
norm_OFFidx = [];




%Xlim
all_XLim = {[0 10],[0 10],[0 10]};

avg_XLim = [0 0.2];


%Base width standardized to xlim
base_width = (full_width-base_space*(numel(all_XLim)-1))/sum(cellfun(@diff,all_XLim));

all_titles = {'1 Hz', '2.5 Hz', '5 Hz'};
pos_ax = [pos_left-base_width    pos_bottom    1*base_width   pos_height];


opts = struct();
% opts.XTick = 0:5:10;
% opts.XTickLabel = arrayfun(@num2str,opts.XTick,'UniformOutput',false);

ax_hm = {};
for ax_idx = 1:3
    curr_xlim = all_XLim{ax_idx};

    %Normalize individual?
    % norm_on =  max(all_mean_bursts{ax_idx},[],2);

    pos_ax = [sum(pos_ax([1,3]))+base_space   pos_bottom    diff(curr_xlim)*base_width    pos_height];


    ax_hm{ax_idx} = axes(f_base,'Position',pos_ax);

    % full traces
    [norm_traces] = norm_UBC(all_full_traces{ax_idx},norm_on,norm_off,norm_OFFidx);
    norm_traces = norm_traces(ONidx,:);

    % average traces
    [norm_avg_traces] = norm_UBC(mean_segments{ax_idx},norm_on,norm_off,norm_OFFidx);
    norm_avg_traces = norm_avg_traces(ONidx,:);

    opts.XLim = curr_xlim;
    opts.XLabel = '';
    opts.XTick = [0 5 10];
    if ax_idx == 2
        opts.XLabel = 'Time (s)';
    end
    makeUBCHeatmap(ax_hm{ax_idx}, norm_traces, Fs, opts);
    % ax_hm{ax_idx}.Title.String = all_titles{ax_idx};
    
    opts.YTick = [];
    opts.YLabel = '';
 
end

cellfun(@(x) move_tick_labels(x,2),ax_hm);