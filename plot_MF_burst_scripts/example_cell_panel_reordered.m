% f_burst = figure('Position', [488 1.8000 680.3150 857.9636],...
%     'Color','w');

%Get right cell idxes
% typ_cell_IDs = {'1657','1685','1758'};
typ_cell_IDs = {'1657','1766','1758'};
[typ_cell_idxs,typ_cell_num] = UBC_cell_ID2idx(fileNames,typ_cell_IDs,ONidx);




%Xlim till 2
all_XLim = {[0.2 1.5],[0.2 1.5], [0.2 1.5], [0.2 1.5], [0.2 2.5]};

%Define axis positions

base_space = 0; %Value unused
left_edge_start = 0.08;
bottom_edge_final = 0.8;
top_edge = 0.98;
ax_space = 0.01;

base_height = (top_edge - bottom_edge_final) - ax_space * (numel(typ_cell_num)-1);
base_height = base_height/3;

bottom_edge_start = top_edge - base_height;
total_width = 0.83;

%Base width standardized to xlim
base_width = (total_width-ax_space*(numel(all_XLim)-1))...
                /sum(cellfun(@diff,all_XLim));


%Offset to stim begin
zerod_x = -[0.5 0.5 0.5 0.5 0.5]; %Also not really used

% all_colors = bbpr(5);
all_colors = zeros(5,3);

input_dur = [0.0100    0.0200    0.0500    0.1000    0.2000];

trace_titles = {'1x','2x 100 Hz','5x 100 Hz','10x 100 Hz','20x 100 Hz'};

trace_label = {[]};

ax_burst_typ = {};



opts = struct();
opts.axis_off = true;
opts.pad = false;

for ii = 1:numel(typ_cell_num)
    curr_cell = typ_cell_num(ii);

    %Reset left edge
    left_edge = left_edge_start;

    %Set correct bottom edge
    bottom_edge = bottom_edge_start - (base_height + ax_space) * (ii-1);


    for ax_idx = 1:5
        curr_xlim = all_XLim{ax_idx};

        %Normalize individual?
        % norm_on =  max(all_mean_bursts{ax_idx},[],2);

        pos_ax = [left_edge,....
            bottom_edge+base_height, diff(curr_xlim)*base_width, base_height];
        %Update left edge for next plot
        left_edge = left_edge + pos_ax(3) + ax_space;


        [curr_ax] = plot_burst_examples_v2(all_mean_bursts(ax_idx),...
            Fs,all_baseline,ONidx,curr_cell,all_colors(ax_idx,:),...
            curr_xlim,zerod_x(ax_idx),input_dur(ax_idx),trace_label,opts,...
            f_burst,pos_ax,base_height,base_space);

        %Add 0 line
        hold(curr_ax{1},'on')
        plot(curr_ax{1},[curr_ax{1}.XLim],[0 0],...
            'Color',[0.7 0.7 0.7],'LineStyle','--')
        hold(curr_ax{1},'off')
        curr_ax{1}.Children = [curr_ax{1}.Children(2:end);...
                                            curr_ax{1}.Children(1)];


        ax_burst_typ{ii,ax_idx} = curr_ax{1};
        if ii == 1
            curr_ax{1}.Title.String = trace_titles{ax_idx};
        end

    end

    same_ylim(ax_burst_typ(ii,:))

    %Add cell label
    text(ax_burst_typ{ii,1},0,0,['Cell\newline#',num2str(curr_cell)],...
        'Units','normalized','Position',[0 0.5],...
        'HorizontalAlignment','right','VerticalAlignment','middle');
end

%Add scale bar to last
scale_opts = struct();
scale_opts.xlabel = 'ms';
scale_opts.xscale_factor = 1000;
scale_opts.origin = [1.5 15];
add_scale_bar(ax_burst_typ{end,end},[0.2,0],scale_opts)

