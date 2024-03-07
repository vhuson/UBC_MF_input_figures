% f_burst_pharma = figure('Position', [488 1.8000 680.3150 857.9636],...
%     'Color','w');


% Define ax positions
num_cols = 5;

left_edge = 0.1;
bottom_edge = 0.1534;
% bottom_edge2 = 0.32;
total_width = 0.73;
total_height = 0.11;
base_gap = 0.03;

bottom_edge2 = bottom_edge - total_height - 0.02;

base_width = (total_width - base_gap * (num_cols-1)) / num_cols;
base_height = total_height;

all_left_edges = (base_width + base_gap) .* (0:num_cols-1) + left_edge;
all_bottom_edges = repmat(bottom_edge,1,num_cols);


trace_labels = {'Baseline','−mGluR2','−AMPAR','−mGluR1'};
% trace_labels = {'1','2','3','4'};
all_titles = {'1x' '2x' '5x' '10x' '20x'};

% Plot peak
ax_pharm_p = {};

opts = struct('input_n',[1 2 3 4],'XLabel','','XTickLabel',[],...
    'XTick',[],'YScale','log','min_val',1);
opts.xtick_symbols = {"o","^","square","diamond"};
opts.base_style = '-';

opts.YLabel = 'Peak (\Deltaspk/s)';
for input_idx = 1:5
    % Set ax pos
    pos_ax = [all_left_edges(input_idx), all_bottom_edges(input_idx),...
        base_width, base_height];

    %Gather data
    all_pharma_currpar = {all_pharma_slow_amp1{input_idx},...
                    all_pharma_slow_amp2{input_idx},...
                    all_pharma_slow_amp3{input_idx},...
                    all_pharma_slow_amp4{input_idx}};


    [ax_pharm_p{input_idx}] = UBC_par_line_plot2(...
            fltr_ONidx,[],all_pharma_currpar,f_burst_pharma,pos_ax,...
            opts);
    title(ax_pharm_p{input_idx},all_titles{input_idx})

    fix_powered_ylabels(ax_pharm_p{input_idx});

    ax_pharm_p{input_idx}.XLim(1) = ax_pharm_p{input_idx}.XLim(1) - ...
                        diff(ax_pharm_p{input_idx}.XLim)*0.05;
    ax_pharm_p{input_idx}.YLim(1) = ax_pharm_p{input_idx}.YLim(1) * 0.85;

    if input_idx > 1
            ax_pharm_p{input_idx}.YTickLabel = '';
    end

    opts.YLabel = '';
    % opts.YRulerVis = 'off';

end
same_ylim(ax_pharm_p)


%Plot n-Spikes
all_bottom_edges = repmat(bottom_edge2,1,num_cols);


ax_pharm_n = {};

opts = struct('input_n',[1 2 3 4],'XLabel','','XTickLabel',[],...{trace_labels},...
    'XTick',[],'YScale','log','min_val',1,'YLabel','Response spikes (n)');

opts.xtick_symbols = {"o","^","square","diamond"};
opts.base_style = '-';
% opts.YLabel = 'Response spikes (n)';
for input_idx = 1:5
    % Set ax pos
    pos_ax = [all_left_edges(input_idx), all_bottom_edges(input_idx),...
        base_width, base_height];

    %Gather data
    all_pharma_currpar = {all_pharma_n_spikes1{input_idx},...
                    all_pharma_n_spikes2{input_idx},...
                    all_pharma_n_spikes3{input_idx},...
                    all_pharma_n_spikes4{input_idx}};

    if input_idx == 5
        opts.bar = true;
    end
    
    [ax_pharm_n{input_idx},cb1] = UBC_par_line_plot2(...
            fltr_ONidx,[],all_pharma_currpar,f_burst_pharma,pos_ax,...
            opts);

    if input_idx == 5
        cb1.Position = [0.8688 0.0503 0.0151 0.0743];
    end

    fix_powered_ylabels(ax_pharm_n{input_idx});
    
    %Offset limits just a little bit
    ax_pharm_n{input_idx}.XLim(1) = ax_pharm_n{input_idx}.XLim(1) - ...
                        diff(ax_pharm_n{input_idx}.XLim)*0.05;
    ax_pharm_n{input_idx}.YLim(1) = ax_pharm_n{input_idx}.YLim(1) * 0.85;


    if input_idx > 1
            ax_pharm_n{input_idx}.YTickLabel = '';
    end

    opts.YLabel = '';
    % opts.YRulerVis = 'off';
end
same_ylim(ax_pharm_n)

%Make dummy axis for legend
dummy_ax = UBC_par_marker_plot([1 1 1 1],f_burst_pharma,[2 2 0.2 0.2]);

legend_labels = {'Baseline','−mGluR2','−AMPAR','−mGluR1'};
legend(flipud(dummy_ax.Children(1:end-1)),legend_labels,...
    'Orientation','vertical',...
    'Box', 'off',...
    'NumColumns',1,...
    'Units','normalized',...
    'Position', [0.8338 0.1805 0.1506 0.0844])

% same_ylim(ax_pharm_n(1:2))
% same_ylim(ax_pharm_n(3:5))


