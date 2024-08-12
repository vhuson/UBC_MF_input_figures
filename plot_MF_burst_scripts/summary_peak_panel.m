% f_burst = figure('Position', [488 1.8000 680.3150 857.9636],...
%     'Color','w');
% summary_lineplots_panel

% Plot settings
all_ylabels = {'2 stim.','20 stim.'};
% all_line_plot_par = {cellfun(@(x,y) {(x)./(x+y).*100},all_sum_spikes_stim,all_sum_spikes_post),...
%                     all_n_spikes_stim,all_n_spikes_post};
% all_ylabels = {'Spikes during step (%)',...
%                 '\DeltaSpikes during step (n)',...
%                 '\DeltaSpikes after step (n)'};

color_bar_on = false;

num_off = numel(OFFidx);

%Define axis position
num_cols = 1;
num_rows = 1;


left_margin = all_left_edges(2);
bottom_margin = 0.08;
base_space = 0.07;
extra_space = 0.03;

% base_width = 0.1175;


plot_sep = 0.01;
graph_height = 0.13;

base_height = (graph_height-plot_sep)/2;
all_bottoms = (base_height+plot_sep) .*(0:1) +bottom_margin;
all_bottoms = fliplr(all_bottoms);



select_cells = ONidx;

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
all_plot_pars = {all_burst_slow_amp{2},all_burst_slow_amp{5}};
%Define axes
line_ax = {};
for ax_idx = 1:2
    curr_par = all_plot_pars{ax_idx};
    curr_par(curr_par<1) = 1;
    curr_ylabel = all_ylabels{ax_idx};

    pos_ax = [left_margin,  all_bottoms(ax_idx), base_width, base_height];
    line_ax{ax_idx} = axes(f_burst,'Position',pos_ax);
    hold on

    sc1 = scatter(1:numel(select_cells)-num_off,curr_par(select_cells(1:end-num_off)),...
        [],all_colors(1:end-num_off,:));%,'filled')
    sc1.MarkerFaceColor = 'w';

    hold off


    xlim([0 numel(select_cells)-num_off+1])
    xticks([1 numel(select_cells)-num_off])


    ylabel(curr_ylabel)
    xlabel(curr_xlabel)

    line_ax{ax_idx}.XLabel.Position(2) = line_ax{ax_idx}.XLabel.Position(2)+ diff(line_ax{ax_idx}.YLim)*0.05;
    line_ax{ax_idx}.XLabel.Units = 'normalized';

    line_ax{ax_idx}.YScale = 'log';
    fix_powered_ylabels(line_ax{ax_idx});
    line_ax{ax_idx}.YLim = [1.0000  230.5999];
    standardAx(line_ax{ax_idx},struct('FontSize',10));
    line_ax{ax_idx}.YTickLabel{5} = '<1';
end
line_ax{1}.XRuler.Visible = 'off';

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

%Add additional text
text(ax_burst_par{1},0,0,'Peak (\Deltaspk/s)','FontSize',10,'FontName','Arial',...
    'Rotation',90,'Units','pixels','Position',[148.7000 52.4000 -0.7988],...
    'HorizontalAlignment','center');

%Add legend
% legend(line_ax{ax_idx},string(10:10:60),'Box','off','NumColumns',1,'Position', [0.6259 0.2402 0.0976 0.1052])


%Tweak figure
% fig_opts = struct();
% fig_opts.FontSize = 10;
% standardFig(f_burst,fig_opts);