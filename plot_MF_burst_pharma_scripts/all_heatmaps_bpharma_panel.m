% f_burst_pharma = figure('Position', [488 1.8000 680.3150 857.9636],...
%     'Color','w');


all_XLim = {[0.2 1.5],[0.2 1.5], [0.2 1.5], [0.2 1.5], [0.2 2.5]};
diff_lim_x = cellfun(@diff, all_XLim);


%Define axes pos
num_cols = 5; %Number of different protocols
num_rows = 4; %Number of washins

left_edge = 0.1;
% bottom_edge = 0.07;
bottom_edge = 0.3020;
total_width = 0.77;
% total_height = 0.88;
total_height = 0.308;
base_gap = 0.01;

%X Lim adjusted graph widths
base_width = (total_width - base_gap * (num_cols-1)) / sum(diff_lim_x);
graph_widths = base_width .* diff_lim_x;

graph_height = (total_height - base_gap * (num_rows-1)) / num_rows;

all_left_edges = ([0 cumsum(graph_widths(1:end-1) + base_gap)]) + left_edge;
all_bottom_edges = (graph_height + base_gap) .* (0:num_rows-1) + bottom_edge;
all_bottom_edges = fliplr(all_bottom_edges);



%Gather all data
all_mean_pharma_bursts_all = {all_mean_pharma_bursts1,...
                              all_mean_pharma_bursts2,...
                              all_mean_pharma_bursts3,...
                              all_mean_pharma_bursts4};



%Normalize per cell based on-mGluR2/3
% norm_on = max(all_mean_pharma_bursts_all{2}{5},[],2);
norm_on = max(medfilt1(all_mean_pharma_bursts_all{2}{5},Fs*0.16,[],2),[],2);

%Normalize per cell per protocol based on-mGluR2/3
per_prot_norm = false;
all_norm_on = cell(1,5);
for ii = 1:5
    all_norm_on{ii} = max(all_mean_pharma_bursts_all{2}{ii},[],2);
end

%Same normalization for OFFs
norm_off = [];
norm_OFFidx = [];


ax_pharm_hm = {};

%Setup basic plot options
% all_titles = {'1x', '2x 100 Hz', '5x 100 Hz', '10x 100 Hz', '20x 100 Hz'};
all_titles = {'1' '2' '5' '10' '20'};


all_row_labels = {{'Baseline'},{'mGluR2/3','block'},{'+ AMPAR','block'},{'+ mGluR1','block'}};
seed_colors_pharma = [0 0 0;
                1 0.6 0;
                0.8 0 0;
                0   0   1];
all_colors_pharma = seed_map(seed_colors_pharma,4);

opts = struct();
opts.XTick = 0.5:1:20.5;
opts.XTickLabel = '';


