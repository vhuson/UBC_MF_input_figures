function [ax_burst_typ] = plot_burst_examples_v2(all_mean_bursts,...
    Fs,baselines,ONidx,curr_cell,all_colors,lim_x,zerod_x,input_dur,trace_labels,...
    opts,f_burst_typ,pos_ax,base_height,base_space)

base_opts = struct();
base_opts.pad = false;
base_opts.YLim = false;
%Options for plot_burst_traces_overlay
base_opts.axis_off = false;
base_opts.scale_barxy = false; %add a 2 element vector to define the length of x and y
base_opts.scale_xlabel = [];
base_opts.scale_xscale_factor = 1;
base_opts.scale_ylabel = [];
base_opts.scale_yscale_factor = 1;
base_opts.input_color = [0.7 0.7 0.7];

opts = merge_structs(base_opts,opts);
%UNTITLED19 Summary of this function goes here
%   Detailed explanation goes here
ax_burst_typ = cell(size(all_mean_bursts));
for idx = 1:numel(all_mean_bursts)
    curr_traces = all_mean_bursts(idx);
    curr_lim_x_offset = lim_x+zerod_x(idx);
    
    if opts.pad
        %extend trace with baseline values
        curr_lim_x = curr_lim_x_offset + 0.5;

        num_req_samples = ceil(diff(curr_lim_x)*Fs);

        %Do we need to pad before the trace begins
        num_pre_samples = diff([ceil(curr_lim_x(1)*Fs), 1]);

        if num_pre_samples > 0
            base_vals = repmat(baselines,1,num_pre_samples);
            curr_traces{1} = [base_vals,curr_traces{1}];
        end

        %Pad required amount after the trace;
        num_post_samples = num_req_samples - size(curr_traces{1},2);

        if num_post_samples > 0
            base_vals = repmat(baselines,1,num_post_samples);
            curr_traces{1} = [curr_traces{1},base_vals];
        end
    end
    
    %Set current axis position
    pos_ax(2) = pos_ax(2) - base_height - base_space;
    %Plot trace
    [ax_burst_typ{idx}] = plot_burst_traces_overlay(curr_traces,Fs,...
        ONidx,curr_cell,all_colors(idx,:),0.5,...
        [],curr_lim_x_offset,f_burst_typ,pos_ax,opts);
    ax_burst_typ{idx}.LineWidth = 1.5;
    %Draw line a little bit above trace
    ax_burst_typ{idx}.YLim(2) = ax_burst_typ{idx}.YLim(2)*1.1;
    hold on
    line([0 input_dur(idx)],repmat(ax_burst_typ{idx}.YLim(2),1,2),...
        'LineWidth',2,'Color',opts.input_color);
    hold off
    
    %Add label if provided
    if ~isempty(trace_labels)
        text(ax_burst_typ{idx},0,0,trace_labels(idx),...
            'Units','normalized','Position',[0.00 0.4 0],...
            'HorizontalAlignment','left',...
            'FontName',"Arial","FontSize",12);
    end
end
same_ylim(ax_burst_typ);
end