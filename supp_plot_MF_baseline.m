%% Get files, general means, and ONidx
%Takes a long time
load_all_data = false; %if false just loads variables required for the figure

%Set up path
run('load_data_scripts\setup_general_path.m')

if load_all_data
    run('load_data_scripts\setup_workspace_alldata.m')
    run('analyze_data_scripts\analyze_baseline.m')
else
    load('saved_workspaces\supp_plot_MF_baseline_workspace.mat')
end


%% Main figure
f_base = figure('Position', [488 1.8000 680.3150 857.9636],...
    'Color','w');

% Example traces and spike triggered average traces
examples_constant_input_panel

%Heatmap
% heatmap_constant_input_panel
heatmap_noavg_constant_input_panel

%Summary panels
% summaries_constant_input_panel
summaries_reordered_constant_input_panel

%Tweak figure
fig_opts = struct();
fig_opts.FontSize = 10;
standardFig(f_base,fig_opts);

%Add labels
plot_labels = repmat({[]},1,40);
plot_labels{1} = 'a';
plot_labels{2} = 'b';
plot_labels{31} = 'c';
plot_labels(34:36) = {'e','d','f'};

[~,t_labels] = labelPlots(f_base,plot_labels);


for ii = [1,3]
    t_labels{ii}.Position(1) = -29;
end

for ii = 4:6
    t_labels{ii}.Position(1) = -67;
end

for ii = 4:5
    t_labels{ii}.Position(2) = 89;
end


% exportgraphics(f_base,'pdf\240801_supp1.pdf','ContentType','vector')
%% Other figures

if false %run manually to plot may require load_all_data
stacked_constant_input_figure

heatmap_constant_input_figure

heatmap_parameter_constant_input_figure

par_overtime_constant_input_figure

par_constant_input_line_figure

examples_constant_input_figure

steadystate_1s_constant_input_line_figure

superimposed_avgsegment_constant_input_figure

stacked_avgsegment_constant_input_figure

summary_test_figure

old_summaries_ci_figure

end