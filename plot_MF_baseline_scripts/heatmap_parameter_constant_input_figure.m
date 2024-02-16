%% Script for plotting heatmap of constant input parameters

% Generic cell to hold any parameter for heatmap plot
array_constant_input_par = {};

for ii = 1:numel(constant_input_pars)
    % plot peaks
    % array_constant_input_par{ii} = [constant_input_pars(ii).peaks{:}]';

    % plot n_spikes constant window
    array_constant_input_par{ii} = [constant_input_pars(ii).n_spikes_min{:}]';

    % plot average rate
    % array_constant_input_par{ii} = [constant_input_pars(ii).avg_rate{:}]';
end



f_base = figure('Position', [488 1.8000 936.8000 852.6545],...
    'Color','w');

all_plot_freqs = [1 2.5 5];

pos_bottom = 0.06;
pos_height = 0.90;

%Normalize per cell
norm_on = max([array_constant_input_par{:}],[],2);
norm_on(norm_on < 0.5) = 0.5;
% norm_on = all_Amp;

%Don't normalize
% norm_on = max([all_constant_input_par{:}],[],'all');


%Different normalization for OFFs??
norm_off = all_baseline;
% norm_OFFidx =OFFidx(end-1:end);

% Normalize the OFFs the same as ONs
norm_OFFidx = [];




%Xlim
all_XLim = {[1/1 10],[1/2.5 10],[1/5 10]};


%Base width standardized to xlim
base_width = 0.8750/sum(cellfun(@diff,all_XLim));

all_titles = {'1 Hz', '2.5 Hz', '5 Hz'};
pos_ax = [0.05-base_width    pos_bottom    1*base_width   pos_height];
opts = struct();
opts.XTick = 0:5:10;
opts.XTickLabel = arrayfun(@num2str,opts.XTick,'UniformOutput',false);


ax_hm = {};
for ax_idx = 1:3
    curr_xlim = all_XLim{ax_idx};

    %Normalize individual?
    % norm_on =  max(all_mean_bursts{ax_idx},[],2);

    pos_ax = [sum(pos_ax([1,3]))+0.01   pos_bottom    diff(curr_xlim)*base_width    pos_height];


    ax_hm{ax_idx} = axes(f_base,'Position',pos_ax);


    [norm_traces] = norm_UBC(array_constant_input_par{ax_idx},norm_on,norm_off,norm_OFFidx);
    norm_traces = norm_traces(ONidx,:);

    opts.XLim = curr_xlim;
    opts.XLabel = '';
    if ax_idx == 2
        opts.YTick = [];
        opts.YLabel = '';
    end
    if ax_idx == 2
        opts.XLabel = 'Time (s)';
    end
    makeUBCHeatmap(ax_hm{ax_idx}, norm_traces, all_plot_freqs(ax_idx), opts);
    ax_hm{ax_idx}.Title.String = all_titles{ax_idx};
end