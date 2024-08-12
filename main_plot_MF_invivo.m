%% Setup workspace
%Need all data for this figure
run('load_data_scripts\setup_workspace_invivo.m')


%% Figure with burst

f_mf_burst = figure('Position', [488 1.8000 680.3150 857.9636],...
    'Color','w');

show_individual_traces = true;
median_fltr = false;
% input_color = [0.1608    0.1608    0.7294];
input_color = [0.2 0.7 0.2];

plot_burst_traces_panel

plot_invivoSP_traces_panel

% plot_invivo_heatmap_panel

%Tweak figure
fig_opts = struct();
fig_opts.FontSize = 10;
standardFig(f_mf_burst,fig_opts);


%Add labels
plot_labels = repmat({[]},1,17);
plot_labels{1} = 'b';
plot_labels{2} = 'c';
plot_labels{11} = 'd';
[f_mf_burst,t_labels] = labelPlots(f_mf_burst,plot_labels);

t_labels{1}.Position(1) = -36;
t_labels{3}.Position(1) = -36;
t_labels{2}.Position(1) = -11;

% exportgraphics(f_mf_burst,'pdf\240730_fig1.pdf','ContentType','vector')

%% other figures
if false %run manually to plot
plot_new_invivoSP_traces_figure

end