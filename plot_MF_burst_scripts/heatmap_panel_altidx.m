

pos_bottom = 0.08;
pos_left = 0.07;
pos_height = 0.4425;
full_width = 0.790;


%Normalize per cell
% norm_on = max(all_mean_bursts{5},[],2);
norm_on = max(medfilt1(all_mean_bursts{5},Fs*0.16,[],2),[],2);
% norm_on = max([all_burst_fast_amp{5},all_burst_slow_amp{5}],[],2);
% norm_on = all_Amp;

%Don't normalize
% norm_on = max(max(all_mean_bursts{5},[],2));
% norm_on = max(all_burst_slow_amp{5});

%Different normalization for OFFs??
norm_off = all_baseline;
% norm_OFFidx =OFFidx(end-1:end);
norm_OFFidx = [];

%1x
ax_hm = {};
%Original xlims
% all_XLim = {[0.3 1.3],[0.15 2.15], [0 5], [0 7], [0 10]};

%Xlim till 4
% all_XLim = {[0.2 1.5],[0.2 1.7], [0 2.5], [0 3.5], [0 4.5]};

%Xlim till 2
all_XLim = {[0.2 1.5],[0.2 1.5], [0.2 1.5], [0.2 1.5], [0.2 2.5]};


%Base width standardized to xlim
base_width = full_width/sum(cellfun(@diff,all_XLim));

all_titles = {'1x', '2x 100 Hz', '5x 100 Hz', '10x 100 Hz', '20x 100 Hz'};
pos_ax = [pos_left-base_width    pos_bottom    1*base_width   pos_height];
opts = struct();
opts.XTick = 0.5:1:20.5;
opts.XTickLabel = arrayfun(@num2str,opts.XTick-0.5,'UniformOutput',false);

for ax_idx = 1:5
    curr_xlim = all_XLim{ax_idx};

    %Normalize individual?
    % norm_on =  max(all_mean_bursts{ax_idx},[],2);

    pos_ax = [sum(pos_ax([1,3]))+0.01   pos_bottom    diff(curr_xlim)*base_width    pos_height];


    ax_hm{ax_idx} = axes(f_burst,'Position',pos_ax);


    [norm_traces] = norm_UBC(all_mean_bursts{ax_idx},norm_on,norm_off,norm_OFFidx);
    norm_traces = norm_traces(ONidx,:);

    opts.XLim = curr_xlim;
    opts.XLabel = '';
    if ax_idx == 2
        opts.YTick = [];
        opts.YLabel = '';
    end
    if ax_idx == 3
        opts.XLabel = 'Time (s)';
    end
    makeUBCHeatmap(ax_hm{ax_idx}, norm_traces, Fs, opts);
    % ax_hm{ax_idx}.Title.String = all_titles{ax_idx};
    ax_hm{1}.YLabel.String = 'Cell # (sorted by width)';
    hold(ax_hm{ax_idx},'on')
    line(ax_hm{ax_idx},repmat(ax_hm{ax_idx}.XTick(1),1,2),...
        ax_hm{ax_idx}.YLim,'Color',[1 0.0 0],'LineWidth',1,'LineStyle',':')
    hold(ax_hm{ax_idx},'off')


end



if exist("typ_cell_num","var")
    [hm_ax] = heatmap_markers(ax_hm{1},typ_cell_num);
else
    [hm_ax] = heatmap_markers(ax_hm{1},[19 37 51]);
end


%Fix label position
ax_hm{1}.YLabel.Units = "pixels";
ax_hm{1}.YLabel.Position(1) = -15;

ax_hm{3}.XLabel.Units = "pixels";
ax_hm{3}.XLabel.Position(1:2) = [59.4728 -14.6487];