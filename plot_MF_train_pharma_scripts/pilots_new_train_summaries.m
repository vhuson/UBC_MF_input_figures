%% 2024-07-25 with AMPAR and mGluR1 component sepearate
f_train_pharma = figure('Position', [488 1.8000 680.3150 857.9636],...
    'Color','w');


num_off = 2;
num_minusend = num_off-1;

plot_range = 2:6;
double_range = 3:12;
all_double_ylabels = {'10','10','20','20','30','30','40','40','50','50','60','60'};
all_ylabels = {'10','20','30','40','50','60'};

seed_colors_pharma = [0 0 0;
                1 0.6 0;
                0.8 0 0;
                0   0   1];

% mGluR2 boxplots
base_plot_num = 4;

left_edge = 0.1;
base_gap = 0.09;
total_width = 0.87;
graph_height = 0.13;

base_width = (total_width - base_gap*2) / base_plot_num;

left_edges = [left_edge ...
    left_edge + base_width*2 + base_gap ...
    left_edge + base_width*3 + base_gap*2];

sub_divide = 1;

% mgluR2_normalized_to_20base
% base_normalized_to_20base


settings = struct();
settings.axUnits = 'normalized';
% settings.BoxSpace = 0.05;
% settings.initSpace = 0.06;

% settings.Marker = '.';
% settings.MarkerSize = 120;
settings.Marker = 'o';
settings.MarkerSize = 12;
settings.MarkerEdgeWidth = 1.2;

settings.violin = true;
settings.violWidthFactor = 4; %How much wider than the Box?
settings.violOutliers = true; %Don't plot outliers
settings.violBandwidth = 0.1; %false means auto define
settings.violTrunc = true; %Truncate violin at data limits
% settings.violColor = [1 0 0;0 0 1; 0 0 0];
settings.violAlpha = 0.15;
settings.violNoBar = true;
settings.violLineWidth = 1;
settings.violFullSetEstimate = false;

settings.xtickrotation = 0;

settings.scatter = 'subgroups';
% settings.violColor = ones(10,3);
settings.violColor = repmat([seed_colors_pharma(2,:);1 1 1],6,1);
% settings.violAlpha = 1;





settings.axPos = [left_edges(1) 0.5975 base_width*2 graph_height];
settings.Label = all_double_ylabels(double_range);
settings.ylabel = 'Response (normalized to baseline)';
settings.violColor = repmat(seed_colors_pharma(1:2,:),numel(plot_range),1);
settings.violBandwidth = 0.15;

norm_60_base = all_sum_spikes_stim_pharma{1}{6}+all_sum_spikes_post_pharma{1}{6};

all_pharma_currpar = {};
cnt = 1;
for ii = plot_range
    curr_base = all_sum_spikes_stim_pharma{1}{ii}+all_sum_spikes_post_pharma{1}{ii};
    curr_mglur2 = all_sum_spikes_stim_pharma{2}{ii}+all_sum_spikes_post_pharma{2}{ii};
    
    all_pharma_currpar{cnt} = curr_base./norm_60_base;
    all_pharma_currpar{cnt+1} = curr_mglur2./norm_60_base;

    %Remove OFFs
    all_pharma_currpar{cnt} = all_pharma_currpar{cnt}(fltr_ONidx_tpharma);
    all_pharma_currpar{cnt+1} = all_pharma_currpar{cnt+1}(fltr_ONidx_tpharma);

    all_pharma_currpar{cnt}(end-num_minusend:end) = [];
    all_pharma_currpar{cnt+1}(end-num_minusend:end) = [];

    cnt = cnt + 2;
end


all_alphas1 = cellfun(@(x,y) signrank(x,y),all_pharma_currpar(1:2:end),all_pharma_currpar(2:2:end));
median_diff1 = cellfun(@(x,y) median(y-x),all_pharma_currpar(1:2:end),all_pharma_currpar(2:2:end));

subgroups = repmat({floor((1:numel(all_pharma_currpar{1}))/sub_divide) },size(all_pharma_currpar));
ax_component1 = ephysBoxPlot(all_pharma_currpar,subgroups,settings);
ax_component1.XTick = mean([ax_component1.XTick(1:2:end);ax_component1.XTick(2:2:end)]);
ax_component1.XTickLabels(2:2:end) = [];
delete(ax_component1.Children(3:4))
% hold(ax_component1,'on')
% plot(ax_component1.XLim,[1 1],'k--')
% hold(ax_component1,'off')

