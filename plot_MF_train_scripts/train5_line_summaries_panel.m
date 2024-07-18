% f_train = figure('Position', [488 1.8000 680.3150 857.9636],...
%     'Color','w');


% Plot settings
all_line_plot_par = {cellfun(@(x,y) {(x)./(x+y).*100},all_sum_spikes_stim,all_sum_spikes_post)};
all_ylabels = {'Spikes during step (%)'};
% all_line_plot_par = {cellfun(@(x,y) {(x)./(x+y).*100},all_sum_spikes_stim,all_sum_spikes_post),...
%                     all_n_spikes_stim,all_n_spikes_post};
% all_ylabels = {'Spikes during step (%)',...
%                 '\DeltaSpikes during step (n)',...
%                 '\DeltaSpikes after step (n)'};



%Define axis position
num_cols = numel(all_line_plot_par);
num_rows = 1;


bottom_margin = 0.1764;
base_width = 0.1261;
base_space = 0.14;
left_margin = 0.5703;
% left_margin = 0.5567;

graph_height = 0.1143;

all_left_edges = (base_width + base_space) .* (0:(num_cols-1)) + left_margin;





select_cells = fltr_ONidx_t5;

curr_xlabel = 'Cell (#)';

seed_colors = [1 0 0;
                1 0.5 0.2;
                0.4 1 0.4;
                0.2 0.5 1;
                0 0 1];

all_colors = seed_map(seed_colors,numel(select_cells));

%Desaturate function
desat_fun = @(curr_colors,desat_val) curr_colors + (1-curr_colors).*desat_val;

base_num = 6;

%Define axes
line_ax = {};
for ax_idx = 1:numel(all_line_plot_par)
    curr_par = all_line_plot_par{ax_idx};
    curr_ylabel = all_ylabels{ax_idx};

    pos_ax = [all_left_edges(ax_idx),  bottom_margin, base_width, graph_height];
    line_ax{ax_idx} = axes(f_train,'Position',pos_ax);
    hold on


    desat_colors = desat_fun(all_colors,5/base_num);



    % scatter(1:numel(select_cells),curr_par{1}(select_cells),[],desat_colors,'filled')


    for ii = 6%2:6
        desat_colors = desat_fun(all_colors,(6-ii)/base_num);
        scatter(1:numel(select_cells),curr_par{ii}(select_cells),[],desat_colors,'filled')

    end
    hold off

    
    xlim([0 numel(select_cells)+1])
    xticks([1 numel(select_cells)])


    ylabel(curr_ylabel)
    xlabel(curr_xlabel)

    line_ax{ax_idx}.XLabel.Position(2) = line_ax{ax_idx}.XLabel.Position(2)+ diff(line_ax{ax_idx}.YLim)*0.05;
    standardAx(line_ax{ax_idx},struct('FontSize',10));
end
%Add legend
% legend(line_ax{ax_idx},string(10:10:60),'Box','off','NumColumns',1,'Position', [0.6259 0.2402 0.0976 0.1052])
