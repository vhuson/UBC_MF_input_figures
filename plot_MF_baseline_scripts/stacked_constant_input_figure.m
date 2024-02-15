%% Figure with constant input responses stacked and ordered
%Only plot subset
% numc = numel(allData);
% select_cells = round(1:numc/20:numc);
% select_cells(end) = numc;
% select_cells = ONidx(select_cells);

select_cells = ONidx;


f1 = figure('Position', [488 1.8000 936.8000 857.9636],...
    'Color','w');

base_width = 0.28;
base_space = 0.03;
pos_bottom = 0.03;
pos_height = 0.93;

pos_ax = [0.0500    pos_bottom    base_width   pos_height];


stack_opts = struct();
stack_opts.Visible = 'off';
[ax_stack_1] = plot_stacked_traces(...
    all_full_traces{1},Fs,select_cells,f1,pos_ax,stack_opts);
set_sensible_ylim(ax_stack_1);
ax_stack_1{1}.Title.String = '1 Hz';
mid_ax = ax_stack_1{ceil(numel(ax_stack_1)/2)};
text(mid_ax,mid_ax.XLim(1)-0.35,mean(mid_ax.YLim),'Response (spk/s)',...
    'HorizontalAlignment','center',...
    'VerticalAlignment','bottom',...
    'Rotation',90,...
    'FontName','Arial','FontSize',12);

pos_ax(1) = pos_ax(1)+base_width+base_space;

[ax_stack_2] = plot_stacked_traces(...
    all_full_traces{2},Fs,select_cells,f1,pos_ax,stack_opts);
set_sensible_ylim(ax_stack_2);
ax_stack_2{1}.Title.String = '2.5 Hz';

pos_ax(1) = pos_ax(1)+base_width+base_space;

[ax_stack_3] = plot_stacked_traces(...
    all_full_traces{3},Fs,select_cells,f1,pos_ax,stack_opts);
set_sensible_ylim(ax_stack_3);
ax_stack_3{1}.Title.String = '5 Hz';

same_ylim_stack({ax_stack_1, ax_stack_2, ax_stack_3},20);

scale_opts = struct();
scale_opts.xlabel = 's';
scale_opts.origin = [8.5,0];

add_scale_bar(ax_stack_3{end},[1,0],scale_opts);