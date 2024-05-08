% f_mf_burst = figure('Position', [488 1.8000 680.3150 857.9636],...
%     'Color','w');

% show_individual_traces = true;

left_edge = 0.13;
top_edge = 0.95;

left_edge_mf = 0.32;

burst_p_width = 0.1625;
burst_p_height = 0.06;
mf_p_width = 0.61;
height_space = 0.01;

x_scale_factor = 37.5;

%% Panel for burst input
ax_pos_burst = [left_edge top_edge-burst_p_height burst_p_width burst_p_height];
ax_burst_input = axes('Position', ax_pos_burst);
x_time = (1:30*Fs)/Fs;
dummy_y = zeros(size(x_time));
dummy_y(5*Fs:5.2*Fs) = 100;
plot(x_time,dummy_y,'k')
xlim([4.5 4.5+burst_p_width*x_scale_factor])
ylim([0 150])
title('20x 100 spk/s Burst')
t1 = text(ax_burst_input,3.5, ax_burst_input.YLim(2)/2,'Input','Rotation',90,...
    'HorizontalAlignment','center');

standardAx(ax_burst_input);
ax_burst_input.XRuler.Visible = 'off';
ax_burst_input.YRuler.Visible = 'off';
ylabel('Input')
scale_opts = struct();
scale_opts.xlabel = 's';
scale_opts.ylabel = 'spk/s';
add_scale_bar(ax_burst_input,[1,50],scale_opts);


%% Panel for MF input
ax_pos_mf = [left_edge_mf top_edge-burst_p_height mf_p_width burst_p_height];
ax_mfburst_input = axes('Position', ax_pos_mf);
plot(x_time,time2rate(round(prot_timings{3}*20),Fs,30),'k')
title('In vivo bursting MF')
xlim([0 mf_p_width*x_scale_factor])
standardAx(ax_mfburst_input);
ax_mfburst_input.XRuler.Visible = 'off';
ax_mfburst_input.YRuler.Visible = 'off';
scale_opts = struct();
scale_opts.ylabel = 'spk/s';
scale_opts.xlabel = 's';
add_scale_bar(ax_mfburst_input,[1,250],scale_opts);




%% Panel for fast cell burst reponse
% curr_cell_data = allData_invivo{3};
% curr_freqs = curr_cell_data.freqs{1}(:,1:2);
% cell 3 (1561), was original, cell 9 (1800) was ugly replacement
curr_cell_data = allData_invivo{10};
curr_freqs = curr_cell_data.freqs{1}(:,1:3);
curr_freqs = vertcat(curr_freqs{:});
curr_freqs = curr_freqs(:,1:30*Fs);
fast_ylim = [0 200];

ax_pos_burst(2) = ax_pos_burst(2)-burst_p_height-height_space;
ax_fast_burst = axes('Position', ax_pos_burst);

hold on
if show_individual_traces
    for ii = 1:3
        plot(x_time,curr_freqs(ii,:),'Color',[0.85 0.85 0.85])
    end
end
y_data = mean(curr_freqs);
if median_fltr
    y_data = medfilt1(y_data,Fs*0.02);
end

plot((1:numel(y_data))/Fs,y_data,'k')
hold off
xlim([4.5 4.5+burst_p_width*x_scale_factor])
ylim(fast_ylim);
t1 = text(ax_fast_burst,3.5, ax_fast_burst.YLim(2)/2,'Fast cell','Rotation',90,...
    'HorizontalAlignment','center');

standardAx(ax_fast_burst);
ax_fast_burst.Visible = 'off';

% scale_opts.origin = [9.5683 80];
add_scale_bar(ax_fast_burst,[0,50],scale_opts);


%% Panel for fast cell mf reponse
% curr_mf_resp = reshape(curr_cell_data.freqs{4},[600000,3]);
curr_mf_resp = curr_cell_data.freqs{2}{6};
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

hold off
ylim(fast_ylim);
xlim([0 mf_p_width*x_scale_factor])
standardAx(ax_fast_mf);
ax_fast_mf.Visible = 'off';
% add_scale_bar(ax_fast_mf,[1,50]);




%% Panel for intermediate cell burst reponse
% curr_cell_data = allData_invivo{3};
% curr_freqs = curr_cell_data.freqs{1}(:,1:2);
% cell 3 (1561), was original, cell 9 (1800) was ugly replacement
curr_cell_data = allData_invivo{4};
curr_freqs = curr_cell_data.freqs{1}(:,4:6);
curr_freqs = vertcat(curr_freqs{:});
curr_freqs = curr_freqs(:,1:30*Fs);
fast_ylim = [0 200];

ax_pos_burst(2) = ax_pos_burst(2)-burst_p_height-height_space;
ax_int_burst = axes('Position', ax_pos_burst);

hold on
if show_individual_traces
    for ii = 1:3
        plot(x_time,curr_freqs(ii,:),'Color',[0.85 0.85 0.85])
    end
end
y_data = mean(curr_freqs);
if median_fltr
    y_data = medfilt1(y_data,Fs*0.02);
