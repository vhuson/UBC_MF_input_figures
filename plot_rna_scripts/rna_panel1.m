cplots = {'Grm1','Gria1','Gria2','Gria3','Gria4','Cacng2','Cacng7','Cacng8','Gsg1l'};
all_titles = {{'mGluR1','(Grm1)'},{'GluA1','(Gria1)'},{'GluA2','(Gria2)'},...
                 {'GluA3','(Gria3)'},{'GluA4','(Gria4)'},...
                 {'TARP \gamma-2','(Cacng2)'},{'TARP \gamma-7','(Cacng7)'},{'TARP \gamma-8','(Cacng8)'},{'GSG1L','(Gsg1l)'}};
num_rows = 2;
num_cols = ceil(numel(cplots) / num_rows);

ax_height = 0.09;
ax_width = 0.1;
ax_space_w = 0.03;
ax_space_h = 0.07;
sep_space = 0.03;
left_edge = 0.13;
top_edge = 0.95;

all_left_edges = (ax_width + ax_space_w) .* (0:num_cols-1) + left_edge;
all_left_edges = repmat(all_left_edges,1,num_rows);
%Shift Gria to the right
all_left_edges(2) = all_left_edges(2)+sep_space;
all_left_edges(3:4) = all_left_edges(2)+(diff(all_left_edges([2,5]))/3).*(1:2);
%Shift GSG1l together
all_left_edges(9) = all_left_edges(9)+sep_space;

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
cb_rna = colorbar();
% cb_rna.Position = [0.6736    0.6419    0.0154    0.0682];
cb_rna.Position = [0.6851    0.6491    0.0165    0.0539];
cb_rna.Ticks = cb_rna.Limits;
cb_rna.TickLabels = {'0' '1'};

% cb_rna.Label.String = {'Gene expr.', '(norm.)'};
% cb_rna.Label.Rotation = 270;
% cb_rna.Label.Units = 'normalized';
% cb_rna.Label.Position(1) = 5.5;

