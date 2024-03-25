% show_individual_traces = true;
% f_mf_burst = figure('Position', [488 1.8000 680.3150 857.9636],...
%     'Color','w');

% left_edge = 0.13;
top_edge = 0.56;

left_edge_mf = 0.13;

% burst_p_width = 0.1425;
burst_p_height = 0.08;
mf_p_width = 0.8;
height_space = 0.01;




% Panel for MF input
x_time = (1:30*Fs)/Fs;
ax_pos_mf = [left_edge_mf top_edge-burst_p_height mf_p_width burst_p_height];
ax_mfburst_input = axes('Position', ax_pos_mf);
plot(x_time,time2rate(round(prot_timings{1}*20),Fs,30),'k')
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
scale_opts.ylabel = 'Hz';
add_scale_bar(ax_mfburst_input,[1,50],scale_opts);



% Panel for fast cell burst reponse
curr_cell_data = allData_invivo{10};
fast_ylim = [0 200];

%Panel for fast cell mf reponse
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
        plot(x_time',curr_mf_resp(:,ii),'Color',[0.7 0.7 0.7])
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


t1 = text(ax_fast_mf,-1, ax_fast_mf.YLim(2)/2,'Fast cell','Rotation',90,...
    'HorizontalAlignment','center');


standardAx(ax_fast_mf);
ax_fast_mf.Visible = 'off';
add_scale_bar(ax_fast_mf,[1,50]);



%Panel for med cell burst reponse
curr_cell_data = allData_invivo{1};
curr_freqs = curr_cell_data.freqs{1}(:,1:2);
mid_ylim = [0 50];
mid_scale_bar = [1 20];

%Panel for fast cell mf reponse
curr_mf_resp = reshape(curr_cell_data.freqs{2},[600000,3]);

ax_pos_mf(2) = ax_pos_mf(2)-burst_p_height-height_space;
ax_mid_mf = axes('Position', ax_pos_mf);
hold on
if show_individual_traces
    for ii = 1:3
        plot(x_time',curr_mf_resp(:,ii),'Color',[0.7 0.7 0.7])
    end
end
y_data = mean(curr_mf_resp,2);
if median_fltr
    y_data = medfilt1(y_data,Fs*0.02);
end

plot((1:numel(y_data))/Fs,y_data,'k')
hold off
ylim(mid_ylim);

t1 = text(ax_mid_mf,-1, ax_mid_mf.YLim(2)/2,'Slow cell','Rotation',90,...
    'HorizontalAlignment','center');

standardAx(ax_mid_mf);
ax_mid_mf.Visible = 'off';
add_scale_bar(ax_mid_mf,mid_scale_bar);




%Panel for off cell burst reponse
curr_cell_data = allData_invivo{2};
curr_freqs = curr_cell_data.freqs{1}(:,1:2);
off_ylim = [0 50];
off_scale_bar = [1 10];


%Panel for off cell mf reponse
curr_mf_resp = reshape(curr_cell_data.freqs{2},[600000,3]);

ax_pos_mf(2) = ax_pos_mf(2)-burst_p_height-height_space;
ax_off_mf = axes('Position', ax_pos_mf);
hold on
if show_individual_traces
    for ii = 1:3
        plot(x_time',curr_mf_resp(:,ii),'Color',[0.7 0.7 0.7])
    end
end
y_data = mean(curr_mf_resp,2);
if median_fltr
    y_data = medfilt1(y_data,Fs*0.02);
end

plot((1:numel(y_data))/Fs,y_data,'k')
hold off
ylim(off_ylim);

t1 = text(ax_off_mf,-1, ax_off_mf.YLim(2)/2,'OFF cell','Rotation',90,...
    'HorizontalAlignment','center');

standardAx(ax_off_mf);
ax_off_mf.Visible = 'off';
% scale_opts = struct();
% scale_opts.origin = [27 8];
add_scale_bar(ax_off_mf,off_scale_bar);