recolor_opts = struct();
recolor_opts.cell_order = 1:numel(all_pharma_currpar{1});
recolor_opts.cell_n = numel(fltr_ONidx_tpharma);
for ii = 1:numel(ax_component1.Children)
    if isa(ax_component1.Children(ii),'matlab.graphics.chart.primitive.Scatter')
        recolor_scatter(ax_component1.Children(ii))
    end
end

% create larger gaps
gap_space = 1;
curr_space = gap_space;
cnt = 1;
for ii = (numel(ax_component1.Children)-4):-2:1
    curr_patch = ax_component1.Children(ii);
    curr_scatter = ax_component1.Children(ii-1);

    curr_patch.XData = curr_patch.XData + curr_space;
    curr_scatter.XData = curr_scatter.XData + curr_space;
    
    if ~mod(cnt,2)
        ax_component1.XTick(cnt/2+1) = ax_component1.XTick(cnt/2+1)+curr_space;
        curr_space = curr_space + gap_space;
    end
    cnt = cnt+1;
end
ax_component1.XTick(cnt/2+1) = ax_component1.XTick(cnt/2+1)+curr_space;
ax_component1.XLim(2) = ax_component1.XLim(2) + curr_space;
hold(ax_component1,'on')
plot(ax_component1.XLim,[1 1],'k--')
hold(ax_component1,'off')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% AMPAR component plot %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

all_n_spikes_full_pharma = cellfun(@(x,y) ...
    {cellfun(@(a,b) {a+b} ,x,y)}...
    ,all_n_spikes_stim_pharma,all_n_spikes_post_pharma);


n_spikes_arrays = cellfun(@(x,y,z) {[x,y,z]},all_n_spikes_full_pharma{2:4});

normalize_vals = n_spikes_arrays{6}(:,1);
norm_spikes_arrays = cellfun(@(x) {x./normalize_vals},n_spikes_arrays);

peak_limit = 5;

%Calculate AMPAR component from current

compare_to_max = true;
correct_residual = false;
all_pharma_currpar = {};
cnt = 1;
for ii = plot_range
    peak_fltr = n_spikes_arrays{ii}(:,1) > peak_limit;


    if ~compare_to_max
        % Compare to mGluR2
        comp_size = norm_spikes_arrays{ii}(peak_fltr,1);
    else
        % Compare to peak
        comp_size = max(norm_spikes_arrays{ii}(peak_fltr,1:2),[],2);
    end
    max_size = comp_size;
    if correct_residual
        comp_size = comp_size - norm_spikes_arrays{ii}(peak_fltr,3);
    end

    ampar_part = max_size - norm_spikes_arrays{ii}(peak_fltr,2);
    
    all_pharma_currpar{cnt} = nan(size(peak_fltr));
    all_pharma_currpar{cnt}(peak_fltr) = ampar_part ./ comp_size .* 100;

     %remove offs
    all_pharma_currpar{cnt} = all_pharma_currpar{cnt}(fltr_ONidx_tpharma);
    all_pharma_currpar{cnt}(end-num_minusend:end) = [];
    
    cnt = cnt+1;
end
all_median2 = cellfun(@nanmedian,all_pharma_currpar);
all_mean2 = cellfun(@nanmean,all_pharma_currpar);

settings.violColor = repmat(seed_colors_pharma(3,:),numel(plot_range),1);
settings.violBandwidth = 15;
settings.Label = all_ylabels(plot_range);
settings.axPos = [left_edges(2) 0.5975 base_width graph_height];

settings.ylabel = 'AMPAR component (%)';


subgroups = repmat({floor((1:numel(all_pharma_currpar{1}))/sub_divide) },size(all_pharma_currpar));

ax2_component = ephysBoxPlot(all_pharma_currpar(:),subgroups,settings);

