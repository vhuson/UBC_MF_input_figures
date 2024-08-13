% f_base_pharma = figure('Position', [488 1.8000 680.3150 857.9636],...
%     'Color','w');


% Specify ax positions
left_edge = 0.08;
bottom_edge = 0.035;
total_width = 0.56;
panel_gap = 0.08;
total_height = 0.1;

num_panels = 3;
base_width = (total_width - (panel_gap*(num_panels-1))) / num_panels;
% graph_height = (total_height - (panel_gap*(num_panels-1))) / num_panels;
graph_height = total_height;

all_left_edges = (base_width + panel_gap) .* (0:(num_panels-1)) + left_edge;
all_bottom_edges = repmat(bottom_edge,1,num_panels);



% Gather data
% Get n_spikes data;
base_n_spikes_ss_pharma_all = {base_n_spikes_ss_pharma1,...
                                base_n_spikes_ss_pharma2,...
                                base_n_spikes_ss_pharma3,...
                                base_n_spikes_ss_pharma4};

for ii = 1:numel(base_n_spikes_ss_pharma_all)

    all_baseline_n_spikes = washin_base_rates{ii}(washin_fltr_base) .* (min_trace_leng_pharma_base1/Fs);

    base_n_spikes_ss_pharma_all{ii} = cellfun(@(x)...
        {x+all_baseline_n_spikes},base_n_spikes_ss_pharma_all{ii});

end

% Get peak data
base_peak_ss_pharma_all = {base_amplitude_ss_pharma1,...
                            base_amplitude_ss_pharma2,...
                            base_amplitude_ss_pharma3,...
                            base_amplitude_ss_pharma4};
for ii = 1:numel(base_peak_ss_pharma_all)

    all_baseline_peak_rate = washin_base_rates{ii}(washin_fltr_base);

    base_peak_ss_pharma_all{ii} = cellfun(@(x)...
        {x+all_baseline_peak_rate},base_peak_ss_pharma_all{ii});

end


chosen_plot_ylabel = "#Spikes";
chosen_plot_par = base_n_spikes_ss_pharma_all;
min_val = 0.1;

% chosen_plot_ylabel = "Peak rate (spk/s)";
% chosen_plot_par = base_peak_ss_pharma_all;
% min_val = 1;


%Plot settings

ax_basep_par = {};


trace_labels = {'Baseline','−mGluR2','−AMPAR','−mGluR1'};
all_titles = {'1 spk/s', '2.5 spk/s', '5 spk/s'};


opts = struct('input_n',[1 2 3 4],'XLabel','','XTickLabel',[],...
    'XTick',[],'YScale','log','min_val',min_val);

opts.YLabel = chosen_plot_ylabel;

opts.xtick_symbols = {"o","^","square","diamond"};
opts.markeredgecolor = {[0 0 0], [1 0.6 0], [0.8 0 0], [ 0   0   1]};
opts.markerfacecolor = cellfun(@(x) {(1-x)*0.8+x},opts.markeredgecolor);
opts.base_style = '-';

opts.bar = false;

% Loop over all panels
for ii = 1:num_panels
    % Set ax pos
    pos_ax = [all_left_edges(ii), all_bottom_edges(ii),...
        base_width, graph_height];

    %Gather current data
    all_pharma_currpar = cellfun(@(x) x(ii),chosen_plot_par);
    

    % if ii == 3
    %     opts.bar = true;
    % end

    %Plot
    [ax_basep_par{ii},cb1] = UBC_par_line_plot2(...
            fltr_ONidx_baseline,[],all_pharma_currpar,f_base_pharma,pos_ax,...
            opts);

    % if ii == 3
    %     % cb1.Position = [0.9397 0.1140 0.0151 0.0743];
    %     %Adjust color bar
    %     cb1.Position(1) = 0.9397; %Left edge
    %     cb1.Units = 'pixels';
    %     cb1.Position(3:4) = [8.7326 59.5984];
    %     cb1.Units = 'normalized';
    %     cb1.Position(2) = pos_ax(2)+pos_ax(4)/2-cb1.Position(4)/2;
    % end

    %Add and tweak labels
    title(ax_basep_par{ii},all_titles{ii})
   
    fix_powered_ylabels(ax_basep_par{ii});

    %Adjust axes
    ax_basep_par{ii}.XLim(1) = ax_basep_par{ii}.XLim(1) - ...
                        diff(ax_basep_par{ii}.XLim)*0.05;
    ax_basep_par{ii}.YLim(1) = ax_basep_par{ii}.YLim(1) * 0.85;
    opts.YLabel = '';
end

same_ylim(ax_basep_par);


ax_pos = [0.6736 0.0478 0.0257 0.0777];

legend_labels = {{'Baseline'},{'mGluR2/3 block'},{'+ AMPAR block'},{'+ mGluR1 block'}};

ax_prot_markers = axes(f_base_pharma,"Position",ax_pos);
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


% add legend line color bar
seed_colors = [1 0 0;
    1 0.5 0.2;
    0.4 1 0.4;
    0.2 0.5 1;
    0 0 1];

legend_colors = seed_map(seed_colors,numel(fltr_ONidx_baseline));
% legend_colors = legend_colors(1:(numel(ONidx)-numel(OFFidx)),:);

legend_pos = [0.8595 0.0479 0.0128 0.0695];

legend_opts = struct();
% legend_opts.n_shown = 5;
legend_opts.n_pos =[1 15 29];
[cl_ax] = colorline_legend(legend_colors,legend_pos,f_base_pharma,legend_opts);

% 
% legend_labels = {'Baseline','−mGluR2','−AMPAR','−mGluR1'};
% t_l_labels = {};
% 
% all_positions = {[1.3483 1.9269 0],...
%                     [1.3483 1.4259 0],...
%                     [1.3483 0.8869 0],...
%                     [1.3483 0.3479 0]};
% 
% for ii = 1:4
%     t_l_labels{ii} = text(ax_basep_par{end},0,0,legend_labels{ii},...
%         'Units','normalized',...
%         'Position', all_positions{ii},...
%         'Rotation', -90,...
%         'HorizontalAlignment','center',...
%         'VerticalAlignment','middle');
% end

%Fix titles and ylabels
for ii = 1:numel(ax_basep_par)
    ax_basep_par{ii}.Title.Units = 'pixels';
    ax_basep_par{ii}.Title.Position(2) = ...
        ax_basep_par{ii}.Title.Position(2)+5;

    ax_basep_par{ii}.YLabel.Units = 'pixels';
    ax_basep_par{ii}.YLabel.Position(1) = -27;
end

