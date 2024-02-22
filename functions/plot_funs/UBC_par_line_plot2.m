function [currAx] = UBC_par_line_plot2(...
    ONidx,OFFidx,burst_par,f1,ax_position,opts)

base_opts.norm = false;
base_opts.YScale = 'linear';
base_opts.XScale = 'linear';
base_opts.XLabel = 'Input spikes (n)';
base_opts.XTickLabel = false;
base_opts.YLabel = '';
base_opts.YTickLabel = false;
base_opts.YRulerVis = "on";
base_opts.bar = false;
base_opts.min_val = -Inf;
base_opts.input_n = [1, 2, 5, 10, 20];



if nargin < 4
    f1 = figure('Color','w','Position', [565.8000 203.4727 359.2000 262.6909]);
end
if nargin < 5
    ax_position = [0.2207 0.2486 0.6341 0.6764];
end
if nargin < 6
    opts = base_opts;
else
    opts = merge_structs(base_opts,opts);
end

norm_bol = opts.norm;
bar_bol = opts.bar;
min_val = opts.min_val;
input_n = opts.input_n;

curr_par_mat = [burst_par{:}];

if norm_bol 
    if islogical(norm_bol) && norm_bol
        % curr_par_mat = curr_par_mat./max(curr_par_mat,[],2);
        curr_par_mat = curr_par_mat./curr_par_mat(:,end);
    else
        curr_par_mat = curr_par_mat./curr_par_mat(:,norm_bol);
    end

end

%Check if values below min and adjust
below_min_val = curr_par_mat< min_val;

adjust_y = any(below_min_val,'all');
curr_par_mat(below_min_val) = min_val;



currAx = axes(f1,'Position',ax_position);
hold on

seed_colors = [1 0 0;
                1 0.5 0.2;
                0.4 1 0.4;
                0.2 0.5 1;
                0 0 1];

all_colors = seed_map(seed_colors,numel(ONidx));
colormap(currAx,flipud(seed_map(seed_colors,256)))

% all_colors = turbo(numel(ONidx));
% 
% 
% colormap(flipud(turbo(256)))


% Balanced cell order mechanism fast slow and medium
%{
%Get forward and backward counting cell idx
order_fwd = 1:(numel(ONidx)-3);
order_bck = fliplr(order_fwd);

%Get center counting idx
cntr = ceil(numel(order_fwd)/2);
order_cntr = nan(size(order_fwd));

if mod(numel(order_fwd),2)
    order_cntr(1:2:end) = order_bck(cntr:end);
    order_cntr(2:2:end) = order_fwd(cntr+1:end);
else
    order_cntr(1:2:end) = order_fwd(cntr+1:end);
    order_cntr(2:2:end) = order_bck(cntr+1:end);
end

%splice all together
cell_order = nan(size(order_fwd));
cell_order(1:3:end) = order_fwd(1:numel(cell_order(1:3:end)));
cell_order(2:3:end) = order_bck(1:numel(cell_order(2:3:end)));
cell_order(3:3:end) = order_cntr(1:numel(cell_order(3:3:end)));

%flip order to give right prominance
cell_order = fliplr(cell_order);
%}

% Random permutation
rng(2);
cell_order = randperm(numel(ONidx)-numel(OFFidx));

% Fast at bottom slow on top
% cell_order = 1:(numel(ONidx)-numel(OFFidx));

for cell_n = cell_order

    plot(input_n,curr_par_mat(ONidx(cell_n),:),'-o',...
        'Color',all_colors(cell_n,:),'MarkerFaceColor','w')
    % ax1.YLim(1) = 0;
    % pause
end
hold off

if bar_bol
    cb1 = colorbar;
    cb1.Ticks = [0 1];
    % cb1.TickLabels = {'Slow' 'Fast'};
    cb1.TickLabels = {num2str(numel(cell_order)) '1'};
    cb1.Label.String = 'Cell (#)';
    cb1.Label.Rotation = 270;
    cb1.Label.Units = 'normalized';
    cb1.Label.Position(1) = 3.7;
    standardBar(cb1);
end
currAx.XTick = input_n;

if ~islogical(opts.XTickLabel)
    xticklabels(opts.XTickLabel);
end

if ~islogical(opts.YTickLabel)
    yticklabels(opts.YTickLabel);
end

xlabel(opts.XLabel)
ylabel(opts.YLabel)

% define_ax_lim_and_mark(min_val,0,currAx);


set(currAx,'YScale',opts.YScale)
set(currAx,'XScale',opts.XScale)

currAx.YRuler.Visible = opts.YRulerVis;


standardAx(currAx);



if adjust_y %Set to min_val
    currAx.YLim(1) = min_val;
    currAx.YTick = unique([currAx.YTick, min_val]);
    currAx.YTickLabel{currAx.YTick == min_val} = ...
        ['<',currAx.YTickLabel{currAx.YTick == min_val}];
end


end