recolor_opts = struct();
recolor_opts.cell_order = 1:numel(all_pharma_currpar{1});
recolor_opts.cell_n = numel(fltr_ONidx_tpharma);
for ii = 1:numel(ax2_component.Children)
    if isa(ax2_component.Children(ii),'matlab.graphics.chart.primitive.Scatter')
        recolor_scatter(ax2_component.Children(ii),recolor_opts)
    end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% mGLuR1 component plot%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Calculate mGluR1 component from current
all_pharma_currpar = {};
cnt = 1;
for ii = plot_range
    peak_fltr = n_spikes_arrays{ii}(:,1) > peak_limit;

    % Compare to mGluR2
    comp_size = norm_spikes_arrays{ii}(peak_fltr,1) - norm_spikes_arrays{ii}(peak_fltr,3);
    % % Compare to peak
    % comp_size = max(norm_spikes_arrays{ii}(peak_fltr,1:2),[],2) - norm_spikes_arrays{ii}(peak_fltr,3);

    mglur1_part = norm_spikes_arrays{ii}(peak_fltr,2) - norm_spikes_arrays{ii}(peak_fltr,3);
    
    all_pharma_currpar{cnt} = nan(size(peak_fltr));
    all_pharma_currpar{cnt}(peak_fltr) = mglur1_part ./ comp_size .* 100;

     %remove offs
    all_pharma_currpar{cnt} = all_pharma_currpar{cnt}(fltr_ONidx_tpharma);
    all_pharma_currpar{cnt}(end-num_minusend:end) = [];
    
    cnt = cnt+1;
end
all_median3 = cellfun(@nanmedian,all_pharma_currpar);
all_mean3 = cellfun(@nanmean,all_pharma_currpar);

settings.violColor = repmat(seed_colors_pharma(4,:),numel(plot_range),1);
settings.violBandwidth = 15;
settings.Label = all_ylabels(plot_range);
settings.axPos = [left_edges(3) 0.5975 base_width graph_height];

settings.ylabel = 'mGluR1 component (%)';


subgroups = repmat({floor((1:numel(all_pharma_currpar{1}))/sub_divide) },size(all_pharma_currpar));

ax3_component = ephysBoxPlot(all_pharma_currpar(:),subgroups,settings);

recolor_opts = struct();
recolor_opts.cell_order = 1:numel(all_pharma_currpar{1});
recolor_opts.cell_n = numel(fltr_ONidx_tpharma);
for ii = 1:numel(ax3_component.Children)
    if isa(ax3_component.Children(ii),'matlab.graphics.chart.primitive.Scatter')
        recolor_scatter(ax3_component.Children(ii),recolor_opts)
    end
end

same_ylim({ax2_component,ax3_component})

standardFig(f_train_pharma,struct('FontSize',10));
%% with plot Wade likes
f_train_pharma = figure('Position', [488 1.8000 680.3150 857.9636],...
    'Color','w');


num_off = 2;
num_minusend = num_off-1;

plot_range = 2:6;
double_range = 3:12;
all_double_ylabels = {'10','10','20','20','30','30','40','40','50','50','60','60'};
all_ylabels = {'10','20','30','40','50','60'};

seed_colors_pharma = [0 0 0;
                1 0.6 0;
                0.8 0 0;
                0   0   1];

% mGluR2 boxplots


left_edge = 0.1;
base_gap = 0.09;
total_width = 0.87;
graph_height = 0.13;

base_width = (total_width - base_gap*2) / 5;

left_edges = [left_edge ...
    left_edge + base_width*2 + base_gap ...
    left_edge + base_width*4 + base_gap*2];

sub_divide = 1;

% mgluR2_normalized_to_20base
% base_normalized_to_20base


settings = struct();
settings.axUnits = 'normalized';
% settings.BoxSpace = 0.05;
% settings.initSpace = 0.06;

% settings.Marker = '.';
% settings.MarkerSize = 120;
settings.Marker = 'o';
settings.MarkerSize = 12;
settings.MarkerEdgeWidth = 1.2;

settings.violin = true;
settings.violWidthFactor = 4; %How much wider than the Box?
settings.violOutliers = true; %Don't plot outliers
settings.violBandwidth = 0.1; %false means auto define
settings.violTrunc = true; %Truncate violin at data limits
% settings.violColor = [1 0 0;0 0 1; 0 0 0];
settings.violAlpha = 0.15;
settings.violNoBar = true;
settings.violLineWidth = 1;
settings.violFullSetEstimate = false;

