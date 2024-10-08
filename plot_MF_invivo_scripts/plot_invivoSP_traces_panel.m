% % show_individual_traces = true;
% f_mf_burst = figure('Position', [488 1.8000 680.3150 857.9636],...
%     'Color','w');

% left_edge = 0.13;
% top_edge = 0.57;
top_edge = 0.39;

left_edge_mf = 0.13;

% burst_p_width = 0.1425;
burst_p_height = 0.06;
mf_p_width = 0.8;
height_space = 0.01;




%% Panel for MF input
x_time = (1:30*Fs)/Fs;
ax_pos_mf = [left_edge_mf top_edge-burst_p_height mf_p_width burst_p_height];
ax_mfburst_input = axes('Position', ax_pos_mf);
plot(x_time,time2rate(round(prot_timings{1}*20),Fs,30),'Color',input_color)
ylim([0 110])
title('In vivo smooth pursuit MF')
t1 = text(ax_mfburst_input,-1, ax_mfburst_input.YLim(2)/2,'Input','Rotation',90,...
    'HorizontalAlignment','center');

standardAx(ax_mfburst_input);
ax_mfburst_input.XRuler.Visible = 'off';
ax_mfburst_input.YRuler.Visible = 'off';
ylabel('Input')
scale_opts = struct();
scale_opts.xlabel = 's';
scale_opts.ylabel = 'spk/s';
scale_opts.origin = [28.7246 80];
add_scale_bar(ax_mfburst_input,[1,50],scale_opts);

add_zero_line(ax_mfburst_input);

%% Panel for fast cell mf reponse
curr_cell_data = allData_invivo{10};
fast_ylim = [0 200];


% curr_mf_resp = reshape(curr_cell_data.freqs{2},[600000,3]);
curr_mf_resp = curr_cell_data.freqs{2}{1};
curr_mf_resp(1:5*Fs) = []; %Cut off front bit
curr_mf_resp = reshape(curr_mf_resp(1:150*Fs),[30*Fs,5]);
curr_mf_resp = curr_mf_resp(:,1:2:5);

ax_pos_mf(2) = ax_pos_mf(2)-burst_p_height-height_space;
ax_fast_mf = axes('Position', ax_pos_mf);
hold on
if show_individual_traces
    for ii = 1:3
        plot(x_time',curr_mf_resp(:,ii),'Color',[0.85 0.85 0.85])
    end
end
y_data = mean(curr_mf_resp,2);
if median_fltr
    y_data = medfilt1(y_data,Fs*0.02);
end

plot((1:numel(y_data))/Fs,y_data,'k')
axis tight
hold off
ylim(fast_ylim);


t1 = text(ax_fast_mf,-1, ax_fast_mf.YLim(2)/2,'Fast','Rotation',90,...
    'HorizontalAlignment','center');


standardAx(ax_fast_mf);
ax_fast_mf.Visible = 'off';

scale_opts = struct();
scale_opts.xlabel = 's';
scale_opts.ylabel = 'spk/s';
add_scale_bar(ax_fast_mf,[0,50],scale_opts);
add_zero_line(ax_fast_mf);

%% Panel for int cell mf reponse
curr_cell_data = allData_invivo{4};

mid_scale_bar = [0 20];


curr_mf_resp = reshape(curr_cell_data.freqs{2}{1},[600001,3]);

ax_pos_mf(2) = ax_pos_mf(2)-burst_p_height-height_space;
ax_int_mf = axes('Position', ax_pos_mf);
hold on
if show_individual_traces
    for ii = 1:3
        plot(x_time',curr_mf_resp(1:numel(x_time),ii),'Color',[0.85 0.85 0.85])
    end
end
y_data = mean(curr_mf_resp,2);
if median_fltr
    y_data = medfilt1(y_data,Fs*0.02);
end

plot(x_time,y_data(1:numel(x_time)),'k')
hold off
ylim(fast_ylim);

t1 = text(ax_int_mf,-1, ax_int_mf.YLim(2)/2,'Mid-range','Rotation',90,...
    'HorizontalAlignment','center');

standardAx(ax_int_mf);
ax_int_mf.Visible = 'off';
add_scale_bar(ax_int_mf,[0 50],scale_opts);

add_zero_line(ax_int_mf);

%% Panel for slow cell mf reponse
curr_cell_data = allData_invivo{1};
curr_freqs = curr_cell_data.freqs{1}(:,1:2);
mid_ylim = [0 50];
mid_scale_bar = [0 20];


curr_mf_resp = reshape(curr_cell_data.freqs{2}{3},[600001,3]);

ax_pos_mf(2) = ax_pos_mf(2)-burst_p_height-height_space;
ax_mid_mf = axes('Position', ax_pos_mf);
hold on
if show_individual_traces
    for ii = 1:3
        plot(x_time',curr_mf_resp(1:numel(x_time),ii),'Color',[0.85 0.85 0.85])
    end
end
y_data = mean(curr_mf_resp,2);
if median_fltr
    y_data = medfilt1(y_data,Fs*0.02);
end

plot(x_time,y_data(1:numel(x_time)),'k')
hold off
ylim(mid_ylim);

t1 = text(ax_mid_mf,-1, ax_mid_mf.YLim(2)/2,'Slow','Rotation',90,...
    'HorizontalAlignment','center');

standardAx(ax_mid_mf);
ax_mid_mf.Visible = 'off';
scale_opts.origin = [29.7246 34];
add_scale_bar(ax_mid_mf,mid_scale_bar,scale_opts);
add_zero_line(ax_mid_mf);



%% Panel for off cell mf reponse
curr_cell_data = allData_invivo{2};
curr_freqs = curr_cell_data.freqs{1}(:,1:2);
off_ylim = [0 50];
off_scale_bar = [0 10];


curr_mf_resp = reshape(curr_cell_data.freqs{2}{3},[600001,3]);

ax_pos_mf(2) = ax_pos_mf(2)-burst_p_height-height_space;
ax_off_mf = axes('Position', ax_pos_mf);
hold on
if show_individual_traces
    for ii = 1:3
        plot(x_time',curr_mf_resp(1:numel(x_time),ii),'Color',[0.85 0.85 0.85])
    end
end
y_data = mean(curr_mf_resp,2);
if median_fltr
    y_data = medfilt1(y_data,Fs*0.02);
end

plot(x_time,y_data(1:numel(x_time)),'k')
hold off
ylim(off_ylim);

t1 = text(ax_off_mf,-1, ax_off_mf.YLim(2)/2,'OFF','Rotation',90,...
    'HorizontalAlignment','center');

standardAx(ax_off_mf);
ax_off_mf.Visible = 'off';
% scale_opts = struct();
scale_opts.origin = [29.7246 44];
add_scale_bar(ax_off_mf,off_scale_bar,scale_opts);
add_zero_line(ax_off_mf);

%% Add UBC label


t_base = text(ax_off_mf,0, 0,'UBC response','Rotation',90,...
    'HorizontalAlignment','center','Units','normalized');
t_base.Units = "pixels";
t_base.Position(2) = 124;
t_base.Position(1) = -42;
