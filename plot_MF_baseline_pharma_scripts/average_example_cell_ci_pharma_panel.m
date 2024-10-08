% f_base_pharma = figure('Position', [488 1.8000 680.3150 857.9636],...
%     'Color','w');
% example_cell_ci_pharma_panel

%Get right cell idxes
% typ_cell_IDs = {'1701','1672'};
typ_cell_IDs = {'1701','1807'};
[typ_cell_idxs,curr_cells] = UBC_cell_ID2idx(fileNames(washin_fltr_base),typ_cell_IDs,fltr_ONidx_baseline);

% curr_cells = [1, 20];

%Xlim 
all_XLim = {[0 0.2],[0 0.2],[0 0.2]};
zerod_x = 0;
diff_lim_x = cellfun(@diff, all_XLim);

%Define axis positions
%Define axes pos
num_cols = 3; %Number of different protocols
num_rows = 4 * numel(curr_cells); %Number of washins * number of cells to plot

left_edge = 0.6890/1.1829;
bottom_edge = 0.96-(0.96-0.6050)*0.8596;
top_edge = 0.96;
ax_space = 0.01/1.1829;
ax_space_v = 0.025*0.8596;
cell_space = 0.03*0.8596;
total_width = 0.2900/1.1829;

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



%Gather all data  all_ss_pharma_base3
all_ss_pharma_base_all = {all_ss_pharma_base1,...
                            all_ss_pharma_base2,...
                            all_ss_pharma_base3,...
                            all_ss_pharma_base4};

% nan_mean_segments = all_ss_segments;
% for ii = 1:numel(nan_mean_segments)
%     nan_idx_mean_segments = nan_mean_segments{ii} == 0;
% 
%     if ~all(nan_idx_mean_segments)
%         nan_mean_segments{ii}(nan_idx_mean_segments) = NaN;
%     end
%     %Specifically maintain zeros in cell 51
%     % nan_mean_segments{ii}(48,:) = all_ss_segments{ii}(48,:);
% end



%Plot options
% all_colors = bbpr(3);
all_colors = zeros(3,3);
opts = struct();
opts.axis_off = true;

all_titles = {'1 spk/s', '2.5 spk/s', '5 spk/s'};

% all_row_labels = {'Baseline','−mGluR2','−AMPAR','−mGluR1'};
all_row_labels = {{'Baseline'},{'mGluR2/3','block'},{'+ AMPAR' 'block'},...
    {'+ mGluR1' 'block'}};

seed_colors_pharma = [0 0 0;
                1 0.6 0;
                0.8 0 0;
                0   0   1];
all_colors_pharma = seed_map(seed_colors_pharma,4);


% loop over all cells
ax_basep_avgtyp = {};
for ii = 1:numel(curr_cells)
    curr_cell = curr_cells(ii);

    %Loop over washins
    for jj = 1:(num_rows/numel(curr_cells))
        curr_prot_traces = all_ss_pharma_base_all{jj};

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
            
            [ax_basep_avgtyp{row_idx,kk}] = plot_burst_traces_overlay(...
                curr_prot_traces(kk),Fs,...
                fltr_ONidx_baseline,curr_cell,all_colors(kk,:),zerod_x,...
                [],lim_x,f_base_pharma,pos_ax,opts);

            %Add 0 line
            hold(ax_basep_avgtyp{row_idx,kk},'on')
            plot(ax_basep_avgtyp{row_idx,kk},lim_x,[0 0],...
                'Color',[0.7 0.7 0.7],'LineStyle','--')
            hold(ax_basep_avgtyp{row_idx,kk},'off')
            
            axis tight
            ax_basep_avgtyp{row_idx,kk}.XLim = lim_x;


            ax_basep_avgtyp{row_idx,kk}.Children = [ax_basep_avgtyp{row_idx,kk}.Children(2:end);...
                                            ax_basep_avgtyp{row_idx,kk}.Children(1)];

            %Add title
            if row_idx == 1
                if kk == 2
                    title(ax_basep_avgtyp{row_idx,kk},["Average response\newline",all_titles{kk}])
                else
                    title(ax_basep_avgtyp{row_idx,kk},all_titles{kk})
                end
            end
        end
        

    end
end




%Homogenize with previous panel
for ii = 1:numel(ax_basep_typ)
    %Set YLim
    ax_basep_avgtyp{ii}.YLim = ax_basep_typ{ii}.YLim;

    %Set Y Positions
    ax_basep_avgtyp{ii}.Position([2,4]) = ax_basep_typ{ii}.Position([2,4]);

end


scale_opts = struct();
scale_opts.xlabel = 'ms';
% scale_opts.ylabel = 'spk/s';
scale_opts.xscale_factor = 1000;
scale_opts.label_fontsize = 10;
all_origins = {[0.1 -60],[0.1 -65]};

cnt = 1;
for idx = 1:4:num_rows
    %Add scale bar to last
    scale_opts.origin = all_origins{cnt};
    add_scale_bar(ax_basep_avgtyp{idx+3,end},[0.1,0],scale_opts);
    cnt = cnt +1;
end



%Add washin label
% if y_labels_on
plus_offset = 16.5;
for ii = [0,4]
    for jj = 1:4
        % curr_label = ['\color[rgb]{',num2str(all_colors_pharma(jj,:)),'}',...
        %             all_row_labels{jj}];
        curr_label = all_row_labels{jj};

        if numel(curr_label) == 1
            curr_t = text(ax_basep_avgtyp{ii+jj,3},1,0.5,curr_label,...
                'Units','normalized',...
                'Position',[1 0.5 0],'VerticalAlignment','middle',...
                'HorizontalAlignment','left');
            curr_t.Units = 'pixels';
            curr_t.Position(1) = curr_t.Position(1)+plus_offset;
            curr_t.Units = 'normalized';
        else
            curr_t1 = text(ax_basep_avgtyp{ii+jj,3},1,0.5,curr_label{1},...
                'Units','normalized',...
                'Position',[1 0.5 0],'VerticalAlignment','bottom',...
                'HorizontalAlignment','left');
            curr_t2 = text(ax_basep_avgtyp{ii+jj,3},1,0.5,curr_label{2},...
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

        if ii == 0 && jj == 3
            curr_t1.Units = 'pixels';
            curr_t2.Units = 'pixels';
            curr_t1.Position(2) = curr_t1.Position(2)+1.5;
            curr_t2.Position(2) = curr_t2.Position(2)+1.5;
            curr_t1.Units = 'normalized';
            curr_t2.Units = 'normalized';
        elseif ii == 0 && jj == 4
            curr_t1.Units = 'pixels';
            curr_t2.Units = 'pixels';
            curr_t1.Position(2) = curr_t1.Position(2)-1.5;
            curr_t2.Position(2) = curr_t2.Position(2)-1.5;
            curr_t1.Units = 'normalized';
            curr_t2.Units = 'normalized';
        end

    end
end
