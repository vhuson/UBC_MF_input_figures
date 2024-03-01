%% 20s of pharma next to each other

f_train_pharma = figure('Position', [488 1.8000 680.3150 857.9636],...
    'Color','w');


select_cells = fltr_ONidx_tpharma;

typ_cell_IDs = {'1754','1751','1750','1749','1753'};

[typ_cell_idxs,typ_cell_num] = UBC_cell_ID2idx(fileNames(train_fltr_5),...
    typ_cell_IDs,select_cells);

typ_cell_idxs = fltr_ONidx_tpharma;
typ_cell_num = 1:numel(select_cells);



%Set axis position
num_rows = numel(typ_cell_idxs);
num_cols = 4;

pos_bottom = 0.4;
pos_top = 0.96;
pos_height = pos_top - pos_bottom;
pos_left = 0.1;
full_width = 0.85;
base_space = 0.02;

base_width = full_width - base_space * (num_cols-1);
base_width = base_width / num_cols;

all_left_edges = (base_width + base_space) .* (0:(num_cols-1)) + pos_left;


base_height = pos_height - base_space * (num_rows-1);
base_height = base_height/num_rows;

all_bottom_pos = (base_height + base_space) .* (0:(num_rows-1)) + pos_bottom;
all_bottom_pos = fliplr(all_bottom_pos);



%Gather data
input_train = input_train_5;

curr_traces = all_mean_trains_pharma;
for ii = 1:numel(curr_traces)
    curr_traces{ii} = cellfun(@(x) {medfilt1(x,Fs*0.02)},curr_traces{ii});
    curr_traces{ii} = vertcat(curr_traces{ii}{:});
end

%Segment 20s out
start_20s = [12, 32, 36]; %Time in sec of start of 20 steps

start_segs = (start_20s - 0.5) * Fs +1;
end_segs = (start_20s + 4) * Fs;

curr_20traces = {};

for jj = 1:numel(curr_traces)
    for ii = 1:numel(start_20s)
        curr_20traces{jj}{ii} = curr_traces{jj}(:,start_segs(ii):end_segs(ii));
    end
end




%Set plot options
all_row_labels = {'Baseline','−mGluR2','−AMPAR','−mGluR1'};
seed_colors_pharma = [0 0 0;
                1 0.6 0;
                0.8 0 0;
                0   0   1];
all_colors_pharma = seed_map(seed_colors_pharma,4);



%Plot settings
all_colors = bbpr(3);

opts = struct('axis_off', true);


%Loop washins and traces
ax_train_20s = {};

for ii = 1:num_rows
    for jj = 1:num_cols
        pos_ax = [all_left_edges(jj)  all_bottom_pos(ii)  base_width  base_height];

        [ax_train_20s{ii,jj}] = plot_burst_traces_overlay(curr_20traces{jj},Fs,...
            select_cells,typ_cell_num(ii),all_colors,repmat(0.5,1,3),...
            [],[-0.5 3.9],f_train_pharma,pos_ax,opts);
        axis tight
        ax_train_20s{ii,jj}.XLim = [-0.5 3.9];
    end
    same_ylim(ax_train_20s(ii,:));

    %Add cell label
    text(ax_train_20s{ii,1},0,0,['#',num2str(typ_cell_num(ii))],'Units','normalized',...
                'Position',[-0.1 0.5],'VerticalAlignment','middle',...
                'HorizontalAlignment','center',...
                'Rotation',0)
end


%Add washin label
for ii = 1:num_cols
        curr_label = ['\color[rgb]{',num2str(all_colors_pharma(ii,:)),'}',...
                    all_row_labels{ii}];
        title(ax_train_20s{1,ii},curr_label)
        % curr_t = text(ax_train_20s{1,jj},0,0,curr_label,...
        %     'Units','normalized',...
        %     'Position',[0 1 0],'VerticalAlignment','bottom',...
        %     'HorizontalAlignment','left');
        % curr_t.Units = 'data';
    
