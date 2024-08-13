%% Setup workspace
load_all_data = false; %Takes a long time

%Set up path
run('load_data_scripts\setup_general_path.m')

if load_all_data
    run('load_data_scripts\setup_workspace_cpp.m')
    run('analyze_data_scripts\analyze_cpp.m')
else
    load('saved_workspaces\supp_plot_MF_cpp_workspace.mat')
end

%% Main cpp burst figure
f_burst_cpp = figure('Position', [488 1.8000 680.3150 857.9636],...
    'Color','w');



example_cell_cpp_panel


heatmap_cpp_panel

% summaries_cpp_panel
summaries_component_cpp_panel

%Tweak figure
fig_opts = struct();
fig_opts.FontSize = 10;
standardFig(f_burst_cpp,fig_opts);


%Add labels
plot_labels = repmat({[]},1,120);
plot_labels{1} = 'a';
plot_labels{17} = 'b';
plot_labels{27} = 'c';
% plot_labels{31} = 'd';
% plot_labels{97} = 'e';
% plot_labels{102} = 'f';
% plot_labels{82} = 'e';
[~,t_labels] = labelPlots(f_burst_cpp,plot_labels);


for ii = 1:numel(t_labels)
    t_labels{ii}.Position(1) = -41;
end

t_labels{3}.Position(2) = 115.1273;

% exportgraphics(f_burst_cpp,'pdf\240801_supp_cpp1.pdf','ContentType','vector')

%% Main cpp train figure
f_train_cpp = figure('Position', [488 1.8000 680.3150 857.9636],...
    'Color','w');

train_example_cell_cpp_panel
train_example_bursts_cpp_panel
% 
%Heatmaps including bursts
train_heatmap_burst_cpp_panel
train_heatmap_cpp_panel

train_component_cpp_panel
% train_nspike_summary_cpp_panel


%Tweak figure
fig_opts = struct();
fig_opts.FontSize = 10;
standardFig(f_train_cpp,fig_opts);

%Add labels
plot_labels = repmat({[]},1,46);
plot_labels{11} = 'a';
plot_labels{2} = 'b';
plot_labels{16} = 'c';
plot_labels{19} = 'd';
plot_labels{22} = 'e';
% plot_labels{46} = 'f';
[~,t_labels] = labelPlots(f_train_cpp,plot_labels);
for ii = 2:numel(t_labels)
    t_labels{ii}.Position(1) = -41;
end

for ii = [1,4]
    t_labels{ii}.Position(1) = -1;
end
% exportgraphics(f_train_cpp,'pdf\240801_supp_cpp2.pdf','ContentType','vector')





