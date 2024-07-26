% f_train_cpp = figure('Position', [488 1.8000 680.3150 857.9636],...
%     'Color','w');

select_cells = fltr_ONidx_tcpp;

%Plot options
title_on = true;
color_bar_on = true;
plot_log = false;

%Set axis position
num_cols = 6;

pos_left = 0.1;
% pos_bottom = 0.23;
full_width = 0.9243-pos_left;
base_space = 0.017;
% base_height = 0.085;
pos_bottom = 0.2053;
base_height = 0.1;

base_width = full_width - base_space * (num_cols-1);
base_width = base_width / num_cols;

all_left_edges = (base_width + base_space) .* (0:(num_cols-1)) + pos_left;



% Gather data
% Get n_spikes data;
all_summary_data = cell(1,8);
all_summary_data2 = cell(1,8);
for ii = 1:8
    all_summary_data{ii} = cellfun(@(x) x(ii),all_n_spikes_stim_cpp);
    all_summary_data2{ii} = cellfun(@(x) x(ii),all_n_spikes_post_cpp);

    all_summary_data{ii} =  cellfun(@(x,y) {x+y},all_summary_data{ii},all_summary_data2{ii});
end
if plot_log
    min_val = 1;
    max_val = Inf;
    y_scale = 'log';
else
    min_val = -Inf;
    max_val = Inf;
    y_scale = 'linear';
end
chosen_plot_ylabel = '\DeltaSpikes (n)';
% chosen_plot_ylabel = '\DeltaSpikes\newlineduring step (n)';
% chosen_plot_ylabel = 'Post spikes (n)';

%Plot settings
step_size = [10, 20, 30, 40, 50, 60];

trace_labels = {'Baseline','−NMDAR'};
all_titles = step_size;


opts = struct('input_n',[1 2],'XLabel','','XTickLabel',[],...
    'XTick',[],'YScale',y_scale,'min_val',min_val,'max_val',max_val);

opts.YLabel = chosen_plot_ylabel;

opts.xtick_symbols = {"o","x"};
opts.base_style = '-';

ax_sp_p_par = {};


for ii = 1:num_cols
    % Set ax pos
    pos_ax = [all_left_edges(ii), pos_bottom,...
        base_width, base_height];
    
    curr_plot_data = all_summary_data{ii};

    if color_bar_on && ii == num_cols
        opts.bar = true;
    end
    
    %Plot
    [ax_sp_p_par{ii},cb1] = UBC_par_line_plot2(...
        select_cells,[],curr_plot_data,f_train_cpp,pos_ax,...
        opts);

    if title_on
        %Add and tweak labels
        title(ax_sp_p_par{ii},all_titles(ii))
    end




    %Adjust axes
    ax_sp_p_par{ii}.XLim(1) = ax_sp_p_par{ii}.XLim(1) - ...
                        diff(ax_sp_p_par{ii}.XLim)*0.05;
    if plot_log
        ax_sp_p_par{ii}.YLim(1) = ax_sp_p_par{ii}.YLim(1) * 0.85;
    end

    %Settings for next plots
    opts.YLabel = '';
end
same_ylim(ax_sp_p_par);



%Fix y ticks
if plot_log
    fix_powered_ylabels(ax_sp_p_par{1});
else
    if min_val ~= -Inf
        ax_sp_p_par{1}.YTick = unique([min_val, ax_sp_p_par{1}.YTick]);
    end
    if max_val ~= Inf
        ax_sp_p_par{1}.YTick = unique([ax_sp_p_par{1}.YTick, max_val]);
    end
    
    if min_val ~= -Inf
        ax_sp_p_par{1}.YTickLabel(1) = {['<',num2str(min_val)]};
    end
    if max_val ~= Inf
        ax_sp_p_par{1}.YTickLabel(end) = {['>',num2str(max_val)]};
    end
end
for ii = 2:numel(ax_sp_p_par)
    ax_sp_p_par{ii}.YTick = ax_sp_p_par{1}.YTick;
    ax_sp_p_par{ii}.YRuler.MinorTick = 'off';
    ax_sp_p_par{ii}.YTickLabel = [];    
end


%Make dummy axis for legend
opts = struct();
opts.input_n = [1,2];
opts.xtick_symbols = {"o","x"};
dummy_ax = UBC_par_marker_plot([1 1],f_train_cpp,[2 2 0.2 0.2],opts);

legend_labels = {'Baseline','NMDAR blocked'};
legend(flipud(dummy_ax.Children(1:end-1)),legend_labels,...
    'Orientation','horizontal',...
    'Box', 'off',...
    'NumColumns',2,...
    'Units','normalized',...
    'Position', [0.3553 0.1466 0.2841 0.0583])
