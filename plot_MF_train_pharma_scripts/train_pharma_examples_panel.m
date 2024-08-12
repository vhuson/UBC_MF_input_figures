%% Plot trains stacked pharma
% 
% f_train_pharma = figure('Position', [488 1.8000 680.3150 857.9636],...
%     'Color','w');

select_cells = fltr_ONidx_tpharma;

% TRAIN5 selection
typ_cell_IDs = {'1823','1774'};
% typ_cell_IDs = {'1823','1817'};
% typ_cell_IDs = {'1823','1833'};

[typ_cell_idxs,typ_cell_num] = UBC_cell_ID2idx(fileNames(train_pharma_fltr),...
    typ_cell_IDs,select_cells);


y_labels_on = false;

input_color = [0.2 0.7 0.2];

%Set axis position
num_cells = numel(typ_cell_num);
num_cols = 1;
num_rows = num_cells * 4; %+1;

pos_bottom = 0.654;
cell_space = 0.021;
base_space = 0.011;
% pos_top = 0.96;
%Manual first panel
first_panel_bottom = 0.9461;
first_panel_height = 0.0139;

pos_top = first_panel_bottom - cell_space;
pos_height = pos_top - pos_bottom;
% pos_left = 0.1;
% full_width = 0.55;
pos_left = 0.205;
% full_width = 0.5234;
both_width = 0.6650;
zoom_gap = 0.0282;
full_width = (both_width-zoom_gap)/1.4;


% pos_left2 = 0.6722;
% base_width2 = 0.2921;
pos_left2 = pos_left+full_width+zoom_gap;
base_width2 = full_width*0.4;

base_height = pos_height - base_space * (num_rows-1) - cell_space * (num_cells-1);
base_height = base_height / num_rows;

all_bottom_edges = (base_height + base_space) .* (0:(num_rows-1));
all_bottom_edges = all_bottom_edges + pos_bottom;
all_bottom_edges = all_bottom_edges + floor(1/4:1/4:num_cells) .* cell_space;
all_bottom_edges = fliplr(all_bottom_edges);

all_bottom_edges = all_bottom_edges([4,8]);

cell_height = base_height * 4 + base_space *3;

%Gather data
trim_amount = 4*Fs + 1000;
input_train = input_train_5;
input_train = input_train(:,1:end-trim_amount);

curr_traces = all_mean_trains_pharma;
for ii = 1:numel(curr_traces)
    curr_traces{ii} = cellfun(@(x) {medfilt1(x,Fs*0.02)},curr_traces{ii});
    %Truncate longer traces
    curr_traces{ii} = cellfun(@(x) {x(1:800001)},curr_traces{ii});
    curr_traces{ii} = vertcat(curr_traces{ii}{:});

    %Trim end a bit
    curr_traces{ii} = curr_traces{ii}(:,1:end-trim_amount);
end


%Set plot options
% all_row_labels = {'Baseline','−mGluR2','−AMPAR','−mGluR1'};
% all_row_labels = {'Baseline','mGluR2/3 block','AMPAR block','mGluR1 block'};
all_row_labels = {{'Baseline'},{'mGluR2/3','block'},{'+ AMPAR' 'block'},...
    {'+ mGluR1' 'block'}};

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
pos_ax = [pos_left  first_panel_bottom(1)  full_width  first_panel_height];

[input_ax] = plot_stacked_traces(...
    input_train,Fs,1,f_train_pharma,pos_ax,stack_opts);
input_ax{1}.Children(1).Color = input_color;
input_ax{1}.Children(1).LineWidth = 1;

%Plot pulse 60 zoom in
stack_opts2 = stack_opts;
stack_opts2.XLim = [27.5 31];

pos_ax2 = [pos_left2  first_panel_bottom(1)  base_width2  first_panel_height];
[input_ax2] = plot_stacked_traces(...
    input_train,Fs,1,f_train_pharma,pos_ax2,stack_opts2);
input_ax2{1}.Children(1).Color = input_color;
input_ax2{1}.Children(1).LineWidth = 1;

