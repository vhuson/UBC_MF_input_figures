%% Plot all traces stacked on top of eachother
f_burst = figure('Position', [488 1.8000 936.8000 852.6545],...
    'Color','w');
numc = numel(allData);
select_cells = round(1:numc/numc:numc);
select_cells(end) = numc;
% select_cells(3) = select_cells(3)+1;
select_cells = ONidx(select_cells);


%1x
base_width = 0.035;
pos_bottom = 0.03;
pos_height = 0.93;

pos_ax = [0.0500    pos_bottom    1*base_width   pos_height];
stack_opts = struct();
stack_opts.Visible = 'off';
[burst_stack_1] = plot_stacked_traces(...
    all_mean_bursts{1},Fs,select_cells,f_burst,pos_ax,stack_opts);
set_axstack_par(burst_stack_1,'XLim',[0.3 1.3]);
burst_stack_1{1}.Title.String = '1x';
mid_ax = burst_stack_1{ceil(numel(burst_stack_1)/2)};
text(mid_ax,mid_ax.XLim(1)-0.35,mean(mid_ax.YLim),'Response (spk/s)',...
    'HorizontalAlignment','center',...
    'VerticalAlignment','bottom',...
    'Rotation',90,...
    'FontName','Arial','FontSize',12);



%2x 100Hz
pos_ax = [sum(pos_ax([1,3]))+0.01   pos_bottom    2*base_width    pos_height];
[burst_stack_2] = plot_stacked_traces(...
    all_mean_bursts{2},Fs,select_cells,f_burst,pos_ax,stack_opts);
set_axstack_par(burst_stack_2,'XLim',[0.15 2.15]);
burst_stack_2{1}.Title.String = '2x 100 Hz';



%5x 100Hz
pos_ax = [sum(pos_ax([1,3]))+0.01    pos_bottom    5*base_width    pos_height];
[burst_stack_3] = plot_stacked_traces(...
    all_mean_bursts{3},Fs,select_cells,f_burst,pos_ax,stack_opts);
set_axstack_par(burst_stack_3,'XLim',[0 5]);
burst_stack_3{1}.Title.String = '5x 100 Hz';



%10x 100Hz
pos_ax = [sum(pos_ax([1,3]))+0.01    pos_bottom    7*base_width   pos_height];
[burst_stack_4] = plot_stacked_traces(...
    all_mean_bursts{4},Fs,select_cells,f_burst,pos_ax,stack_opts);
burst_stack_4{1}.Title.String = '10x 100 Hz';
set_axstack_par(burst_stack_4,'XLim',[0 7]);



%20x 100Hz
pos_ax = [sum(pos_ax([1,3]))+0.01    pos_bottom    10*base_width    pos_height];
[burst_stack_5] = plot_stacked_traces(...
    all_mean_bursts{5},Fs,select_cells,f_burst,pos_ax,stack_opts);
burst_stack_5{1}.Title.String = '20x 100 Hz';
set_axstack_par(burst_stack_5,'XLim',[0 10]);
scale_opts = struct();
scale_opts.xlabel = 's';
scale_opts.origin = [8.5,0];

same_ylim_stack({burst_stack_1, burst_stack_2, burst_stack_3,burst_stack_4,burst_stack_5});
add_scale_bar(burst_stack_5{end},[1,0],scale_opts);