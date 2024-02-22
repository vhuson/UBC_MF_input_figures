%% Example cells panel
f_base = figure('Position', [488 1.8000 680.3150 857.9636],...
    'Color','w');


%19, 29 37 51 60
typ_cell_IDs = {'1657','1685','1766','1758','1678'};
[typ_cell_idxs,typ_cell_num] = UBC_cell_ID2idx(fileNames,typ_cell_IDs,ONidx);



base_width = 0.18;
base_w_unit = base_width/5;
base_height = 0.055;
top_margin = 0.96;
left_margin = 0.08;
left_margin_avg = 0.689;
base_space = 0.02;
base_hspace = 0.01;

pos_ax = [left_margin-base_width-base_hspace,...
    top_margin+base_space,...
    base_width, base_height];

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

% all_colors = repmat([0 0 0],3,1);
all_colors = bbpr(3);
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
    pos_ax = [left_margin,...
              top_margin-base_height*ii-base_space*(ii-1),...
              base_width, base_height];

    %Loop over input freqs
    for jj = 1:numel(full_baseline_incl_traces)
        pos_ax(1) = left_margin + (base_width + base_hspace) * (jj-1);
        pos_ax(3) = base_width;
        [ax_burst_typ{ii}{jj}] = plot_burst_traces_overlay(full_baseline_incl_traces(jj),Fs,...
            ONidx,curr_cell,all_colors(jj,:),0,...
            [],lim_x,f_base,pos_ax,opts);


        % pos_ax(1) = left_margin + (base_width + base_hspace*1.3) * numel(full_baseline_incl_traces)...
        %                         + sum(base_w_avg(1:(jj-1))) + base_hspace * (jj-1);
        pos_ax(1) = left_margin_avg + (base_w_avg(jj) + base_hspace)  * (jj-1);
        
        pos_ax(3) = base_w_avg(jj);

        % [ax_burst_typ_ss{ii}{jj}] = plot_burst_traces_overlay(full_baseline_incl_traces(jj),Fs,...
        %     ONidx,curr_cell,all_colors(1,:),0,...
        %     [],lim_x_ss,f_base,pos_ax,opts);

        [ax_burst_typ_avg{ii}{jj}] = plot_burst_traces_overlay(nan_mean_segments(jj),Fs,...
            ONidx,curr_cell,all_colors(jj,:),0,...
            [],lim_x_avg(jj,:),f_base,pos_ax,opts);

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
    % same_ylim([ax_burst_typ{ii},ax_burst_typ_ss{ii}],'YMinValue',50);
    same_ylim([ax_burst_typ{ii},ax_burst_typ_avg{ii}],'YMinValue',50);
    % same_ylim();
    
    scale_opts = struct();
    if ii == numel(typ_cell_num)
        scale_opts.xlabel = 's';
        scale_opts.ylabel = 'spk/s';
    end
    add_scale_bar(ax_burst_typ{ii}{1},[1,y_scalebar_size(ii)],scale_opts);
    % add_scale_bar(ax_burst_typ_ss{ii}{end},[0.5,0],scale_opts);

    if ii == numel(typ_cell_num)
        scale_opts.xlabel = 'ms';
        scale_opts.xscale_factor = 1000;
        scale_opts.ylabel = 'spk/s';
        add_scale_bar(ax_burst_typ_avg{ii}{end},[0.1,0],scale_opts);
    end
    

end
