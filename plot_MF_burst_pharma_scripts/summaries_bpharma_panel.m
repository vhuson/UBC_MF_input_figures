% f_burst_pharma = figure('Position', [488 1.8000 680.3150 857.9636],...
%     'Color','w');


% Define ax positions
num_cols = 5;

left_edge = 0.1;
bottom_edge = 0.1557;
% bottom_edge2 = 0.32;
total_width = 0.6429;
total_height = 0.095;
base_gap = 0.03;

% bottom_edge2 = bottom_edge - total_height - 0.02;

base_width = (total_width - base_gap * (num_cols-1)) / num_cols;
base_height = total_height;

all_left_edges = (base_width + base_gap) .* (0:num_cols-1) + left_edge;
all_bottom_edges = repmat(bottom_edge,1,num_cols);


% trace_labels = {{'Baseline'},{'mGluR2/3','block'},{'+ AMPAR','block'},{'+ mGluR1','block'}};
trace_labels = {{'Baseline'},{'mGluR2/3 block'},{'+ AMPAR block'},{'+ mGluR1 block'}};
% trace_labels = {'1','2','3','4'};
all_titles = {'1' '2' '5' '10' '20'};

% Plot peak
ax_pharm_p = {};

opts = struct('input_n',[1 2 3 4],'XLabel','','XTickLabel',[],...
    'XTick',[],'YScale','log','min_val',1);
opts.xtick_symbols = {"o","^","square","diamond"};
opts.markeredgecolor = {[0 0 0], [1 0.6 0], [0.8 0 0], [ 0   0   1]};
opts.markerfacecolor = cellfun(@(x) {(1-x)*0.8+x},opts.markeredgecolor);
opts.base_style = '-';
% 
% opts.YLabel = 'Peak (\Deltaspk/s)';
% for input_idx = 1:5
%     % Set ax pos
%     pos_ax = [all_left_edges(input_idx), all_bottom_edges(input_idx),...
%         base_width, base_height];
% 
%     %Gather data
%     all_pharma_currpar = {all_pharma_slow_amp1{input_idx},...
%                     all_pharma_slow_amp2{input_idx},...
%                     all_pharma_slow_amp3{input_idx},...
%                     all_pharma_slow_amp4{input_idx}};
% 
% 
%     [ax_pharm_p{input_idx}] = UBC_par_line_plot2(...
%             fltr_ONidx,[],all_pharma_currpar,f_burst_pharma,pos_ax,...
%             opts);
%     title(ax_pharm_p{input_idx},all_titles{input_idx})
% 
%     fix_powered_ylabels(ax_pharm_p{input_idx});
% 
%     ax_pharm_p{input_idx}.XLim(1) = ax_pharm_p{input_idx}.XLim(1) - ...
%                         diff(ax_pharm_p{input_idx}.XLim)*0.05;
%     ax_pharm_p{input_idx}.YLim(1) = ax_pharm_p{input_idx}.YLim(1) * 0.85;
% 
%     if input_idx > 1
%             ax_pharm_p{input_idx}.YTickLabel = '';
%     end
% 
%     opts.YLabel = '';
%     % opts.YRulerVis = 'off';
% 
% end
% same_ylim(ax_pharm_p)


%Plot n-Spikes
% all_bottom_edges = repmat(bottom_edge2,1,num_cols);


ax_pharm_n = {};

opts = struct('input_n',[1 2 3 4],'XLabel','','XTickLabel',[],...{trace_labels},...
    'XTick',[],'YScale','log','min_val',1,'YLabel','\DeltaSpikes (n)');

opts.xtick_symbols = {"o","^","square","diamond"};
opts.markeredgecolor = {[0 0 0], [1 0.6 0], [0.8 0 0], [ 0   0   1]};
opts.markerfacecolor = cellfun(@(x) {(1-x)*0.8+x},opts.markeredgecolor);
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

    if input_idx == 1
        opts.bar = true;
    else
        opts.bar = false;
    end
    
    [ax_pharm_n{input_idx},cb1] = UBC_par_line_plot2(...
            fltr_ONidx,[],all_pharma_currpar,f_burst_pharma,pos_ax,...
            opts);
     title(ax_pharm_n{input_idx},all_titles{input_idx})
    
     if input_idx == 1
         cb1.Position = [0.4367 0.0545 0.0128 0.0695];
        %Adjust color bar
        % cb1.Position(1) = 0.8688; %Left edge
        % cb1.Units = 'pixels';
        % cb1.Position(3:4) = [8.7326 59.5984];
        % cb1.Units = 'normalized';
        % cb1.Position(2) = pos_ax(2)+pos_ax(4)/2-cb1.Position(4)/2;
     end
    if input_idx == 5
       
        % add legend line color bar
        seed_colors = [1 0 0;
            1 0.5 0.2;
            0.4 1 0.4;
            0.2 0.5 1;
            0 0 1];

        legend_colors = seed_map(seed_colors,numel(fltr_ONidx));
        % legend_colors = legend_colors(1:(numel(ONidx)-numel(OFFidx)),:);

        legend_pos = [0.9339 0.1667 0.0128 0.0695];

        legend_opts = struct();
        % legend_opts.n_shown = 5;
        legend_opts.n_pos =[1 15 31];
        [cl_ax] = colorline_legend(legend_colors,legend_pos,f_burst_pharma,legend_opts);
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


%Custom marker legend
ax_pos = [0.7621 0.1695 0.0257 0.0777];

ax_prot_markers = axes(f_burst_pharma,"Position",ax_pos);
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
    t_ml{ii} = text(0.5,5-ii,trace_labels{ii},...
        'FontSize',9,'FontName','Arial');
    t_ml{ii}.Units = 'pixels';
    t_ml{ii}.Position(1) = t_ml{ii}.Position(1)+3;
     t_ml{ii}.Units = 'data';
end
hold off
axis off

% %Make dummy axis for legend
% dummy_opts = struct();
% dummy_opts.markerfacecolor = opts.markerfacecolor;
% dummy_opts.markeredgecolor = opts.markeredgecolor;
% dummy_ax = UBC_par_marker_plot([1 1 1 1],f_burst_pharma,[2 2 0.2 0.2],dummy_opts);
% 
% legend_labels = trace_labels;
% legend(flipud(dummy_ax.Children(1:end-1)),legend_labels,...
%     'Orientation','vertical',...
%     'Box', 'off',...
%     'NumColumns',1,...
%     'Units','normalized',...
%     'Position', [0.8338 0.0412 0.1506 0.0844])

% same_ylim(ax_pharm_n(1:2))
% same_ylim(ax_pharm_n(3:5))



%Tweak figure
fig_opts = struct();
fig_opts.FontSize = 10;
standardFig(f_burst_pharma,fig_opts);

