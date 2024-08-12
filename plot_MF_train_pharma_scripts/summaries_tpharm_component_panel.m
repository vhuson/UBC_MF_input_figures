%% 2024-07-25 with AMPAR and mGluR1 component sepearate
% f_train_pharma = figure('Position', [488 1.8000 680.3150 857.9636],...
%     'Color','w');


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
plot_units = 9;

bottom_edge = 0.0363;
left_edge = 0.1;
base_gap = 0.11;
extra_gap = 0.08;
total_width = 0.87;
graph_height = 0.095;

base_width = (total_width - base_gap*2 - extra_gap) / plot_units;

left_edges = [left_edge ...
    left_edge + base_width*5 + base_gap + extra_gap ...
    left_edge + base_width*7 + base_gap*2+ extra_gap];

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





settings.axPos = [left_edges(1) bottom_edge base_width*5 graph_height];
% settings.Label = all_double_ylabels(double_range);
settings.Label = repmat({'Baseline','−mGluR2/3'},1,numel(plot_range));
settings.ylabel = 'Response (norm.)';
% settings.violColor = repmat(seed_colors_pharma(1:2,:),numel(plot_range),1);
settings.violColor = ones(numel(plot_range)*2,3);
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
settings.ylim = [0 2.5];
ax_component1 = ephysBoxPlot(all_pharma_currpar,subgroups,settings);
settings.ylim = 'auto';


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
all_space = [gap_space,gap_space];
cnt = 1;
for ii = (numel(ax_component1.Children)-4):-2:1
    curr_patch = ax_component1.Children(ii);
    curr_scatter = ax_component1.Children(ii-1);

    curr_patch.XData = curr_patch.XData + curr_space;
    curr_scatter.XData = curr_scatter.XData + curr_space;
    
    if ~mod(cnt,2)
        % ax_component1.XTick(cnt/2+1) = ax_component1.XTick(cnt/2+1)+curr_space;
        curr_space = curr_space + gap_space;
        all_space = [all_space, curr_space, curr_space];
    end
    cnt = cnt+1;
end
ax_component1.XTick(3:end) = ax_component1.XTick(3:end)+all_space(1:end-2);

%burst Text positions
burst_t_pos = mean([ax_component1.XTick(1:2:end);ax_component1.XTick(2:2:end)]);

% ax_component1.XTick(end-1) = [];
% ax_component1.XTickLabels(end-1) = [];
delete(ax_component1.Children(4))

%Reduce normalized to single dot
ax_component1.Children(3).XData = mean(ax_component1.Children(3).XData);
ax_component1.Children(3).YData = 1;
ax_component1.Children(3).CData = [0 0 0];
ax_component1.Children(3).MarkerFaceColor = 'flat';
ax_component1.Children(3).SizeData = 30;


%Shift last to the middle since it doesn't have a partner
% shift_dist = burst_t_pos(end)-mean(curr_patch.XData);
% curr_patch.XData = curr_patch.XData + shift_dist;
% curr_scatter.XData = curr_scatter.XData + shift_dist;
% ax_component1.XTick(end) = burst_t_pos(end);

ax_component1.XLim(2) = ax_component1.XLim(2) + curr_space - gap_space;
hold(ax_component1,'on')
plot(ax_component1.XLim,[1 1],'k:')
hold(ax_component1,'off')

%add stars
for ii = 1:numel(all_alphas1)
    if all_alphas1(ii) < 0.01
        hold(ax_component1,'on')
        curr_x = burst_t_pos(ii);
        curr_y = ax_component1.YLim(2);
        line([-1 1]+curr_x,[curr_y,curr_y],'color','k','LineWidth',1)
        t_start = text(curr_x,curr_y,'*','HorizontalAlignment',...
            'center','VerticalAlignment','baseline');
        t_start.Units = 'pixels';
        t_start.Position(2) = t_start.Position(2)-3;
        t_start.Units = 'data';

        hold(ax_component1,'off')
    end
end


%add burst text
burst_t = {};
burst_labels = all_ylabels(plot_range);
for ii = 1:numel(burst_t_pos)
    burst_t{ii} = text(ax_component1,burst_t_pos(ii),1,burst_labels{ii},...
        'HorizontalAlignment','center');
    burst_t{ii}.Units = 'normalized';
    burst_t{ii}.Position(2) = -0.2623;%1.0739; % -0.25; %1.1;%
    burst_t{ii}.Units = 'data';

end

%Set symbols as tick labels
xlabel_opts.xtick_symbols = repmat({"_","+"},1,5);
% xlabel_opts.xtick_symbols(end-1) = [];
xlabel_opts.markeredgecolor = repmat({[0 0 0], [0 0 0]},1,5);
% xlabel_opts.markeredgecolor(end-1) = [];
xlabel_opts.markerfacecolor = cellfun(@(x) {(1-x)*0.8+x},xlabel_opts.markeredgecolor);
xlabel_opts.offset = 0.12;

set_xlabel_symbols(ax_component1,xlabel_opts);
xlabel_text = text(1,-0.0683,{'mGluR2/3','block'},...
    'FontSize',10,'FontName','Arial',...
    'Units','normalized');


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

% settings.violColor = repmat(seed_colors_pharma(3,:),numel(plot_range),1);
settings.violColor = ones(numel(plot_range),3);
settings.violBandwidth = 15;
settings.Label = all_ylabels(plot_range);
settings.axPos = [left_edges(2) bottom_edge base_width*2 graph_height];

settings.ylabel = {'AMPAR', 'component (%)'};


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
    
    all_pharma_currpar{cnt} = nan(size(peak_fltr));
    all_pharma_currpar{cnt}(peak_fltr) = mglur1_part ./ comp_size .* 100;
    all_pharma_currpar{cnt}(all_pharma_currpar{cnt} > 100) = 100;

     %remove offs
    all_pharma_currpar{cnt} = all_pharma_currpar{cnt}(fltr_ONidx_tpharma);
    all_pharma_currpar{cnt}(end-num_minusend:end) = [];
    
    cnt = cnt+1;
end
all_median3 = cellfun(@nanmedian,all_pharma_currpar);
all_mean3 = cellfun(@nanmean,all_pharma_currpar);

% settings.violColor = repmat(seed_colors_pharma(4,:),numel(plot_range),1);
settings.violColor = ones(numel(plot_range),3);
settings.violBandwidth = 15;
settings.Label = all_ylabels(plot_range);
settings.axPos = [left_edges(3) bottom_edge base_width*2 graph_height];

settings.ylabel = {'mGluR1' 'component (%)'};


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

% standardFig(f_train_pharma,struct('FontSize',10));