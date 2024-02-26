function [hg] = add_scale_bar(ax1,scale_barxy,opts)
%UNTITLED16 Summary of this function goes here
%   Detailed explanation goes here
base_opts = struct();
base_opts.x_pixel_offset = 5;
base_opts.y_pixel_offset = 5;
base_opts.linewidth = 1.5;
base_opts.xlabel = []; %'s';
base_opts.xscale_factor = 1;
base_opts.ylabel = []; %'pA';
base_opts.yscale_factor = 1;

base_opts.label_font = 'Arial';
base_opts.label_fontsize = 12;

base_opts.origin = 'auto';



if nargin < 3
    opts = base_opts;
else
    opts = merge_structs(base_opts,opts);
end

old_units = ax1.Units;
ax1.Units = 'pixels';

%Get axis size
x_space = diff(ax1.XLim);
x_units_per_pixel = x_space / ax1.Position(3);
y_space = diff(ax1.YLim);
y_units_per_pixel = y_space / ax1.Position(3);

%Define x y positions
if strcmp(opts.origin,'auto')
    %define x
    x_offset = opts.x_pixel_offset;

    x2 = ax1.XLim(2) - x_units_per_pixel * x_offset;
    x1 = x2 - scale_barxy(1);

    %Define y positions
    y_offset = opts.y_pixel_offset;

    y2 = ax1.YLim(2) - y_units_per_pixel * y_offset;
    y1 = y2 - scale_barxy(2);
else
    x1 = opts.origin(1);
    x2 = x1 + scale_barxy(1);

    y1 = opts.origin(2);
    y2 = y1 + scale_barxy(2);

    %Check if within limits, if not adjust to fit exactly
    ax1.XLim(1) = min([ax1.XLim(1), x1]);
    ax1.XLim(2) = max([ax1.XLim(2), x2]);

    ax1.YLim(1) = min([ax1.YLim(1), y1]);
    ax1.YLim(2) = max([ax1.YLim(2), y2]);
end


%Draw scale bar
hold(ax1,"on");
% hg = hggroup(ax1);
%x line
if scale_barxy(1) > 0
    %Draw line
    line([x1 x2],[y1 y1],'Color','k','LineWidth',opts.linewidth,'Parent',ax1);
    %Draw label
    if ~isempty(opts.xlabel)
        label_string = [num2str(scale_barxy(1) * opts.xscale_factor), ...
            ' ', opts.xlabel];
        text(ax1,mean([x1 x2]),y1-y_units_per_pixel*2,label_string,...
            'HorizontalAlignment','center',...
            'VerticalAlignment','top',...
            'FontSize',opts.label_fontsize,...
            'FontName',opts.label_font,'Parent',ax1)
    end
end

if scale_barxy(2) > 0
    line(ax1,[x1 x1],[y1 y2],'Color','k','LineWidth',opts.linewidth,'Parent',ax1)

    %Draw label
    if ~isempty(opts.ylabel)
        label_string = [num2str(scale_barxy(2) * opts.yscale_factor), ...
            ' ', opts.ylabel];
        text(ax1,x1-x_units_per_pixel*3,mean([y1 y2]),label_string,...
            'HorizontalAlignment','right',...
            'VerticalAlignment','middle',...
            'FontSize',opts.label_fontsize,...
            'FontName',opts.label_font,'Parent',ax1)
    end
end
ax1.Units = old_units;
end