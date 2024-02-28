%% Typical examples script
% % 
% f_burst_pharma = figure('Position', [488 1.8000 680.3150 857.9636],...
%     'Color','w');

% curr_cells = [5, 9, 13, 18, 24];
% typ_cell_IDs = {'1686','1694','1776','1774','1709'};

% curr_cells = [8, 10, 13, 18, 24];
typ_cell_IDs = {'1657','1668','1776','1774','1709'};
[typ_cell_idxs,curr_cells] = UBC_cell_ID2idx(fileNames(washin_fltr),typ_cell_IDs,fltr_ONidx);




% all_lim_x = {[-0.21 0.7], [-0.6 2], [-1.5 5]};

all_lim_x = {[-0.3 1], [-0.3 1], [-0.3 1],[-0.3 1],[-0.3 2]};
diff_lim_x = cellfun(@diff,all_lim_x);

num_rows = numel(curr_cells);
num_cols = 5; %Number of burst types

left_edge = 0.08;
top_edge = 0.92;
total_height = 0.28;
total_width = 0.3489;
height_space = 0.015;
base_space = 0.01;


bottom_edge = top_edge - total_height;



graph_height = (total_height - height_space*(num_rows-1)) / num_rows;
% base_width = (total_width - base_space*(num_cols-1)) / num_cols;
%Width based on xlim
base_width = (total_width - base_space*(num_cols-1)) /  sum(diff_lim_x);



% all_left_edge = (base_width + base_space) .* (0:(num_cols-1)) + left_edge;
%Width based on xlim
all_left_edge = [0 cumsum(base_width .* diff_lim_x(1:end-1))...
    + base_space .* (1:(num_cols-1))] + left_edge;

all_bottom_edge = (graph_height + height_space) .* (0:(num_rows-1)) + bottom_edge;
all_bottom_edge = fliplr(all_bottom_edge);




select_cells = fltr_ONidx;




all_x_scales = [0.2 1 2];


seed_colors_pharma = [0 0 0;
                1 0.6 0;
                0.8 0 0;
                0   0   1];


all_colors_pharma = seed_map(seed_colors_pharma,4);

trace_labels = {'Baseline','−mGluR2','−AMPAR','−mGluR1'};
all_titles = {'1x' '2x' '5x' '10x' '20x'};

opts = struct();
opts.axis_off = true;

ax_pharm_typ = {};

for ii = 1:numel(curr_cells)
    curr_cell = curr_cells(ii);
    % lim_x = all_lim_x{ii};

    for pharm_burst_idx = 1:5
        lim_x = all_lim_x{pharm_burst_idx};

        pos_ax = [all_left_edge(pharm_burst_idx) all_bottom_edge(ii)...
            base_width*diff_lim_x(pharm_burst_idx) graph_height];


        trace_array = {all_mean_pharma_bursts1{pharm_burst_idx},...
            all_mean_pharma_bursts2{pharm_burst_idx},...
            all_mean_pharma_bursts3{pharm_burst_idx},...
            all_mean_pharma_bursts4{pharm_burst_idx}};




        [ax_pharm_typ{ii,pharm_burst_idx}] = plot_burst_traces_overlay(trace_array,Fs,...
            select_cells,curr_cell,all_colors_pharma,repmat(0.5,1,4),...
            [],lim_x,f_burst_pharma,pos_ax,opts);

        ylabel(['Cell #',num2str(curr_cell),'\newlineResponse (spk/s)'])

        if ii == 1
            title(all_titles{pharm_burst_idx})
        end


        opts.scale_xlabel = [];
        opts.scale_ylabel = [];
    end

    text(ax_pharm_typ{ii,1},0,0,['Cell\newline#',num2str(curr_cell)],'Units','normalized',...
                'Position',[-0.01 0.5],'VerticalAlignment','middle',...
                'HorizontalAlignment','right')

    same_ylim(ax_pharm_typ(ii,:))

    

end

scale_opts = struct();
scale_opts.xlabel = 's';
scale_opts.origin = [1 14];
% scale_opts.xscale_factor = 1e3;
% scale_opts.ylabel = 'spk/s';
add_scale_bar(ax_pharm_typ{ii,end},[1 0],scale_opts);

% legend_labels = {'Baseline','−mGluR2','−AMPAR','−mGluR1'};
% legend(ax_pharm_typ{1,3},legend_labels,...
%     'Orientation','horizontal',...
%     'Box', 'off',...
%     'NumColumns',2,...
%     'Units','normalized',...
%     'Position', [0.1452 0.9435 0.3319 0.0459])
% legend_labels = {'1: Baseline','2: −mGluR2','3: −AMPAR','4: −mGluR1'};


%Separate text labels for legend
%{
legend_positions = {[-186.6364 -33.0378 0],...
        [-104.0764 -33.0378 0],...
        [-21.5164 -33.0378 0],...
        [61.0436 -33.0378 0]};


for ii = 1:numel(legend_labels)
    text(ax_pharm_typ{end,end},0,0,legend_labels{ii},...
        'Units','pixels',...
        'HorizontalAlignment','center',...
        'Position',legend_positions{ii})

end
%}