settings.xtickrotation = 0;

settings.scatter = 'subgroups';
% settings.violColor = ones(10,3);
settings.violColor = repmat([seed_colors_pharma(2,:);1 1 1],6,1);
% settings.violAlpha = 1;





settings.axPos = [left_edges(1) 0.5975 base_width*2 graph_height];
settings.Label = all_double_ylabels(double_range);
settings.ylabel = 'Response (normalized to baseline)';
settings.violColor = repmat(seed_colors_pharma(1:2,:),numel(plot_range),1);
settings.violBandwidth = 0.15;

norm_60_base = all_sum_spikes_stim_pharma{1}{6}+all_sum_spikes_post_pharma{1}{6};

all_pharma_currpar = {};
cnt = 1;
for ii = plot_range
    curr_base = all_sum_spikes_stim_pharma{1}{ii}+all_sum_spikes_post_pharma{1}{ii};
    curr_mglur2 = all_sum_spikes_stim_pharma{2}{ii}+all_sum_spikes_post_pharma{2}{ii};
    
    all_pharma_currpar{cnt} = curr_base./norm_60_base;
    all_pharma_currpar{cnt+1} = curr_mglur2./norm_60_base;

    %Remove OFFs
    all_pharma_currpar{cnt} = all_pharma_currpar{cnt}(fltr_ONidx_tpharma);
    all_pharma_currpar{cnt+1} = all_pharma_currpar{cnt+1}(fltr_ONidx_tpharma);

    all_pharma_currpar{cnt}(end-num_minusend:end) = [];
    all_pharma_currpar{cnt+1}(end-num_minusend:end) = [];

    cnt = cnt + 2;
end


all_alphas1 = cellfun(@(x,y) signrank(x,y),all_pharma_currpar(1:2:end),all_pharma_currpar(2:2:end));
median_diff1 = cellfun(@(x,y) median(y-x),all_pharma_currpar(1:2:end),all_pharma_currpar(2:2:end));

subgroups = repmat({floor((1:numel(all_pharma_currpar{1}))/sub_divide) },size(all_pharma_currpar));
ax_component1 = ephysBoxPlot(all_pharma_currpar,subgroups,settings);
ax_component1.XTick = mean([ax_component1.XTick(1:2:end);ax_component1.XTick(2:2:end)]);
ax_component1.XTickLabels(2:2:end) = [];
delete(ax_component1.Children(3:4))
hold(ax_component1,'on')
plot(ax_component1.XLim,[1 1],'k--')
hold(ax_component1,'off')

recolor_opts = struct();
recolor_opts.cell_order = 1:numel(all_pharma_currpar{1});
recolor_opts.cell_n = numel(fltr_ONidx_tpharma);
for ii = 1:numel(ax_component1.Children)
    if isa(ax_component1.Children(ii),'matlab.graphics.chart.primitive.Scatter')
        recolor_scatter(ax_component1.Children(ii))
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% mGLuR2 normalized plot%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

settings.violColor = repmat([seed_colors_pharma(2,:);1 1 1],numel(plot_range),1);
settings.axPos = [left_edges(2) 0.5975 base_width*2 graph_height];

settings.ylabel = 'Response (normalized to -mGluR2)';

all_n_spikes_full_pharma = cellfun(@(x,y) ...
    {cellfun(@(a,b) {a+b} ,x,y)}...
    ,all_n_spikes_stim_pharma,all_n_spikes_post_pharma);


n_spikes_arrays = cellfun(@(x,y,z) {[x,y,z]},all_n_spikes_full_pharma{2:4});

normalize_vals = n_spikes_arrays{6}(:,1);
norm_spikes_arrays = cellfun(@(x) {x./normalize_vals},n_spikes_arrays);

peak_limit = 5;
cnt = 1;

