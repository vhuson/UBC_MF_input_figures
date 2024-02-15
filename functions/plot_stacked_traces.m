function [ax_stack_1] = plot_stacked_traces(...
    curr_data_array,Fs,select_cells,f1,pos1,opts)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
base_opts.plot_color = false;
base_opts.Visible = 'on';
if nargin < 3
    select_cells = 1:size(curr_data_array,1);
end
if nargin < 4
    f1 = figure('Position', [488 1.8000 406.6000 780.8000]);
end
if nargin < 5
    pos1 = [0.0500    0.0500    0.90    0.9300];
end
if nargin < 6
    opts = base_opts;
else
    opts = merge_structs(base_opts,opts);
end

if opts.plot_color
    seed_colors = [
        1 0 0;
        1 0.5 0.2;
        0.4 1 0.4;
        0.2 0.5 1;
        0 0 1];

    all_colors = seed_map(seed_colors,numel(select_cells));
end

disp_num = numel(select_cells);

[all_positions] = get_stacked_axes_positions(pos1,0.08,disp_num);
all_positions = flipud(all_positions);

ax_stack_1 = cell(1,disp_num);

for ii = 1:disp_num
    curr_trace = curr_data_array(select_cells(ii),:);
    % currBaseline = all_baseline(select_cells(ii));


    %Check trace arrays and make sure its not only NaN and zeros (because this
    %is not plot in matlab for unclear reasons)
    nan_data = isnan(curr_trace);
    if any(nan_data)
        nonan_data = curr_trace(~nan_data);
    else
        nonan_data = curr_trace;
    end
    if all(nonan_data == 0)
        curr_trace(~nan_data) = 0.05;
    end



     
    ax_stack_1{ii} = axes('Position',all_positions(ii,:));
    hold on
    % line([1 numel(curr_trace)]/Fs,repmat(currBaseline,1,2),'Color','r');
    if opts.plot_color
        curr_color = all_colors(ii,:);
    else
        curr_color = 'k';
    end
    plot(((1:numel(curr_trace)))/Fs,curr_trace,'Color',curr_color);
    hold off

    ax_stack_1{ii}.YLim(1) = 0;

    % %Check if YLim is sensible
    % [counts,edges] = histcounts(curr_trace,1000);
    % edges(counts == 0) = [];
    % edges(edges > mean(curr_trace)+std(curr_trace)*4) = [];
    % 
    % last_real_YLim = round(edges(end)*1.2,2,"significant");
    % 
    % if last_real_YLim > 0
    %     ax_stack_1{ii}.YLim(2) = min([ax_stack_1{ii}.YLim(2),...
    %         last_real_YLim]);
    % end

    if ii ~= disp_num
        ax_stack_1{ii}.XTick = [];
    end
    ax_stack_1{ii}.YTick = [];
    ax_stack_1{ii}.XRuler.Visible = opts.Visible;
    ax_stack_1{ii}.YRuler.Visible = opts.Visible;
    % ax{ii}.YTickLabel(1:end-1) = {''};
    if nargin >= 4
        standardAx(ax_stack_1{ii});
    end
end
if nargin < 4
    standardFig(f1);
end

end