function [cl_ax] = colorline_legend(color_map,ax_pos,curr_fig,opts)
%UNTITLED Summary of this function goes here
%   Plot color bar like legend of colored lines
base_opts.n_shown = 3;
base_opts.n_pos = false; %Or list of cells to show
base_opts.even_space = true;

if nargin < 2
    ax_pos = [0.13 0.13 0.8 0.8];
end
if nargin < 3
    curr_fig = gcf;
end
if nargin < 4
    opts = base_opts;
else
    opts = merge_structs(base_opts,opts);
end


cl_ax = axes(curr_fig,'Position',ax_pos);

%Find positions to show
if islogical(opts.n_pos)
    n_pos = 1:(size(color_map,1)-1)/(numel(n_pos)-1):size(color_map,1);
    n_pos = round(n_pos);
else
    n_pos = opts.n_pos;
end

idx_pos = n_pos;

if opts.even_space
    n_pos = 1:(size(color_map,1)-1)/(numel(n_pos)-1):size(color_map,1);
end

hold(cl_ax,'on')
dash_lines = {};
for ii = 1:numel(n_pos)
    plot([0,1],-[n_pos(ii) n_pos(ii)],'Color',color_map(idx_pos(ii),:),...
        'LineWidth',1)

    t_l = text(1,-n_pos(ii),num2str(idx_pos(ii)),...
        'FontName','Arial','FontSize',10);
    t_l.Units = 'pixels';
    t_l.Position(1) = t_l.Position(1) + 3;
    t_l.Units = 'data';

    if ii > 1 % add dashed line
        %Don't dash add elipsis
        % dash_lines{end+1} = line([0.5 0.5],-[n_pos(ii-1) n_pos(ii)],...
        %     'LineStyle',':','Color','k');
        %This is also stupid just do three separate dots
        % dash_lines{end+1} = text(0.5,mean(-[n_pos(ii-1) n_pos(ii)]),...
        %     '. . .','FontSize',10,'FontName','Arial',...
        %     'Rotation',90,'HorizontalAlignment','center',...
        %     'VerticalAlignment','baseline');
        curr_space = -[n_pos(ii-1) n_pos(ii)];
        dash_pos = -n_pos(ii-1):diff(curr_space)/4:-n_pos(ii);
        dash_lines{end+1} = scatter([0.5 0.5 0.5],dash_pos(2:end-1),28,"black",'.');
    end
end
hold(cl_ax,'off')
axis tight
axis off
%Fix dashes
% cl_ax.Units = 'pixels';
% data_units_per_pixel = diff(cl_ax.YLim)/cl_ax.Position(4);
% for ii = 1:numel(dash_lines)
%     dash_lines{ii}.YData = dash_lines{ii}.YData + ...
%         [-data_units_per_pixel, data_units_per_pixel]*3;
% end
% cl_ax.Units = 'normalized';

% %Add label on the right
% legend_label = text(cl_ax,sum(t_l.Extent([1,3])),0,'Cell #',...
%     'FontSize',10,'FontName','Arial',...
%     'Rotation',-90,'HorizontalAlignment','center','VerticalAlignment','bottom');
% legend_label.Units = 'normalized';
% legend_label.Position(2) = 0.5;

%Add label on top
t1 = title(cl_ax,'Cell #','FontSize',10,'FontName','Arial','FontWeight','normal');
t1.Position(1) = sum(t_l.Extent([1,3]))/2;
t1.Units = 'pixels';
t1.Position(2) = t1.Position(2)+3;
t1.Units = 'data';

end