end

plot((1:numel(y_data))/Fs,y_data,'k')
hold off
xlim([4.5 4.5+burst_p_width*x_scale_factor])
ylim(fast_ylim);
t1 = text(ax_int_burst,3.5, ax_int_burst.YLim(2)/2,'Mid. cell','Rotation',90,...
    'HorizontalAlignment','center');

standardAx(ax_int_burst);
ax_int_burst.Visible = 'off';

% scale_opts.origin = [9.5683 80];
add_scale_bar(ax_int_burst,[0,50],scale_opts);


%% Panel for intermediate cell mf reponse
% curr_mf_resp = reshape(curr_cell_data.freqs{4},[600000,3]);
% curr_mf_resp = curr_cell_data.freqs{2}{2};
% curr_mf_resp(1:5*Fs) = []; %Cut off front bit
% curr_mf_resp = reshape(curr_mf_resp(1:150*Fs),[30*Fs,5]);
% curr_mf_resp = curr_mf_resp(:,1:2:5);

curr_mf_resp = reshape(curr_cell_data.freqs{2}{2},[600001,3]);


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

plot((1:numel(y_data))/Fs,y_data,'k')

hold off
ylim(fast_ylim);
xlim([0 mf_p_width*x_scale_factor])
standardAx(ax_int_mf);
ax_int_mf.Visible = 'off';
% add_scale_bar(ax_fast_mf,[1,50]);





%% Panel for slow cell burst reponse
curr_cell_data = allData_invivo{1};
curr_freqs = curr_cell_data.freqs{1}(:,1:2);

curr_freqs = vertcat(curr_freqs{:});
curr_freqs = curr_freqs(:,1:30*Fs);
mid_ylim = [0 50];
mid_scale_bar = [0 20];

ax_pos_burst(2) = ax_pos_burst(2)-burst_p_height-height_space;
ax_mid_burst = axes('Position', ax_pos_burst);
hold on
if show_individual_traces
    for ii = 1:2
        plot(x_time,curr_freqs(ii,:),'Color',[0.85 0.85 0.85])
    end
end
y_data = mean(curr_freqs,1);
if median_fltr
    y_data = medfilt1(y_data,Fs*0.02);
end
plot((1:numel(y_data))/Fs,y_data,'k')

hold off
xlim([4.5 4.5+burst_p_width*x_scale_factor])
ylim(mid_ylim);
t1 = text(ax_mid_burst,3.5, ax_mid_burst.YLim(2)/2,'Slow cell','Rotation',90,...
    'HorizontalAlignment','center');


standardAx(ax_mid_burst);
ax_mid_burst.Visible = 'off';

scale_opts.origin = [10.3183 20];
add_scale_bar(ax_mid_burst,mid_scale_bar,scale_opts);


%% Panel for slow cell mf reponse
curr_mf_resp = reshape(curr_cell_data.freqs{2}{5},[600001,3]);

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

plot((1:numel(y_data))/Fs,y_data,'k')
hold off
ylim(mid_ylim);
xlim([0 mf_p_width*x_scale_factor])
standardAx(ax_mid_mf);
ax_mid_mf.Visible = 'off';
% add_scale_bar(ax_mid_mf,mid_scale_bar);




%% Panel for off cell burst reponse
curr_cell_data = allData_invivo{2};
curr_freqs = curr_cell_data.freqs{1}(:,1:2);

curr_freqs = vertcat(curr_freqs{:});
curr_freqs = curr_freqs(:,1:30*Fs);
off_ylim = [0 50];
off_scale_bar = [0 10];

ax_pos_burst(2) = ax_pos_burst(2)-burst_p_height-height_space;
ax_off_burst = axes('Position', ax_pos_burst);
hold on
if show_individual_traces
    for ii = 1:2
        plot(x_time,curr_freqs(ii,:),'Color',[0.85 0.85 0.85])
    end
end
y_data = mean(curr_freqs,1);
if median_fltr
    y_data = medfilt1(y_data,Fs*0.02);
end
plot((1:numel(y_data))/Fs,y_data,'k')
hold off
xlim([4.5 4.5+burst_p_width*x_scale_factor])
ylim(off_ylim);
t1 = text(ax_off_burst,3.5, ax_off_burst.YLim(2)/2,'OFF cell','Rotation',90,...
    'HorizontalAlignment','center');

standardAx(ax_off_burst);
ax_off_burst.Visible = 'off';
scale_opts.origin = [10.3183 8];
add_scale_bar(ax_off_burst,off_scale_bar,scale_opts);


%% Panel for off cell mf reponse
curr_mf_resp = reshape(curr_cell_data.freqs{2}{5},[600001,3]);

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

plot((1:numel(y_data))/Fs,y_data,'k')
hold off
ylim(off_ylim);
xlim([0 mf_p_width*x_scale_factor])
standardAx(ax_off_mf);
ax_off_mf.Visible = 'off';
scale_opts = struct();
scale_opts.origin = [27 8];
% add_scale_bar(ax_off_mf,off_scale_bar,scale_opts);