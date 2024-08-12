% f_mf_burst = figure('Position', [488 1.8000 680.3150 857.9636],...
%     'Color','w');

% show_individual_traces = true;

left_edge = 0.13;
top_edge = 0.77;

left_edge_mf = 0.32;

burst_p_width = 0.1625;
burst_p_height = 0.06;
mf_p_width = 0.61;
height_space = 0.01;

x_scale_factor = 37.5;


%% panel for burst input 
ax_pos_burst = [left_edge top_edge-burst_p_height burst_p_width burst_p_height];
ax_burst_input = axes('Position', ax_pos_burst);
x_time = (1:30*Fs)/Fs;
dummy_y = zeros(size(x_time));
dummy_y(5*Fs:5.2*Fs) = 100;
plot(x_time,dummy_y,'Color',input_color)
xlim([4.5 4.5+burst_p_width*x_scale_factor])
ylim([0 150])
% title('20x 100 spk/s Burst')
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

add_zero_line(ax_burst_input);

%% Panel for MF input with labels
% Get rolling window of spike counts
spike_times_s = prot_timings{3}/1000;

interv = 0.01;
burst_window = 0.19;
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
locs(pks<3) = [];
pks(pks<3) = [];

start_x = start_times + burst_window/2;

%Plotting
% ax_rolling_nspikes = axes('Position', [0.0834 0.4578 0.8466 0.0772]);
% hold on
% bar(start_x,rolling_n_spikes)
% plot(start_x(locs),pks,'r.')
% hold off
% xlim([0 mf_p_width*x_scale_factor])
% box off

% Panel for MF input
x_time = (1:30*Fs)/Fs;
ax_pos_mf = [left_edge_mf top_edge-burst_p_height mf_p_width burst_p_height];
ax_mfburst_input = axes('Position', ax_pos_mf);
plot(x_time,time2rate(round(prot_timings{3}*20),Fs,30),'Color',input_color)


title('In vivo bursting MF')
xlim([0 mf_p_width*x_scale_factor])

%Add text labels for peaks
peak_labels = {};
% lefties = [2,5,8,11,17];
lefties = [];
fix_overlap = false;
manual_labels = true;

%Label positions with 2 spike minimum
% man_label_pos = [0.535000000000002	924.576271186440	1.42108547152020e-14;
% 1.06572368421053	449.576271186440	1.42108547152020e-14;
% 1.24054276315790	25.0000000000004	1.42108547152020e-14;
% 1.99235197368421	25.0000000000004	1.42108547152020e-14;
% 2.33500000000000	224.788135593221	1.42108547152020e-14;
% 2.89500000000000	871.680790960452	1.42108547152020e-14;
% 3.50090460526316	74.9999999999993	1.42108547152020e-14;
% 4.52945723684211	50.0000000000007	1.42108547152020e-14;
% 4.99500000000000	808.050847457626	1.42108547152020e-14;
% 5.55054276315789	50.0000000000007	1.42108547152020e-14;
% 7.17500000000000	799.576271186440	1.42108547152020e-14;
% 9.33500000000000	685.734463276837	1.42108547152020e-14;
% 9.83572368421053	99.9999999999997	1.42108547152020e-14;
% 11.7750000000000	521.892655367231	1.42108547152020e-14;
% 12.2709046052632	25.0000000000004	1.42108547152020e-14;
% 13.7094572368421	74.9999999999993	1.42108547152020e-14;
% 14.2550000000000	527.471751412430	1.42108547152020e-14;
% 14.8005427631579	25.0000000000004	1.42108547152020e-14;
% 16.1650000000000	1015.88983050847	1.42108547152020e-14;
% 18.2794572368421	25.0000000000004	1.42108547152020e-14;
% 18.7450000000000	1007.20338983051	1.42108547152020e-14;
% 19.3205427631579	91.7372881355936	1.42108547152020e-14;
% 20.1105427631579	25.0000000000004	1.42108547152020e-14];

%Label positions with 3 spike minimum
man_label_pos = [0.535000000000002	924.576271186440	1.42108547152020e-14;
0.9002          	449.576271186440	1.42108547152020e-14;
2.89500000000000	852.259887005649	1.42108547152020e-14;
3.28018092105263	55.5790960451983	1.42108547152020e-14;
4.99500000000000	788.629943502825	1.42108547152020e-14;
7.17500000000000	780.155367231639	1.42108547152020e-14;
9.33500000000000	685.734463276837	1.42108547152020e-14;
9.67018092105263	80.5790960451986	1.42108547152020e-14;
11.7750000000000	521.892655367231	1.42108547152020e-14;
13.8750000000000	74.9999999999993	1.42108547152020e-14;
14.2550000000000	488.629943502825	1.42108547152020e-14;
16.1650000000000	996.468926553672	1.42108547152020e-14;
18.8001809210526	987.782485875707	1.42108547152020e-14;
19.1550000000000	111.158192090395	1.42108547152020e-14];

