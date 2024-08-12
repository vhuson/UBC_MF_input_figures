% f_burst = figure('Position', [488 1.8000 680.3150 857.9636],...
%     'Color','w');

%Get right cell idxes
typ_cell_IDs = {'1777', '1665', '1687','1657'};
% typ_cell_IDs = {'1657','1766','1758','1702'};
[typ_cell_idxs,typ_cell_num] = UBC_cell_ID2idx(fileNames,typ_cell_IDs,ONidx);

typ_cell_num = round(1:41/7:42);
typ_cell_num(1) = 4;
typ_cell_num(3) = 10;
typ_cell_num(5) = 27;


%Xlim till 2
all_XLim = {[0.2 1.5],[0.2 1.5], [0.2 1.5], [0.2 1.5], [0.2 2.5]};

%Define axis positions

base_space = 0; %Value unused
left_edge_start = 0.08;
bottom_edge_final = 0.61;
top_edge = 0.98;
ax_space = 0.01;
input_height = 0.02;

base_height = (top_edge - bottom_edge_final) - ax_space * (numel(typ_cell_num+1)-1);
base_height = base_height/numel(typ_cell_num+1);

bottom_edge_start = top_edge - base_height;
total_width = 0.83;

%Base width standardized to xlim
base_width = (total_width-ax_space*(numel(all_XLim)-1))...
                /sum(cellfun(@diff,all_XLim));


%Offset to stim begin
zerod_x = -[0.5 0.5 0.5 0.5 0.5]; %Also not really used

% all_colors = bbpr(5);
all_colors = zeros(5,3);
input_color = [0.2 0.7 0.2];

input_dur = [0.0100    0.0200    0.0500    0.1000    0.2000];
input_times = {[0 0.01],[0 0.02],[0 0.05],[0 0.1],[0 0.2]};


% trace_titles = {'1x','2x 100 spk/s','5x 100 spk/s','10x 100 spk/s','20x 100 spk/s'};
trace_titles = {'1','2','5','10','20'};

trace_label = {[]};

ax_burst_typ = {};

%Scale bars
scale_opts = struct();
scale_opts.ylabel = 'spk/s';

all_scale_origins = {[2 50], [2 140], [2 33], [2 10],[2 50], [2 140], [2 33], [2 10]};
all_scale_size = {[0,50], [0,50], [0,50], [0,50],[0,50], [0,50],[0,50], [0.2,50]};


opts = struct();
opts.axis_off = true;
opts.pad = false;
opts.input_color = [0.2 0.7 0.2];

for ii = 1:numel(typ_cell_num)+1
    if ii > 1
        curr_cell = typ_cell_num(ii-1);
    end

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

        if ii == 1 %Draw input trace
            curr_input = input_times{ax_idx};
            x_time = (-0.5*Fs:30*Fs)/Fs;
            dummy_y = zeros(size(x_time));
            input_start = find(x_time >= curr_input(1),1);
            input_end = find(x_time >= curr_input(2),1);
            dummy_y(input_start:input_end) = 100;

            % curr_ax = {axes('Position',pos_ax)};
            % plot(x_time,dummy_y,'Color',input_color);
            % ylim([0 100]);
            % xlim(curr_xlim);
            [curr_ax] = plot_burst_examples_v2({dummy_y},...
                Fs,0,1,1,input_color,...
                curr_xlim,zerod_x(ax_idx),0,trace_label,opts,...
                f_burst,pos_ax,base_height,base_space);
            curr_ax{1}.Position(4) = input_height;
        else
            [curr_ax] = plot_burst_examples_v2(all_mean_bursts(ax_idx),...
                Fs,all_baseline,ONidx,curr_cell,all_colors(ax_idx,:),...
                curr_xlim,zerod_x(ax_idx),0,trace_label,opts,...
                f_burst,pos_ax,base_height,base_space);
        end

        %Add 0 line
        if ii > 1
            hold(curr_ax{1},'on')
            plot(curr_ax{1},[curr_ax{1}.XLim],[0 0],...
                'Color',[0.7 0.7 0.7],'LineStyle','--')
            hold(curr_ax{1},'off')
            curr_ax{1}.Children = [curr_ax{1}.Children(2:end);...
                curr_ax{1}.Children(1)];
        end


        ax_burst_typ{ii,ax_idx} = curr_ax{1};
        if ii == 1
            curr_ax{1}.Title.String = trace_titles{ax_idx};
            curr_ax{1}.Title.Position(1) = mean(input_times{ax_idx});
            if ax_idx == 5
                left_extent = curr_ax{1}.Title.Extent(1);
                curr_ax{1}.Title.HorizontalAlignment = 'left';
                curr_ax{1}.Title.Position(1) = left_extent;
                curr_ax{1}.Title.String = [curr_ax{1}.Title.String,...
                                            ' stimuli']; % at 100 spk/s

            end
        end

    end

    same_ylim(ax_burst_typ(ii,:))

    %Add cell label
    if ii == 1
        curr_string = 'Input';
    elseif ii == 2
        curr_string = {'Cell\newline',['#',num2str(curr_cell)]};
    else
        curr_string = ['#',num2str(curr_cell)];
    end
    text(ax_burst_typ{ii,1},0,0,curr_string,...
        'Units','normalized','Position',[0 0.5],...
        'HorizontalAlignment','right','VerticalAlignment','middle');

    %Add scale bar to last
    
    if ii == numel(typ_cell_num)+1
        scale_opts.xlabel = 'ms';
        scale_opts.xscale_factor = 1000;
    end
    
    if ii > 1
    % scale_opts.origin = all_scale_origins{ii-1};
    add_scale_bar(ax_burst_typ{end,end},all_scale_size{ii-1},scale_opts);
    end
end

%Reduce zero line to avoid scale bar clash
curr_ax{1}.Children(3).XData(2) = 1.7;


% %Add input line
% il_opts = struct();
% il_opts.input_color = [0.2 0.7 0.2];
% input_durs = {[0 0.01],[0 0.02],[0 0.05],[0 0.1],[0 0.2]};
% 
% for ii = 1:numel(input_durs)
%     input_dur = input_durs{ii};
% 
%     cellfun(@(x) add_input_line(x,input_dur,il_opts),ax_burst_typ(:,ii));
% end

%Add scale bar to last
% scale_opts = struct();
% scale_opts.xlabel = 'ms';
% scale_opts.ylabel = 'spk/s';
% scale_opts.xscale_factor = 1000;
% scale_opts.origin = [1.8 15];
% add_scale_bar(ax_burst_typ{end,end},[0.2,10],scale_opts)

% standardFig(f_burst,struct('FontSize',10))
