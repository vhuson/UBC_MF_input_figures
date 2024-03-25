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
ylabel('Input')
scale_opts = struct();
scale_opts.xlabel = 's';
scale_opts.ylabel = 'Hz';
% add_scale_bar(ax_burst_input,[1,50],scale_opts);


% Panel for MF input
ax_pos_mf = [left_edge_mf top_edge-burst_p_height mf_p_width burst_p_height];
ax_mfburst_input = axes('Position', ax_pos_mf);

step_pos = [5, 8, 12, 16, 20, 24, 28, 32];
step_size = [10 60 80 100 120 140 160 60];

dummy_y_160 = zeros(1,880001);
dummy_y_160(5*Fs:36*Fs) = 10;
for ii = 2:numel(step_pos)
    dummy_y_160(step_pos(ii)*Fs:(step_pos(ii)+1)*Fs) = step_size(ii);
end

plot((1:numel(dummy_y_160))/Fs,dummy_y_160,'k')
axis tight
ax_mfburst_input.YLim(2) = ax_mfburst_input.YLim(2)*1.4;
t1 = text(step_pos(1),step_size(1)+32,num2str(step_size(1)));
for ii = 2:numel(step_pos)
    t2 = text(step_pos(ii)+0.5,step_size(ii)+32,num2str(step_size(ii)),...
        "HorizontalAlignment","center","FontSize",10);
end

% title('In vivo smooth pursuit MF')

standardAx(ax_mfburst_input);
ax_mfburst_input.XRuler.Visible = 'off';
ax_mfburst_input.YRuler.Visible = 'off';
% add_scale_bar(ax_mfburst_input,[1,50],scale_opts);

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
    curr_160_resp = curr_cell_data.freqs{2}{end};
    curr_160_resp = medfilt1(curr_160_resp,0.02*Fs);


    ax_pos_mf(2) = ax_pos_mf(2)-burst_p_height-height_space;
    ax_cells_mf{ii} = axes('Position', ax_pos_mf);
    plot((1:numel(curr_160_resp))/Fs,curr_160_resp,'k')
    axis tight
    standardAx(ax_cells_mf{ii});
    ax_cells_mf{ii}.Visible = 'off';
    % add_scale_bar(ax_cells_mf{ii},[1,10]);

    linkaxes([ax_cells_burst{ii}, ax_cells_mf{ii}],'y')
end

%%

%Panel for fast cell burst reponse
curr_cell_data = allData_invivo{3};
curr_freqs = curr_cell_data.freqs{1}(:,1:2);
fast_ylim = [0 200];

ax_pos_burst(2) = ax_pos_burst(2)-burst_p_height-height_space;
ax_fast_burst = axes('Position', ax_pos_burst);

hold on
if show_individual_traces
    for ii = 1:2
        plot(x_time',curr_freqs(:,ii),'Color',[0.7 0.7 0.7])
    end
end
plot(x_time,mean(curr_freqs,2),'k')
hold off
xlim([4.5 10])
ylim(fast_ylim);
t1 = text(ax_fast_burst,3.5, ax_fast_burst.YLim(2)/2,'Fast cell','Rotation',90,...
    'HorizontalAlignment','center');

standardAx(ax_fast_burst);
ax_fast_burst.Visible = 'off';
add_scale_bar(ax_fast_burst,[1,50],scale_opts);


%Panel for fast cell mf reponse
curr_160_resp = reshape(curr_cell_data.freqs{4},[600000,3]);

ax_pos_mf(2) = ax_pos_mf(2)-burst_p_height-height_space;
ax_fast_mf = axes('Position', ax_pos_mf);
hold on
if show_individual_traces
    for ii = 1:3
        plot(x_time',curr_160_resp(:,ii),'Color',[0.7 0.7 0.7])
    end
end
plot(x_time,mean(curr_160_resp,2),'k')
hold off
ylim(fast_ylim);
standardAx(ax_fast_mf);
ax_fast_mf.Visible = 'off';
add_scale_bar(ax_fast_mf,[1,50]);




%Panel for med cell burst reponse
curr_cell_data = allData_invivo{1};
curr_freqs = curr_cell_data.freqs{1}(:,1:2);
mid_ylim = [0 50];
mid_scale_bar = [1 20];

ax_pos_burst(2) = ax_pos_burst(2)-burst_p_height-height_space;
ax_mid_burst = axes('Position', ax_pos_burst);
hold on
if show_individual_traces
    for ii = 1:2
        plot(x_time',curr_freqs(:,ii),'Color',[0.7 0.7 0.7])
    end
end
plot(x_time,mean(curr_freqs,2),'k')
hold off
xlim([4.5 10])
ylim(mid_ylim);
t1 = text(ax_mid_burst,3.5, ax_mid_burst.YLim(2)/2,'Slow cell','Rotation',90,...
    'HorizontalAlignment','center');


standardAx(ax_mid_burst);
ax_mid_burst.Visible = 'off';
add_scale_bar(ax_mid_burst,mid_scale_bar,scale_opts);


%Panel for fast cell mf reponse
curr_160_resp = reshape(curr_cell_data.freqs{4},[600000,3]);

ax_pos_mf(2) = ax_pos_mf(2)-burst_p_height-height_space;
ax_mid_mf = axes('Position', ax_pos_mf);
hold on
if show_individual_traces
    for ii = 1:3
        plot(x_time',curr_160_resp(:,ii),'Color',[0.7 0.7 0.7])
    end
end
plot(x_time,mean(curr_160_resp,2),'k')
hold off
ylim(mid_ylim);
standardAx(ax_mid_mf);
ax_mid_mf.Visible = 'off';
add_scale_bar(ax_mid_mf,mid_scale_bar);




%Panel for off cell burst reponse
curr_cell_data = allData_invivo{2};
curr_freqs = curr_cell_data.freqs{1}(:,1:2);
off_ylim = [0 50];
off_scale_bar = [1 10];

ax_pos_burst(2) = ax_pos_burst(2)-burst_p_height-height_space;
ax_off_burst = axes('Position', ax_pos_burst);
hold on
if show_individual_traces
    for ii = 1:2
        plot(x_time',curr_freqs(:,ii),'Color',[0.7 0.7 0.7])
    end
end
plot(x_time,mean(curr_freqs,2),'k')
hold off
xlim([4.5 10])
ylim(off_ylim);
t1 = text(ax_off_burst,3.5, ax_off_burst.YLim(2)/2,'OFF cell','Rotation',90,...
    'HorizontalAlignment','center');

standardAx(ax_off_burst);
ax_off_burst.Visible = 'off';
scale_opts.origin = [8.8 8];
add_scale_bar(ax_off_burst,off_scale_bar,scale_opts);


%Panel for off cell mf reponse
curr_160_resp = reshape(curr_cell_data.freqs{4},[600000,3]);

ax_pos_mf(2) = ax_pos_mf(2)-burst_p_height-height_space;
ax_off_mf = axes('Position', ax_pos_mf);
hold on
if show_individual_traces
    for ii = 1:3
        plot(x_time',curr_160_resp(:,ii),'Color',[0.7 0.7 0.7])
    end
end
plot(x_time,mean(curr_160_resp,2),'k')
hold off
ylim(off_ylim);
standardAx(ax_off_mf);
ax_off_mf.Visible = 'off';
scale_opts = struct();
scale_opts.origin = [27 8];
add_scale_bar(ax_off_mf,off_scale_bar,scale_opts);