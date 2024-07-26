% f_train_cpp = figure('Position', [488 1.8000 680.3150 857.9636],...
%     'Color','w');

select_cells = fltr_ONidx_tcpp;


%Set axis position
num_rows = 2;

pos_bottom = 0.368;
pos_top = 0.619;
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
% curr_traces = all_mean_pharma_bursts;
% curr_traces = cellfun(@(x) {x{5}},curr_traces);
curr_traces = {all_mean_cpp_bursts1{5},all_mean_cpp_bursts2{5}};


curr_train_traces = all_mean_trains_cpp;
for ii = 1:numel(curr_train_traces)
    curr_train_traces{ii} = cellfun(@(x) {medfilt1(x,Fs*0.02)},curr_train_traces{ii});
    %Truncate longer traces
    curr_train_traces{ii} = cellfun(@(x) {x(1:800001)},curr_train_traces{ii});
    curr_train_traces{ii} = vertcat(curr_train_traces{ii}{:});
end


%Normalize per cell based on-baseline highest protocol
% norm_on = max([curr_train_traces{2}],[],2);
norm_on = max(medfilt1(curr_traces{1},Fs*0.16,[],2),[],2);

%Same normalization for OFFs
norm_off = [];
norm_OFFidx = [];


all_row_labels = {'Baseline','−NMDAR'};
seed_colors_pharma = [0 0 0;
                1 0.0 0.9];
all_colors_pharma = seed_map(seed_colors_pharma,2);

opts = struct();
opts.XLim = [0 3.5];
opts.XLabel = '';
opts.XTick = [0.5:2:3.5];
opts.XTickLabel = '';



ax_cpp_sp_burst_hm = {};
for ii = 1:num_rows
    %Define current washin data
    curr_plot_data = curr_traces{ii};

    %Set more options
    % opts.YLabel = ['\color[rgb]{',num2str(all_colors_pharma(ii,:)),'}',...
    %                 all_row_labels{ii},'\newline\color{black}Cell (#)'];
    opts.YLabel = {all_row_labels{ii},'Cell #'};
    

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

    ax_cpp_sp_burst_hm{ii} = axes(f_train_cpp,'Position',pos_ax);

    %Plot heatmap
    makeUBCHeatmap(ax_cpp_sp_burst_hm{ii}, norm_traces, Fs, opts);
    
    %add stim onset line
    hold(ax_cpp_sp_burst_hm{ii},'on')
    line(ax_cpp_sp_burst_hm{ii},repmat(ax_cpp_sp_burst_hm{ii}.XTick(1),1,2),...
        ax_cpp_sp_burst_hm{ii}.YLim,'Color',[1 0 0],'LineWidth',0.5,'LineStyle',':')
    hold(ax_cpp_sp_burst_hm{ii},'off')

end



for ii = 1:2
    if exist("typ_cell_num","var")
        [hm_ax] = heatmap_markers(ax_cpp_sp_burst_hm{ii},typ_cell_num);
    else
        [hm_ax] = heatmap_markers(ax_cpp_sp_burst_hm{ii},[4 6]);
    end
end

%Fix label position
ax_cpp_sp_burst_hm{1}.YLabel.Units = "pixels";
ax_cpp_sp_burst_hm{1}.YLabel.Position(1) = -15;
ax_cpp_sp_burst_hm{2}.YLabel.Units = "pixels";
ax_cpp_sp_burst_hm{2}.YLabel.Position(1) = -15;
