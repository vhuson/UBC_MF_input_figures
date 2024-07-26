%% Typical examples script
% %
% f_burst_cpp = figure('Position', [488 1.8000 680.3150 857.9636],...
%     'Color','w');

% curr_cells = [5, 9, 13, 18, 24];
% typ_cell_IDs = {'1686','1694','1776','1774','1709'};

% curr_cells = [8, 10, 13, 18, 24];
% typ_cell_IDs = {'1854','1859'};
% typ_cell_IDs = {'1862','1859'};
typ_cell_IDs = {'1865','1859'};
[typ_cell_idxs,curr_cells] = UBC_cell_ID2idx(fileNames(washin_fltr),typ_cell_IDs,fltr_ONidx);




% all_lim_x = {[-0.21 0.7], [-0.6 2], [-1.5 5]};

all_lim_x = {[-0.3 1], [-0.3 1], [-0.3 2],[-0.3 3],[-0.3 5]};
diff_lim_x = cellfun(@diff,all_lim_x);

num_rows = numel(curr_cells)+1;
num_cols = 5; %Number of burst types

left_edge = 0.1;
top_edge = 1.02;
total_height = 0.27;
total_width = 0.87;
height_space = 0.015;
base_space = 0.01;
input_height = 0.02;

bottom_edge = top_edge - total_height;



graph_height = (total_height - height_space*(num_rows-1)) / num_rows;
% base_width = (total_width - base_space*(num_cols-1)) / num_cols;
%Width based on xlim
base_width = (total_width - base_space*(num_cols-1)) /  sum(diff_lim_x);



% all_left_edge = (base_width + base_space) .* (0:(num_cols-1)) + left_edge;
%Width based on xlim
all_left_edge = [0 cumsum(base_width .* diff_lim_x(1:end-1))...
    + base_space .* (1:(num_cols-1))] + left_edge;

all_bottom_edge = (graph_height + height_space) .* (0:(num_rows-1)) + bottom_edge;
all_bottom_edge = fliplr(all_bottom_edge);




select_cells = fltr_ONidx;


input_color = [0.2 0.7 0.2];
input_dur = [0.0100    0.0200    0.0500    0.1000    0.2000];
input_times = {[0 0.01],[0 0.02],[0 0.05],[0 0.1],[0 0.2]};


all_x_scales = [0.2 1 2];


seed_colors_pharma = [0 0 0;
    1 0.0 0.9];


all_colors_pharma = seed_map(seed_colors_pharma,2);

trace_labels = {'Baseline','−NMDAR'};
all_titles = {'1' '2' '5' '10' '20'};

opts = struct();
opts.axis_off = true;

%Scale bar options
scale_opts = struct();
scale_opts.ylabel = 'spk/s';
scale_opts.y_2line = true;
all_scale_origin = {[4.5 65],[4.5 35],[2 50],[2 80],[1 14]};
all_scale_size = {[0 50], [0.5 10], [0 50], [0 50], [1 10]};

man_ylim = [0 0 1];
all_ylim = {[],[0 50]};

ax_cpp_typ = {};

