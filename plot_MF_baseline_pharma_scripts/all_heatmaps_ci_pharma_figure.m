

% f_base_pharma_hmsupp = figure('Position', [488 1.8000 680.3150 857.9636],...
%     'Color','w');


all_XLim = {[0 11],[0 11],[0 11]};
diff_lim_x = cellfun(@diff, all_XLim);


%Define axes pos
num_cols = 3; %Number of different protocols
num_rows = 4; %Number of washins

left_edge = 0.1;
bottom_edge = 0.07;
total_width = 0.85;
total_height = 0.88;
base_gap = 0.03;

%X Lim adjusted graph widths
base_width = (total_width - base_gap * (num_cols-1)) / sum(diff_lim_x);
graph_widths = base_width .* diff_lim_x;

graph_height = (total_height - base_gap * (num_rows-1)) / num_rows;

all_left_edges = ([0 cumsum(graph_widths(1:end-1) + base_gap)]) + left_edge;
all_bottom_edges = (graph_height + base_gap) .* (0:num_rows-1) + bottom_edge;
all_bottom_edges = fliplr(all_bottom_edges);


%Gather all data
all_mean_pharma_ci_all = {all_full_pharma_base1,...
                              all_full_pharma_base2,...
                              all_full_pharma_base3,...
                              all_full_pharma_base4};

all_preprot_pharma_ci_all = {all_preprot_base_pharma_base1,...
                                all_preprot_base_pharma_base2,...
                                all_preprot_base_pharma_base3,...
                                all_preprot_base_pharma_base4};

%Concatenate and fill zeros
for ii = 1:numel(all_mean_pharma_ci_all)
    [all_mean_pharma_ci_all{ii}] = concat_inst_freqs(all_mean_pharma_ci_all{ii},...
        all_preprot_pharma_ci_all{ii},Fs);
end


%Normalize per cell based on-mGluR2 1 Hz
% norm_on = max(all_mean_pharma_ci_all{2}{1},[],2);

%Normalize per cell based on-mGluR2 highest protocol
norm_on = max([all_mean_pharma_ci_all{2}{:}],[],2);

%Normalize per cell per protocol based on-mGluR2
per_prot_norm = false;
all_norm_on = cell(1,num_cols);
for ii = 1:num_cols
    all_norm_on{ii} = max(all_mean_pharma_ci_all{2}{ii},[],2);
end

%Same normalization for OFFs
norm_off = [];
norm_OFFidx = [];


ax_pharm_hm = {};

%Setup basic plot options
all_titles = {'1 Hz', '2.5 Hz', '5 Hz'};

all_row_labels = {'Baseline','−mGluR2','−AMPAR','−mGluR1'};
seed_colors_pharma = [0 0 0;
                1 0.6 0;
                0.8 0 0;
                0   0   1];
all_colors_pharma = seed_map(seed_colors_pharma,4);

opts = struct();
opts.XTick = 1:5:21;
opts.XTickLabel = '';


%Loop over washins
for ii = 1:num_rows
    %Define current washin data
    curr_mean_pharma_bursts = all_mean_pharma_ci_all{ii};
    
    %Set more options
    opts.YLabel = ['\color[rgb]{',num2str(all_colors_pharma(ii,:)),'}',...
                    all_row_labels{ii},'\newline\color{black}Cell (#)'];
    opts.YTick = false;
    if ii == num_rows
        opts.XTickLabel = arrayfun(@num2str,opts.XTick-1,'UniformOutput',false);
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

        ax_pharm_hm{ii,jj} = axes(f_base_pharma_hmsupp,'Position',pos_ax);

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
        

        %Plot heatmap
        makeUBCHeatmap(ax_pharm_hm{ii,jj}, norm_traces, Fs, opts);
        

        %Add titles
        if ii == 1
            title(ax_pharm_hm{ii,jj},all_titles{jj})
        end

    end
end



