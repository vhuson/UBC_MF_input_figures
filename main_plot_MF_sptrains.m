%% Get files, general means, and ONidx
%Takes a long time
load_all_data = false; %if false just loads variables required for the figure

%Set up path
run('load_data_scripts\setup_general_path.m')

if load_all_data
    run('load_data_scripts\setup_workspace_alldata.m')
    run('analyze_data_scripts\analyze_sptrains.m')
else
    load('saved_workspaces\main_plot_MF_sptrains_workspace.mat')
end




%% Main figure
f_train = figure('Position', [488 1.8000 680.3150 857.9636],...
    'Color','w');

train5_examples_panel
train5_burst_examples_panel


train5_heatmap_panel
train5_burst_heatmap_panel

train5_summaries_panel
% train5_line_summaries_panel
train5_time_to_peak_plot


%Tweak figure
fig_opts = struct();
fig_opts.FontSize = 10;
standardFig(f_train,fig_opts);

%Add labels
plot_labels = repmat({[]},1,31);
plot_labels{17} = 'a';
plot_labels{9} = 'b';
plot_labels{27} = 'c';
plot_labels{26} = 'd';
plot_labels{28} = 'e';
plot_labels{30} = 'f';
plot_labels{31} = 'h';
plot_labels{32} = 'g';

[~,t_labels] = labelPlots(f_train,plot_labels);

for ii = [2, 4, 5]
    t_labels{ii}.Position(1) = t_labels{ii}.Position(1)-14;
end
for ii = [1,3]
    t_labels{ii}.Position(1) = 0;
end

for ii = 5:8
    t_labels{ii}.Position(2) = t_labels{ii}.Position(2)+10;
end
for ii = 6:8
    t_labels{ii}.Position(1) = -58;
end


% exportgraphics(f_train,'pdf\240810_fig4.pdf','ContentType','vector')
%%
if false %run manually to plot may require load_all_data
%calculate correlation
train5_HDvsHW_corr

%Other plots
train5_20s_figure
plot_trains_stacked_figure
end