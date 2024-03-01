%% Plot trains stacked pharma

% f_train_pharma = figure('Position', [488 1.8000 680.3150 857.9636],...
%     'Color','w');

select_cells = fltr_ONidx_tpharma;

% TRAIN5 selection
% [4,6] 
typ_cell_IDs = {'1657','1663'};

[typ_cell_idxs,typ_cell_num] = UBC_cell_ID2idx(fileNames(select_cells),...
    typ_cell_IDs,select_cells);


y_labels_on = false;


%Set axis position
num_cells = numel(typ_cell_num);
num_cols = 1;
num_rows = num_cells * 4 +1;

pos_bottom = 0.6;
pos_top = 0.96;
pos_height = pos_top - pos_bottom;
% pos_left = 0.1;
% full_width = 0.55;
pos_left = 0.1966;
full_width = 0.5334;
base_space = 0.01;
cell_space = 0.02;

% pos_left2 = 0.6722;
% base_width2 = 0.2921;
pos_left2 = 0.7466;
base_width2 = 0.2177;

base_height = pos_height - base_space * (num_rows-1) - cell_space * num_cells;
base_height = base_height / num_rows;

all_bottom_edges = (base_height + base_space) .* (0:(num_rows-1));
all_bottom_edges = all_bottom_edges + pos_bottom;
all_bottom_edges = all_bottom_edges + floor(0:1/4:num_cells) .* cell_space;
all_bottom_edges = fliplr(all_bottom_edges);

all_bottom_edges = all_bottom_edges(1:4:9);

cell_height = base_height * 4 + base_space *3;

%Gather data
trim_amount = 4*Fs + 1000;
input_train = input_train_5;
input_train = input_train(:,1:end-trim_amount);

curr_traces = all_mean_trains_pharma;
for ii = 1:numel(curr_traces)
    curr_traces{ii} = cellfun(@(x) {medfilt1(x,Fs*0.02)},curr_traces{ii});
    curr_traces{ii} = vertcat(curr_traces{ii}{:});

    %Trim end a bit
    curr_traces{ii} = curr_traces{ii}(:,1:end-trim_amount);
end


%Set plot options
all_row_labels = {'Baseline','−mGluR2','−AMPAR','−mGluR1'};
seed_colors_pharma = [0 0 0;
                1 0.6 0;
                0.8 0 0;
                0   0   1];
all_colors_pharma = seed_map(seed_colors_pharma,4);


stack_opts = struct();
stack_opts.Visible = 'off';
stack_opts.XLim = [0 36];
stack_opts.padding = base_space*100;




%Plot input trace
pos_ax = [pos_left  all_bottom_edges(1)  full_width  base_height];

[input_ax] = plot_stacked_traces(...
    input_train,Fs,1,f_train_pharma,pos_ax,stack_opts);
%Plot pulse 60 zoom in
stack_opts2 = stack_opts;
stack_opts2.XLim = [27.5 31];

pos_ax2 = [pos_left2  all_bottom_edges(1)  base_width2  base_height];
[input_ax2] = plot_stacked_traces(...
    input_train,Fs,1,f_train_pharma,pos_ax2,stack_opts2);


%Loop over cells and plot
pharma_stack = {};
pharma_stack2 = {};
for ii = 1:num_cells
    %Set axis position
    pos_ax = [pos_left  all_bottom_edges(ii+1)  full_width  cell_height];

    %Get data
    plot_traces = cellfun(@(x) {x(typ_cell_idxs(ii),:)},curr_traces);
    plot_traces = vertcat(plot_traces{:});
    
    %Plot
    [pharma_stack{ii}] = plot_stacked_traces(...
    plot_traces,Fs,1:4,f_train_pharma,pos_ax,stack_opts);
    cellfun(@add_zero_line, pharma_stack{ii});


    %Plot pulse 60 zoom in
    pos_ax2 = [pos_left2  all_bottom_edges(ii+1)  base_width2  cell_height];

    [pharma_stack2{ii}] = plot_stacked_traces(...
    plot_traces,Fs,1:4,f_train_pharma,pos_ax2,stack_opts2);
    cellfun(@add_zero_line, pharma_stack2{ii});

    if y_labels_on
    %Add cell label
    text(pharma_stack{ii}{2},0,0,['#',num2str(typ_cell_num(ii))],'Units','normalized',...
                'Position',[-0.05 -0],'VerticalAlignment','middle',...
                'HorizontalAlignment','center',...
                'Rotation',0)
    end
    %Same ylim
    same_ylim_stack({pharma_stack{ii}, pharma_stack2{ii}});
end
pharma_stack{1}{1}.YLim(2) = 123;
pharma_stack{1}{2}.YLim(2) = 123;
pharma_stack2{1}{1}.YLim(2) = 123;
pharma_stack2{1}{2}.YLim(2) = 123;

%Add scale bar
scale_opts = struct();
scale_opts.xlabel = 's';
scale_opts.ylabel = 'spk/s';
scale_opts.origin = [33,-70];
cellfun(@(x) add_scale_bar(x{end},[3 50],scale_opts),pharma_stack);

scale_opts.origin = [30.5,-70];
cellfun(@(x) add_scale_bar(x{end},[0.5 0],scale_opts),pharma_stack2);


%Axis size by ylim
cellfun(@axis_height_by_ylim,pharma_stack,'UniformOutput', false);
cellfun(@axis_height_by_ylim,pharma_stack2,'UniformOutput', false);


%Add washin label
% if y_labels_on
for ii = 1:numel(pharma_stack)
    for jj = 1:4
        curr_label = ['\color[rgb]{',num2str(all_colors_pharma(jj,:)),'}',...
                    all_row_labels{jj}];
        curr_t = text(pharma_stack{ii}{jj},0,0,curr_label,...
            'Units','normalized',...
            'Position',[0 1 0],'VerticalAlignment','bottom',...
            'HorizontalAlignment','left');
        curr_t.Units = 'data';
    end
end
% end



%Label train input
text(input_ax{1},0,2,'0','VerticalAlignment','bottom')
text(input_ax{1},5,7,'5','VerticalAlignment','bottom')
text(input_ax{1},8.5,12,'10','VerticalAlignment','bottom','HorizontalAlignment','center')
text(input_ax{1},12.5,22,'20','VerticalAlignment','bottom','HorizontalAlignment','center')
text(input_ax{1},16.5,32,'30','VerticalAlignment','bottom','HorizontalAlignment','center')
text(input_ax{1},20.5,42,'40','VerticalAlignment','bottom','HorizontalAlignment','center')
text(input_ax{1},24.5,52,'50','VerticalAlignment','bottom','HorizontalAlignment','center')
text(input_ax{1},28.5,62,'60','VerticalAlignment','bottom','HorizontalAlignment','center')
text(input_ax{1},32.5,22,'20','VerticalAlignment','bottom','HorizontalAlignment','center')

text(input_ax2{1},27.5,7,'5','VerticalAlignment','bottom')
text(input_ax2{1},28.5,62,'60','VerticalAlignment','bottom','HorizontalAlignment','center')
text(input_ax2{1},29.1,7,'5','VerticalAlignment','bottom')