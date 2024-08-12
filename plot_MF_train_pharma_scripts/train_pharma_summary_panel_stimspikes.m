% f_train_pharma = figure('Position', [488 1.8000 680.3150 857.9636],...
%     'Color','w');

select_cells = fltr_ONidx_tpharma;

%Plot options
title_on = true;
color_bar_on = true;
plot_log = false;

%Set axis position
num_cols = 6;

pos_left = 0.1;
% pos_bottom = 0.23;
full_width = 0.7429-pos_left;
base_space = 0.017;
% base_height = 0.085;
pos_bottom = 0.1604;
base_height = 0.1;

base_width = full_width - base_space * (num_cols-1);
base_width = base_width / num_cols;

all_left_edges = (base_width + base_space) .* (0:(num_cols-1)) + pos_left;



% Gather data
% Get n_spikes data;
all_summary_data = cell(1,8);
all_summary_data2 = cell(1,8);
for ii = 1:8
    all_summary_data{ii} = cellfun(@(x) x(ii),all_n_spikes_stim_pharma);
    all_summary_data2{ii} = cellfun(@(x) x(ii),all_n_spikes_post_pharma);

    all_summary_data{ii} =  cellfun(@(x,y) {x+y},all_summary_data{ii},all_summary_data2{ii});
end
if plot_log
    min_val = 1;
    max_val = Inf;
    y_scale = 'log';
else
    min_val = -50;
    max_val = 150;
    y_scale = 'linear';
end
chosen_plot_ylabel = '\DeltaSpikes (n)';
% chosen_plot_ylabel = '\DeltaSpikes\newlineduring step (n)';
% chosen_plot_ylabel = 'Post spikes (n)';

%Plot settings
step_size = [10, 20, 30, 40, 50, 60];

trace_labels = {'Baseline','−mGluR2','−AMPAR','−mGluR1'};
all_titles = step_size;


opts = struct('input_n',[1 2 3 4],'XLabel','','XTickLabel',[],...
    'XTick',[],'YScale',y_scale,'min_val',min_val,'max_val',max_val);

opts.YLabel = chosen_plot_ylabel;

opts.xtick_symbols = {"o","^","square","diamond"};
opts.markeredgecolor = {[0 0 0], [1 0.6 0], [0.8 0 0], [ 0   0   1]};
opts.markerfacecolor = cellfun(@(x) {(1-x)*0.8+x},opts.markeredgecolor);
opts.base_style = '-';

ax_sp_p_par = {};


for ii = 1:num_cols
    % Set ax pos
    pos_ax = [all_left_edges(ii), pos_bottom,...
        base_width, base_height];
    
    curr_plot_data = all_summary_data{ii};

    if color_bar_on && ii == 1
        opts.bar = true;
    else
        opts.bar = false;
    end
    
    %Plot
    [ax_sp_p_par{ii},cb1] = UBC_par_line_plot2(...
        select_cells,[],curr_plot_data,f_train_pharma,pos_ax,...
        opts);

    if color_bar_on && ii == 1
        cb1.Position(1:2) = [0.4472 0.0500 ];
    end

    if ii == num_cols
       
        % add legend line color bar
        seed_colors = [1 0 0;
            1 0.5 0.2;
            0.4 1 0.4;
            0.2 0.5 1;
            0 0 1];

        legend_colors = seed_map(seed_colors,numel(select_cells));
        % legend_colors = legend_colors(1:(numel(ONidx)-numel(OFFidx)),:);

        legend_pos = [0.9339 0.1714 0.0128 0.0695];

        legend_opts = struct();
        % legend_opts.n_shown = 5;
        legend_opts.n_pos =[1 5 11];
        [cl_ax] = colorline_legend(legend_colors,legend_pos,f_train_pharma,legend_opts);
    end

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

    ax_sp_p_par{1}.YTick = unique([min_val, ax_sp_p_par{1}.YTick, max_val]);
    ax_sp_p_par{1}.YTickLabel(1) = {['<',num2str(min_val)]};
    ax_sp_p_par{1}.YTickLabel(end) = {['>',num2str(max_val)]};
end
for ii = 2:numel(ax_sp_p_par)
    ax_sp_p_par{ii}.YTick = ax_sp_p_par{1}.YTick;
    ax_sp_p_par{ii}.YRuler.MinorTick = 'off';
    ax_sp_p_par{ii}.YTickLabel = [];    
end


%Make dummy axis for legend
% dummy_opts = struct();
% dummy_opts.markerfacecolor = opts.markerfacecolor;
% dummy_opts.markeredgecolor = opts.markeredgecolor;
% dummy_ax = UBC_par_marker_plot([1 1 1 1],f_train_pharma,[2 2 0.2 0.2],dummy_opts);
% 
% % legend_labels = {'Baseline','mGluR2/3 block','AMPAR block','mGluR1 block'};
% legend_labels = {'Baseline','−mGluR2/3','−AMPAR','−mGluR1'};
% legend(flipud(dummy_ax.Children(1:end-1)),legend_labels,...
%     'Orientation','horizontal',...
%     'Box', 'off',...
%     'NumColumns',1,...
%     'Units','normalized',...
%     'Position', [0.8326 0.0412 0.1647 0.0844])



%Custom marker legend
ax_pos = [0.7621 0.1742 0.0257 0.0777];

legend_labels = {{'Baseline'},{'mGluR2/3 block'},{'+ AMPAR block'},{'+ mGluR1 block'}};

ax_prot_markers = axes(f_train_pharma,"Position",ax_pos);
xtick_symbols = {"o","^","square","diamond"};
seed_colors_pharma = [0 0 0;
                1 0.6 0;
                0.8 0 0;
                0   0   1];
prot_markeredgecolor = {[0 0 0], [1 0.6 0], [0.8 0 0], [ 0   0   1]};
prot_markerfacecolor = cellfun(@(x) {(1-x)*0.8+x},opts.markeredgecolor);
prot_marker_sizes = [6, 6, 7, 6];
hold on
t_ml = {};
for ii = 1:4
    plot(0,5-ii,...
        xtick_symbols{ii},...
        'MarkerEdgeColor',prot_markeredgecolor{ii},'MarkerFaceColor',prot_markerfacecolor{ii},...
        'MarkerSize',prot_marker_sizes(ii));
    t_ml{ii} = text(0.5,5-ii,legend_labels{ii},...
        'FontSize',9,'FontName','Arial');
    t_ml{ii}.Units = 'pixels';
    t_ml{ii}.Position(1) = t_ml{ii}.Position(1)+3;
     t_ml{ii}.Units = 'data';
end
hold off
axis off

%Fix ylabel
ax_sp_p_par{1}.YLabel.Units = 'pixels';
ax_sp_p_par{1}.YLabel.Position(1) = -37;