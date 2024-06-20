%% Plot trains stacked

% f_train = figure('Position', [488 1.8000 680.3150 857.9636],...
%     'Color','w');

select_cells = fltr_ONidx_t5;
% TRAIN5 selection
% [4,6,15,19,22] 
% typ_cell_IDs = {'1754','1751','1750','1765','1753'};
% [4,6,12,15,18,22] 
typ_cell_IDs = {'1754','1751','1759','1750','1749','1753'};

[typ_cell_idxs,typ_cell_num] = UBC_cell_ID2idx(fileNames(train_fltr_5),...
    typ_cell_IDs,select_cells);

% TRAIN10 selection
% select_cells = select_cells([2,10,14]);

input_color = [0.2 0.7 0.2];

y_labels_on = false;

%Set axis position
pos_bottom = 0.6;
pos_top = 0.96;
pos_height = pos_top - pos_bottom;
% pos_left = 0.1;
% full_width = 0.55;
pos_left = 0.1966;
full_width = 0.5334;
base_space = 0.01;

% pos_left2 = 0.6722;
% base_width2 = 0.2921;
pos_left2 = 0.7466;
base_width2 = 0.2177;


%Gather data
input_train = input_train_5;

curr_traces = all_mean_trains_5(train_fltr_5);
curr_traces = cellfun(@(x) {medfilt1(x,Fs*0.02)},curr_traces);
%Truncate longer traces
curr_traces = cellfun(@(x) {x(1:800001)},curr_traces);
curr_traces = vertcat(curr_traces{:});

%Trim end to cut last 20
trim_samples = 4*Fs + 1000;
curr_traces = curr_traces(:,1:end-trim_samples);
input_train = input_train(:,1:end-trim_samples);






%Add input to general array
curr_traces = [input_train; curr_traces];
select_cells = [1 typ_cell_idxs+1];


%Set plot options
stack_opts = struct();
stack_opts.Visible = 'off';
stack_opts.XLim = [0 36];


pos_ax = [pos_left  pos_bottom  full_width  pos_height];




[train_stack_1] = plot_stacked_traces(...
    curr_traces,Fs,select_cells,f_train,pos_ax,stack_opts);
train_stack_1{1}.Children(1).Color = input_color;
train_stack_1{1}.Children(1).LineWidth = 1;
cellfun(@add_zero_line, train_stack_1(2:end));

%Plot pulse 60 zoom in
stack_opts.XLim = [27.5 31];

pos_ax2 = [pos_left2  pos_bottom  base_width2  pos_height];

[train_stack_2] = plot_stacked_traces(...
    curr_traces,Fs,select_cells,f_train,pos_ax2,stack_opts);
train_stack_2{1}.Children(1).Color = input_color;
train_stack_2{1}.Children(1).LineWidth = 1;
cellfun(@add_zero_line, train_stack_2(2:end));

%add stim onset line
for ii = 2:numel(train_stack_2)
    hold(train_stack_2{ii},'on')
    line(train_stack_2{ii},repmat(train5_step_times(7),1,2),...
        train_stack_2{ii}.YLim,'Color',[1 0 0],'LineWidth',0.5,'LineStyle',':')
    line(train_stack_2{ii},repmat((train5_step_times(7)+1),1,2),...
        train_stack_2{ii}.YLim,'Color',[1 0 0],'LineWidth',0.5,'LineStyle',':')
    hold(train_stack_2{ii},'off')
end

%Add cell label
if y_labels_on
for ii = 2:numel(train_stack_1)
    text(train_stack_1{ii},0,0,['#',num2str(typ_cell_num(ii-1))],'Units','normalized',...
                'Position',[-0.05 0.5],'VerticalAlignment','middle',...
                'HorizontalAlignment','center',...
                'Rotation',0)
end
end
%Add scale bar
scale_opts = struct();
scale_opts.xlabel = 's';
scale_opts.ylabel = 'spk/s';
scale_opts.origin = [33,-25];
add_scale_bar(train_stack_1{end},[3 20],scale_opts);

scale_opts.origin = [30.5,-25];
add_scale_bar(train_stack_2{end},[0.5 0],scale_opts);


[all_graph_heights,all_bottoms] = axis_height_by_ylim(train_stack_1);

for ii = 1:numel(train_stack_2)
    train_stack_2{ii}.Position(2) = all_bottoms(ii);
    train_stack_2{ii}.Position(4) = all_graph_heights(ii);
end

%Label train input
text(train_stack_1{1},0,2,'0','VerticalAlignment','bottom')
text(train_stack_1{1},5,7,'5','VerticalAlignment','bottom')
text(train_stack_1{1},8.5,12,'10','VerticalAlignment','bottom','HorizontalAlignment','center')
text(train_stack_1{1},12.5,22,'20','VerticalAlignment','bottom','HorizontalAlignment','center')
text(train_stack_1{1},16.5,32,'30','VerticalAlignment','bottom','HorizontalAlignment','center')
text(train_stack_1{1},20.5,42,'40','VerticalAlignment','bottom','HorizontalAlignment','center')
text(train_stack_1{1},24.5,52,'50','VerticalAlignment','bottom','HorizontalAlignment','center')
text(train_stack_1{1},28.5,62,'60','VerticalAlignment','bottom','HorizontalAlignment','center')
text(train_stack_1{1},32.5,22,'20','VerticalAlignment','bottom','HorizontalAlignment','center')
text(train_stack_1{1},33.2,2,'0','VerticalAlignment','bottom')
% text(train_stack_1{1},36.5,22,'20','VerticalAlignment','bottom','HorizontalAlignment','center')

text(train_stack_2{1},27.5,7,'5','VerticalAlignment','bottom')
text(train_stack_2{1},28.5,62,'60','VerticalAlignment','bottom','HorizontalAlignment','center')
text(train_stack_2{1},29.1,7,'5','VerticalAlignment','bottom')