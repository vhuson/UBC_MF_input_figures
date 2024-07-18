f_mf_burst = figure('Position', [488 1.8000 680.3150 857.9636],...
    'Color','w');

% show_individual_traces = true;

left_edge = 0.13;
top_edge = 0.95;

left_edge_mf = 0.32;

burst_p_width = 0.1625;
burst_p_height = 0.06;
mf_p_width = 0.61;
height_space = 0.01;

x_scale_factor = 37.5;

% Get rolling window of spike counts
spike_times_s = prot_timings{3}/1000;

interv = 0.01;
burst_window = 0.10;
start_times = 0:interv:(30-burst_window);

rolling_n_spikes = zeros(size(start_times));

for ii = 1:numel(start_times)
    start_time = start_times(ii);
    end_time = start_time + burst_window;

    curr_spikes = spike_times_s > start_time & spike_times_s <= end_time;

    rolling_n_spikes(ii) = sum(curr_spikes);
end

%find peaks
[pks,locs] = findpeaks(rolling_n_spikes);
% locs(pks<2) = [];
% pks(pks<2) = [];

start_x = start_times + burst_window/2;

%Plotting
ax_rolling_nspikes = axes('Position', [0.0834 0.4578 0.8466 0.0772]);
hold on
bar(start_x,rolling_n_spikes)
plot(start_x(locs),pks,'r.')
hold off
xlim([0 mf_p_width*x_scale_factor])
box off

% Panel for MF input
x_time = (1:30*Fs)/Fs;
ax_pos_mf = [0.0834 0.5473 0.8466 0.1443];
ax_mfburst_input = axes('Position', ax_pos_mf);
plot(x_time,time2rate(round(prot_timings{3}*20),Fs,30),'Color',input_color)


title('In vivo bursting MF')
xlim([0 mf_p_width*x_scale_factor])

%Add text labels for peaks
peak_labels = {};
% lefties = [2,5,8,11,17];
lefties = [];
for ii = 1:numel(pks)
    if start_x(locs(ii)) > ax_mfburst_input.XLim(2)
        break
    end
    peak_labels{ii} = text(start_x(locs(ii)),0,[num2str(pks(ii)),'x'],...
        'FontName','Arial','HorizontalAlignment','center','VerticalAlignment','bottom');
    peak_labels{ii}.Units = 'normalized';
    
    peak_labels{ii}.Position(2) = 0.025*pks(ii);
  
    

    if ismember(ii,lefties)
        peak_labels{ii}.HorizontalAlignment = 'left';
        peak_labels{ii}.Units = 'pixels';
        peak_labels{ii}.Position(1) = peak_labels{ii}.Position(1)+2;
    end

    % %Check for overlap
    % if ii > 1
    %     prev_extent = sum(peak_labels{ii-1}.Extent([1,3]));
    %     prev_y = peak_labels{ii-1}.Extent(2);
    %     curr_extent = peak_labels{ii}.Extent(1);
    %     curr_y = peak_labels{ii}.Extent(2);
    % 
    % 
    %     if curr_extent <= prev_extent && prev_y == curr_y
    %         %Flip allignments.
    %         peak_labels{ii}.HorizontalAlignment = 'left';
    %         peak_labels{ii}.VerticalAlignment = 'top';
    %     end
    % end
peak_labels{ii}.Units = 'data';
peak_labels{ii}.FontSize = 10;
end


standardAx(ax_mfburst_input,struct('FontSize',10));
ax_mfburst_input.XRuler.Visible = 'off';
ax_mfburst_input.YRuler.Visible = 'off';
scale_opts = struct();
scale_opts.y_2line = true;
scale_opts.ylabel = 'spk/s';
scale_opts.xlabel = 's';
add_scale_bar(ax_mfburst_input,[1,250],scale_opts);

add_zero_line(ax_mfburst_input);


standardFig(f_mf_burst,struct('FontSize',10));
linkaxes([ax_mfburst_input ax_rolling_nspikes],'x')