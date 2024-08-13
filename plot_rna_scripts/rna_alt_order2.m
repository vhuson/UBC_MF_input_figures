f_RNA_ampar = figure('Position', [488 1.8000 680.3150 857.9636],...
    'Color','w');

cplots = {'Grm1','Gria1','Gria2','Cacng2','Calb2','Gria3','Gria4','Gsg1l'};

all_titles = {{'mGluR1','(Grm1)'},{'GluA1','(Gria1)'},{'GluA2','(Gria2)'},{'TARP \gamma-2','(Cacng2)'},...                 
                 {'Calretinin','(Calb2)'},{'GluA3','(Gria3)'},{'GluA4','(Gria4)'},{'GSG1L','(Gsg1l)'}};
num_rows = 2;
num_cols = ceil(numel(cplots) / num_rows);

ax_height = 0.09;
ax_width = 0.1;
ax_space_w = 0.04;
ax_space_h = 0.05;
sep_space = 0.03;
left_edge = 0.13;
top_edge = 0.95;

all_left_edges = (ax_width + ax_space_w) .* (0:num_cols-1) + left_edge;
%Shift Gria together
all_left_edges(2) = all_left_edges(2)+sep_space/2;
all_left_edges(3) = all_left_edges(3)-sep_space/2;
all_left_edges = repmat(all_left_edges,1,num_rows);

all_bottom_edges = top_edge - (ax_height + ax_space_h) .* (1:num_rows);
all_bottom_edges = repmat(all_bottom_edges,num_cols,1);
all_bottom_edges = all_bottom_edges(:)';


counts_for_plot = mncount;
names_for_plot = mnames;

ax_rna = {};
for ii = 1:numel(cplots)
    curr_ax_pos = [all_left_edges(ii),...
                    all_bottom_edges(ii),...
                    ax_width, ax_height];


    ax_rna{ii} = upanel_plot(counts_for_plot,Y,names_for_plot,cplots(ii),...
        (1:size(counts_for_plot,1))','tsne',curr_ax_pos,f_RNA_ampar);
    title(all_titles{ii})

end



%Tweak figure
fig_opts = struct();
fig_opts.FontSize = 10;
standardFig(f_RNA_ampar,fig_opts);


%Add labels
plot_labels = repmat({[]},1,10);
plot_labels{1} = 'a';
plot_labels{2} = 'b';
plot_labels{4} = 'c';
% plot_labels{10} = 'd';
% plot_labels{97} = 'e';
% plot_labels{102} = 'f';
% plot_labels{82} = 'e';
[~,t_labels] = labelPlots(f_RNA_ampar,plot_labels);

for ii = 1:3
    t_labels{ii}.Position(2) = 100;
end