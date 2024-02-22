% f_burst_pharma = figure('Position', [488 1.8000 680.3150 857.9636],...
%     'Color','w');

% Which cells to plot
% typ_cell_IDs = {'1686','1694','1774'};
% [typ_cell_idxs,curr_cells] = UBC_cell_ID2idx(fileNames(washin_fltr),typ_cell_IDs,fltr_ONidx);
% curr_cells = [5, 9, 18];

plot_amp = true;

%Set up axes positions
num_rows = numel(curr_cells);
num_cols = 5; %Number of burst types

left_edge = 0.55;
top_edge = 0.96;
total_height = 0.3;
total_width = 0.375;
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
% xtick_labels = {'Baseline','−mGluR2','−AMPAR','−mGluR1'};
xtick_labels = {'1','2','3','4'};
all_titles = {'1x' '2x' '5x' '10x' '20x'};

ax_pharm_typline = {};

opts = struct('input_n',[1 2 3 4],'XLabel','','XTickLabel',[]);

for ii = 1:numel(curr_cells)
    curr_cell = curr_cells(ii);
    lim_x = all_lim_x{ii};
    if ii == round(numel(curr_cells)/2)
        if plot_amp
            opts.YLabel = "Peak (\Deltaspk/s)";
        else
            opts.YLabel = "#Spikes (n)";
        end
    end

    if ii == numel(curr_cells)
        opts.XTickLabel = xtick_labels;
    end
    opts.YRulerVis = "on";
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


        [ax_pharm_typline{ii,input_idx}] = UBC_par_line_plot2(...
            1,[],all_pharma_line_par,f_burst_pharma,pos_ax,...
            opts);

        ax_pharm_typline{ii,input_idx}.Children.Color = 'k';

        opts.YLabel = "";
        opts.YRulerVis = "off";

        if ii == 1
            title(ax_pharm_typline{ii,input_idx},all_titles{input_idx})
        end
    end
    same_ylim(ax_pharm_typline(ii,:))
end

cellfun(@(x) set(x,'XTickLabelRotation',0),ax_pharm_typline(3,:))
