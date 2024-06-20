%% Plot trains stacked

% f_train = figure('Position', [488 1.8000 680.3150 857.9636],...
%     'Color','w');
% train5_examples_panel

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



%Set axis position
pos_bottom = 0.6;
pos_top = 0.96;
pos_height = pos_top - pos_bottom;
pos_left = 0.1;
full_width = 0.08;
base_space = 0.01;




%Gather data
input_train = input_burst;

curr_traces = all_mean_bursts{5}(train_fltr_5,:);


%Add input to general array
curr_traces = [input_train; curr_traces];
select_cells = [1 typ_cell_idxs+1];


%Set plot options
stack_opts = struct();
stack_opts.Visible = 'off';
stack_opts.XLim = [0 2.5];


pos_ax = [pos_left  pos_bottom  full_width  pos_height];




[train_stack_burst] = plot_stacked_traces(...
    curr_traces,Fs,select_cells,f_train,pos_ax,stack_opts);
train_stack_burst{1}.Children(1).Color = input_color;
train_stack_burst{1}.Children(1).LineWidth = 1;
cellfun(@add_zero_line, train_stack_burst(2:end));

%Add cell label
for ii = 2:numel(train_stack_burst)
    text(train_stack_burst{ii},0,0,['#',num2str(typ_cell_num(ii-1))],'Units','normalized',...
                'Position',[-0.05 0.5],'VerticalAlignment','middle',...
                'HorizontalAlignment','right',...
                'Rotation',0)
end

%Add scale bar
scale_opts = struct();
scale_opts.xlabel = 's';
scale_opts.ylabel = 'spk/s';
scale_opts.origin = [2,-25];
add_scale_bar(train_stack_burst{end},[0.5 20],scale_opts);

for ii = 2:numel(train_stack_burst)-1
    add_scale_bar(train_stack_burst{ii},[0 20]);
end


%Axis by ylim
% [all_graph_heights,all_bottoms] = axis_height_by_ylim(train_stack_burst(2:end));


%Fix Ylim and ax positions (requires train panel to already be there)
for ii = 1:numel(train_stack_burst)
        curr_ylim = train_stack_burst{ii}.YLim;
        train_ylim = train_stack_1{ii}.YLim;
        if curr_ylim(2) < train_ylim(2)
            train_stack_burst{ii}.YLim = train_ylim;
        end

        train_stack_burst{ii}.Position([2,4]) = train_stack_1{ii}.Position([2,4]);


end


%Label train input
text(train_stack_burst{1},0,2,'0','VerticalAlignment','bottom')
text(train_stack_burst{1},0.6,102,'100','VerticalAlignment','bottom','HorizontalAlignment','center')