%Loop over cells and plot
pharma_stack = {};
pharma_stack2 = {};
for ii = 1:num_cells
    %Set axis position
    pos_ax = [pos_left  all_bottom_edges(ii)  full_width  cell_height];

    %Get data
    plot_traces = cellfun(@(x) {x(typ_cell_idxs(ii),:)},curr_traces);
    plot_traces = vertcat(plot_traces{:});
    
    %Plot
    [pharma_stack{ii}] = plot_stacked_traces(...
    plot_traces,Fs,1:4,f_train_pharma,pos_ax,stack_opts);
    cellfun(@add_zero_line, pharma_stack{ii});


    %Plot pulse 60 zoom in
    pos_ax2 = [pos_left2  all_bottom_edges(ii)  base_width2  cell_height];

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
pharma_stack{1}{1}.YLim(2) = 160;
pharma_stack{1}{2}.YLim(2) = 160;
pharma_stack{1}{3}.YLim(2) = 160;
pharma_stack2{1}{1}.YLim(2) = 160;
pharma_stack2{1}{2}.YLim(2) = 160;
pharma_stack2{1}{3}.YLim(2) = 160;



%Axis size by ylim
cellfun(@axis_height_by_ylim,pharma_stack,'UniformOutput', false);
cellfun(@axis_height_by_ylim,pharma_stack2,'UniformOutput', false);


%Add washin label
% if y_labels_on
plus_offset = 16.5;
for ii = 1:numel(pharma_stack)
    for jj = 1:4
        % curr_label = ['\color[rgb]{',num2str(all_colors_pharma(jj,:)),'}',...
        %             all_row_labels{jj}];
        curr_label = all_row_labels{jj};

        if numel(curr_label) == 1
            curr_t = text(pharma_stack2{ii}{jj},1,0.5,curr_label,...
                'Units','normalized',...
                'Position',[1 0.5 0],'VerticalAlignment','middle',...
                'HorizontalAlignment','left');
            curr_t.Units = 'pixels';
            curr_t.Position(1) = curr_t.Position(1)+plus_offset;
            curr_t.Units = 'normalized';
        else
            curr_t1 = text(pharma_stack2{ii}{jj},1,0.5,curr_label{1},...
                'Units','normalized',...
                'Position',[1 0.5 0],'VerticalAlignment','bottom',...
                'HorizontalAlignment','left');
            curr_t2 = text(pharma_stack2{ii}{jj},1,0.5,curr_label{2},...
                'Units','normalized',...
                'Position',[1 0.5 0],'VerticalAlignment','top',...
                'HorizontalAlignment','left');

            curr_t1.Units = 'pixels';
            curr_t2.Units = 'pixels';
            curr_t1.Position(2) = curr_t1.Position(2)-2.5;
            curr_t2.Position(2) = curr_t2.Position(2)+2.5;
            
            if strcmp(curr_label{1}(1),'+')
                curr_t1.Position(1) = curr_t1.Position(1)+5;
            else
                curr_t1.Position(1) = curr_t1.Position(1)+plus_offset;
            end
            curr_t2.Position(1) = curr_t2.Position(1)+plus_offset;
            curr_t1.Units = 'normalized';
            curr_t2.Units = 'normalized';

        end
    end
end
% end


%Add scale bar
scale_opts = struct();
scale_opts.xlabel = 's';
scale_opts.ylabel = 'spk/s';
scale_opts.origin = [33,-85];
cellfun(@(x) add_scale_bar(x{end},[3 50],scale_opts),pharma_stack(1));
scale_opts.origin = [33,-70];
cellfun(@(x) add_scale_bar(x{end},[3 50],scale_opts),pharma_stack(2));

scale_opts.origin = [30.5,-85];
cellfun(@(x) add_scale_bar(x{end},[0.5 0],scale_opts),pharma_stack2(1));
scale_opts.origin = [30.5,-70];
cellfun(@(x) add_scale_bar(x{end},[0.5 0],scale_opts),pharma_stack2(2));


%annotation line for stim block
dist1 = train5_step_times(7) - stack_opts2.XLim(1);
scaled_dist1 = dist1/diff(stack_opts2.XLim);
scaled_dist2 = (dist1+1)/diff(stack_opts2.XLim);

xcord1 = pos_left2 + base_width2 * scaled_dist1;
xcord2 = pos_left2 + base_width2 * scaled_dist2;
h1 = annotation('line',repmat(xcord1,1,2),[pos_bottom all_bottom_edges(1)+cell_height],'Linewidth',1,'LineStyle',':','Color',[1 0 0]);
h2 = annotation('line',repmat(xcord2,1,2),[pos_bottom all_bottom_edges(1)+cell_height],'Linewidth',1,'LineStyle',':','Color',[1 0 0]);

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

% %Tweak figure
% fig_opts = struct();
% fig_opts.FontSize = 10;
% standardFig(f_train_pharma,fig_opts);
