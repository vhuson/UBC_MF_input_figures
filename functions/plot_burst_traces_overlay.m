function [ax1] = plot_burst_traces_overlay(trace_array,Fs,...
    curr_selection,curr_idx,all_colors,zerod_x,trace_labels,lim_x,f1,ax_position,opts)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

base_opts = struct();
base_opts.YLim = false;
base_opts.axis_off = false;
base_opts.scale_barxy = false; %add a 2 element vector to define the length of x and y
base_opts.scale_xlabel = [];
base_opts.scale_xscale_factor = 1;
base_opts.scale_ylabel = [];
base_opts.scale_yscale_factor = 1;

if nargin < 9
    f1 = figure('Position', [565.8000 187.4000 359.2000 279.2000]);
end
if nargin < 10
    ax_position = [0.1300 0.1100 0.7750 0.8150];
end
if nargin < 11
    opts = base_opts;
else
    opts = merge_structs(base_opts,opts);
end

ax1 = axes(f1,"Position",ax_position);
curr_cell = curr_selection(curr_idx);

%Check trace arrays and make sure its not only NaN and zeros (because this
%is not plot in matlab for unclear reasons)
% for ii = 1:numel(trace_array)
%     curr_trace = trace_array{ii}(curr_cell,:);
%     nan_data = isnan(curr_trace);
%     if any(nan_data)
%         nonan_data = curr_trace(~nan_data);
%         if all(nonan_data == 0)
%             trace_array{ii}(curr_cell,~nan_data) = 0.05;
%         end
% 
%     end
% 
% end

% Destroy 0 traces
if all(trace_array{1}(curr_cell,:) == 0)
    yData = [0 0];
    xData = [1 numel(trace_array{1}(curr_cell,:))] /Fs;
else
    yData = trace_array{1}(curr_cell,:);
    xData = (1:numel(trace_array{1}(curr_cell,:)))/Fs;
end

plot(xData-zerod_x(1),...
    yData,'Color',all_colors(1,:))

hold on
for jj = 2:numel(trace_array)
    % Destroy 0 traces
    if all(trace_array{jj}(curr_cell,:) == 0)
        yData = [0 0];
        xData = [1 numel(trace_array{jj}(curr_cell,:))] /Fs;
    else
        yData = trace_array{jj}(curr_cell,:);
        xData = (1:numel(trace_array{jj}(curr_cell,:)))/Fs;
    end
    plot(xData-zerod_x(jj),...
        yData,'Color',all_colors(jj,:))
end
hold off
% title(['Cell #',num2str(curr_idx)])
if ~isempty(trace_labels)
    legend(trace_labels,'Box','off')
end
% ylabel('Response (spk/s)')
% xlabel('Time (s)')
xlim(lim_x)

if islogical(opts.YLim)
    ax1.YLim(1) = min([ax1.YLim(1), 0]);
else
    ax1.YLim = opts.YLim;
end

if opts.axis_off
    ax1.XRuler.Visible ="off";
    ax1.YRuler.Visible ="off";
end

if opts.scale_barxy
    scale_opts = struct();
    scale_opts.ylabel = opts.scale_ylabel;
    scale_opts.xlabel = opts.scale_xlabel;
    scale_opts.xscale_factor = opts.scale_xscale_factor;
    scale_opts.yscale_factor = opts.scale_yscale_factor;
    add_scale_bar(ax1,opts.scale_barxy,scale_opts)
    
end
standardAx(ax1);

end