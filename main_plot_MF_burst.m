%% Get files, general means, and ONidx
%Load raw data and reanalyze (takes a long time)
load_all_data = false; %if false just loads variables required for the figure

%Set up path
run('load_data_scripts\setup_general_path.m')

if load_all_data
    run('load_data_scripts\setup_workspace_alldata.m')
    run('analyze_data_scripts\analyze_burst.m')
else
    load('saved_workspaces\main_plot_MF_burst_workspace.mat')
end



%% Main figure
f_burst = figure('Position', [488 1.8000 680.3150 857.9636],...
    'Color','w');


%Run panel scripts
% example_cell_panel
example_cell_panel_reordered

heatmap_panel

summary_lineplots_panel
summary_peak_panel


%Tweak figure
fig_opts = struct();
fig_opts.FontSize = 10;
standardFig(f_burst,fig_opts);



%Add labels
plot_labels = repmat({[]},1,27);
plot_labels{1} = 'a';
% plot_labels{6} = 'b';
% plot_labels{11} = 'c';
plot_labels{26} = 'b';
plot_labels(31:33) = {'c','e','f'};
plot_labels(35) = {'d'};
[~,t_labels] = labelPlots(f_burst,plot_labels);

for ii = 1:numel(t_labels)
    t_labels{ii}.Position(1) = t_labels{ii}.Position(1)-14;
    
end

% exportgraphics(f_burst,'pdf\240809_fig2.pdf','ContentType','vector')

%% Other figure scripts

if false %run manually to plot may require load_all_data
heatmap_figure
stacked_traces_figure
example_summary_figure
alt_onidx_figure
end