%Loop over washins
for ii = 1:num_rows
    %Define current washin data
    curr_mean_pharma_bursts = all_mean_pharma_bursts_all{ii};
    
    %Set more options
    % opts.YLabel = ['\color[rgb]{',num2str(all_colors_pharma(ii,:)),'}',...
    %                 all_row_labels{ii},'\newline\color{black}Cell #'];

    % opts.YLabel = {[all_row_labels{ii},'\newline'],...
    %                 'Cell #'};
    opts.YLabel = 'Cell #';
    opts.YTick = false;
    if ii == num_rows
        opts.XTickLabel = arrayfun(@num2str,opts.XTick-0.5,'UniformOutput',false);
    end

    %Loop over stim protocols
    for jj = 1:num_cols
        %Define current stim protocol data
        curr_mean_pharma_prot = curr_mean_pharma_bursts{jj};
        
        %Normalize data
        if per_prot_norm
            norm_on = all_norm_on{jj};
        end

        [norm_traces] = norm_UBC(curr_mean_pharma_prot,norm_on,norm_off,norm_OFFidx);
        norm_traces = norm_traces(fltr_ONidx,:);

        %Setup axis
        pos_ax = [all_left_edges(jj),   all_bottom_edges(ii),...
            graph_widths(jj)    graph_height];

        ax_pharm_hm{ii,jj} = axes(f_burst_pharma,'Position',pos_ax);

        %Setup current plot options
        opts.XLim = all_XLim{jj};        
        if jj == 2
            opts.YTick = [];
            opts.YLabel = '';
        end

        opts.XLabel = '';
        if ii == num_rows && jj == round(num_cols/2)
            opts.XLabel = 'Time (s)';
        end
        if ii == num_rows && jj == num_cols
            opts.colorbar = false;
        else
            opts.colorbar = false;
        end

        %Plot heatmap
        makeUBCHeatmap(ax_pharm_hm{ii,jj}, norm_traces, Fs, opts);
        
        %Add stim start line
        hold(ax_pharm_hm{ii,jj},'on')
        line(ax_pharm_hm{ii,jj},repmat(ax_pharm_hm{ii,jj}.XTick(1),1,2),...
            ax_pharm_hm{ii,jj}.YLim,'Color',[1 0.0 0],'LineWidth',1,'LineStyle',':')
        hold(ax_pharm_hm{ii,jj},'off')

        %Add titles
        if ii == 1
            title(ax_pharm_hm{ii,jj},all_titles{jj})
        end

    end

    %Add row label

    % row_label = text(ax_pharm_hm{ii,jj},0,0,all_row_labels{ii},...
    %     'FontSize',10,'FontName','Arial','VerticalAlignment','middle',...
    %     'HorizontalAlignment','center','Units','normalized');
    % row_label.Position = [1.25 0.5 0];

end


%Add washin label
% if y_labels_on
plus_offset = 16.5;
for jj = 1:4
    % curr_label = ['\color[rgb]{',num2str(all_colors_pharma(jj,:)),'}',...
    %             all_row_labels{jj}];
    curr_label = all_row_labels{jj};

    if numel(curr_label) == 1
        curr_t = text(ax_pharm_hm{jj,end},1,0.5,curr_label,...
            'Units','normalized',...
            'Position',[1 0.5 0],'VerticalAlignment','middle',...
            'HorizontalAlignment','left');
        curr_t.Units = 'pixels';
        curr_t.Position(1) = curr_t.Position(1)+plus_offset;
        curr_t.Units = 'normalized';
    else
        curr_t1 = text(ax_pharm_hm{jj,end},1,0.5,curr_label{1},...
            'Units','normalized',...
            'Position',[1 0.5 0],'VerticalAlignment','bottom',...
            'HorizontalAlignment','left');
        curr_t2 = text(ax_pharm_hm{jj,end},1,0.5,curr_label{2},...
            'Units','normalized',...
            'Position',[1 0.5 0],'VerticalAlignment','top',...
            'HorizontalAlignment','left');

        curr_t1.Units = 'pixels';
        curr_t2.Units = 'pixels';
        curr_t1.Position(2) = curr_t1.Position(2)-2.5;
        curr_t2.Position(2) = curr_t2.Position(2)+2.5;

        if strcmp(curr_label{1}(1),'+')
            curr_t1.Position(1) = curr_t1.Position(1)+5;
        else
            curr_t1.Position(1) = curr_t1.Position(1)+plus_offset;
        end
        curr_t2.Position(1) = curr_t2.Position(1)+plus_offset;
        curr_t1.Units = 'normalized';
        curr_t2.Units = 'normalized';

    end
end


for ii = 1:4
    if exist("curr_cells","var")
        [hm_ax] = heatmap_markers(ax_pharm_hm{ii,1},curr_cells);
    else
        [hm_ax] = heatmap_markers(ax_pharm_hm{ii,1},[8    10    13    18    24]);
    end
end


%Fix label position
for ii = 1:4
    ax_pharm_hm{ii,1}.YLabel.Units = "pixels";
    ax_pharm_hm{ii,1}.YLabel.Position(1) = -17;
end

ax_pharm_hm{4,3}.XLabel.Units = "pixels";
ax_pharm_hm{4,3}.XLabel.Position(1:2) = [53 -12];



% Tweak figure
% fig_opts = struct();
% fig_opts.FontSize = 10;
% standardFig(f_burst_pharma,fig_opts);