% f_burst_pharma = figure('Position', [488 1.8000 680.3150 857.9636],...
%     'Color','w');


ax_pos = [0.1 0.9491 0.26 0.0366];

seed_colors_pharma = [0 0 0;
                1 0.6 0;
                0.8 0 0;
                0   0   1];


all_colors_pharma = seed_map(seed_colors_pharma,4);
legend_labels = {'Baseline','mGluR2/3 block','+ AMPAR block','+ mGluR1 block'};


%Make graphic

ax_prot = axes(f_burst_pharma,"Position",ax_pos);
hold on
%Baseline
plot([0,1],[4,4],'Color',all_colors_pharma(1,:),"LineWidth",1.5)
text(1.1,4,legend_labels{1},"FontSize",9,"FontName","Arial",...
    "HorizontalAlignment","left","VerticalAlignment","middle")
%mGluR2/3
plot([1,4],[3,3],'Color',all_colors_pharma(2,:),"LineWidth",1.5)
text(4.1,3,legend_labels{2},"FontSize",9,"FontName","Arial",...
    "HorizontalAlignment","left","VerticalAlignment","middle")
%ampar
plot([2,4],[2,2],'Color',all_colors_pharma(3,:),"LineWidth",1.5)
text(4.1,2,legend_labels{3},"FontSize",9,"FontName","Arial",...
    "HorizontalAlignment","left","VerticalAlignment","middle")
%mglur1
plot([3,4],[1,1],'Color',all_colors_pharma(4,:),"LineWidth",1.5)
text(4.1,1,legend_labels{4},"FontSize",9,"FontName","Arial",...
    "HorizontalAlignment","left","VerticalAlignment","middle")
hold off
ax_prot.Visible = 'off';




