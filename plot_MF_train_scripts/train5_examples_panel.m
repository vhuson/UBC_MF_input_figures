%% Plot trains stacked

% f_train = figure('Position', [488 1.8000 680.3150 857.9636],...
%     'Color','w');


%Set axis position
pos_bottom = 0.7;
pos_height = 0.25;
pos_left = 0.1;
full_width = 0.8613;
base_space = 0.01;



%Gather data
input_train = input_train_5;

curr_traces = all_mean_trains_5(train_fltr_5);
curr_traces = cellfun(@(x) {medfilt1(x,Fs*0.02)},curr_traces);
curr_traces = vertcat(curr_traces{:});
%Trim end a bit
curr_traces = curr_traces(:,1:end-500);
input_train = input_train(:,1:end-500);

select_cells = fltr_ONidx_t5;



% TRAIN5 selection
typ_cell_idx = [6,15,21];
select_cells = select_cells(typ_cell_idx);
% TRAIN10 selection
% select_cells = select_cells([2,10,14]);

%Add input to general array
curr_traces = [input_train; curr_traces];
select_cells = [1 select_cells+1];


%Set plot options
stack_opts = struct();
stack_opts.Visible = 'off';
stack_opts.XLim = [0 44];


pos_ax = [pos_left  pos_bottom  full_width  pos_height];




[train_stack_1] = plot_stacked_traces(...
    curr_traces,Fs,select_cells,f_train,pos_ax,stack_opts);

%Add cell label
for ii = 2:numel(train_stack_1)
    text(train_stack_1{ii},0,0,['Cell #',num2str(typ_cell_idx(ii-1))],'Units','normalized',...
                'Position',[-0.05 0.5],'VerticalAlignment','middle',...
                'HorizontalAlignment','center',...
                'Rotation',0)
end
%Add scale bar
scale_opts = struct();
scale_opts.xlabel = 's';
scale_opts.origin = [41,0];
add_scale_bar(train_stack_1{end},[3 0],scale_opts);

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
text(train_stack_1{1},36.5,22,'20','VerticalAlignment','bottom','HorizontalAlignment','center')
