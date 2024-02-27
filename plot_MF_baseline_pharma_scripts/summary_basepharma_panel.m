% f_base_pharma = figure('Position', [488 1.8000 680.3150 857.9636],...
%     'Color','w');


% Specify ax positions
left_edge = 0.7324;
bottom_edge = 0.08;
total_width = 0.1809;
panel_gap = 0.04;
total_height = 0.49;

num_panels = 3;
base_width = total_width;
graph_height = (total_height - (panel_gap*(num_panels-1))) / num_panels;

all_left_edges = repmat(left_edge,1,num_panels);
all_bottom_edges = (graph_height + panel_gap) .* (0:(num_panels-1)) + bottom_edge;
all_bottom_edges = fliplr(all_bottom_edges);


% Gather data
% Get n_spikes data;
base_n_spikes_ss_pharma_all = {base_n_spikes_ss_pharma1,...
                                base_n_spikes_ss_pharma2,...
                                base_n_spikes_ss_pharma3,...
                                base_n_spikes_ss_pharma4};

for ii = 1:numel(base_n_spikes_ss_pharma_all)

    all_baseline_n_spikes = washin_base_rates{ii}(washin_fltr) .* (min_trace_leng_pharma_base1/Fs);

    base_n_spikes_ss_pharma_all{ii} = cellfun(@(x)...
        {x+all_baseline_n_spikes},base_n_spikes_ss_pharma_all{ii});

end

% Get peak data
base_peak_ss_pharma_all = {base_amplitude_ss_pharma1,...
                            base_amplitude_ss_pharma2,...
                            base_amplitude_ss_pharma3,...
                            base_amplitude_ss_pharma4};
for ii = 1:numel(base_peak_ss_pharma_all)

    all_baseline_peak_rate = washin_base_rates{ii}(washin_fltr);

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
all_titles = {'1 Hz', '2.5 Hz', '5 Hz'};


opts = struct('input_n',[1 2 3 4],'XLabel','','XTickLabel',[],...
    'XTick',[],'YScale','log','min_val',min_val);

opts.YLabel = chosen_plot_ylabel;

opts.xtick_symbols = {"o","^","square","diamond"};
opts.base_style = '-';

opts.bar = true;

% Loop over all panels
for ii = 1:num_panels
    % Set ax pos
    pos_ax = [all_left_edges(ii), all_bottom_edges(ii),...
        base_width, graph_height];

    %Gather current data
    all_pharma_currpar = cellfun(@(x) x(ii),chosen_plot_par);
    

    if ii == 2
        opts.bar = false;
    end

    %Plot
    [ax_basep_par{ii},cb1] = UBC_par_line_plot2(...
            fltr_ONidx,[],all_pharma_currpar,f_base_pharma,pos_ax,...
            opts);

    if ii == 1
        cb1.Position = [0.9297 0.1140 0.0151 0.0743];
    end

    %Add and tweak labels
    title(ax_basep_par{ii},all_titles{ii})
   
    fix_powered_ylabels(ax_basep_par{ii});

    %Adjust axes
    ax_basep_par{ii}.XLim(1) = ax_basep_par{ii}.XLim(1) - ...
                        diff(ax_basep_par{ii}.XLim)*0.05;
    ax_basep_par{ii}.YLim(1) = ax_basep_par{ii}.YLim(1) * 0.85;

end

same_ylim(ax_basep_par);


%Make dummy axis for legend
dummy_ax = UBC_par_marker_plot([1 1 1 1],f_base_pharma,[2 2 0.2 0.2]);

legend_labels = {'Baseline','−mGluR2','−AMPAR','−mGluR1'};
% legend_labels = {'','','',''};
legend(flipud(dummy_ax.Children(1:end-1)),legend_labels,...
    'Orientation','Horizontal',...
    'Box', 'off',...
    'NumColumns',2,...
    'Units','normalized',...
    'Position', [0.6773 0.0174 0.2986 0.0477])
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
