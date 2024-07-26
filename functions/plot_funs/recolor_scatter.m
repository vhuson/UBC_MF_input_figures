function [] = recolor_scatter(scatter_obj,opts)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
base_opts.seed_colors = [1 0 0;
                1 0.5 0.2;
                0.4 1 0.4;
                0.2 0.5 1;
                0 0 1];
base_opts.cell_n = numel(scatter_obj.XData);
base_opts.cell_order = 1:numel(scatter_obj.XData);
base_opts.color_face = false;


if nargin < 2
    opts = base_opts;
else
    opts = merge_structs(base_opts,opts);
end

all_colors = seed_map(opts.seed_colors,opts.cell_n);

all_colors = all_colors(opts.cell_order,:);

scatter_obj.CData = all_colors;
scatter_obj.MarkerEdgeColor = 'flat';
if opts.color_face
    scatter_obj.MarkerFaceColor = 'flat';
    scatter_obj.MarkerFaceAlpha = 0.5;
end
end