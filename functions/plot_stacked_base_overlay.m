function [ax_stack_1] = plot_stacked_base_overlay(...
    base_data,all_baseline,Fs,select_cells,f1,pos1)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
if nargin < 3
    select_cells = 1:size(base_data{1},1);
end
if nargin < 4
    f1 = figure('Position', [488 1.8000 406.6000 780.8000]);
end
if nargin < 5
    pos1 = [0.0500    0.0500    0.90    0.9300];
end

trace_size = cellfun(@size,base_data,'UniformOutput',false);
trace_size = vertcat(trace_size{:});
trace_size = min(trace_size(:,2));

disp_num = numel(select_cells);

[all_positions] = get_stacked_axes_positions(pos1,0.08,disp_num);
all_positions = flipud(all_positions);

ax_stack_1 = cell(1,disp_num);

colors = [0.2 0.2 0.2;
                0.4 0.4 0.4;
                0.6 0.6 0.6];

for ii = 1:disp_num
    currBaseline = all_baseline(select_cells(ii));
     
    ax_stack_1{ii} = axes(f1,'Position',all_positions(ii,:));
    hold on
    line([1 trace_size]/Fs,repmat(currBaseline,1,2),'Color','r');
    for jj = 1:3
        curr_trace = base_data{jj}(select_cells(ii),1:trace_size);
        plot(((1:trace_size))/Fs,curr_trace,'Color',colors(jj,:));
    end
    hold off

    ax_stack_1{ii}.YLim(1) = 0;
    if ii ~= numel(select_cells)
        ax_stack_1{ii}.XTick = [];
    end
    ax_stack_1{ii}.YTick = [];


    if nargin >= 4
        standardAx(ax_stack_1{ii});
    end
end
if nargin < 4
    standardFig(f1);
end

end