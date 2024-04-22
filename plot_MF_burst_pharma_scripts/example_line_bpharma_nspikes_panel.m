% f_burst_pharma = figure('Position', [488 1.8000 680.3150 857.9636],...
%     'Color','w');
% example_cell_bpharma_panel
% example_line_bpharma_v2_panel

% Which cells to plot
% curr_cells = [5, 9, 13, 18, 24];
% typ_cell_IDs = {'1686','1694','1776','1774','1709'};

% curr_cells = [8, 10, 13, 18, 24];
typ_cell_IDs = {'1657','1668','1776','1774','1709'};
[typ_cell_idxs,curr_cells] = UBC_cell_ID2idx(fileNames(washin_fltr),typ_cell_IDs,fltr_ONidx);


plot_amp = false;

%Set up axes positions
num_rows = numel(curr_cells);
num_cols = 5; %Number of burst types

left_edge = 0.77;
top_edge = 0.92;
total_height = 0.28;
total_width = 0.2;
height_space = 0.015;
base_space = 0.015;

bottom_edge = top_edge - total_height;

graph_height = (total_height - height_space*(num_rows-1)) / num_rows;
base_width = (total_width - base_space*(num_cols-1)) / num_cols;

all_left_edge = (base_width + base_space) .* (0:(num_cols-1)) + left_edge;
all_bottom_edge = (graph_height + height_space) .* (0:(num_rows-1)) + bottom_edge;
all_bottom_edge = fliplr(all_bottom_edge);


%Specify graph options
select_cells = fltr_ONidx;
legend_labels = {'Baseline','−mGluR2','−AMPAR','−mGluR1'};
xtick_symbols = {"o","^","square","diamond"};

xtick_labels = {'1','2','3','4'};
all_titles = {'1x' '2x' '5x' '10x' '20x'};

ax_pharm_typline = {};

opts = struct('input_n',[1 2 3 4],'XLabel','','XTickLabel',[],'XTick',[]);
opts.markerfacecolor = {'w',[0.7 0.7 0.7],'w',[0.7 0.7 0.7]};


% Set marker colors
%Use pharmacology colors
%{
seed_colors_pharma = [0 0 0;
                1 0.6 0;
                0.8 0 0;
                0   0   1];
all_colors_pharma = seed_map(seed_colors_pharma,4);
opts.markeredgecolor = {all_colors_pharma(1,:),...
                        all_colors_pharma(2,:),...
                        all_colors_pharma(3,:),...
                        all_colors_pharma(4,:)};
%}

%Use cell marker color
%
cell_marker_color = true;
seed_colors = [1 0 0;
                1 0.5 0.2;
                0.4 1 0.4;
                0.2 0.5 1;
                0 0 1];

all_colors = seed_map(seed_colors,numel(fltr_ONidx));

%}

for ii = 1:numel(curr_cells)
    curr_cell = curr_cells(ii);
    lim_x = all_lim_x{ii};
    if ii == round(numel(curr_cells)/2)
        if plot_amp
            opts.YLabel = "Peak (\Deltaspk/s)";
        else
            opts.YLabel = "\DeltaSpikes (n)";
        end
    end

    % if ii == numel(curr_cells)
    %     opts.XTickLabel = xtick_labels;
    % end
    opts.YRulerVis = "on";

    %Set color based on cell
    if cell_marker_color
        opts.markeredgecolor = repmat({all_colors(curr_cell,:)},1,4);
        % opts.line_color = all_colors(curr_cell,:);
    end

    for input_idx = 1:5
        %Set right ax pos
        pos_ax = [all_left_edge(input_idx) all_bottom_edge(ii)...
            base_width graph_height];


        %Get correct data
        if plot_amp
            %Amplitude
            all_pharma_line_par = {all_pharma_slow_amp1{input_idx}(select_cells(curr_cell)),...
                all_pharma_slow_amp2{input_idx}(select_cells(curr_cell)),...
                all_pharma_slow_amp3{input_idx}(select_cells(curr_cell)),...
                all_pharma_slow_amp4{input_idx}(select_cells(curr_cell))};
        else
            %n_spikse
            all_pharma_line_par = {all_pharma_n_spikes1{input_idx}(select_cells(curr_cell)),...
                all_pharma_n_spikes2{input_idx}(select_cells(curr_cell)),...
                all_pharma_n_spikes3{input_idx}(select_cells(curr_cell)),...
                all_pharma_n_spikes4{input_idx}(select_cells(curr_cell))};
        end
        
        %Make plot with different markers
        [ax_pharm_typline{ii,input_idx}] = UBC_par_marker_plot(...
            [all_pharma_line_par{:}],f_burst_pharma,pos_ax,opts);
        
        
        % [ax_pharm_typline{ii,input_idx}] = UBC_par_line_plot2(...
        %     1,[],all_pharma_line_par,f_burst_pharma,pos_ax,...
        %     opts);
        % 
        % ax_pharm_typline{ii,input_idx}.Children.Color = 'k';

        opts.YLabel = "";
        opts.YRulerVis = "off";

        if ii == 1
            title(ax_pharm_typline{ii,input_idx},all_titles{input_idx})
        end
    end
    same_ylim(ax_pharm_typline(ii,:))
end

%Reduce number of YTicks in all panels
% for ii = 1:numel(ax_pharm_typline)
%     ax_pharm_typline{ii}.YTick(2:2:end) = [];
% end

% 
% dummy_opts = struct();
% dummy_opts.markerfacecolor = {'w',[0.7 0.7 0.7],'w',[0.7 0.7 0.7]};
% dummy_ax = UBC_par_marker_plot([1 1 1 1],f_burst_pharma,[2 2 0.2 0.2],...
%     dummy_opts);
% 
% legend_labels = {'Baseline','−mGluR2','−AMPAR','−mGluR1'};
% legend(flipud(dummy_ax.Children(1:end-1)),legend_labels,...
%     'Orientation','horizontal',...
%     'Box', 'off',...
%     'NumColumns',2,...
%     'Units','normalized',...
%     'Position', [0.6327 0.9435 0.3319 0.0459])

%Tweak figure
fig_opts = struct();
fig_opts.FontSize = 10;
standardFig(f_burst_pharma,fig_opts);