all_pharma_currpar = {};
for ii = plot_range
    peak_fltr = n_spikes_arrays{ii}(:,1) > peak_limit;
    
    %mGluR2 condition
    all_pharma_currpar{cnt} = nan(size(peak_fltr));
    all_pharma_currpar{cnt}(peak_fltr) = norm_spikes_arrays{ii}(peak_fltr,1);
    %After mGluR1 condition
    all_pharma_currpar{cnt+1} = nan(size(peak_fltr));
    all_pharma_currpar{cnt+1}(peak_fltr) = norm_spikes_arrays{ii}(peak_fltr,3);


    %remove offs
    all_pharma_currpar{cnt} = all_pharma_currpar{cnt}(fltr_ONidx_tpharma);
    all_pharma_currpar{cnt}(end-num_minusend:end) = [];

    all_pharma_currpar{cnt+1} = all_pharma_currpar{cnt+1}(fltr_ONidx_tpharma);
    all_pharma_currpar{cnt+1}(end-num_minusend:end) = [];
    
    cnt = cnt+2;
end

subgroups = repmat({floor((1:numel(all_pharma_currpar{1}))/sub_divide) },size(all_pharma_currpar));
ax2_component = ephysBoxPlot(all_pharma_currpar(:),subgroups,settings);
% ax2_component.YLim(1) = -0.1;
ax2_component.XTick = mean([ax2_component.XTick(1:2:end);ax2_component.XTick(2:2:end)]);
ax2_component.XTickLabels(2:2:end) = [];
delete(ax2_component.Children(3:4))
hold(ax2_component,'on')
plot(ax2_component.XLim,[1 1],'k--')
hold(ax2_component,'off')

recolor_opts = struct();
recolor_opts.cell_order = 1:numel(all_pharma_currpar{1});
recolor_opts.cell_n = numel(fltr_ONidx_tpharma);
for ii = 1:numel(ax2_component.Children)
    if isa(ax2_component.Children(ii),'matlab.graphics.chart.primitive.Scatter')
        recolor_scatter(ax2_component.Children(ii),recolor_opts)
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% mGLuR1 component plot%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Calculate mGluR1 component from current
all_pharma_currpar = {};
cnt = 1;
for ii = plot_range
    peak_fltr = n_spikes_arrays{ii}(:,1) > peak_limit;

    % Compare to mGluR2
    comp_size = norm_spikes_arrays{ii}(peak_fltr,1) - norm_spikes_arrays{ii}(peak_fltr,3);
    % % Compare to peak
    % comp_size = max(norm_spikes_arrays{ii}(peak_fltr,1:2),[],2) - norm_spikes_arrays{ii}(peak_fltr,3);

    mglur1_part = norm_spikes_arrays{ii}(peak_fltr,2) - norm_spikes_arrays{ii}(peak_fltr,3);
    
    all_pharma_currpar{cnt} = nan(size(peak_fltr));
    all_pharma_currpar{cnt}(peak_fltr) = mglur1_part ./ comp_size .* 100;

     %remove offs
    all_pharma_currpar{cnt} = all_pharma_currpar{cnt}(fltr_ONidx_tpharma);
    all_pharma_currpar{cnt}(end-num_minusend:end) = [];
    
    cnt = cnt+1;
end
all_median3 = cellfun(@nanmedian,all_pharma_currpar);
all_mean3 = cellfun(@nanmean,all_pharma_currpar);

settings.violColor = repmat(seed_colors_pharma(4,:),numel(plot_range),1);
settings.violBandwidth = 15;
settings.Label = all_ylabels(plot_range);
settings.axPos = [left_edges(3) 0.5975 base_width graph_height];

settings.ylabel = 'mGluR1 component (%)';


subgroups = repmat({floor((1:numel(all_pharma_currpar{1}))/sub_divide) },size(all_pharma_currpar));

ax3_component = ephysBoxPlot(all_pharma_currpar(:),subgroups,settings);

recolor_opts = struct();
recolor_opts.cell_order = 1:numel(all_pharma_currpar{1});
recolor_opts.cell_n = numel(fltr_ONidx_tpharma);
for ii = 1:numel(ax3_component.Children)
    if isa(ax3_component.Children(ii),'matlab.graphics.chart.primitive.Scatter')
        recolor_scatter(ax3_component.Children(ii),recolor_opts)
    end
end

standardFig(f_train_pharma,struct('FontSize',10));
