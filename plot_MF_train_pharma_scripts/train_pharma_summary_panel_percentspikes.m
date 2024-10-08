% f_train_pharma = figure('Position', [488 1.8000 680.3150 857.9636],...
%     'Color','w');

select_cells = fltr_ONidx_tpharma;

%Plot options
title_on = false;

%Set axis position
num_cols = 6;

pos_left = 0.1;
pos_bottom = 0.02;
full_width = 0.9243-pos_left;
base_space = 0.017;
base_height = 0.085;

base_width = full_width - base_space * (num_cols-1);
base_width = base_width / num_cols;

all_left_edges = (base_width + base_space) .* (0:(num_cols-1)) + pos_left;



% Gather data
% Get n_spikes data;
all_summary_data = cell(1,8);
for ii = 1:8
    % all_summary_data{ii} = cellfun(@(x) x(ii),all_n_spikes_stim_pharma);
    % all_summary_data{ii} = cellfun(@(x) x(ii),all_n_spikes_post_pharma);
    all_summary_data{ii} = cellfun(@(x,y) {(x{ii})./(x{ii}+y{ii}).*100},...
        all_sum_spikes_stim_pharma,all_sum_spikes_post_pharma);

end
min_val = -Inf;
chosen_plot_ylabel = 'Spikes\newlineduring step (%)';
% chosen_plot_ylabel = 'Post spikes (n)';

%Plot settings
step_size = [10, 20, 30, 40, 50, 60];

trace_labels = {'Baseline','−mGluR2','−AMPAR','−mGluR1'};
all_titles = step_size;


opts = struct('input_n',[1 2 3 4],'XLabel','','XTickLabel',[],...
    'XTick',[],'YScale','linear','min_val',min_val);

opts.YLabel = chosen_plot_ylabel;

opts.xtick_symbols = {"o","^","square","diamond"};
opts.base_style = '-';

ax_sp_p_par = {};


for ii = 1:num_cols
    % Set ax pos
    pos_ax = [all_left_edges(ii), pos_bottom,...
        base_width, base_height];
    
    curr_plot_data = all_summary_data{ii};

    if ii == num_cols
        opts.bar = true;
    end
    
     %Plot
    [ax_sp_p_par{ii},cb1] = UBC_par_line_plot2(...
            select_cells,[],curr_plot_data,f_train_pharma,pos_ax,...
            opts);
    
    if title_on
        %Add and tweak labels
        title(ax_sp_p_par{ii},all_titles(ii))
    end
    


    %Adjust axes
    ax_sp_p_par{ii}.XLim(1) = ax_sp_p_par{ii}.XLim(1) - ...
                        diff(ax_sp_p_par{ii}.XLim)*0.05;
    ax_sp_p_par{ii}.YLim(1) = ax_sp_p_par{ii}.YLim(1) * 0.85;


    %Settings for next plots
    opts.YLabel = '';
end
same_ylim(ax_sp_p_par);


%Fix y ticks
if strcmp(opts.YScale,'log')
    fix_powered_ylabels(ax_sp_p_par{1});
end
for ii = 2:numel(ax_sp_p_par)
    ax_sp_p_par{ii}.YTick = ax_sp_p_par{1}.YTick;
    ax_sp_p_par{ii}.YRuler.MinorTick = 'off';
    ax_sp_p_par{ii}.YTickLabel = [];
end

