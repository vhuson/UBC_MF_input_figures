function [ax1] = changed_par_normalized_plot(numerator_par,denominator_par,...
    x_sorting,f1,ax_pos,opts)

warn_neg = true;

base_opts = struct();
base_opts.title_text = '';
base_opts.ylabel_text = '';
base_opts.xlabel_text = '';
base_opts.xlim = 'auto';
base_opts.curr_color = 'k';
base_opts.plot_line = false;
base_opts.upperbound = Inf;
base_opts.lowerbound = -Inf;
base_opts.overlay = [];


if nargin < 3
    x_sorting = 1:numel(numerator_par);
end
if nargin < 4
    f1 = figure('Color','w','Position', [685.2182 320 432.7818 246.5273]');
end
if nargin < 5
    ax_pos = [0.1624 0.1952 0.7426 0.7135];
end

if nargin < 6
    opts = base_opts;
else
    opts = merge_structs(base_opts,opts);
end

if warn_neg
    if all(numerator_par > 0) && all(denominator_par > 0)
        %all good do nothing
    elseif all(numerator_par < 0) && all(denominator_par < 0)
        %Also fine
    else
        if any(numerator_par < 0)
            disp('The following numerators are negative:')
            disp(find(numerator_par < 0))
        end
        if any(denominator_par < 0)
            disp('The following denominator_pars are negative:')
            disp(find(denominator_par < 0))
        end
    end

end

if isempty(opts.overlay)
    ax1 = axes(f1, 'Position', ax_pos);
else
    ax1 = opts.overlay;
    hold(ax1,'on')
end

ratio_par = numerator_par ./ denominator_par;

plot(ax1,x_sorting,ratio_par,'ko',...
        'MarkerEdgeColor',opts.curr_color,'MarkerFaceColor','w')

xlim(opts.xlim);

if isnumeric(opts.plot_line)
    line(ax1.XLim,repmat(opts.plot_line,1,2),'Color','k','LineWidth',1)
    ax1.Children(end+1) = ax1.Children(1);
end

if isempty(opts.overlay) %No need to do this again
    xlabel(opts.xlabel_text)
    ylabel(opts.ylabel_text)
    title(opts.title_text)
end

define_ax_lim_and_mark(opts.upperbound,1,ax1,1);
define_ax_lim_and_mark(opts.lowerbound,0,ax1,1);

standardAx(ax1);

end

%{
                                       

% input_idx = 2;
% numerator_par = all_pharma_slow_amp1{input_idx};
% denominator_par = all_pharma_slow_amp2{input_idx};
% ylabel_text = '\DeltaPeak (norm.)';
numerator_par = all_pharma_n_spikes1{input_idx};
denominator_par = all_pharma_n_spikes2{input_idx};
ylabel_text = '#Spikes Baseline / -mGluR2';

% numerator_par = all_pharma_slow_amp3{5};
% denominator_par = all_pharma_slow_amp3{input_idx};
% ylabel_text = '\DeltaPeak (norm.)';
% ball_color =[1 0.6 0];
% base_color = [0 0 0];
% 
% numerator_par = all_pharma_n_spikes3{5};
% denominator_par = all_pharma_n_spikes3{input_idx};
% ylabel_text = '\Delta #Spikes (norm.)';
% ball_color =[0.8 0 0;];
% base_color = [0.8 0 0;];


x_sorting = all_pharma_slow_HD1{5};
%Filter out the low amplitude stuff before ratio
% cut_off = 1;
% fltr_cells = denominator_par >= cut_off;
 
% denominator_par = denominator_par(fltr_cells);
% numerator_par = numerator_par(fltr_cells);
% x_sorting = x_sorting(fltr_cells);
% 
% curr_select_cells = get_fltr_ONidx(select_cells,find(fltr_cells));

curr_select_cells = select_cells;

%take the ratio (mGluR2 / Baseline)
ratio_par = numerator_par ./ denominator_par;
ratio_par(~fltr_cells) = -1;
% ratio_par = (numerator_par - denominator_par)./numerator_par;
% denominator_par = denominator_par - denominator_par;
% ratio_par = ratio_par ./ numerator_par;

all_colors = bbpr(5);
%Plot with cell n on the x axis for 1x burst

ratio_par = ratio_par(curr_select_cells);
denominator_par = denominator_par(curr_select_cells);
numerator_par = numerator_par(curr_select_cells);
x_sorting = 1:numel(ratio_par);

% for ii = 1:numel(ratio_par)
%         line(repmat(x_sorting(ii),1,2),...
%             sort([ratio_par(ii) denominator_par(ii)]),'Color',...
%             all_colors(input_idx,:))
% end
% 
% plot(x_sorting,denominator_par,'ko',...
%     'MarkerEdgeColor',base_color,'MarkerFaceColor','w')
plot(x_sorting,ratio_par,'ko',...
        'MarkerEdgeColor',all_colors(input_idx,:),'MarkerFaceColor','w')
% plot(1:numel(curr_select_cells),ratio_par(curr_select_cells),...
%     'Color',all_colors(input_idx,:))


% set(gca,'YScale','log')
% set(gca,'XScale','log')
line(ax{input_idx}.XLim,[1 1],'Color','k','LineWidth',1)
ax{input_idx}.Children(end+1) = ax{input_idx}.Children(1);
xlim([0 numel(ratio_par)+1]);
% ax1.YLim(1) = 0;
% ylim([-1.2 1.2])
% ax1.YLim = [-max(abs(ax1.YLim)), max(abs(ax1.YLim))];
xlabel('Sorted cell #')
ylabel(ylabel_text)
title(title_texts{input_idx})
define_ax_lim_and_mark(1.5,1,ax{input_idx},1);
define_ax_lim_and_mark(-0.2,0,ax{input_idx},1);
standardAx(gca);
end

same_ylim(ax,'YTick',ax{5}.YTick,'YTickLabel',ax{5}.YTickLabel)
end
%}