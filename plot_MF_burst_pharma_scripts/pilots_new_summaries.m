%% 2024-07-25 with AMPAR and mGluR1 component sepearate
f_burst_pharma = figure('Position', [488 1.8000 680.3150 857.9636],...
    'Color','w');


num_off = 4;
num_minusend = num_off-1;

seed_colors_pharma = [0 0 0;
                1 0.6 0;
                0.8 0 0;
                0   0   1];

% mGluR2 boxplots
plot_units = 5;

left_edge = 0.1;
base_gap = 0.09;
total_width = 0.87;
graph_height = 0.13;

base_width = (total_width - base_gap*2) / plot_units;

left_edges = [left_edge ...
    left_edge + base_width*3 + base_gap ...
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
settings.violColor = repmat([seed_colors_pharma(2,:);1 1 1],5,1);
% settings.violAlpha = 1;





settings.axPos = [left_edges(1) 0.5975 base_width*3 graph_height];
% settings.Label = {'1','1','2','2','5','5','10','10','20','20'};
settings.Label = repmat({'Baseline','−mGluR2/3'},1,5);
settings.ylabel = 'Response (norm.)';
settings.violColor = repmat(seed_colors_pharma(1:2,:),5,1);
settings.violBandwidth = 0.15;

all_pharma_currpar = {base_normalized_to_20base(:,1),mgluR2_normalized_to_20base(:,1),...
    base_normalized_to_20base(:,2),mgluR2_normalized_to_20base(:,2),...
    base_normalized_to_20base(:,3),mgluR2_normalized_to_20base(:,3),...
    base_normalized_to_20base(:,4),mgluR2_normalized_to_20base(:,4),...
    base_normalized_to_20base(:,5),mgluR2_normalized_to_20base(:,5)};


for ii = 1:numel(all_pharma_currpar)
    % all_pharma_currpar{ii}(all_pharma_currpar{ii}>3) = 3;
    all_pharma_currpar{ii} = all_pharma_currpar{ii}(fltr_ONidx);
    all_pharma_currpar{ii}(end-num_minusend:end) = [];
end


all_alphas1 = cellfun(@(x,y) signrank(x,y),all_pharma_currpar(1:2:end),all_pharma_currpar(2:2:end));
median_diff1 = cellfun(@(x,y) median(y-x),all_pharma_currpar(1:2:end),all_pharma_currpar(2:2:end));

subgroups = repmat({floor((1:numel(all_pharma_currpar{1}))/sub_divide) },size(all_pharma_currpar));

settings.ylim = [0 2.7];
ax_component1 = ephysBoxPlot(all_pharma_currpar,subgroups,settings);
settings.ylim = 'auto';




recolor_opts.cell_order = 1:numel(all_pharma_currpar{1});
for ii = 1:numel(ax_component1.Children)
    if isa(ax_component1.Children(ii),'matlab.graphics.chart.primitive.Scatter')
        recolor_scatter(ax_component1.Children(ii))
    end
end

% create larger gaps
gap_space = 1;
curr_space = gap_space;
all_space = [gap_space,gap_space];
cnt = 1;
for ii = (numel(ax_component1.Children)-4):-2:1
    curr_patch = ax_component1.Children(ii);
    curr_scatter = ax_component1.Children(ii-1);

    curr_patch.XData = curr_patch.XData + curr_space;
    curr_scatter.XData = curr_scatter.XData + curr_space;
    
    if ~mod(cnt,2)
        % ax_component1.XTick(cnt/2+1) = ax_component1.XTick(cnt/2+1)+curr_space;
        % ax_component1.XTick(cnt/2+2) = ax_component1.XTick(cnt/2+2)+curr_space;
        
        curr_space = curr_space + gap_space;
        all_space = [all_space, curr_space, curr_space];
    end
    cnt = cnt+1;
end
ax_component1.XTick(3:end) = ax_component1.XTick(3:end)+all_space(1:end-2);

%burst Text positions
burst_t_pos = mean([ax_component1.XTick(1:2:end);ax_component1.XTick(2:2:end)]);


ax_component1.XTick(end-1) = [];
ax_component1.XTickLabels(end-1) = [];
delete(ax_component1.Children(3:4))


% ax_component1.XTick(cnt/2+1) = ax_component1.XTick(cnt/2+1)+curr_space;
%Shift last to the middle since it doesn't have a partner
shift_dist = burst_t_pos(end)-mean(curr_patch.XData);
curr_patch.XData = curr_patch.XData + shift_dist;
curr_scatter.XData = curr_scatter.XData + shift_dist;
ax_component1.XTick(end) = burst_t_pos(end);

ax_component1.XLim(2) = ax_component1.XLim(2) + curr_space - gap_space;
hold(ax_component1,'on')
plot(ax_component1.XLim,[1 1],'k:')
hold(ax_component1,'off')

%add burst text
burst_t = {};
burst_labels = {'1','2','5','10','20'};
for ii = 1:numel(burst_t_pos)
    burst_t{ii} = text(ax_component1,burst_t_pos(ii),1,burst_labels{ii},...
        'HorizontalAlignment','center');
    burst_t{ii}.Units = 'normalized';
    burst_t{ii}.Position(2) = -0.25; %1.1;%
    burst_t{ii}.Units = 'data';

end

%Set symbols as tick labels
xlabel_opts.xtick_symbols = repmat({"o","^"},1,5);
xlabel_opts.xtick_symbols(end-1) = [];
xlabel_opts.markeredgecolor = repmat({[0 0 0], [1 0.6 0]},1,5);
xlabel_opts.markeredgecolor(end-1) = [];
xlabel_opts.markerfacecolor = cellfun(@(x) {(1-x)*0.8+x},xlabel_opts.markeredgecolor);
xlabel_opts.offset = 0.12;

set_xlabel_symbols(ax_component1,xlabel_opts);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% AMPAR component plot %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n_spikes_arrays = cellfun(@(x,y,z) {[x,y,z]},all_pharma_n_spikes2,all_pharma_n_spikes3,all_pharma_n_spikes4);

normalize_vals = n_spikes_arrays{5}(:,1);
norm_spikes_arrays = cellfun(@(x) {x./normalize_vals},n_spikes_arrays);

peak_limit = 5;

compare_to_max = true;
correct_residual = false;
%Calculate AMPAR component from current
all_pharma_currpar = {};
for ii = 1:numel(n_spikes_arrays)
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
    
    all_pharma_currpar{ii} = nan(size(peak_fltr));
    all_pharma_currpar{ii}(peak_fltr) = ampar_part ./ comp_size .* 100;

     %remove offs
    all_pharma_currpar{ii} = all_pharma_currpar{ii}(fltr_ONidx);
    all_pharma_currpar{ii}(end-num_minusend:end) = [];

end

all_median2 = cellfun(@nanmedian,all_pharma_currpar);
all_mean2 = cellfun(@nanmean,all_pharma_currpar);

settings.violColor = repmat(seed_colors_pharma(3,:),5,1);
settings.violBandwidth = 15;
settings.Label = {'1','2','5','10','20'};
settings.axPos = [left_edges(2) 0.5975 base_width graph_height];

settings.ylabel = 'AMPAR component (%)';


subgroups = repmat({floor((1:numel(all_pharma_currpar{1}))/sub_divide) },size(all_pharma_currpar));

ax2_component = ephysBoxPlot(all_pharma_currpar(:),subgroups,settings);

recolor_opts = struct();
recolor_opts.cell_order = 1:numel(all_pharma_currpar{1});
recolor_opts.cell_n = numel(fltr_ONidx);
for ii = 1:numel(ax2_component.Children)
    if isa(ax2_component.Children(ii),'matlab.graphics.chart.primitive.Scatter')
        recolor_scatter(ax2_component.Children(ii),recolor_opts);
    end
end

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% mGLuR1 component plot%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Calculate mGluR1 component from current
all_pharma_currpar = {};
for ii = 1:numel(n_spikes_arrays)
    peak_fltr = n_spikes_arrays{ii}(:,1) > peak_limit;

    if ~compare_to_max
        % Compare to mGluR2
        comp_size = norm_spikes_arrays{ii}(peak_fltr,1);
    else
        % Compare to peak
        comp_size = max(norm_spikes_arrays{ii}(peak_fltr,1:2),[],2);
    end
    if correct_residual
        comp_size = comp_size - norm_spikes_arrays{ii}(peak_fltr,3);
    end

    mglur1_part = norm_spikes_arrays{ii}(peak_fltr,2) - norm_spikes_arrays{ii}(peak_fltr,3);
    
    all_pharma_currpar{ii} = nan(size(peak_fltr));
    all_pharma_currpar{ii}(peak_fltr) = mglur1_part ./ comp_size .* 100;
    all_pharma_currpar{ii}(all_pharma_currpar{ii} > 100) = 100;
     %remove offs
    all_pharma_currpar{ii} = all_pharma_currpar{ii}(fltr_ONidx);
    all_pharma_currpar{ii}(end-num_minusend:end) = [];

end

all_median3 = cellfun(@nanmedian,all_pharma_currpar);
all_mean3 = cellfun(@nanmean,all_pharma_currpar);

settings.violColor = repmat(seed_colors_pharma(4,:),5,1);
settings.violBandwidth = 15;
settings.Label = {'1','2','5','10','20'};
settings.axPos = [left_edges(3) 0.5975 base_width graph_height];

settings.ylabel = 'mGluR1 component (%)';


subgroups = repmat({floor((1:numel(all_pharma_currpar{1}))/sub_divide) },size(all_pharma_currpar));

ax3_component = ephysBoxPlot(all_pharma_currpar(:),subgroups,settings);

recolor_opts = struct();
recolor_opts.cell_order = 1:numel(all_pharma_currpar{1});
recolor_opts.cell_n = numel(fltr_ONidx);
for ii = 1:numel(ax3_component.Children)
    if isa(ax3_component.Children(ii),'matlab.graphics.chart.primitive.Scatter')
        recolor_scatter(ax3_component.Children(ii),recolor_opts);
    end
end


same_ylim({ax2_component,ax3_component});
standardFig(f_burst_pharma,struct('FontSize',10));


%% 2024-07-25 with plot Wade likes
f_burst_pharma = figure('Position', [488 1.8000 680.3150 857.9636],...
    'Color','w');


num_off = 4;
num_minusend = num_off-1;

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
settings.violColor = repmat([seed_colors_pharma(2,:);1 1 1],5,1);
% settings.violAlpha = 1;





settings.axPos = [left_edges(1) 0.5975 base_width*2 graph_height];
settings.Label = {'1','1','2','2','5','5','10','10','20','20'};
settings.ylabel = 'Response (normalized to baseline)';
settings.violColor = repmat(seed_colors_pharma(1:2,:),5,1);
settings.violBandwidth = 0.15;

all_pharma_currpar = {base_normalized_to_20base(:,1),mgluR2_normalized_to_20base(:,1),...
    base_normalized_to_20base(:,2),mgluR2_normalized_to_20base(:,2),...
    base_normalized_to_20base(:,3),mgluR2_normalized_to_20base(:,3),...
    base_normalized_to_20base(:,4),mgluR2_normalized_to_20base(:,4),...
    base_normalized_to_20base(:,5),mgluR2_normalized_to_20base(:,5)};


for ii = 1:numel(all_pharma_currpar)
    % all_pharma_currpar{ii}(all_pharma_currpar{ii}>3) = 3;
    all_pharma_currpar{ii} = all_pharma_currpar{ii}(fltr_ONidx);
    all_pharma_currpar{ii}(end-num_minusend:end) = [];
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

recolor_opts.cell_order = 1:numel(all_pharma_currpar{1});
for ii = 1:numel(ax_component1.Children)
    if isa(ax_component1.Children(ii),'matlab.graphics.chart.primitive.Scatter')
        recolor_scatter(ax_component1.Children(ii))
    end
end

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% mGLuR2 normalized plot%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

settings.violColor = repmat([seed_colors_pharma(2,:);1 1 1],5,1);
settings.axPos = [left_edges(2) 0.5975 base_width*2 graph_height];

settings.ylabel = 'Response (normalized to -mGluR2)';
settings.Label = {'1','1','2','2','5','5','10','10','20','20'};

n_spikes_arrays = cellfun(@(x,y,z) {[x,y,z]},all_pharma_n_spikes2,all_pharma_n_spikes3,all_pharma_n_spikes4);

normalize_vals = n_spikes_arrays{5}(:,1);
norm_spikes_arrays = cellfun(@(x) {x./normalize_vals},n_spikes_arrays);

peak_limit = 5;
cnt = 1;

all_pharma_currpar = {};
for ii = 1:numel(n_spikes_arrays)
    peak_fltr = n_spikes_arrays{ii}(:,1) > peak_limit;
    
    %mGluR2 condition
    all_pharma_currpar{cnt} = nan(size(peak_fltr));
    all_pharma_currpar{cnt}(peak_fltr) = norm_spikes_arrays{ii}(peak_fltr,1);
    %After mGluR1 condition
    all_pharma_currpar{cnt+1} = nan(size(peak_fltr));
    all_pharma_currpar{cnt+1}(peak_fltr) = norm_spikes_arrays{ii}(peak_fltr,3);


    %remove offs
    all_pharma_currpar{cnt} = all_pharma_currpar{cnt}(fltr_ONidx);
    all_pharma_currpar{cnt}(end-num_minusend:end) = [];

    all_pharma_currpar{cnt+1} = all_pharma_currpar{cnt+1}(fltr_ONidx);
    all_pharma_currpar{cnt+1}(end-num_minusend:end) = [];
    
    cnt = cnt+2;
end

subgroups = repmat({floor((1:numel(all_pharma_currpar{1}))/sub_divide) },size(all_pharma_currpar));
ax2_component = ephysBoxPlot(all_pharma_currpar(:),subgroups,settings);
ax2_component.YLim(1) = -0.1;
ax2_component.XTick = mean([ax2_component.XTick(1:2:end);ax2_component.XTick(2:2:end)]);
ax2_component.XTickLabels(2:2:end) = [];
delete(ax2_component.Children(3:4))
hold(ax2_component,'on')
plot(ax2_component.XLim,[1 1],'k--')
hold(ax2_component,'off')

recolor_opts = struct();
recolor_opts.cell_order = 1:numel(all_pharma_currpar{1});
recolor_opts.cell_n = numel(fltr_ONidx);
for ii = 1:numel(ax2_component.Children)
    if isa(ax2_component.Children(ii),'matlab.graphics.chart.primitive.Scatter')
        recolor_scatter(ax2_component.Children(ii),recolor_opts);
    end
end

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% mGLuR1 component plot%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Calculate mGluR1 component from current
all_pharma_currpar = {};
for ii = 1:numel(n_spikes_arrays)
    peak_fltr = n_spikes_arrays{ii}(:,1) > peak_limit;

    % Compare to mGluR2
    comp_size = norm_spikes_arrays{ii}(peak_fltr,1) - norm_spikes_arrays{ii}(peak_fltr,3);
    % Compare to peak
    % comp_size = max(norm_spikes_arrays{ii}(peak_fltr,1:2),[],2) - norm_spikes_arrays{ii}(peak_fltr,3);

    mglur1_part = norm_spikes_arrays{ii}(peak_fltr,2) - norm_spikes_arrays{ii}(peak_fltr,3);
    
    all_pharma_currpar{ii} = nan(size(peak_fltr));
    all_pharma_currpar{ii}(peak_fltr) = mglur1_part ./ comp_size .* 100;

     %remove offs
    all_pharma_currpar{ii} = all_pharma_currpar{ii}(fltr_ONidx);
    all_pharma_currpar{ii}(end-num_minusend:end) = [];

end

all_median3 = cellfun(@nanmedian,all_pharma_currpar);
all_mean3 = cellfun(@nanmean,all_pharma_currpar);

settings.violColor = repmat(seed_colors_pharma(4,:),5,1);
settings.violBandwidth = 15;
settings.Label = {'1','2','5','10','20'};
settings.axPos = [left_edges(3) 0.5975 base_width graph_height];

settings.ylabel = 'mGluR1 component (%)';


subgroups = repmat({floor((1:numel(all_pharma_currpar{1}))/sub_divide) },size(all_pharma_currpar));

ax3_component = ephysBoxPlot(all_pharma_currpar(:),subgroups,settings);

recolor_opts = struct();
recolor_opts.cell_order = 1:numel(all_pharma_currpar{1});
recolor_opts.cell_n = numel(fltr_ONidx);
for ii = 1:numel(ax3_component.Children)
    if isa(ax3_component.Children(ii),'matlab.graphics.chart.primitive.Scatter')
        recolor_scatter(ax3_component.Children(ii),recolor_opts)
    end
end

standardFig(f_burst_pharma,struct('FontSize',10));


%% 2024-07-25 all responses normalized to baseline + mGluR1 component (Too busy)
f_burst_pharma = figure('Position', [488 1.8000 680.3150 857.9636],...
    'Color','w');


num_off = 4;
num_minusend = num_off-1;

seed_colors_pharma = [0 0 0;
                1 0.6 0;
                0.8 0 0;
                0   0   1];

% mGluR2 boxplots
plot_units = 5;

left_edge = 0.1;
base_gap = 0.09;
total_width = 0.87;
graph_height = 0.13;

base_width = (total_width - base_gap*2) / plot_units;

left_edges = [left_edge ...
    left_edge + base_width*4 + base_gap];

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
settings.violAlpha = 0.3;
settings.violNoBar = true;
settings.violLineWidth = 1;
settings.violFullSetEstimate = false;

settings.xtickrotation = 0;

settings.scatter = 'subgroups';
% settings.violColor = ones(10,3);
% settings.violAlpha = 1;





settings.axPos = [left_edges(1) 0.5975 base_width*4 graph_height];
settings.Label = {'1','1','1','1','2','2',2','2','5','5','5','5','10','10','10','10','20','20','20','20'};
settings.ylabel = 'Response (normalized to baseline)';
settings.violColor = repmat(seed_colors_pharma(1:4,:),5,1);
settings.violBandwidth = 0.15;

all_pharma_currpar = {};
for ii = 1:5
    all_pharma_currpar = [all_pharma_currpar, cellfun(@(x) {x(:,ii)},normalized_to_20_base)];
end


for ii = 1:numel(all_pharma_currpar)
    % all_pharma_currpar{ii}(all_pharma_currpar{ii}>3) = 3;
    all_pharma_currpar{ii} = all_pharma_currpar{ii}(fltr_ONidx);
    all_pharma_currpar{ii}(end-num_minusend:end) = [];
end


all_alphas1 = cellfun(@(x,y) signrank(x,y),all_pharma_currpar(1:2:end),all_pharma_currpar(2:2:end));
median_diff1 = cellfun(@(x,y) median(y-x),all_pharma_currpar(1:2:end),all_pharma_currpar(2:2:end));

subgroups = repmat({floor((1:numel(all_pharma_currpar{1}))/sub_divide) },size(all_pharma_currpar));
ax_component1 = ephysBoxPlot(all_pharma_currpar,subgroups,settings);



ax_component1.XTick = mean([ax_component1.XTick(1:4:end);ax_component1.XTick(4:4:end)]);
ax_component1.XTickLabels = ax_component1.XTickLabels(1:4:end);
delete(ax_component1.Children(7:8))
hold(ax_component1,'on')
plot(ax_component1.XLim,[1 1],'k--')
hold(ax_component1,'off')

recolor_opts.cell_order = 1:numel(all_pharma_currpar{1});
for ii = 1:numel(ax_component1.Children)
    if isa(ax_component1.Children(ii),'matlab.graphics.chart.primitive.Scatter')
        recolor_scatter(ax_component1.Children(ii))
    end
end


%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% mGLuR1 component plot%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Calculate mGluR1 component from current
all_pharma_currpar = {};
for ii = 1:numel(n_spikes_arrays)
    peak_fltr = n_spikes_arrays{ii}(:,1) > peak_limit;

    if ~compare_to_max
        % Compare to mGluR2
        comp_size = norm_spikes_arrays{ii}(peak_fltr,1);
    else
        % Compare to peak
        comp_size = max(norm_spikes_arrays{ii}(peak_fltr,1:2),[],2);
    end
    if correct_residual
        comp_size = comp_size - norm_spikes_arrays{ii}(peak_fltr,3);
    end

    mglur1_part = norm_spikes_arrays{ii}(peak_fltr,2) - norm_spikes_arrays{ii}(peak_fltr,3);
    
    all_pharma_currpar{ii} = nan(size(peak_fltr));
    all_pharma_currpar{ii}(peak_fltr) = mglur1_part ./ comp_size .* 100;

     %remove offs
    all_pharma_currpar{ii} = all_pharma_currpar{ii}(fltr_ONidx);
    all_pharma_currpar{ii}(end-num_minusend:end) = [];

end

all_median3 = cellfun(@nanmedian,all_pharma_currpar);
all_mean3 = cellfun(@nanmean,all_pharma_currpar);

settings.violColor = repmat(seed_colors_pharma(4,:),5,1);
settings.violBandwidth = 15;
settings.Label = {'1','2','5','10','20'};
settings.axPos = [left_edges(2) 0.5975 base_width graph_height];

settings.ylabel = 'mGluR1 component (%)';


subgroups = repmat({floor((1:numel(all_pharma_currpar{1}))/sub_divide) },size(all_pharma_currpar));

ax3_component = ephysBoxPlot(all_pharma_currpar(:),subgroups,settings);

recolor_opts = struct();
recolor_opts.cell_order = 1:numel(all_pharma_currpar{1});
recolor_opts.cell_n = numel(fltr_ONidx);
for ii = 1:numel(ax3_component.Children)
    if isa(ax3_component.Children(ii),'matlab.graphics.chart.primitive.Scatter')
        recolor_scatter(ax3_component.Children(ii),recolor_opts)
    end
end

standardFig(f_burst_pharma,struct('FontSize',10));


%% OLD shit

all_pharma_ampar = cell(size(n_spikes_arrays));
all_pharma_mglur = cell(size(n_spikes_arrays));
%Cap responses at 0
for ii = 1:numel(n_spikes_arrays)
    peak_fltr = n_spikes_arrays{ii}(:,1) > 5;

    max_peak = max(n_spikes_arrays{ii}(:,1:2),[],2);

    %AMPAR component
    curr_component = nan(size(peak_fltr));
    %Difference with max_peak
    curr_component(peak_fltr) = max_peak(peak_fltr,1) - n_spikes_arrays{ii}(peak_fltr,2);
    % Divide by maximum peak (either in mGluR2 or ampar)
    curr_component(peak_fltr) = curr_component(peak_fltr)./ max_peak(peak_fltr,1);
    curr_component(peak_fltr) = curr_component(peak_fltr).*100;

    all_pharma_ampar{ii} = curr_component;
    
    %mglur1 Component 
    curr_component = nan(size(peak_fltr));
    %Difference with AMPAR
    curr_component(peak_fltr) = n_spikes_arrays{ii}(peak_fltr,2) - n_spikes_arrays{ii}(peak_fltr,3);

    % Divide by maximum peak (either in mGluR2 or ampar)
    curr_component(peak_fltr) = curr_component(peak_fltr)./ max_peak(peak_fltr,1);
    curr_component(peak_fltr) = curr_component(peak_fltr).*100;

    all_pharma_mglur{ii} = curr_component;

    %remove offs
    all_pharma_ampar{ii} = all_pharma_ampar{ii}(fltr_ONidx);
    all_pharma_ampar{ii}(end-3:end) = [];

    all_pharma_mglur{ii} = all_pharma_mglur{ii}(fltr_ONidx);
    all_pharma_mglur{ii}(end-3:end) = [];

    % all_pharma_currpar{ii}(isnan(all_pharma_currpar{ii})) = 0;
    % all_pharma_currpar{ii}(all_pharma_n_spikes2{ii} < 1 & all_pharma_n_spikes2{ii} > -Inf) = 0;
end

all_pharma_currpar = [all_pharma_ampar;all_pharma_mglur];

ax9_component = ephysBoxPlot(all_pharma_currpar(:),settings);

recolor_opts = struct();
recolor_opts.cell_order = 1:numel(all_pharma_mglur{1});
recolor_opts.cell_n = numel(fltr_ONidx);
for ii = 1:numel(ax9_component.Children)
    if isa(ax9_component.Children(ii),'matlab.graphics.chart.primitive.Scatter')
        recolor_scatter(ax9_component.Children(ii),recolor_opts)
    end
end

standardFig(f_burst_pharma,struct('FontSize',10))


%% mGluR2 boxplots

% mgluR2_normalized_to_20base
% base_normalized_to_20base
f_burst_pharma = figure('Position', [488 1.8000 680.3150 857.9636],...
    'Color','w');


settings.axPos = [0.2001 0.1242 0.5362 0.3164];
settings.Label = {'1','1','2','2','5','5','10','10','20','20'};
settings.ylabel = '#Spikes (base x20 normalized)';
settings.violColor = ones(10,3);
settings.violBandwidth = 0.15;

all_pharma_currpar = {base_normalized_to_20base(:,1),mgluR2_normalized_to_20base(:,1),...
    base_normalized_to_20base(:,2),mgluR2_normalized_to_20base(:,2),...
    base_normalized_to_20base(:,3),mgluR2_normalized_to_20base(:,3),...
    base_normalized_to_20base(:,4),mgluR2_normalized_to_20base(:,4),...
    base_normalized_to_20base(:,5),mgluR2_normalized_to_20base(:,5)};


for ii = 1:numel(all_pharma_currpar)
    all_pharma_currpar{ii}(all_pharma_currpar{ii}>3) = 3;
    all_pharma_currpar{ii} = all_pharma_currpar{ii}(fltr_ONidx);
    all_pharma_currpar{ii}(end-3:end) = [];
end

ax9_component = ephysBoxPlot(all_pharma_currpar,settings);

recolor_opts.cell_order = 1:numel(all_pharma_currpar{1});
for ii = 1:numel(ax9_component.Children)
    if isa(ax9_component.Children(ii),'matlab.graphics.chart.primitive.Scatter')
        recolor_scatter(ax9_component.Children(ii))
    end
end

standardFig(f_burst_pharma,struct('FontSize',10))

%%
% f_burst_pharma = figure('Position', [488 1.8000 680.3150 857.9636],...
    % 'Color','w');

pos_ax = [0.1680 0.7464 0.2886 0.1915];


%Gather data
ax_pharm_p = {};

opts = struct('max_val',200);
opts.YLabel = '%Reduction with NBQX';
opts.XScale = 'log';
% opts.YScale = 'log';

all_pharma_currpar = {mglur2_to_ampar_percentchange(:,1),...
    mglur2_to_ampar_percentchange(:,2),...
    mglur2_to_ampar_percentchange(:,3),...
    mglur2_to_ampar_percentchange(:,4),...
    mglur2_to_ampar_percentchange(:,5)};


[ax1] = UBC_par_line_plot2(...
    fltr_ONidx,fltr_ONidx(end-3:end),all_pharma_currpar,f_burst_pharma,pos_ax,...
    opts);
xlim([0.8 23])



pos_ax = [0.1680 0.4678 0.2886 0.1915];
opts.YLabel = '%Reduction with JNJ';

all_pharma_currpar = {mglur2_to_mglur1_percentchange(:,1),...
    mglur2_to_mglur1_percentchange(:,2),...
    mglur2_to_mglur1_percentchange(:,3),...
    mglur2_to_mglur1_percentchange(:,4),...
    mglur2_to_mglur1_percentchange(:,5)};


[ax2] = UBC_par_line_plot2(...
    fltr_ONidx,fltr_ONidx(end-3:end),all_pharma_currpar,f_burst_pharma,pos_ax,...
    opts);
xlim([0.8 23])
