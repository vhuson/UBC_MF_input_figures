% f_base_pharma = figure('Position', [488 1.8000 680.3150 857.9636],...
%     'Color','w');

%Get right cell idxes
% typ_cell_IDs = {'1701','1672'};
typ_cell_IDs = {'1701','1807'};
[typ_cell_idxs,curr_cells] = UBC_cell_ID2idx(fileNames(washin_fltr),typ_cell_IDs,fltr_ONidx_baseline);

% curr_cells = [1, 20];

%Xlim 
all_XLim = {[-1 10],[-1 10],[-1 10]};
diff_lim_x = cellfun(@diff, all_XLim);

%Define axis positions
num_cols = 3; %Number of different protocols
num_rows = 4 * numel(curr_cells); %Number of washins * number of cells to plot

left_edge = 0.08;
bottom_edge = 0.96-(0.96-0.6050)*0.8596;
top_edge = 0.96;
ax_space = 0.01/1.1829;
ax_space_v = 0.025*0.8596;
cell_space = 0.03*0.8596;
total_width = 0.56/1.1829;

base_height = (top_edge - bottom_edge) - ax_space_v * (num_rows-1)...
                                - cell_space * (numel(curr_cells)-1);
base_height = base_height/num_rows;

%Base width standardized to xlim
base_width = (total_width-ax_space*(num_cols-1))...
                /sum(diff_lim_x);

all_base_widths = base_width .* diff_lim_x;

all_left_edges = [0 cumsum(all_base_widths(1:end-1)+ax_space)] + left_edge;

all_bottom_edges = (base_height+ax_space_v) .* (0:(num_rows-1)) + bottom_edge;
all_bottom_edges = all_bottom_edges + cell_space .* (ceil(0.25:0.25:numel(curr_cells))-1);
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
        all_preprot_pharma_ci_all{ii},Fs,struct('use_median',true));

    
end

%Plot options
% all_colors = bbpr(3);
all_colors = zeros(3,3);
opts = struct();
opts.axis_off = true;

all_titles = {'1 spk/s', '2.5 spk/s', '5 spk/s'};

% all_row_labels = {'Baseline','−mGluR2','−AMPAR','−mGluR1'};
all_row_labels = {'Baseline','mGluR2/3 block','AMPAR block','mGluR1 block'};
seed_colors_pharma = [0 0 0;
                1 0.6 0;
                0.8 0 0;
                0   0   1];
all_colors_pharma = seed_map(seed_colors_pharma,4);


% loop over all cells
ax_basep_typ = {};
for ii = 1:numel(curr_cells)
    curr_cell = curr_cells(ii);

    %Loop over washins
    for jj = 1:(num_rows/numel(curr_cells))
        curr_prot_traces = all_mean_pharma_ci_all{jj};

        %Loop over protocols
        for kk = 1:num_cols
            %Plot options
            lim_x = all_XLim{kk};
            
            %Row position
            row_idx = jj+(num_rows/numel(curr_cells)*(ii-1));

            %Set axis position
            pos_ax = [all_left_edges(kk),...
                all_bottom_edges(row_idx),...
                all_base_widths(kk), base_height];



            %Plot
            [ax_basep_typ{row_idx,kk}] = plot_burst_traces_overlay(...
                curr_prot_traces(kk),Fs,...
                fltr_ONidx_baseline,curr_cell,all_colors(kk,:),1,...
                [],lim_x,f_base_pharma,pos_ax,opts);

            %Add 0 line
            hold(ax_basep_typ{row_idx,kk},'on')
            plot(ax_basep_typ{row_idx,kk},[ax_basep_typ{row_idx,kk}.XLim],[0 0],...
                'Color',[0.7 0.7 0.7],'LineStyle','--')
            hold(ax_basep_typ{row_idx,kk},'off')

            axis tight
            ax_basep_typ{row_idx,kk}.XLim = lim_x;

            ax_basep_typ{row_idx,kk}.Children = [ax_basep_typ{row_idx,kk}.Children(2:end);...
                                            ax_basep_typ{row_idx,kk}.Children(1)];
            %Add title
            if row_idx == 1
                title(ax_basep_typ{row_idx,kk},all_titles{kk})
            end
        end
        

        %Add washin label
        % curr_label = ['\color[rgb]{',num2str(all_colors_pharma(jj,:)),'}',...
        %             all_row_labels{jj}];
        % curr_t = text(ax_basep_typ{row_idx,1},0,0,curr_label,...
        %     'Units','normalized',...
        %     'Position',[0 0.01 0],'VerticalAlignment','top',...
        %     'HorizontalAlignment','left');
        % curr_t.Units = 'data';
        
        if curr_cell == curr_cells(ismember(typ_cell_IDs,'1672'))
            %Set smaller ylim
            ax_basep_typ{row_idx,kk}.YLim(2) = min([ax_basep_typ{row_idx,kk}.YLim(2),...
                30]);

        end

        same_ylim(ax_basep_typ(row_idx,:));
        
        if jj == 2
            if ii == 1
                label_string = {'Cell\newline',['#',num2str(curr_cell)]};
            else
                label_string = ['#',num2str(curr_cell)];
            end

            t_cell_label{ii} = text(ax_basep_typ{row_idx,1},0,0,label_string,'Units','normalized',...
                'Position',[-0.05 -0.1],'VerticalAlignment','middle',...
                'HorizontalAlignment','right');
        end

    end
end


scale_opts = struct();
scale_opts.xlabel = 's';
scale_opts.ylabel = 'spk/s';
scale_opts.xscale_factor = 1;
scale_opts.label_fontsize = 10;
all_origins = {[9 -60],[9 -65]};

cnt = 1;
for idx = 1:4:num_rows

    same_ylim(ax_basep_typ(idx+3,:));

    [all_graph_heights,all_bottoms] = axis_height_by_ylim(ax_basep_typ(idx:idx+3,1));

    for ii = 1:numel(all_graph_heights)
        for prot = 2:3
            ax_basep_typ{(idx-1)+ii,prot}.Position(2) = all_bottoms(ii);
            ax_basep_typ{(idx-1)+ii,prot}.Position(4) = all_graph_heights(ii);
        end
    end

    %Add scale bar to last
    scale_opts.origin = all_origins{cnt};
    add_scale_bar(ax_basep_typ{idx+3,end},[1,50],scale_opts);

    cnt = cnt+1;
end



%Fix label position
t_cell_label{2}.Position = [-0.0500   -0.9021         0];

