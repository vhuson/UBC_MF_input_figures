%% Example + summary figure
%19, 29 51
typ_cell_IDs = {'1657','1685','1758'};
[typ_cell_idxs,typ_cell_num] = UBC_cell_ID2idx(fileNames,typ_cell_IDs,ONidx);

f_burst_typ = figure('Position', [488 1.8000 936.8000 852.6545],...
    'Color','w');


base_width = 0.28;
base_height = 0.05;
top_margin = 0.96;
left_margin = 0.07;
base_space = 0.01;
base_hspace = 0.02;

pos_ax = [left_margin top_margin+base_space,...
    base_width base_height];


curr_cell = typ_cell_num(1);

all_colors = bbpr(5);
lim_x = [-1 1.5];
input_dur = [0.0100    0.0200    0.0500    0.1000    0.2000];

zerod_x = [0.5 0.51 0.54 0.59 0.69];
trace_labels = {'1x','2x','5x','10x','20x'};

opts = struct();
opts.axis_off = true;
opts.pad = false;

[ax_burst_typfast] = plot_burst_examples_v2(all_mean_bursts,...
    Fs,all_baseline,ONidx,curr_cell,all_colors,lim_x,zerod_x,input_dur,trace_labels,opts,...
    f_burst_typ,pos_ax,base_height,base_space);


pos_ax(2) = pos_ax(2) - base_height*6 - base_space*6;
[ax_burst_typfast{6}] = plot_burst_traces_overlay(all_mean_bursts,Fs,...
    ONidx,curr_cell,all_colors,zerod_x,...
    [],lim_x+0.5,f_burst_typ,pos_ax,opts);

scale_opts = struct();
scale_opts.xlabel = 's';
add_scale_bar(ax_burst_typfast{6},[1,0],scale_opts);


pos_ax(1) = left_margin + base_width + base_hspace;
pos_ax(2) = top_margin+base_space;

curr_cell = typ_cell_num(2);
lim_x = [-1 3.5];

[ax_burst_typmid] = plot_burst_examples_v2(all_mean_bursts,...
    Fs,all_baseline,ONidx,curr_cell,all_colors,lim_x,zerod_x,input_dur,[],opts,...
    f_burst_typ,pos_ax,base_height,base_space);

pos_ax(2) = pos_ax(2) - base_height*6 - base_space*6;
[ax_burst_typmid{6}] = plot_burst_traces_overlay(all_mean_bursts,Fs,...
    ONidx,curr_cell,all_colors,zerod_x,...
    [],lim_x+0.5,f_burst_typ,pos_ax,opts);

add_scale_bar(ax_burst_typmid{6},[1,0],scale_opts);


pos_ax(1) = left_margin + base_width*2 + base_hspace*2;
pos_ax(2) = top_margin+base_space;

curr_cell = typ_cell_num(3);
lim_x = [-1 6.5];

[ax_burst_typslow] = plot_burst_examples_v2(all_mean_bursts,...
    Fs,all_baseline,ONidx,curr_cell,all_colors,lim_x,zerod_x,input_dur,[],opts,...
    f_burst_typ,pos_ax,base_height,base_space);

pos_ax(2) = pos_ax(2) - base_height*6 - base_space*6;
[ax_burst_typslow{6}] = plot_burst_traces_overlay(all_mean_bursts,Fs,...
    ONidx,curr_cell,all_colors,zerod_x,...
    [],lim_x+0.5,f_burst_typ,pos_ax,opts);

add_scale_bar(ax_burst_typslow{6},[1,0],scale_opts);


title(ax_burst_typfast{1},'Fast')
title(ax_burst_typmid{1},'Medium')
title(ax_burst_typslow{1},'Slow')


base_width = 0.14;
bar_width = 0.07;
base_space = 0.09;

graph_height = 0.17;

pos_ax(1) = left_margin;
pos_ax(2) = pos_ax(2)- graph_height - 0.06;
pos_ax(3:4) = [base_width, graph_height];
% pos_ax = [0.07 0.07 base_width 0.2064];

[ax_burst_par1] = UBC_par_line_plot(...
    ONidx,OFFidx,all_burst_n_spikes,[0 1 0],-Inf,f_burst_typ,pos_ax);
ylabel("Response spikes (n)")
ax_burst_par1.YTick = 10.^(-4:4);
ax_burst_par1.YTickLabel = string(10.^(-4:4));
ax_burst_par1.YRuler.MinorTickValues = 10.^(-4:4);

pos_ax(1) = sum(pos_ax([1,3]))+base_space;
[ax_burst_par2] = UBC_par_line_plot(...
    ONidx,OFFidx,all_burst_slow_amp,[0 1 0],1,f_burst_typ,pos_ax);
ylabel('Peak response (\Deltaspk/s)')
ax_burst_par2.YTick = 10.^(-4:4);
ax_burst_par2.YTickLabel = string(10.^(-4:4));
ax_burst_par2.YTickLabel(5) = {'<1'};
ax_burst_par2.YRuler.MinorTickValues = 10.^(-4:4);

pos_ax(1) = sum(pos_ax([1,3]))+base_space;
[ax_burst_par3] = UBC_par_line_plot(...
    ONidx,OFFidx,all_burst_slow_HD,[0 1 0],-Inf,f_burst_typ,pos_ax);
ylabel('Half-width (s)')
ax_burst_par3.YTick = 10.^(-4:4);
ax_burst_par3.YTickLabel = string(10.^(-4:4));
ax_burst_par3.YRuler.MinorTickValues = 10.^(-4:4);
ax_burst_par3.YLim(2) = 10;

pos_ax(1) = sum(pos_ax([1,3]))+base_space;
pos_ax(3) = base_width + bar_width;
[ax_burst_par4] = UBC_par_line_plot(...
    ONidx,OFFidx,all_burst_pause,[0 1 1],-Inf,f_burst_typ,pos_ax);
ylabel('Pause (s)')
ax_burst_par4.YTick = 10.^(-4:4);
ax_burst_par4.YTickLabel = string(10.^(-4:4));
ax_burst_par4.YRuler.MinorTickValues = 10.^(-4:4);
ax_burst_par4.YLim(1) = 0.001;





% save_figure_larger(f_burst,4);
