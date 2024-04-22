% f_train_pharma = figure('Position', [488 1.8000 680.3150 857.9636],...
%     'Color','w');

select_cells = fltr_ONidx_tpharma;

y_labels_on = false;

%Set axis position
num_rows = 4;

pos_bottom = 0.368;
pos_top = 0.619;
pos_height = pos_top - pos_bottom;
% pos_left = 0.1;
% full_width = 0.55;
pos_left = 0.1966;
full_width = 0.5334;
base_space = 0.01;

% pos_left2 = 0.6722;
% base_width2 = 0.2921;
pos_left2 = 0.7466;
base_width2 = 0.2177;



base_height = (pos_height - base_space * (num_rows-1)) / num_rows;

all_bottom_edges = (base_height + base_space) .* (0:(num_rows-1)) + pos_bottom;
all_bottom_edges = fliplr(all_bottom_edges);

curr_traces = all_mean_trains_pharma;
for ii = 1:numel(curr_traces)
    curr_traces{ii} = cellfun(@(x) {medfilt1(x,Fs*0.02)},curr_traces{ii});
    %Truncate longer traces
    curr_traces{ii} = cellfun(@(x) {x(1:800001)},curr_traces{ii});
    curr_traces{ii} = vertcat(curr_traces{ii}{:});
end


%Normalize per cell based on-mGluR2 highest protocol
% norm_on = max([curr_traces{2}],[],2);
norm_on = max(medfilt1(curr_traces{2},Fs*0.11,[],2),[],2);

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
opts.XLim = [0 36];
opts.XLabel = '';
opts.XTick = [0:10:40];
opts.XTickLabel = '';
if ~y_labels_on
    opts.YTick = [];
    opts.YLabel = '';
end

opts2 = opts;
opts2.XLim = [27.5 31];
opts2.XTick = [28:31];
opts2.YTick = [];
opts2.YLabel = '';

ax_pharm_sp_hm = {};
ax_pharm_sp_hm2 = {};
for ii = 1:num_rows
    %Define current washin data
    curr_plot_data = curr_traces{ii};

    %Set more options
    if y_labels_on
    opts.YLabel = ['\color[rgb]{',num2str(all_colors_pharma(ii,:)),'}',...
                    all_row_labels{ii},'\newline\color{black}Cell (#)'];
    end

    if ii == num_rows
        opts.XTickLabel = arrayfun(@num2str,opts.XTick,'UniformOutput',false);
        opts.XLabel = 'Time (s)';

        opts2.XTickLabel = arrayfun(@num2str,opts2.XTick,'UniformOutput',false);
        % opts2.XLabel = 'Time (s)';
    end


    %Normalize data
    [norm_traces] = norm_UBC(curr_plot_data,norm_on,norm_off,norm_OFFidx);
    norm_traces = norm_traces(select_cells,:);

    %Setup axis
    pos_ax = [pos_left,   all_bottom_edges(ii),...
        full_width    base_height];

    ax_pharm_sp_hm{ii} = axes(f_train_pharma,'Position',pos_ax);

    %Plot heatmap
    makeUBCHeatmap(ax_pharm_sp_hm{ii}, norm_traces, Fs, opts);
    
    %add stim onset line
    hold(ax_pharm_sp_hm{ii},'on')
    for curr_step_time = train5_step_times(2:8)
        line(ax_pharm_sp_hm{ii},repmat(curr_step_time*Fs,1,2),...
            ax_pharm_sp_hm{ii}.YLim,'Color',[1 0 0],'LineWidth',0.5,'LineStyle',':')
    end
    hold(ax_pharm_sp_hm{ii},'off')

    %plot zoom in
    %setup axes and plot
    pos_ax2 = [pos_left2   all_bottom_edges(ii)    base_width2    base_height];
    ax_pharm_sp_hm2{ii} = axes(f_train_pharma,'Position',pos_ax2);

    makeUBCHeatmap(ax_pharm_sp_hm2{ii}, norm_traces, Fs, opts2);

    hold(ax_pharm_sp_hm2{ii},'on')

    line(ax_pharm_sp_hm2{ii},repmat(train5_step_times(7)*Fs,1,2),...
        ax_pharm_sp_hm2{ii}.YLim,'Color',[1 0 0],'LineWidth',0.5,'LineStyle',':')
    line(ax_pharm_sp_hm2{ii},repmat((train5_step_times(7)+1)*Fs,1,2),...
        ax_pharm_sp_hm2{ii}.YLim,'Color',[1 0 0],'LineWidth',0.5,'LineStyle',':')
    hold(ax_pharm_sp_hm2{ii},'off')


end

