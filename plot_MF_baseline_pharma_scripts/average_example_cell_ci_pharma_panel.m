% f_base_pharma = figure('Position', [488 1.8000 680.3150 857.9636],...
%     'Color','w');
% example_cell_ci_pharma_panel

%Get right cell idxes
% typ_cell_IDs = {'1701','1672'};
typ_cell_IDs = {'1701','1807'};
[typ_cell_idxs,curr_cells] = UBC_cell_ID2idx(fileNames(washin_fltr),typ_cell_IDs,fltr_ONidx);

% curr_cells = [1, 20];

%Xlim 
all_XLim = {[0 0.2],[0 0.2],[0 0.2]};
zerod_x = 0;
diff_lim_x = cellfun(@diff, all_XLim);

%Define axis positions
%Define axes pos
num_cols = 3; %Number of different protocols
num_rows = 4 * numel(curr_cells); %Number of washins * number of cells to plot

left_edge = 0.6890;
bottom_edge = 0.6050;
top_edge = 0.96;
ax_space = 0.01;
ax_space_v = 0.02;
cell_space = 0.03;
total_width = 0.2900;

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

all_titles = {'1 Hz', '2.5 Hz', '5 Hz'};

all_row_labels = {'Baseline','−mGluR2','−AMPAR','−mGluR1'};
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
                fltr_ONidx,curr_cell,all_colors(kk,:),zerod_x,...
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
                title(ax_basep_avgtyp{row_idx,kk},all_titles{kk})
            end
        end
        

    end
end


scale_opts = struct();
scale_opts.xlabel = 'ms';
% scale_opts.ylabel = 'spk/s';
scale_opts.xscale_factor = 1000;
scale_opts.label_fontsize = 10;
scale_opts.origin = [0.1 -25];

for idx = 1:4:num_rows
    %Add scale bar to last
    add_scale_bar(ax_basep_avgtyp{idx+3,end},[0.1,0],scale_opts)
   
end

%Homogenize with previous panel
for ii = 1:numel(ax_basep_typ)
    %Set YLim
    ax_basep_avgtyp{ii}.YLim = ax_basep_typ{ii}.YLim;

    %Set Y Positions
    ax_basep_avgtyp{ii}.Position([2,4]) = ax_basep_typ{ii}.Position([2,4]);

end



