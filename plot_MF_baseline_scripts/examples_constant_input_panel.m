%% Example cells panel
% f_base = figure('Position', [488 1.8000 680.3150 857.9636],...
%     'Color','w');


%19, 29 37 51 60
% typ_cell_IDs = {'1657','1685','1766','1758','1678'};
%5, 29 37 51 60
typ_cell_IDs = {'1719','1685','1766','1758','1678'};

[typ_cell_idxs,typ_cell_num] = UBC_cell_ID2idx(fileNames,typ_cell_IDs,ONidx);


%Define axis positions
num_cols = 3; %Number of different protocols
num_rows = numel(typ_cell_num); %Number of washins * number of cells to plot

left_edge = 0.08;
bottom_edge = 0.6050;
top_edge = 0.96;
ax_space = 0.01;
ax_space_v = 0.020;
cell_space = 0.03;
total_width = 0.56;


left_edge2 = 0.6890;
total_width2 = 0.2900;

total_height = top_edge - bottom_edge;
base_height = total_height - ax_space_v * (num_rows-1);
base_height = base_height / num_rows;

all_bottom_edges = (base_height + ax_space_v) * (0:(num_rows-1)) + bottom_edge;
all_bottom_edges = fliplr(all_bottom_edges);

base_width = total_width - ax_space * (num_cols-1);
base_width = base_width / num_cols;

all_left_edges = (base_width + ax_space) * (0:(num_cols-1)) + left_edge;

base_width2 = total_width2 - ax_space * (num_cols-1);
base_width2 = base_width2 / num_cols;

all_left_edges2 = (base_width2 + ax_space) * (0:(num_cols-1)) + left_edge2;



%Concatenate and fill zeros
[full_baseline_incl_traces] = concat_inst_freqs(all_full_traces,...
    pre_prot_baseline_traces,Fs);

%Remove zeros from mean segments 
% nan_mean_segments = mean_segments;
nan_mean_segments = all_ss_segments;
for ii = 1:numel(nan_mean_segments)
    nan_idx_mean_segments = nan_mean_segments{ii} == 0;

    if ~all(nan_idx_mean_segments)
        nan_mean_segments{ii}(nan_idx_mean_segments) = NaN;
    end
    %Specifically maintain zeros in cell 51
    nan_mean_segments{ii}(48,:) = all_ss_segments{ii}(48,:);
end

all_colors = repmat([0 0 0],3,1);
% all_colors = bbpr(3);
lim_x = [0 11];
lim_x_ss = [8.95 10.95];
% lim_x_avg = [[0 1];[0 0.4];[0 0.2]];
lim_x_avg = [[0 0.2];[0 0.2];[0 0.2]];
base_w_avg = lim_x_avg(:,2).*base_width*2.5;

y_scalebar_size = [20 20 20 20 20];

zerod_x = [0 0 0];
trace_labels = {'1 Hz','2.5 Hz','5 Hz'};

opts = struct();
opts.axis_off = true;
opts.pad = false;

ax_base_typ = cell(size(typ_cell_num));
scale_opts = struct();
scale_opts.xlabel = 's';

