f_mf_new_SP = figure('Position', [488 1.8000 680.3150 857.9636],...
    'Color','w');

show_segment = 1;

left_edge = 0.13;
top_edge = 0.95;

left_edge_mf = 0.3;

burst_p_width = 0.1425;
burst_p_height = 0.08;
mf_p_width = 0.6;
height_space = 0.01;

% Panel for burst input
ax_pos_burst = [left_edge top_edge-burst_p_height burst_p_width burst_p_height];
ax_burst_input = axes('Position', ax_pos_burst);
x_time = (1:30*Fs)/Fs;
dummy_y = zeros(size(x_time));
dummy_y(5*Fs:5.2*Fs) = 100;
plot(x_time,dummy_y,'k')
xlim([4.5 10])
ylim([0 150])
title('20x 100Hz Burst')
t1 = text(ax_burst_input,3.5, ax_burst_input.YLim(2)/2,'Input','Rotation',90,...
    'HorizontalAlignment','center');

standardAx(ax_burst_input);
ax_burst_input.XRuler.Visible = 'off';
ax_burst_input.YRuler.Visible = 'off';
% ylabel('Input')
scale_opts = struct();
scale_opts.xlabel = 's';
scale_opts.ylabel = 'Hz';
% add_scale_bar(ax_burst_input,[1,50],scale_opts);


% Panel for MF input
ax_pos_mf = [left_edge_mf top_edge-burst_p_height mf_p_width burst_p_height];
ax_mfburst_input = axes('Position', ax_pos_mf);
plot(x_time,time2rate(round(prot_timings{1}*20),Fs,30),'k')
title('In vivo smooth pursuit MF')

standardAx(ax_mfburst_input);
ax_mfburst_input.XRuler.Visible = 'off';
ax_mfburst_input.YRuler.Visible = 'off';
add_scale_bar(ax_mfburst_input,[1,50],scale_opts);

ax_cells_burst = {};
ax_cells_mf = {};
for ii = [9 6 8 4 7]%[9 6 8 4 5 7]
    %Burst response
    curr_cell_data = allData_invivo{ii};
    curr_freqs = curr_cell_data.freqs{1}(:,1:4);
    curr_freqs = vertcat(curr_freqs{:});

    ax_pos_burst(2) = ax_pos_burst(2)-burst_p_height-height_space;
    ax_cells_burst{ii} = axes('Position', ax_pos_burst);
    y_data = mean(curr_freqs);
    plot((1:numel(y_data))/Fs,y_data,'k')
    xlim([4.5 10])

    standardAx(ax_cells_burst{ii});
    ax_cells_burst{ii}.Visible = 'off';
    add_scale_bar(ax_cells_burst{ii},[1,10]);

    %MF response
    curr_mf_resp = curr_cell_data.freqs{2}{1}(600001:1200000);
    curr_mf_resp = medfilt1(curr_mf_resp,0.02*Fs);


    ax_pos_mf(2) = ax_pos_mf(2)-burst_p_height-height_space;
    ax_cells_mf{ii} = axes('Position', ax_pos_mf);
    plot((1:numel(curr_mf_resp))/Fs,curr_mf_resp,'k')

    standardAx(ax_cells_mf{ii});
    ax_cells_mf{ii}.Visible = 'off';
    % add_scale_bar(ax_cells_mf{ii},[1,10]);
    linkaxes([ax_cells_burst{ii}, ax_cells_mf{ii}],'y')
end
