% f_train = figure('Position', [488 1.8000 680.3150 857.9636],...
%     'Color','w');
% train5_summaries_panel

% Plot settings
all_line_plot_par = {cellfun(@(x,y) {(x)./(x+y).*100},all_sum_spikes_stim,all_sum_spikes_post)};
all_ylabels = {'Time to peak (s)'};
% all_line_plot_par = {cellfun(@(x,y) {(x)./(x+y).*100},all_sum_spikes_stim,all_sum_spikes_post),...
%                     all_n_spikes_stim,all_n_spikes_post};
% all_ylabels = {'Spikes during step (%)',...
%                 '\DeltaSpikes during step (n)',...
%                 '\DeltaSpikes after step (n)'};

color_bar_on = false;

num_off = 4;

%Define axis position
num_cols = numel(all_line_plot_par);
num_rows = 1;


bottom_margin = 0.1764;
% base_width = 0.1061;
base_width = 0.1161;
base_space = 0.14;
% left_margin = 0.5921;
left_margin = 0.6121;

graph_height = 0.1143;

all_left_edges = (base_width + base_space) .* (0:(num_cols-1)) + left_margin;





select_cells = fltr_ONidx_t5;

curr_xlabel = 'Cell #';

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

curr_par = vertcat(all_60_fit{:});
curr_par = curr_par(:,2);
curr_ylabel = all_ylabels{ax_idx};

pos_ax = [all_left_edges(ax_idx),  bottom_margin, base_width, graph_height];
line_ax = axes(f_train,'Position',pos_ax);
hold on


desat_colors = desat_fun(all_colors,5/base_num);



% scatter(1:numel(select_cells),curr_par{1}(select_cells),[],desat_colors,'filled')



desat_colors = desat_fun(all_colors,0);
sc1 = scatter(1:numel(select_cells)-num_off,curr_par(select_cells(1:end-num_off)),...
    [],desat_colors(1:end-num_off,:));%,'filled')
sc1.MarkerFaceColor = 'w';

hold off


xlim([0 numel(select_cells)-num_off+1])
xticks([1 numel(select_cells)-num_off])


ylabel(curr_ylabel)
xlabel(curr_xlabel)

line_ax.XLabel.Position(2) = line_ax.XLabel.Position(2)+ diff(line_ax.YLim)*0.05;
line_ax.XLabel.Units = 'normalized';

line_ax.YScale = 'log';
fix_powered_ylabels(line_ax);


%Add color bar
if color_bar_on
    seed_colors = [1 0 0;
        1 0.5 0.2;
        0.4 1 0.4;
        0.2 0.5 1;
        0 0 1];

    all_colors = seed_map(seed_colors,numel(select_cells));
    all_colors(end-num_off:end,:) = [];
    colormap(line_ax,flipud(seed_map(all_colors,256)))

    cb1 = colorbar(line_ax);
    cb1.Ticks = [0 1];
    % cb1.TickLabels = {'Slow' 'Fast'};
    cb1.TickLabels = {num2str(numel(select_cells)-num_off) '1'};
    cb1.Label.String = 'Cell #';
    cb1.Label.Rotation = 270;
    cb1.Label.Units = 'normalized';
    cb1.Label.Position(1) = 3.7;
    standardBar(cb1);

    %Adjust color bar
    cb1.Position(1) = sum(pos_ax([1,3])); %0.9393; %Left edge
    cb1.Units = 'pixels';
    cb1.Position(1) = cb1.Position(1) + 13;
    cb1.Position(3:4) = [8.7326 59.5984];
    cb1.Units = 'normalized';
    cb1.Position(2) = pos_ax(2)+pos_ax(4)/2-cb1.Position(4)/2;

end

standardAx(line_ax,struct('FontSize',10));

%Add legend
% legend(line_ax{ax_idx},string(10:10:60),'Box','off','NumColumns',1,'Position', [0.6259 0.2402 0.0976 0.1052])
