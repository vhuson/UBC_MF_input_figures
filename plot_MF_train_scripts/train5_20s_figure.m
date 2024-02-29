%% Plot 20s overlayed

f_train = figure('Position', [488 1.8000 680.3150 857.9636],...
    'Color','w');

select_cells = fltr_ONidx_t5;
% TRAIN5 selection
% [4,6,15,19,22] 
% typ_cell_IDs = {'1754','1751','1750','1765','1753'};
% [4,6,15,18,22] 
typ_cell_IDs = {'1754','1751','1750','1749','1753'};

[typ_cell_idxs,typ_cell_num] = UBC_cell_ID2idx(fileNames(train_fltr_5),...
    typ_cell_IDs,select_cells);

% TRAIN10 selection
% select_cells = select_cells([2,10,14]);



%Set axis position
num_rows = numel(typ_cell_idxs)+1;

pos_bottom = 0.6;
pos_top = 0.96;
pos_height = pos_top - pos_bottom;
pos_left = 0.1;
full_width = 0.55;
base_space = 0.01;

pos_left2 = 0.6722;
base_width2 = 0.2921;

base_height = pos_height - base_space * (num_rows-1);
base_height = base_height/num_rows;

all_bottom_pos = (base_height + base_space) .* (0:(num_rows-1)) + pos_bottom;
all_bottom_pos = fliplr(all_bottom_pos);


%Gather data
input_train = input_train_5;

curr_traces = all_mean_trains_5(train_fltr_5);
curr_traces = cellfun(@(x) {medfilt1(x,Fs*0.02)},curr_traces);
curr_traces = vertcat(curr_traces{:});

%Add input trace
curr_traces = [input_train; curr_traces];
select_cells = [1 select_cells+1];
typ_cell_num = [1 typ_cell_num+1];

%Segment 20s out
start_20s = [12, 32, 36]; %Time in sec of start of 20 steps

start_segs = (start_20s - 0.5) * Fs +1;
end_segs = (start_20s + 4) * Fs;

curr_20traces = cell(size(start_20s));

for ii = 1:numel(curr_20traces)
    curr_20traces{ii} = curr_traces(:,start_segs(ii):end_segs(ii));
end

%Offset input traces slightly
% offset_amount = 1;
% curr_20traces{2}(1,:) = curr_20traces{2}(1,:)-offset_amount;
% curr_20traces{3}(1,:) = curr_20traces{3}(1,:)-offset_amount*2;


%Plot settings
all_colors = bbpr(3);

opts = struct('axis_off', true);


%Loop traces
ax_train_20s = {};
for ii = 1:num_rows
    pos_ax2 = [pos_left2  all_bottom_pos(ii)  base_width2  base_height];

    [ax_train_20s{ii}] = plot_burst_traces_overlay(curr_20traces,Fs,...
        select_cells,typ_cell_num(ii),all_colors,repmat(0.5,1,3),...
        [],[-0.5 3.9],f_train,pos_ax2,opts);
end

%Add scale bar
scale_opts = struct();
scale_opts.xlabel = 's';
scale_opts.origin = [3.4,-25];
add_scale_bar(ax_train_20s{end},[0.5 0],scale_opts);

%Normalize axes
[all_graph_heights,all_bottoms] = axis_height_by_ylim(ax_train_20s);

%Legend
l1 = legend(ax_train_20s{end},{'1st', '2nd','3rd'},'Box','off',...
    'Position',[0.6711    0.5546    0.1108    0.0669]);

labelString = ['5 ',...
            '\color[rgb]{',num2str(all_colors(2,:)),'}0 ',...
            '\color[rgb]{',num2str(all_colors(3,:)),'}0'];
%Labels
t1 = text(ax_train_20s{1},-0.7,26,'5','VerticalAlignment','bottom','FontSize',10);
t2 = text(ax_train_20s{1},-0.7,11,['\color[rgb]{',num2str(all_colors(2,:)),'}5'],'VerticalAlignment','bottom','FontSize',10);
t3 = text(ax_train_20s{1},-0.7,-4,['\color[rgb]{',num2str(all_colors(3,:)),'}0'],'VerticalAlignment','bottom','FontSize',10);
t4 = text(ax_train_20s{1},0.5,22,'20','VerticalAlignment','bottom',...
    'HorizontalAlignment','center','FontSize',10);
t5 = text(ax_train_20s{1},1.2,7,labelString,'VerticalAlignment','bottom','FontSize',10);
%
% f_train = figure('Position', [488 1.8000 680.3150 857.9636],...
%     'Color','w');

%Define axis position



%Get data
abs_20s_spikes_stim = cellfun(@(x) {sum(x(2:end,0.5*Fs:1.5*Fs),2)/Fs},curr_20traces);
abs_20s_spikes_post = cellfun(@(x) {sum(x(2:end,1.5*Fs:end),2)/Fs},curr_20traces);

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
summary_on = fltr_ONidx_t5;
% summary_off = OFFidx(end-1:end);
summary_off = [];
    

opts = struct();
% opts.input_n = step_size(plot_steps);
opts.input_n = [1 2 3];
opts.YScale = 'log';
% opts.XScale = 'log';
opts.XLabel = " 20 spk/s step";

opts.XTick = opts.input_n;
opts.XTickLabel = {'1st','2nd','3rd'};
opts.min_val = 1;


ax_train_par = {};

%Loop over all panels
for p_idx = 1:numel(all_plot_par)
    %Set axis position
    pos_ax2 = [pos_left2+0.05  (pos_ax2(2) - 0.22)  base_width2-0.1  0.15];

    %Panel specific options
    opts.YLabel = all_ylabels{p_idx};
    opts.min_val = all_min_vals(p_idx);

    if p_idx == numel(all_plot_par)
        opts.bar = true;
    end
    [ax_train_par{p_idx},cb1] = UBC_par_line_plot2(...
        summary_on,summary_off,all_plot_par{p_idx}(plot_steps),f_train,pos_ax2,opts);
    xlim([opts.input_n(1) opts.input_n(end)])

    %Offset XLim a little bit
    ax_train_par{p_idx}.XLim(1) = ax_train_par{p_idx}.XLim(1)...
        - diff(ax_train_par{p_idx}.XLim) * 0.05;
    fix_powered_ylabels(ax_train_par{p_idx})
    % opts.YScale = 'linear';
end
% fix_powered_ylabels(ax_train_par{1})

cb1.Position = [0.9393 0.2107 0.0176 0.0621];


%Tweak figure
fig_opts = struct();
fig_opts.FontSize = 10;
standardFig(f_train,fig_opts);