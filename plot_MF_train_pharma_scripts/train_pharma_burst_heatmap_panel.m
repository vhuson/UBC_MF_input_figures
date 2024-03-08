% f_train_pharma = figure('Position', [488 1.8000 680.3150 857.9636],...
%     'Color','w');

select_cells = fltr_ONidx_tpharma;


%Set axis position
num_rows = 4;

pos_bottom = 0.28;
pos_top = 0.565;
pos_height = pos_top - pos_bottom;
pos_left = 0.1;
full_width = 0.08;
% pos_left = 0.21;
% full_width = 0.52;
base_space = 0.01;




base_height = (pos_height - base_space * (num_rows-1)) / num_rows;

all_bottom_edges = (base_height + base_space) .* (0:(num_rows-1)) + pos_bottom;
all_bottom_edges = fliplr(all_bottom_edges);


%Gather data
curr_traces = all_mean_pharma_bursts;
curr_traces = cellfun(@(x) {x{5}},curr_traces);

curr_train_traces = all_mean_trains_pharma;
for ii = 1:numel(curr_train_traces)
    curr_train_traces{ii} = cellfun(@(x) {medfilt1(x,Fs*0.02)},curr_train_traces{ii});
    curr_train_traces{ii} = vertcat(curr_train_traces{ii}{:});
end


%Normalize per cell based on-mGluR2 highest protocol
norm_on = max([curr_train_traces{2}],[],2);

%Same normalization for OFFs
norm_off = [];
norm_OFFidx = [];


all_row_labels = {'Baseline','−mGluR2','−AMPAR','−mGluR1'};
seed_colors_pharma = [0 0 0;
                1 0.6 0;
                0.8 0 0;
                0   0   1];
all_colors_pharma = seed_map(seed_colors_pharma,4);

opts = struct();
opts.XLim = [0 2.5];
opts.XLabel = '';
opts.XTick = [0.5:2:3.5];
opts.XTickLabel = '';



ax_pharm_sp_burst_hm = {};
for ii = 1:num_rows
    %Define current washin data
    curr_plot_data = curr_traces{ii};

    %Set more options
    opts.YLabel = ['\color[rgb]{',num2str(all_colors_pharma(ii,:)),'}',...
                    all_row_labels{ii},'\newline\color{black}Cell (#)'];
    

    if ii == num_rows
        opts.XTickLabel = arrayfun(@num2str,opts.XTick-0.5,'UniformOutput',false);
        % opts.XLabel = 'Time (s)';
    end


    %Normalize data
    [norm_traces] = norm_UBC(curr_plot_data,norm_on,norm_off,norm_OFFidx);
    norm_traces = norm_traces(select_cells,:);

    %Setup axis
    pos_ax = [pos_left,   all_bottom_edges(ii),...
        full_width    base_height];

    ax_pharm_sp_burst_hm{ii} = axes(f_train_pharma,'Position',pos_ax);

    %Plot heatmap
    makeUBCHeatmap(ax_pharm_sp_burst_hm{ii}, norm_traces, Fs, opts);
    
    %add stim onset line
    hold(ax_pharm_sp_burst_hm{ii},'on')
    line(ax_pharm_sp_burst_hm{ii},repmat(ax_pharm_sp_burst_hm{ii}.XTick(1),1,2),...
        ax_pharm_sp_burst_hm{ii}.YLim,'Color',[1 0 0],'LineWidth',0.5,'LineStyle',':')
    hold(ax_pharm_sp_burst_hm{ii},'off')

end



for ii = 1:4
    if exist("curr_cells","var")
        [hm_ax] = heatmap_markers(ax_pharm_sp_burst_hm{ii},typ_cell_num);
    else
        [hm_ax] = heatmap_markers(ax_pharm_sp_burst_hm{ii},[4 6]);
    end
end
