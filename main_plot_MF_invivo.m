%% In vivo like inputs
%Set up path
mfile_name          = mfilename('fullpath');
[pathstr,name,ext]  = fileparts(mfile_name);
cd(pathstr);

addpath(genpath('functions'))
addpath(genpath('plot_MF_invivo_scripts'))

%% Load cells
Fs = 20000;

fileNames_invivo = dir('data_raw\MF_stim\saved\*');
fileNames_invivo = fileNames_invivo(contains({fileNames_invivo(:).name},'.mat'));


allData_invivo = cell(size(fileNames_invivo));

for ii = 1:numel(fileNames_invivo)
    allData_invivo{ii} = load(fullfile(fileNames_invivo(ii).folder,fileNames_invivo(ii).name));    
end

%% Read protocols
fileProtocols = dir('data_raw\MF_stim\protocols\*');
[~,sortIdx]=sort([fileProtocols.datenum]);
fileProtocols = fileProtocols(sortIdx);

allProtNames = {fileProtocols(:).name};
allProtNames = allProtNames(endsWith(allProtNames, '.txt'));

prot_timings = cellfun(@(x) {csvread(fullfile(fileProtocols(1).folder,x))},...
                    allProtNames);


%% Figure with burst

f_mf_burst = figure('Position', [488 1.8000 680.3150 857.9636],...
    'Color','w');

plot_burst_traces_panel

plot_invivoSP_traces_panel

%Tweak figure
fig_opts = struct();
fig_opts.FontSize = 10;
standardFig(f_mf_burst,fig_opts);


%Add labels
plot_labels = repmat({[]},1,17);
plot_labels{1} = 'a';
plot_labels{2} = 'b';
plot_labels{9} = 'c';
labelPlots(f_mf_burst,plot_labels);


%% Figure with MF (burst) just 1 cell

mf_idx = 4;

%Anonymous function to get some baseline
get_last_from_prev = @(x) x.freqs{mf_idx-1}(end-Fs:end,1);

curr_cell_data = allData_invivo{1};
% cell_label ='Fast cell';
cell_label ='Slow cell';
% fast_ylim = [0 150];
fast_ylim = [0 50];
fast_scale_bar = [1 20];



f_mf_SP = figure('Color','w','Position', [156.3455 1.8727 970.4727 857.8909]);

left_edge = 0.13;
top_edge = 0.95;

left_edge_mf = 0.3;

burst_p_width = 0.1425;
burst_p_height = 0.1078;
mf_p_width = 0.6;
height_space = 0.03;

% Panel for burst input
ax_pos_burst = [left_edge top_edge-burst_p_height burst_p_width burst_p_height];
ax_burst_input = axes('Position', ax_pos_burst);
x_time = (1:30*Fs)/Fs;
x_time2 = (0:31*Fs)/Fs;
dummy_y = zeros(size(x_time));
dummy_y(5*Fs:5.2*Fs) = 100;
plot(x_time,dummy_y,'k')
xlim([4.5 10])
ylim([0 110])
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
add_scale_bar(ax_burst_input,[1,50],scale_opts);


% Panel for MF input
ax_pos_mf = [left_edge_mf top_edge-burst_p_height mf_p_width burst_p_height];
ax_mfburst_input = axes('Position', ax_pos_mf);
plot(x_time2,time2rate(round((prot_timings{3}+1000)*20),Fs,31+1/Fs),'k')
ylim([0 110])
title('In vivo smooth pursuit MF')

standardAx(ax_mfburst_input);
ax_mfburst_input.XRuler.Visible = 'off';
ax_mfburst_input.YRuler.Visible = 'off';
add_scale_bar(ax_mfburst_input,[1,50],scale_opts);



%Panel for fast cell burst reponse
curr_freqs = curr_cell_data.freqs{1}(:,1:2);