for ii = 1:numel(curr_cells)+1
    if ii > 1
        curr_cell = curr_cells(ii-1);
    end
    % lim_x = all_lim_x{ii};

    for pharm_burst_idx = 1:5
        lim_x = all_lim_x{pharm_burst_idx};

        pos_ax = [all_left_edge(pharm_burst_idx) all_bottom_edge(ii)...
            base_width*diff_lim_x(pharm_burst_idx) graph_height];


        if ii == 1 %Draw input trace
            curr_input = input_times{pharm_burst_idx};
            x_time = (-0.5*Fs:30*Fs)/Fs;
            dummy_y = zeros(size(x_time));
            input_start = find(x_time >= curr_input(1),1);
            input_end = find(x_time >= curr_input(2),1);
            dummy_y(input_start:input_end) = 100;

            % curr_ax = {axes('Position',pos_ax)};
            % plot(x_time,dummy_y,'Color',input_color);
            % ylim([0 100]);
            % xlim(curr_xlim);
            pos_ax(2) = pos_ax(2) + height_space + base_space;
            [curr_ax] = plot_burst_examples_v2({dummy_y},...
                Fs,0,1,1,input_color,...
                lim_x,0,0,{[]},opts,...
                f_burst_cpp,pos_ax,height_space,base_space);
            curr_ax{1}.Position(4) = input_height;
            
        else

            trace_array = {all_mean_cpp_bursts1{pharm_burst_idx},...
                all_mean_cpp_bursts2{pharm_burst_idx}};

            [ax_cpp_typ{ii-1,pharm_burst_idx}] = plot_burst_traces_overlay(trace_array,Fs,...
                select_cells,curr_cell,all_colors_pharma,repmat(0.5,1,4),...
                [],lim_x,f_burst_cpp,pos_ax,opts);

            ylabel(['Cell #',num2str(curr_cell),'\newlineResponse (spk/s)'])


            if man_ylim(ii)
                ylim(all_ylim{ii-1})
            end


            

        end

        if ii == 1
            title(all_titles{pharm_burst_idx})
            curr_ax{1}.Title.Position(1) = mean(input_times{pharm_burst_idx});
        end



    end

    if ii > 1

        if ii == 2
            label_string = {'Cell\newline',['#',num2str(curr_cell)]};
        else
            label_string = ['#',num2str(curr_cell)];
        end

        text(ax_cpp_typ{ii-1,1},0,0,label_string,'Units','normalized',...
            'Position',[-0.01 0.5],'VerticalAlignment','middle',...
            'HorizontalAlignment','right')

        same_ylim(ax_cpp_typ(ii-1,:))

        if ii == numel(curr_cells) +1
            scale_opts.xlabel = 's';
        end
        scale_opts.origin = all_scale_origin{ii-1};
        add_scale_bar(ax_cpp_typ{ii-1,end},all_scale_size{ii-1},scale_opts);
        opts.scale_xlabel = [];
        opts.scale_ylabel = [];
    end
    
end

%Add input line
% il_opts = struct();
% il_opts.input_color = [0.2 0.7 0.2];
% input_durs = {[0 0.01],[0 0.02],[0 0.05],[0 0.1],[0 0.2]};
% 
% for ii = 1:numel(input_durs)
%     input_dur = input_durs{ii};
% 
%     cellfun(@(x) add_input_line(x,input_dur,il_opts),ax_cpp_typ(:,ii));
% end

% scale_opts = struct();
% scale_opts.xlabel = 's';
% scale_opts.origin = [1 14];
% scale_opts.xscale_factor = 1e3;
% scale_opts.ylabel = 'spk/s';
% add_scale_bar(ax_pharm_typ{ii,end},[1 0],scale_opts);

% legend_labels = {'Baseline','−mGluR2/3','−AMPAR','−mGluR1'};
% legend(ax_pharm_typ{1,3},legend_labels,...
%     'Orientation','horizontal',...
%     'Box', 'off',...
%     'NumColumns',2,...
%     'Units','normalized',...
%     'Position', [0.1452 0.9435 0.3319 0.0459])
% legend_labels = {'1: Baseline','2: −mGluR2/3','3: −AMPAR','4: −mGluR1'};


%Separate text labels for legend
%{
legend_positions = {[-186.6364 -33.0378 0],...
        [-104.0764 -33.0378 0],...
        [-21.5164 -33.0378 0],...
        [61.0436 -33.0378 0]};


for ii = 1:numel(legend_labels)
    text(ax_pharm_typ{end,end},0,0,legend_labels{ii},...
        'Units','pixels',...
        'HorizontalAlignment','center',...
        'Position',legend_positions{ii})

end
%}



legend_labels = {'Baseline','NMDAR\newlineblocked'};
legend(ax_cpp_typ{ii-1,1},legend_labels,...
    'Orientation','vertical',...
    'Box', 'off',...
    'NumColumns',1,...
    'Units','normalized',...
    'Position', [0.8340 0.9089 0.1570 0.0683])

curr_ax{1}.XLim(2) = curr_ax{1}.XLim(1) + diff(curr_ax{1}.XLim) * 0.6;
curr_ax{1}.Position(3) = curr_ax{1}.Position(3) * 0.6;