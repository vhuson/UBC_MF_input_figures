function [currAx,cb1] = UBC_par_line_plot(...
    ONidx,OFFidx,burst_par,all_bol,min_val,f1,ax_position,input_n)


if nargin < 4
    all_bol = [false,false,true];
end
if nargin <5
    min_val = -Inf;
end

if nargin < 6
    f1 = figure('Color','w','Position', [565.8000 203.4727 359.2000 262.6909]);
end
if nargin < 7
    ax_position = [0.2207 0.2486 0.6341 0.6764];
end
if nargin < 8
    input_n = [1,2,5,10,20];
end
norm_bol = all_bol(1);
log_bol = all_bol(2);
bar_bol = all_bol(3);


%
% curr_par_mat = [all_burst_n_spikes{:}];
% y_label_text = 'Response spikes';
% y_label_units = ' (n)';

% curr_par_mat = [all_burst_slow_amp{:}];
% y_label_text = 'Peak response';
% y_label_units = ' (\Deltaspk/s)';

% curr_par_mat = [all_burst_slow_HD{:}];
% y_label_text = 'Half-width';
% y_label_units = ' (s)';
% 
curr_par_mat = [burst_par{:}];
% y_label_text = 'Pause';
% y_label_units = ' (s)';

if norm_bol 
    if islogical(norm_bol)
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
    cb1.TickLabels = {num2str(numel(ONidx)) '1'};
    cb1.Label.String = 'Cell (#)';
    cb1.Label.Rotation = 270;
    cb1.Label.Units = 'normalized';
    cb1.Label.Position(1) = 3.7;
    standardBar(cb1);
end
currAx.XTick = input_n;
xlabel('Input spikes (n)')

% define_ax_lim_and_mark(min_val,0,currAx);

if log_bol
    set(currAx,'YScale','log')
    set(currAx,'XScale','log')
    currAx.XLim(1) = 0.9;
end

standardAx(currAx);



if adjust_y %Set to min_val
    currAx.YLim(1) = min_val;
    currAx.YTick = unique([currAx.YTick, min_val]);
    currAx.YTickLabel{currAx.YTick == min_val} = ...
        ['<',currAx.YTickLabel{currAx.YTick == min_val}];
end


end