ax_pos_burst(2) = ax_pos_burst(2)-burst_p_height-height_space;
ax_fast_burst = axes('Position', ax_pos_burst);
hold on
for ii = 1:2
    plot(x_time',curr_freqs(:,ii),'Color',[0.7 0.7 0.7])
end

plot(x_time,mean(curr_freqs,2),'k')
hold off
xlim([4.5 10])
ylim(fast_ylim);
t1 = text(ax_fast_burst,3.5, ax_fast_burst.YLim(2)/2,cell_label,'Rotation',90,...
    'HorizontalAlignment','center');

standardAx(ax_fast_burst);
ax_fast_burst.Visible = 'off';
add_scale_bar(ax_fast_burst,fast_scale_bar,scale_opts);


%Panel for fast cell mf reponse
curr_mf_base = get_last_from_prev(curr_cell_data);

curr_mf_resp = curr_cell_data.freqs{mf_idx}(1:600000);


%Concatenate and fill zeros
[full_mf_resp] = concat_inst_freqs({curr_mf_resp'},...
    {curr_mf_base'},Fs);

ax_pos_mf(2) = ax_pos_mf(2)-burst_p_height-height_space;
ax_fast_mf = axes('Position', ax_pos_mf);

plot(x_time2,full_mf_resp{1},'k')

ylim(fast_ylim);
standardAx(ax_fast_mf);
ax_fast_mf.Visible = 'off';
add_scale_bar(ax_fast_mf,fast_scale_bar);



%Panel for mid cell mf reponse
curr_mf_base = curr_cell_data.freqs{mf_idx}(600000-Fs:600000);

curr_mf_resp = curr_cell_data.freqs{mf_idx}(600001:1200000);

curr_mf_base(:) = NaN;
full_mf_resp = {[curr_mf_base;curr_mf_resp]};
%Concatenate and fill zeros
% [full_mf_resp] = concat_inst_freqs({curr_mf_resp'},...
%     {curr_mf_base'},Fs);

ax_pos_mf(2) = ax_pos_mf(2)-burst_p_height-height_space;
ax_mid_mf = axes('Position', ax_pos_mf);

plot(x_time2,full_mf_resp{1},'k')

ylim(fast_ylim);
standardAx(ax_mid_mf);
ax_mid_mf.Visible = 'off';
add_scale_bar(ax_mid_mf,fast_scale_bar);



%Panel for off cell mf reponse
curr_mf_base = curr_cell_data.freqs{mf_idx}(1200000-Fs:1200000);

curr_mf_resp = curr_cell_data.freqs{mf_idx}(1200001:1800000);

curr_mf_base(:) = NaN;
full_mf_resp = {[curr_mf_base;curr_mf_resp]};
%Concatenate and fill zeros
% [full_mf_resp] = concat_inst_freqs({curr_mf_resp'},...
%     {curr_mf_base'},Fs);

ax_pos_mf(2) = ax_pos_mf(2)-burst_p_height-height_space;
ax_off_mf = axes('Position', ax_pos_mf);

plot(x_time2,full_mf_resp{1},'k')

ylim(fast_ylim);
standardAx(ax_off_mf);
ax_off_mf.Visible = 'off';
% scale_opts = struct();
% scale_opts.origin = [27 8];
add_scale_bar(ax_off_mf,fast_scale_bar);





%% Figure with MF (pref dir) just fast cell

%Anonymous function to get some baseline
get_last_from_prev = @(x) x.freqs{1}(end-Fs:end,2);



f_mf_SP = figure('Color','w','Position', [156.3455 1.8727 970.4727 857.8909]);

left_edge = 0.13;
top_edge = 0.95;

left_edge_mf = 0.3;

burst_p_width = 0.1425;
burst_p_height = 0.1078;
mf_p_width = 0.6;
height_space = 0.03;

% Panel for burst input
ax_pos_burst = [left_edge top_edge-burst_p_height burst_p_width burst_p_height];
ax_burst_input = axes('Position', ax_pos_burst);
x_time = (1:30*Fs)/Fs;
x_time2 = (0:31*Fs)/Fs;
dummy_y = zeros(size(x_time));
dummy_y(5*Fs:5.2*Fs) = 100;
plot(x_time,dummy_y,'k')
xlim([4.5 10])
ylim([0 110])
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
add_scale_bar(ax_burst_input,[1,50],scale_opts);


% Panel for MF input
ax_pos_mf = [left_edge_mf top_edge-burst_p_height mf_p_width burst_p_height];
ax_mfburst_input = axes('Position', ax_pos_mf);
plot(x_time2,time2rate(round((prot_timings{1}+1000)*20),Fs,31+1/Fs),'k')
ylim([0 110])
title('In vivo smooth pursuit MF')

standardAx(ax_mfburst_input);
ax_mfburst_input.XRuler.Visible = 'off';
ax_mfburst_input.YRuler.Visible = 'off';
add_scale_bar(ax_mfburst_input,[1,50],scale_opts);



%Panel for fast cell burst reponse
curr_cell_data = allData_invivo{2};
curr_freqs = curr_cell_data.freqs{1}(:,1:2);
% fast_ylim = [0 150];
fast_ylim = [0 50];
fast_scale_bar = [1 10];

ax_pos_burst(2) = ax_pos_burst(2)-burst_p_height-height_space;
ax_fast_burst = axes('Position', ax_pos_burst);
hold on
for ii = 1:2
    plot(x_time',curr_freqs(:,ii),'Color',[0.7 0.7 0.7])
end

plot(x_time,mean(curr_freqs,2),'k')
hold off
xlim([4.5 10])
ylim(fast_ylim);
t1 = text(ax_fast_burst,3.5, ax_fast_burst.YLim(2)/2,'OFF cell','Rotation',90,...
    'HorizontalAlignment','center');

standardAx(ax_fast_burst);
ax_fast_burst.Visible = 'off';
add_scale_bar(ax_fast_burst,fast_scale_bar,scale_opts);


%Panel for fast cell mf reponse
curr_mf_base = get_last_from_prev(curr_cell_data);

curr_mf_resp = curr_cell_data.freqs{2}(1:600000);


%Concatenate and fill zeros
[full_mf_resp] = concat_inst_freqs({curr_mf_resp'},...
    {curr_mf_base'},Fs);

ax_pos_mf(2) = ax_pos_mf(2)-burst_p_height-height_space;
ax_fast_mf = axes('Position', ax_pos_mf);

plot(x_time2,full_mf_resp{1},'k')

ylim(fast_ylim);
standardAx(ax_fast_mf);
ax_fast_mf.Visible = 'off';
add_scale_bar(ax_fast_mf,fast_scale_bar);



%Panel for mid cell mf reponse
curr_mf_base = curr_cell_data.freqs{2}(600000-Fs:600000);

curr_mf_resp = curr_cell_data.freqs{2}(600001:1200000);

curr_mf_base(:) = NaN;
full_mf_resp = {[curr_mf_base;curr_mf_resp]};
%Concatenate and fill zeros
% [full_mf_resp] = concat_inst_freqs({curr_mf_resp'},...
%     {curr_mf_base'},Fs);

ax_pos_mf(2) = ax_pos_mf(2)-burst_p_height-height_space;
ax_mid_mf = axes('Position', ax_pos_mf);

plot(x_time2,full_mf_resp{1},'k')

ylim(fast_ylim);
standardAx(ax_mid_mf);
ax_mid_mf.Visible = 'off';
add_scale_bar(ax_mid_mf,fast_scale_bar);



%Panel for off cell mf reponse
curr_mf_base = curr_cell_data.freqs{2}(1200000-Fs:1200000);

curr_mf_resp = curr_cell_data.freqs{2}(1200001:1800000);

curr_mf_base(:) = NaN;
full_mf_resp = {[curr_mf_base;curr_mf_resp]};
%Concatenate and fill zeros
% [full_mf_resp] = concat_inst_freqs({curr_mf_resp'},...
%     {curr_mf_base'},Fs);

ax_pos_mf(2) = ax_pos_mf(2)-burst_p_height-height_space;
ax_off_mf = axes('Position', ax_pos_mf);

plot(x_time2,full_mf_resp{1},'k')

ylim(fast_ylim);
standardAx(ax_off_mf);
ax_off_mf.Visible = 'off';
% scale_opts = struct();
% scale_opts.origin = [27 8];
add_scale_bar(ax_off_mf,fast_scale_bar);





%% Figure with MF (pref dir) just first 30

%Anonymous function to get some baseline
get_last_from_prev = @(x) x.freqs{1}(end-Fs:end,2);



f_mf_SP = figure('Color','w','Position', [156.3455 1.8727 970.4727 857.8909]);

left_edge = 0.13;
top_edge = 0.95;

left_edge_mf = 0.3;

burst_p_width = 0.1425;
burst_p_height = 0.1078;
mf_p_width = 0.6;
height_space = 0.03;

% Panel for burst input
ax_pos_burst = [left_edge top_edge-burst_p_height burst_p_width burst_p_height];
ax_burst_input = axes('Position', ax_pos_burst);
x_time = (1:30*Fs)/Fs;
x_time2 = (0:31*Fs)/Fs;
dummy_y = zeros(size(x_time));
dummy_y(5*Fs:5.2*Fs) = 100;
plot(x_time,dummy_y,'k')
xlim([4.5 10])
ylim([0 110])
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
add_scale_bar(ax_burst_input,[1,50],scale_opts);


% Panel for MF input
ax_pos_mf = [left_edge_mf top_edge-burst_p_height mf_p_width burst_p_height];
ax_mfburst_input = axes('Position', ax_pos_mf);
plot(x_time2,time2rate(round((prot_timings{1}+1000)*20),Fs,31+1/Fs),'k')
ylim([0 110])
title('In vivo smooth pursuit MF')

standardAx(ax_mfburst_input);
ax_mfburst_input.XRuler.Visible = 'off';
ax_mfburst_input.YRuler.Visible = 'off';
add_scale_bar(ax_mfburst_input,[1,50],scale_opts);



%Panel for fast cell burst reponse
curr_cell_data = allData_invivo{3};
curr_freqs = curr_cell_data.freqs{1}(:,1:2);
fast_ylim = [0 150];

ax_pos_burst(2) = ax_pos_burst(2)-burst_p_height-height_space;
ax_fast_burst = axes('Position', ax_pos_burst);
hold on
for ii = 1:2
    plot(x_time',curr_freqs(:,ii),'Color',[0.7 0.7 0.7])
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
curr_mf_base = get_last_from_prev(curr_cell_data);

curr_mf_resp = curr_cell_data.freqs{2}(1:600000);


%Concatenate and fill zeros
[full_mf_resp] = concat_inst_freqs({curr_mf_resp'},...
    {curr_mf_base'},Fs);

ax_pos_mf(2) = ax_pos_mf(2)-burst_p_height-height_space;
ax_fast_mf = axes('Position', ax_pos_mf);

plot(x_time2,full_mf_resp{1},'k')

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
for ii = 1:2
    plot(x_time',curr_freqs(:,ii),'Color',[0.7 0.7 0.7])
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


%Panel for mid cell mf reponse
curr_mf_base = get_last_from_prev(curr_cell_data);

curr_mf_resp = curr_cell_data.freqs{2}(1:600000);


%Concatenate and fill zeros
[full_mf_resp] = concat_inst_freqs({curr_mf_resp'},...
    {curr_mf_base'},Fs);

ax_pos_mf(2) = ax_pos_mf(2)-burst_p_height-height_space;
ax_mid_mf = axes('Position', ax_pos_mf);

plot(x_time2,full_mf_resp{1},'k')

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
for ii = 1:2
    plot(x_time',curr_freqs(:,ii),'Color',[0.7 0.7 0.7])
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
curr_mf_base = get_last_from_prev(curr_cell_data);

curr_mf_resp = curr_cell_data.freqs{2}(1:600000);


%Concatenate and fill zeros
[full_mf_resp] = concat_inst_freqs({curr_mf_resp'},...
    {curr_mf_base'},Fs);

ax_pos_mf(2) = ax_pos_mf(2)-burst_p_height-height_space;
ax_off_mf = axes('Position', ax_pos_mf);

plot(x_time2,full_mf_resp{1},'k')

ylim(off_ylim);
standardAx(ax_off_mf);
ax_off_mf.Visible = 'off';
% scale_opts = struct();
% scale_opts.origin = [27 8];
add_scale_bar(ax_off_mf,off_scale_bar);



%% Figure with MF (pref dir)

f_mf_SP = figure('Color','w','Position', [156.3455 1.8727 970.4727 857.8909]);

left_edge = 0.13;
top_edge = 0.95;

left_edge_mf = 0.3;

burst_p_width = 0.1425;
burst_p_height = 0.1078;
mf_p_width = 0.6;
height_space = 0.03;

% Panel for burst input
ax_pos_burst = [left_edge top_edge-burst_p_height burst_p_width burst_p_height];
ax_burst_input = axes('Position', ax_pos_burst);
x_time = (1:30*Fs)/Fs;
dummy_y = zeros(size(x_time));
dummy_y(5*Fs:5.2*Fs) = 100;
plot(x_time,dummy_y,'k')
xlim([4.5 10])
ylim([0 110])
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
add_scale_bar(ax_burst_input,[1,50],scale_opts);


% Panel for MF input
ax_pos_mf = [left_edge_mf top_edge-burst_p_height mf_p_width burst_p_height];
ax_mfburst_input = axes('Position', ax_pos_mf);
plot(x_time,time2rate(round(prot_timings{1}*20),Fs,30),'k')
ylim([0 110])
title('In vivo smooth pursuit MF')

standardAx(ax_mfburst_input);
ax_mfburst_input.XRuler.Visible = 'off';
ax_mfburst_input.YRuler.Visible = 'off';
add_scale_bar(ax_mfburst_input,[1,50],scale_opts);



%Panel for fast cell burst reponse
curr_cell_data = allData_invivo{3};
curr_freqs = curr_cell_data.freqs{1}(:,1:2);
fast_ylim = [0 150];

ax_pos_burst(2) = ax_pos_burst(2)-burst_p_height-height_space;
ax_fast_burst = axes('Position', ax_pos_burst);
hold on
for ii = 1:2
    plot(x_time',curr_freqs(:,ii),'Color',[0.7 0.7 0.7])
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
curr_mf_resp = reshape(curr_cell_data.freqs{2},[600000,3]);

ax_pos_mf(2) = ax_pos_mf(2)-burst_p_height-height_space;
ax_fast_mf = axes('Position', ax_pos_mf);
hold on
for ii = 1:3
    plot(x_time',curr_mf_resp(:,ii),'Color',[0.7 0.7 0.7])
end
plot(x_time,mean(curr_mf_resp,2),'k')
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
for ii = 1:2
    plot(x_time',curr_freqs(:,ii),'Color',[0.7 0.7 0.7])
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
curr_mf_resp = reshape(curr_cell_data.freqs{2},[600000,3]);

ax_pos_mf(2) = ax_pos_mf(2)-burst_p_height-height_space;
ax_mid_mf = axes('Position', ax_pos_mf);
hold on
for ii = 1:3
    plot(x_time',curr_mf_resp(:,ii),'Color',[0.7 0.7 0.7])
end
plot(x_time,mean(curr_mf_resp,2),'k')
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
for ii = 1:2
    plot(x_time',curr_freqs(:,ii),'Color',[0.7 0.7 0.7])
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
curr_mf_resp = reshape(curr_cell_data.freqs{2},[600000,3]);

ax_pos_mf(2) = ax_pos_mf(2)-burst_p_height-height_space;
ax_off_mf = axes('Position', ax_pos_mf);
hold on
for ii = 1:3
    plot(x_time',curr_mf_resp(:,ii),'Color',[0.7 0.7 0.7])
end
plot(x_time,mean(curr_mf_resp,2),'k')
hold off
ylim(off_ylim);
standardAx(ax_off_mf);
ax_off_mf.Visible = 'off';
% scale_opts = struct();
% scale_opts.origin = [27 8];
add_scale_bar(ax_off_mf,off_scale_bar);