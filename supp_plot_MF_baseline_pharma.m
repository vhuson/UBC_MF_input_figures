%% Get files, general means, and ONidx
%Takes a long time
load_all_data = false; %if false just loads variables required for the figure

%Set up path
run('load_data_scripts\setup_general_path.m')

if load_all_data
    run('load_data_scripts\setup_workspace_alldata.m')
    run('analyze_data_scripts\analyze_baseline_pharma.m')
else
    load('saved_workspaces\supp_plot_MF_baseline_pharma_workspace.mat')
end



%% Main figure
f_base_pharma = figure('Position', [488 1.8000 680.3150 857.9636],...
    'Color','w');


example_cell_ci_pharma_panel

average_example_cell_ci_pharma_panel

all_heatmaps_ci_pharma_panel

summary_basepharma_panel

%Tweak figure
fig_opts = struct();
fig_opts.FontSize = 10;
standardFig(f_base_pharma,fig_opts);


%Add labels
plot_labels = repmat({[]},1,63);
plot_labels{1} = 'a';
plot_labels{25} = 'b';
plot_labels{49} = 'c';
plot_labels{61} = 'd';
% plot_labels{62} = 'e';
% plot_labels{63} = 'f';

[~,t_labels] = labelPlots(f_base_pharma,plot_labels);


for ii = [1,3,4]
    t_labels{ii}.Position(1) = -29;
end
t_labels{4}.Position(2) = 94;

t_labels{2}.Position(1) = -13;
% for ii = 4:6
%     t_labels{ii}.Position(1) = -49;
%     t_labels{ii}.Position(2) = 115;
% end

% exportgraphics(f_base_pharma,'pdf\240801_supp2.pdf','ContentType','vector')

%% Other figures

if false %run manually to plot may require load_all_data
all_heatmaps_ci_pharma_figure

stacked_traces_parheatmap_figure

baseline_pharma_ratiopar_figure
end


