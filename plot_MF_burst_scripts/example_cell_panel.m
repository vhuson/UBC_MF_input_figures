% f_burst = figure('Position', [488 1.8000 680.3150 857.9636],...
%     'Color','w');


typ_cell_IDs = {'1657','1685','1758'};
[typ_cell_idxs,typ_cell_num] = UBC_cell_ID2idx(fileNames,typ_cell_IDs,ONidx);

base_width = 0.263;
base_height = 0.027;
top_margin = 0.98;
left_margin = 0.08;
base_space = 0.003;
base_hspace = 0.02;

pos_ax = [left_margin top_margin+base_space,...
    base_width base_height];


curr_cell = typ_cell_num(1);

all_colors = bbpr(5);
lim_x = [-1 1.5];
input_dur = [0.0100    0.0200    0.0500    0.1000    0.2000];

%Offset based on stim end
zerod_x = [0.5 0.51 0.54 0.59 0.69];


%Offset to stim begin
zerod_x = [0.5 0.5 0.5 0.5 0.5];
%Overlay aligned to end (20x sets the tone)
zerod_x_overlay = [0.31 0.32 0.35 0.4 0.5];
% zerod_x_overlay = [0.5 0.51 0.54 0.59 0.69];

trace_labels = {'1x','2x','5x','10x','20x'};

opts = struct();
opts.axis_off = true;
opts.pad = false;

[ax_burst_typfast] = plot_burst_examples_v2(all_mean_bursts,...
    Fs,all_baseline,ONidx,curr_cell,all_colors,lim_x,zerod_x,input_dur,trace_labels,opts,...
    f_burst,pos_ax,base_height,base_space);


pos_ax(2) = pos_ax(2) - base_height*6 - base_space*6;
[ax_burst_typfast{6}] = plot_burst_traces_overlay(all_mean_bursts,Fs,...
    ONidx,curr_cell,all_colors,zerod_x_overlay,...
    [],lim_x+0.5,f_burst,pos_ax,opts);

scale_opts = struct();
scale_opts.xlabel = 's';
add_scale_bar(ax_burst_typfast{6},[1,0],scale_opts);


pos_ax(1) = left_margin + base_width + base_hspace;
pos_ax(2) = top_margin+base_space;

curr_cell = typ_cell_num(2);
lim_x = [-1 3.5];

[ax_burst_typmid] = plot_burst_examples_v2(all_mean_bursts,...
    Fs,all_baseline,ONidx,curr_cell,all_colors,lim_x,zerod_x,input_dur,[],opts,...
    f_burst,pos_ax,base_height,base_space);

pos_ax(2) = pos_ax(2) - base_height*6 - base_space*6;
[ax_burst_typmid{6}] = plot_burst_traces_overlay(all_mean_bursts,Fs,...
    ONidx,curr_cell,all_colors,zerod_x_overlay,...
    [],lim_x+0.5,f_burst,pos_ax,opts);

add_scale_bar(ax_burst_typmid{6},[1,0],scale_opts);


pos_ax(1) = left_margin + base_width*2 + base_hspace*2;
pos_ax(2) = top_margin+base_space;

curr_cell = typ_cell_num(3);
lim_x = [-1 6.5];

%Smaller YLim
opts.YLim = [0 28];
[ax_burst_typslow] = plot_burst_examples_v2(all_mean_bursts,...
    Fs,all_baseline,ONidx,curr_cell,all_colors,lim_x,zerod_x,input_dur,[],opts,...
    f_burst,pos_ax,base_height,base_space);

pos_ax(2) = pos_ax(2) - base_height*6 - base_space*6;
[ax_burst_typslow{6}] = plot_burst_traces_overlay(all_mean_bursts,Fs,...
    ONidx,curr_cell,all_colors,zerod_x_overlay,...
    [],lim_x+0.5,f_burst,pos_ax,opts);

add_scale_bar(ax_burst_typslow{6},[1,0],scale_opts);


t1 = title(ax_burst_typfast{1},['Cell #',num2str(typ_cell_num(1))],...
    'Units', 'normalized','Position', [0.5000 0.6799 0]);
title(ax_burst_typmid{1},['Cell #',num2str(typ_cell_num(2))],...
    'Units', 'normalized','Position', [0.5000 0.6799 0]);
title(ax_burst_typslow{1},['Cell #',num2str(typ_cell_num(3))],...
    'Units', 'normalized','Position', [0.5000 0.6799 0]);