%% Supplementary figure showing RNA data
%Set up path
run('load_data_scripts\setup_general_path.m')
%load analyzed rna data
run('analyze_data_scripts\analyze_rna.m')

%% plot with all tarps in UBCs (No calret, hole)
f_RNA_ampar = figure('Position', [488 1.8000 680.3150 857.9636],...
    'Color','w');

rna_panel1

%Tweak figure
fig_opts = struct();
fig_opts.FontSize = 10;
standardFig(f_RNA_ampar,fig_opts);


%Add labels
plot_labels = repmat({[]},1,10);
plot_labels{1} = 'a';
plot_labels{2} = 'b';
plot_labels{6} = 'c';
plot_labels{9} = 'd';
% plot_labels{97} = 'e';
% plot_labels{102} = 'f';
% plot_labels{82} = 'e';
[~,t_labels] = labelPlots(f_RNA_ampar,plot_labels);

for ii = 1:4
    t_labels{ii}.Position(2) = 100;
end
% exportgraphics(f_RNA_ampar,'pdf\240809_supp_rna.pdf','ContentType','vector')
%% Make plot of specified genes

if false %run manually to plot may require load_all_data
rna_alt_order2
rna_alt_order3
rna_alt_order4
end