end

%Add scale bar
scale_opts = struct();
scale_opts.xlabel = 's';
scale_opts.ylabel = 'spk/s';
scale_opts.origin = [3.4,-25];
add_scale_bar(ax_train_20s{end,end},[0.5 20],scale_opts);
same_ylim(ax_train_20s(end,:));

%Normalize axes
[all_graph_heights,all_bottoms] = axis_height_by_ylim(ax_train_20s(:,end));

for ii = 1:num_cols-1
    for jj = 1:numel(all_graph_heights)
        ax_train_20s{jj,ii}.Position(2) = all_bottoms(jj);
        ax_train_20s{jj,ii}.Position(4) = all_graph_heights(jj);
    
    end
end

%Add legend
l1 = legend(ax_train_20s{end},{'1st', '2nd','3rd'},'Box','off',...
    'Position',[0.8289 0.8628 0.1108 0.0669]);

%%
% Add summary panels
ax_train_pharma_par = {};
for col = 1:num_cols

%Get data
abs_20s_spikes_stim = cellfun(@(x) {sum(x(:,0.5*Fs:1.5*Fs),2)/Fs},curr_20traces{col});
abs_20s_spikes_post = cellfun(@(x) {sum(x(:,1.5*Fs:end),2)/Fs},curr_20traces{col});

all_plot_par = {abs_20s_spikes_stim,...
                    abs_20s_spikes_post};


all_ylabels = {'Stim spikes (n)',...
                'Post spikes (n)'};

% all_ylabels = {'Peak response (\Deltaspk/s)',...
%                 "Response spikes (n)",...
%                 'Steady state (spk/s)'};


% all_min_vals = [1 1 0.01];
all_min_vals = [1 1];



%Train plot pars
% plot_steps = 1:6;
plot_steps = [1, 2, 3];
step_size = [20, 20, 20];


%Plot settings
summary_on = select_cells;
% summary_off = OFFidx(end-1:end);
summary_off = [];
    

opts = struct();
% opts.input_n = step_size(plot_steps);
opts.input_n = [1 2 3];
opts.YScale = 'log';
% opts.XScale = 'log';
opts.XLabel = "";

opts.XTick = opts.input_n;
opts.XTickLabel = {'1st','2nd','3rd'};
opts.min_val = 1;



%Set axis position
pos_ax2 = [all_left_edges(col)+0.02  all_bottom_pos(end)+0.03  base_width-0.05  0.11];

%Loop over all panels
for p_idx = 1:numel(all_plot_par)
    %Set axis position
    pos_ax2(2) = pos_ax2(2) - 0.18;

    %Panel specific options
    if col == 1
    opts.YLabel = all_ylabels{p_idx};
    end
    opts.min_val = all_min_vals(p_idx);

    if p_idx == numel(all_plot_par) && col == num_cols
        opts.bar = true;
    end
    [ax_train_pharma_par{col,p_idx},cb1] = UBC_par_line_plot2(...
        summary_on,summary_off,all_plot_par{p_idx}(plot_steps),f_train_pharma,pos_ax2,opts);
    xlim([opts.input_n(1) opts.input_n(end)])

    %Offset XLim a little bit
    ax_train_pharma_par{col,p_idx}.XLim(1) = ax_train_pharma_par{col,p_idx}.XLim(1)...
        - diff(ax_train_pharma_par{col,p_idx}.XLim) * 0.05;
    fix_powered_ylabels(ax_train_pharma_par{col,p_idx})
    % opts.YScale = 'linear';
    opts.XLabel = " 20 spk/s step";
end
% fix_powered_ylabels(ax_train_par{1})

end
same_ylim(ax_train_pharma_par(:,1));
same_ylim(ax_train_pharma_par(:,2));

cb1.Position = [0.9367 0.0927 0.0177 0.0621];

%Tweak figure
fig_opts = struct();
fig_opts.FontSize = 10;
standardFig(f_train_pharma,fig_opts);
