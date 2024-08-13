%% Get files, general means, and ONidx
%Load raw data and reanalyze (takes a long time)
load_all_data = false; %if false just loads variables required for the figure

%Set up path
run('load_data_scripts\setup_general_path.m')

if load_all_data
    run('load_data_scripts\setup_workspace_alldata.m')
    run('analyze_data_scripts\analyze_burst_pharma.m')
else
    load('saved_workspaces\main_plot_MF_burst_pharma_workspace.mat')
end



%% Main figure
f_burst_pharma = figure('Position', [488 1.8000 680.3150 857.9636],...
    'Color','w');



example_cell_bpharma_panel

% example_line_bpharma_panel
example_line_bpharma_v2_panel
example_line_bpharma_nspikes_panel

all_heatmaps_bpharma_panel

summaries_bpharma_panel
summaries_bpharm_component_panel
% summaries_bpharma_singlerow_panel

%Tweak figure
fig_opts = struct();
fig_opts.FontSize = 10;
standardFig(f_burst_pharma,fig_opts);

%avoid tweak on this
washin_graphic_panel
for ii = 1:4
    t_ml{ii}.FontSize = 9;
end

%Add labels
plot_labels = repmat({[]},1,106);
plot_labels{1} = 'a';
plot_labels{26} = 'b';
plot_labels{52} = 'c';
plot_labels{77} = 'd';
plot_labels{97} = 'e';
plot_labels{104} = 'f';
plot_labels{106} = 'g';
plot_labels{107} = 'h';
% plot_labels{82} = 'e';
[~,t_labels] = labelPlots(f_burst_pharma,plot_labels);

for ii = 1:numel(t_labels)
    t_labels{ii}.Position(1) = t_labels{ii}.Position(1)-14;
end
for ii = [1,4,5,6]
    t_labels{ii}.Position(1) = -58;
end
t_labels{6}.Position(2) = 81;

for ii = [7,8]
    t_labels{ii}.Position(1:2) = [-71 81];
end

% exportgraphics(f_burst_pharma,'pdf\240809_fig3.pdf','ContentType','vector')

%% Other figures

if false %run manually to plot may require load_all_data
all_heatmaps_bpharma_figure
example_cellslines_bpharma_figure
summaries_bpharma_figure
pilots_new_summaries
bad_pilots_new_summaries
end