for ii = 1:numel(pks)
    if start_x(locs(ii)) > ax_mfburst_input.XLim(2)
        break
    end
    peak_labels{ii} = text(start_x(locs(ii)),0,[num2str(pks(ii))],...
        'FontName','Arial','HorizontalAlignment','center','VerticalAlignment','bottom');
    peak_labels{ii}.Units = 'normalized';
    
    peak_labels{ii}.Position(2) = 0.025*pks(ii);
  
    

    if ismember(ii,lefties)
        peak_labels{ii}.HorizontalAlignment = 'left';
        peak_labels{ii}.Units = 'pixels';
        peak_labels{ii}.Position(1) = peak_labels{ii}.Position(1)+2;
    end

    %Check for overlap
    if ii > 1 && fix_overlap
        peak_labels{ii}.Units = 'pixels';
        peak_labels{ii-1}.Units = 'pixels';

        prev_y_min = peak_labels{ii-1}.Extent(2);
        prev_y_max = sum(peak_labels{ii-1}.Extent([2,4]))-6;
        curr_y_min = peak_labels{ii}.Extent(2);
        curr_y_max = sum(peak_labels{ii}.Extent([2,4]))-6;

        %Check for y overlap
        if curr_y_min < prev_y_max || curr_y_max < prev_y_min

            prev_extent = sum(peak_labels{ii-1}.Extent([1,3]));
            curr_extent = peak_labels{ii}.Extent(1);

            %Check for x overlap
            if curr_extent < prev_extent
                peak_labels{ii}.Position(1) = peak_labels{ii}.Position(1) + prev_extent-curr_extent+1;
            end
        end
        peak_labels{ii}.Units = 'data';
        peak_labels{ii-1}.Units = 'data';



        % prev_y = peak_labels{ii-1}.Extent(2);
        % curr_y = peak_labels{ii}.Extent(2);
        % if curr_extent <= prev_extent && prev_y == curr_y
        %     %Flip allignments.
        %     peak_labels{ii}.HorizontalAlignment = 'left';
        %     peak_labels{ii}.VerticalAlignment = 'top';
        % end
        
    end
peak_labels{ii}.Units = 'data';
peak_labels{ii}.FontSize = 10;
if manual_labels
    peak_labels{ii}.Position = man_label_pos(ii,:);
end
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

%% old Panel for MF input without labels
% ax_pos_mf = [left_edge_mf top_edge-burst_p_height mf_p_width burst_p_height];
% ax_mfburst_input = axes('Position', ax_pos_mf);
% plot(x_time,time2rate(round(prot_timings{3}*20),Fs,30),'Color',input_color)
% title('In vivo bursting MF')
% xlim([0 mf_p_width*x_scale_factor])
% standardAx(ax_mfburst_input);
% ax_mfburst_input.XRuler.Visible = 'off';
% ax_mfburst_input.YRuler.Visible = 'off';
% scale_opts = struct();
% scale_opts.y_2line = true;
% scale_opts.ylabel = 'spk/s';
% scale_opts.xlabel = 's';
% add_scale_bar(ax_mfburst_input,[1,250],scale_opts);
% 
% add_zero_line(ax_mfburst_input);


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
t1 = text(ax_fast_burst,3.5, ax_fast_burst.YLim(2)/2,'Fast','Rotation',90,...
    'HorizontalAlignment','center');

standardAx(ax_fast_burst);
ax_fast_burst.Visible = 'off';

scale_opts.origin = [10.3183 80];
add_scale_bar(ax_fast_burst,[0,50],scale_opts);
add_zero_line(ax_fast_burst);

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

scale_opts.origin = [22.5996 80];
add_scale_bar(ax_fast_mf,[0,50],scale_opts);
add_zero_line(ax_fast_mf);



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
t1 = text(ax_int_burst,3.5, ax_int_burst.YLim(2)/2,'Mid-range','Rotation',90,...
    'HorizontalAlignment','center');

standardAx(ax_int_burst);
ax_int_burst.Visible = 'off';

scale_opts.origin = [10.3183 100];
add_scale_bar(ax_int_burst,[0,50],scale_opts);
add_zero_line(ax_int_burst);

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
scale_opts.origin = [22.5996 100];
add_scale_bar(ax_int_mf,[0,50],scale_opts);
add_zero_line(ax_int_mf);




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
t1 = text(ax_mid_burst,3.5, ax_mid_burst.YLim(2)/2,'Slow','Rotation',90,...
    'HorizontalAlignment','center');


standardAx(ax_mid_burst);
ax_mid_burst.Visible = 'off';

scale_opts.origin = [10.3183 25];
add_scale_bar(ax_mid_burst,mid_scale_bar,scale_opts);
add_zero_line(ax_mid_burst);

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
scale_opts.origin = [22.5996 25];
add_scale_bar(ax_mid_mf,mid_scale_bar,scale_opts);
add_zero_line(ax_mid_mf);



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
t1 = text(ax_off_burst,3.5, ax_off_burst.YLim(2)/2,'OFF','Rotation',90,...
    'HorizontalAlignment','center');

standardAx(ax_off_burst);
ax_off_burst.Visible = 'off';
scale_opts.origin = [10.3183 15];
add_scale_bar(ax_off_burst,off_scale_bar,scale_opts);
add_zero_line(ax_off_burst);

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

scale_opts.origin = [22.5996 15];
add_scale_bar(ax_off_mf,off_scale_bar,scale_opts);
add_zero_line(ax_off_mf);

%% Add UBC label


t_base = text(ax_off_burst,0, 0,'UBC response','Rotation',90,...
    'HorizontalAlignment','center','Units','normalized');
t_base.Units = "pixels";
t_base.Position(2) = 124;
t_base.Position(1) = -42;

