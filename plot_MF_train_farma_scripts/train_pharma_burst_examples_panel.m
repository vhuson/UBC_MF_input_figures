%% Plot trains stacked pharma

% f_train_pharma = figure('Position', [488 1.8000 680.3150 857.9636],...
%     'Color','w');
% train_pharma_examples_panel

select_cells = fltr_ONidx_tpharma;

% TRAIN5 selection
% [4,6,15,19,22] 
% typ_cell_IDs = {'1754','1751','1750','1765','1753'};
% [4,6,15,18,22] 
% typ_cell_IDs = {'1754','1751','1750','1749','1753'};
% 
% [typ_cell_idxs,typ_cell_num] = UBC_cell_ID2idx(fileNames(train_pharma_fltr),...
%     typ_cell_IDs,select_cells);


typ_cell_idxs = [6, 1];
typ_cell_num = [4, 6];


%Set axis position
num_cells = numel(typ_cell_num);
num_cols = 1;
num_rows = num_cells * 4 +1;

pos_bottom = 0.6;
pos_top = 0.96;
pos_height = pos_top - pos_bottom;
pos_left = 0.1;
full_width = 0.08;
base_space = 0.01;
cell_space = 0.02;


base_height = pos_height - base_space * (num_rows-1) - cell_space * num_cells;
base_height = base_height / num_rows;

all_bottom_edges = (base_height + base_space) .* (0:(num_rows-1));
all_bottom_edges = all_bottom_edges + pos_bottom;
all_bottom_edges = all_bottom_edges + floor(0:1/4:num_cels) .* cell_space;
all_bottom_edges = fliplr(all_bottom_edges);

all_bottom_edges = all_bottom_edges(1:4:9);

cell_height = base_height * 4 + base_space *3;

%Gather data
input_train = input_burst;

curr_traces = all_mean_pharma_bursts;
curr_traces = cellfun(@(x) {x{5}},curr_traces);



%Set plot options
all_row_labels = {'Baseline','−mGluR2','−AMPAR','−mGluR1'};
seed_colors_pharma = [0 0 0;
                1 0.6 0;
                0.8 0 0;
                0   0   1];
all_colors_pharma = seed_map(seed_colors_pharma,4);


stack_opts = struct();
stack_opts.Visible = 'off';
stack_opts.XLim = [0 2.5];
stack_opts.padding = base_space*100;




%Plot input trace
pos_ax = [pos_left  all_bottom_edges(1)  full_width  base_height];

[input_ax_burst] = plot_stacked_traces(...
    input_train,Fs,1,f_train_pharma,pos_ax,stack_opts);


%Loop over cells and plot
pharma_stack_burst = {};
for ii = 1:num_cells
    %Set axis position
    pos_ax = [pos_left  all_bottom_edges(ii+1)  full_width  cell_height];

    %Get data
    plot_traces = cellfun(@(x) {x(typ_cell_idxs(ii),:)},curr_traces);
    plot_traces = vertcat(plot_traces{:});
    
    %Plot
    [pharma_stack_burst{ii}] = plot_stacked_traces(...
    plot_traces,Fs,1:4,f_train_pharma,pos_ax,stack_opts);
    cellfun(@add_zero_line, pharma_stack_burst{ii});


    %Plot pulse 60 zoom in

    %Add cell label
    text(pharma_stack_burst{ii}{2},0,0,['#',num2str(typ_cell_num(ii))],'Units','normalized',...
                'Position',[-0.55 -0],'VerticalAlignment','middle',...
                'HorizontalAlignment','center',...
                'Rotation',0)
    
    %Same ylim
    same_ylim_stack(pharma_stack_burst(ii));
end

%Add scale bar
scale_opts = struct();
scale_opts.xlabel = 's';
scale_opts.ylabel = 'spk/s';
scale_opts.origin = [stack_opts.XLim(2)-0.5,20];
add_scale_bar(pharma_stack_burst{1}{end},[0.5 100],scale_opts);
for ii = 1:numel(pharma_stack_burst{1})-1
    add_scale_bar(pharma_stack_burst{1}{ii},[0 100]);
end

scale_opts.origin = [stack_opts.XLim(2)-0.5,-70];
add_scale_bar(pharma_stack_burst{2}{end},[0.5 50],scale_opts);
for ii = 1:numel(pharma_stack_burst{2})-1
    add_scale_bar(pharma_stack_burst{2}{ii},[0 50]);
end

%Axis size by ylim
% cellfun(@axis_height_by_ylim,pharma_stack_burst,'UniformOutput', false);

%Fix Ylim and ax positions (requires train panel to already be there)

for ii = 1:numel(pharma_stack_burst)
    for jj = 1:4
        curr_ylim = pharma_stack_burst{ii}{jj}.YLim;
        train_ylim = pharma_stack{ii}{jj}.YLim;
        if curr_ylim(2) < train_ylim(2)
            pharma_stack_burst{ii}{jj}.YLim = train_ylim;
        end
        
        % pharma_stack_burst{ii}{jj}.YLim = pharma_stack{ii}{jj}.YLim;
        % if ii == 1 && jj == 4
        %     pharma_stack_burst{ii}{jj}.Position([2]) = pharma_stack{ii}{jj}.Position([2]);
        % else
            pharma_stack_burst{ii}{jj}.Position([2,4]) = pharma_stack{ii}{jj}.Position([2,4]);
        % end
    end
end


%Add washin label
% for ii = 1:numel(pharma_stack_burst)
%     for jj = 1:4
%         curr_label = ['\color[rgb]{',num2str(all_colors_pharma(jj,:)),'}',...
%                     all_row_labels{jj}];
%         curr_t = text(pharma_stack_burst{ii}{jj},0,0,curr_label,...
%             'Units','normalized',...
%             'Position',[0.5 1 0],'VerticalAlignment','bottom',...
%             'HorizontalAlignment','left');
%         curr_t.Units = 'data';
%     end
% end




%Label train input
text(input_ax_burst{1},0,2,'0','VerticalAlignment','bottom')
text(input_ax_burst{1},0.6,102,'100','VerticalAlignment','bottom','HorizontalAlignment','center')
