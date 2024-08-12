
% Alternative ONidx
%
if ~exist('ONidx_20','var') %Don't overwrite
    ONidx_20 = ONidx;
end

amp_cutoff = 7.3;

amp_par = all_burst_slow_amp{2};
sort_par = all_burst_slow_HD{2};

zero_idx = find(amp_par < amp_cutoff);


[~,ONidx_2] = sort(sort_par);

%Remove zeros and put at the end in order they occur in 20x
ONidx_2(ismember(ONidx_2,zero_idx)) = [];
ONidx_2 = [ONidx_2',ONidx_20(ismember(ONidx_20,zero_idx))];

alt_idx_init = true;
ONidx = ONidx_2;
f_burst = figure('Position', [488 1.8000 680.3150 857.9636],...
    'Color','w');


%Run panel scripts
% example_cell_panel
example_cell_panel_reordered_altidx

heatmap_panel_altidx



%Tweak figure
fig_opts = struct();
fig_opts.FontSize = 10;
standardFig(f_burst,fig_opts);



%Add labels
plot_labels = repmat({[]},1,27);
plot_labels{1} = 'a';
% plot_labels{6} = 'b';
% plot_labels{11} = 'c';
plot_labels{46} = 'b';
[~,t_labels] = labelPlots(f_burst,plot_labels);

for ii = 1:numel(t_labels)
    t_labels{ii}.Position(1) = t_labels{ii}.Position(1)-14;
    
end
ONidx = ONidx_20;
% exportgraphics(f_burst,'pdf\240801_fig2_2xsort.pdf','ContentType','vector')