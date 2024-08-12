%% In vivo like inputs
%Set up path
addpath(genpath('functions'))
addpath(genpath('plot_MF_invivo_scripts'))

%% Load cells
Fs = 20000;

% fileNames_invivo = dir('data_raw\MF_stim\saved\*');
% fileNames_invivo = fileNames_invivo(contains({fileNames_invivo(:).name},'.mat'));
% 
% fileNames_invivo2 = dir('data_analyzed\MF_stim_fastshutdown\*');
% fileNames_invivo2 = fileNames_invivo2(contains({fileNames_invivo2(:).name},'.mat'));
% 
% fileNames_invivo = [fileNames_invivo; fileNames_invivo2];

fileNames_invivo = dir('data_analyzed\MF_stim_invivo_all\*');
fileNames_invivo = fileNames_invivo(contains({fileNames_invivo(:).name},'.mat'));


badCellNames = {'Cell1848_analyzed.mat'};
removeCells = find(cellfun(@(x) ismember(x,badCellNames),{fileNames_invivo(:).name}));



if ~isempty(removeCells)
    fileNames_invivo(removeCells) = [];
end


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


%% Get all median stats

all_HD_invivo = cellfun(@(x) x.medianStats.HD,allData_invivo);
all_pause_invivo = cellfun(@(x) x.medianStats.pause,allData_invivo);
all_Amp_invivo = cellfun(@(x) x.medianStats.Amp,allData_invivo);
all_baseline_invivo = cellfun(@(x) x.medianStats.baseline,allData_invivo);

%{
figure;
plot(1:numel(all_HD),sort(all_HD),'ko')
set(gca,'YScale','log');

%}

%% Get sorting index
%Select Pure OFF by Amp
OFFidx_invivo = find(all_Amp_invivo<8);
%Add manually
OFFnames = {};
cellIdx = find(cellfun(@(x) contains(x,OFFnames),{fileNames_invivo.name}));
OFFidx_invivo = [OFFidx_invivo,cellIdx];
%Remove manually
OFFnames = {'Cell1839'};
cellIdx = find(cellfun(@(x) contains(x,OFFnames),{fileNames_invivo.name}));
OFFidx_invivo(ismember(OFFidx_invivo,cellIdx)) = [];



%Sort non OFF by HD or fit width
% [~,ONidx] = sort(mHD2);
[~,ONidx_invivo] = sort(all_HD_invivo);
ONidx_invivo = ONidx_invivo(:)';
ONidx_invivo = [ONidx_invivo(~ismember(ONidx_invivo,OFFidx_invivo)) ONidx_invivo(ismember(ONidx_invivo,OFFidx_invivo))];

%Sort OFFs by pause
[~, OFFsort] = sort(all_pause_invivo(ONidx_invivo(end-numel(OFFidx_invivo)+1:end)));
ONidx_invivo(end-numel(OFFidx_invivo)+1:end) = ONidx_invivo(OFFsort+(numel(ONidx_invivo)-numel(OFFidx_invivo)));
OFFidx_invivo = ONidx_invivo(end-numel(OFFidx_invivo)+1:end);
%Remove bad cells
% badCells = [120    40    14    49   31];
% ONidx(ismember(ONidx,badCells)) = [];
%}


%% Gather all smooth pursuit and burst data
washin = [1 0 0 0 0];

file_match = 'IVburst';
[all_raw_IVburst] = get_mean_by_filecode(...
    allData_invivo,file_match,washin);

file_match = 'MF20_94';
[all_raw_IVburst2] = get_mean_by_filecode(...
    allData_invivo,file_match,washin);

old_idx = ~cellfun(@isempty,all_raw_IVburst2);
all_raw_IVburst(old_idx) = all_raw_IVburst2(old_idx);


file_match = 'SPpref';
[all_raw_IVSP] = get_mean_by_filecode(...
    allData_invivo,file_match,washin);

file_match = 'MF5_39';
[all_raw_IVSP2] = get_mean_by_filecode(...
    allData_invivo,file_match,washin);

old_idx = ~cellfun(@isempty,all_raw_IVSP2);
all_raw_IVSP(old_idx) = all_raw_IVSP2(old_idx);

%% Get mean traces
all_mean_IVburst = cell(size(all_raw_IVburst));
all_mean_IVSP = all_mean_IVburst;

all_full_IVburst = all_mean_IVburst;
all_full_IVSP = all_mean_IVburst;

for ii = 1:numel(all_raw_IVburst)
    curr_burst = all_raw_IVburst{ii};
    curr_SP    = all_raw_IVSP{ii};

    curr_length = numel(curr_burst);

    if curr_length == 1800003
        curr_burst_resps = reshape(curr_burst,[600001,3]);
        curr_SP_resps    = reshape(curr_SP,[600001,3]);
    elseif curr_length == 1200002
        curr_burst_resps = reshape(curr_burst,[600001,2]);
        curr_SP_resps    = reshape(curr_SP,[600001,2]);
    elseif curr_length == 3200003
        curr_burst(1:5*Fs) = []; %Cut off front bit
        curr_burst_resps = reshape(curr_burst(1:(600001*5)),[600001,5]);
        curr_burst_resps = curr_burst_resps(:,1:2:5);

        curr_SP(1:5*Fs) = []; %Cut off front bit
        curr_SP_resps = reshape(curr_SP(1:(600001*5)),[600001,5]);
        curr_SP_resps = curr_SP_resps(:,1:2:5);
    end
    
    all_full_IVburst{ii} = curr_burst_resps;
    all_full_IVSP{ii}    = curr_SP_resps;
    all_mean_IVburst{ii} = mean(curr_burst_resps,2);
    all_mean_IVSP{ii}    = mean(curr_SP_resps,2);

    all_mean_IVburst{ii} = all_mean_IVburst{ii}(1:600000);
    all_mean_IVSP{ii} = all_mean_IVSP{ii}(1:600000);
end


%% Figure with burst

f_mf_burst = figure('Position', [488 1.8000 680.3150 857.9636],...
    'Color','w');

show_individual_traces = true;
median_fltr = false;
% input_color = [0.1608    0.1608    0.7294];
input_color = [0.2 0.7 0.2];

plot_burst_traces_panel

plot_invivoSP_traces_panel

% plot_invivo_heatmap_panel

%Tweak figure
fig_opts = struct();
fig_opts.FontSize = 10;
standardFig(f_mf_burst,fig_opts);


%Add labels
plot_labels = repmat({[]},1,17);
plot_labels{1} = 'c';
plot_labels{2} = 'd';
plot_labels{11} = 'e';
[f_mf_burst,t_labels] = labelPlots(f_mf_burst,plot_labels);

t_labels{1}.Position(1) = -36;
t_labels{3}.Position(1) = -36;
t_labels{2}.Position(1) = -11;

% exportgraphics(f_mf_burst,'pdf\240730_fig1.pdf','ContentType','vector')

%% other figures

plot_new_invivoSP_traces_figure

plot_new_T160_traces_figure

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