%% Get files, general means, and ONidx
%Takes a long time
load_all_data = false; %if false just loads variables required for the figure

%Set up path
run('load_data_scripts\setup_general_path.m')

if load_all_data
    run('load_data_scripts\setup_workspace_alldata.m')
    run('analyze_data_scripts\analyze_sptrains_pharma.m')
else
    load('saved_workspaces\main_plot_MF_sptrains_pharma_workspace.mat')
end





%% Main figure
f_train_pharma = figure('Position', [488 1.8000 680.3150 857.9636],...
    'Color','w');

train_pharma_examples_panel
train_pharma_burst_examples_panel
% 
%Heatmaps including bursts
train_pharma_burst_heatmap_panel
train_pharma_heatmap_panel
% 
% train_pharma_summary_panel_peak
train_pharma_summary_panel_stimspikes
summaries_tpharm_component_panel
% train_pharma_summary_panel_postspikes
% train_pharma_summary_panel_percentspikes
% train_pharma_summary_panel


%Tweak figure
fig_opts = struct();
fig_opts.FontSize = 10;
standardFig(f_train_pharma,fig_opts);

%Add labels
plot_labels = repmat({[]},1,51);
plot_labels{19} = 'a';
plot_labels{2} = 'b';
% plot_labels{3} = 'c';
% plot_labels{7} = 'd';
% plot_labels{24} = 'c';
% plot_labels{11} = 'f';
% plot_labels{15} = 'g';
plot_labels{28} = 'c';
plot_labels{33} = 'd';
plot_labels{40} = 'e';
plot_labels{48} = 'f';
plot_labels{50} = 'g';
plot_labels{51} = 'h';
[~,t_labels] = labelPlots(f_train_pharma,plot_labels);

for ii = [1,4]
    t_labels{ii}.Position(1) = -6;
end
for ii = [2,3,5,6]
    t_labels{ii}.Position(1) = -47;
end
t_labels{5}.Position(2) = 102;
for ii = [7,8]
    t_labels{ii}.Position(1:2) = [-69 80];
end
t_labels{6}.Position(2) = 80;
% exportgraphics(f_train_pharma,'pdf\240809_fig5.pdf','ContentType','vector')
%% other figure
if false %run manually to plot may require load_all_data
train_pharma_20s_figure
end

