function [sb_ax] = add_scale_bar(ax1,scale_barxy,opts)
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
base_opts.y_2line = false;

base_opts.label_font = 'Arial';
base_opts.label_fontsize = 10;

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
    % ax1.XLim(1) = min([ax1.XLim(1), x1]);
    % ax1.XLim(2) = max([ax1.XLim(2), x2]);
    % 
    % ax1.YLim(1) = min([ax1.YLim(1), y1]);
    % ax1.YLim(2) = max([ax1.YLim(2), y2]);
end


%Draw scale bar
ax1.Color = 'none';
sb_ax = axes(ax1.Parent,'Units','pixels',"Position",ax1.Position,'Visible',...
    'off','Color','none','HandleVisibility','off');
sb_ax.XLim = ax1.XLim;
sb_ax.YLim = ax1.YLim;
hold(sb_ax,"on");
% hg = hggroup(ax1);
%x line
if scale_barxy(1) > 0
    %Draw line
    line([x1 x2],[y1 y1],'Color','k','LineWidth',opts.linewidth,'Parent',sb_ax);
    %Draw label
    if ~isempty(opts.xlabel)
        label_string = [num2str(scale_barxy(1) * opts.xscale_factor), ...
            ' ', opts.xlabel];
        text(sb_ax,mean([x1 x2]),y1-y_units_per_pixel*2,label_string,...
            'HorizontalAlignment','center',...
            'VerticalAlignment','top',...
            'FontSize',opts.label_fontsize,...
            'FontName',opts.label_font,'Parent',sb_ax)
    end
end

if scale_barxy(2) > 0
    line(sb_ax,[x1 x1],[y1 y2],'Color','k','LineWidth',opts.linewidth,'Parent',sb_ax)

    %Draw label
    if ~isempty(opts.ylabel)
        if opts.y_2line
            label_string = [num2str(scale_barxy(2) * opts.yscale_factor)];
            ty1 = text(sb_ax,x1-x_units_per_pixel*3,mean([y1 y2]),label_string,...
                'HorizontalAlignment','right',...
                'VerticalAlignment','bottom',...
                'FontSize',opts.label_fontsize,...
                'FontName',opts.label_font,'Parent',sb_ax);
            ty1.Units = 'pixels';
            ty1.Position(2) = ty1.Position(2) -2;

            label_string2 = [opts.ylabel];
            ty2 = text(sb_ax,x1-x_units_per_pixel*3,mean([y1 y2]),label_string2,...
                'HorizontalAlignment','right',...
                'VerticalAlignment','top',...
                'FontSize',opts.label_fontsize,...
                'FontName',opts.label_font,'Parent',sb_ax);
            ty2.Units = 'pixels';
            ty2.Position(2) = ty2.Position(2) + 2;

            %Shift to left aligned
            left_extent = min(ty1.Extent(1) , ty2.Extent(1));
            ty1.Position(1) = left_extent;
            ty2.Position(1) = left_extent;
            ty1.HorizontalAlignment = 'left';
            ty2.HorizontalAlignment = 'left';

            ty1.Units = 'data';
            ty2.Units = 'data';
        else
        label_string = [num2str(scale_barxy(2) * opts.yscale_factor), ...
            ' ', opts.ylabel];
        text(sb_ax,x1-x_units_per_pixel*3,mean([y1 y2]),label_string,...
            'HorizontalAlignment','right',...
            'VerticalAlignment','middle',...
            'FontSize',opts.label_fontsize,...
            'FontName',opts.label_font,'Parent',sb_ax)
        end
    end
end

%Check to make sure if scale bar is within limits, if not adjust axes
%Get units per pixel
pix_per_x = sb_ax.Position(3) / diff(sb_ax.XLim);
pix_per_y = sb_ax.Position(4) / diff(sb_ax.YLim);

if sb_ax.XLim(1) > x1
    %Move axes left
    pix_change = pix_per_x * (sb_ax.XLim(1) - x1);
    sb_ax.Position(1) = sb_ax.Position(1) - pix_change;
    sb_ax.Position(3) = sb_ax.Position(3) + pix_change;
    sb_ax.XLim(1) = x1;
end

if sb_ax.XLim(2) < x2
    %Expand axes right
    pix_change = pix_per_x * (x2 - sb_ax.XLim(2));
    sb_ax.Position(3) = sb_ax.Position(3) + pix_change;
    sb_ax.XLim(2) = x2;
end


if sb_ax.YLim(1) > y1
    %Move axes down
    pix_change = pix_per_y * (sb_ax.YLim(1) - y1);
    sb_ax.Position(2) = sb_ax.Position(2) - pix_change;
    sb_ax.Position(4) = sb_ax.Position(4) + pix_change;
    sb_ax.YLim(1) = y1;
end

if sb_ax.YLim(2) < y2
    %Expand axes up
    pix_change = pix_per_y * (y2 - sb_ax.YLim(2));
    sb_ax.Position(4) = sb_ax.Position(4) + pix_change;
    sb_ax.YLim(2) = y2;
end



ax1.Units = old_units;
end