ax_burst_typ = {};
ax_burst_typ_ss = {};
%Loop over cells
for ii = 1:numel(typ_cell_num)
    curr_cell = typ_cell_num(ii);

    %Loop over input freqs
    for jj = 1:numel(full_baseline_incl_traces)
        %Define axes full trace
        pos_ax = [all_left_edges(jj) all_bottom_edges(ii) base_width base_height];
        
        % plot full trace
        [ax_burst_typ{ii}{jj}] = plot_burst_traces_overlay(full_baseline_incl_traces(jj),Fs,...
            ONidx,curr_cell,all_colors(jj,:),0,...
            [],lim_x,f_base,pos_ax,opts);
        add_zero_line(ax_burst_typ{ii}{jj});

        %Define axes average segment
        pos_ax = [all_left_edges2(jj) all_bottom_edges(ii) base_width2 base_height];

        % plot average segment
        [ax_burst_typ_avg{ii}{jj}] = plot_burst_traces_overlay(nan_mean_segments(jj),Fs,...
            ONidx,curr_cell,all_colors(jj,:),0,...
            [],lim_x_avg(jj,:),f_base,pos_ax,opts);
        add_zero_line(ax_burst_typ_avg{ii}{jj});
        if ii == 1
            title(ax_burst_typ{ii}{jj},trace_labels{jj})
            if jj ==2
                % title(ax_burst_typ_ss{ii}{jj},"End of train")
                title(ax_burst_typ_avg{ii}{jj},"Spike triggered average")
            end
        end

        if jj == 1
            text(ax_burst_typ{ii}{jj},0,0,['#',num2str(curr_cell)],'Units','normalized',...
                'Position',[-0.01 0.5],'VerticalAlignment','middle',...
                'HorizontalAlignment','right')

        end

    end
    
    % same_ylim([ax_burst_typ{ii},ax_burst_typ_avg{ii}],'YMinValue',50);
    same_ylim([ax_burst_typ{ii},ax_burst_typ_avg{ii}]);
    
    % scale_opts = struct();
    % if ii == numel(typ_cell_num)
    %     scale_opts.xlabel = 's';
    %     scale_opts.ylabel = 'spk/s';
    % end
    % add_scale_bar(ax_burst_typ{ii}{1},[1,y_scalebar_size(ii)],scale_opts);
    % % add_scale_bar(ax_burst_typ_ss{ii}{end},[0.5,0],scale_opts);
    % 
    % if ii == numel(typ_cell_num)
    %     scale_opts.xlabel = 'ms';
    %     scale_opts.xscale_factor = 1000;
    %     scale_opts.ylabel = 'spk/s';
    %     add_scale_bar(ax_burst_typ_avg{ii}{end},[0.1,0],scale_opts);
    % end
    

end

%Adjust ylim of last cell
if strcmp(typ_cell_IDs{end},'1678')
    same_ylim([ax_burst_typ{end},ax_burst_typ_avg{end}],'YMaxValue',65);
end

% Add scale bars
scale_opts = struct();
scale_opts.xlabel = 's';
scale_opts.ylabel = 'spk/s';
scale_opts.xscale_factor = 1;
scale_opts.label_fontsize = 10;
scale_opts.origin = [10 -25];
add_scale_bar(ax_burst_typ{end}{end},[1,20],scale_opts)

scale_opts.xlabel = 'ms';
scale_opts.xscale_factor = 1000;
scale_opts.origin = [0.1 -25];
add_scale_bar(ax_burst_typ_avg{end}{end},[0.1,0],scale_opts)
same_ylim([ax_burst_typ{end},ax_burst_typ_avg{end}]);



%Adjust positioning by y-limits
all_first_axes = vertcat(ax_burst_typ{:});
all_first_axes = all_first_axes(:,1);

[all_graph_heights,all_bottoms] = axis_height_by_ylim(all_first_axes);

for ii = 1:5
    for jj =1:3
        ax_burst_typ{ii}{jj}.Position(2) = all_bottoms(ii);
        ax_burst_typ{ii}{jj}.Position(4) = all_graph_heights(ii);

        ax_burst_typ_avg{ii}{jj}.Position(2) = all_bottoms(ii);
        ax_burst_typ_avg{ii}{jj}.Position(4) = all_graph_heights(ii);
    end
end


% scale_opts = struct();
% scale_opts.xlabel = 's';
% scale_opts.ylabel = 'spk/s';
% scale_opts.xscale_factor = 1;
% scale_opts.label_fontsize = 10;
% scale_opts.origin = [9 -25];

% for idx = 1:4:num_rows
    %Add scale bar to last
    % add_scale_bar(ax_basep_typ{idx+3,end},[1,20],scale_opts)
    % same_ylim(ax_basep_typ(idx+3,:));
% 
%     [all_graph_heights,all_bottoms] = axis_height_by_ylim(ax_basep_typ(idx:idx+3,1));
% 
%     for ii = 1:numel(all_graph_heights)
%         for prot = 2:3
%             ax_basep_typ{(idx-1)+ii,prot}.Position(2) = all_bottoms(ii);
%             ax_basep_typ{(idx-1)+ii,prot}.Position(4) = all_graph_heights(ii);
%         end
%     end
% end
