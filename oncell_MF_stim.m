%% Prepare variables and get file list
try
    close(ftrace);
catch
end
try
    close(fpeak);
catch
end

vars = {'Amp';'Fs';'HD';'OFF';'OFFidx';'OFFsort';'ONidx';'Spk';'T';...
    'TickMarksX';'TicksX';'allData';'ans';'ax1';'ax2';'ax3';'ax4';'ax5';...
    'ax6';'baseRange';'baseline';'cc';'cellRange';'currCell';'data';...
    'endP';'endPoint';'endT';'expTime';'fig1';'fileNames';'firstCell';...
    'firstHalf';'firstHalf_OFF';'fpeak';'freqs';'ftrace';'i';'idx';'ii';...
    'lastCell';'lastHalf';'lastHalf_OFF';'limY';'logEnd';'logFreqs';...
    'logMarks';'logStart';'logTime';'mAmp';'mBaseline';'mFreqs';...
    'mFreqs_norm';'mHD';'mPause';'maxX';'numPoints';'pausePos';'pid';...
    'pv';'rangeT';'rangeT2';'sPause';'smoothFreqs';'sortIdx';'spks';...
    'startP';'startPoint';'startT';'stimDur';'stimEnd';'traces';'typCell';...
    'vars';'xTime';'xq'};
clear(vars{:});

fclose all;

%Sampling rate
Fs = 20000;

%Spikes
spks = {};
traces = [];
freqs = [];
Spk = {};
sPause = {};
HD = {};
Amp = {};
baseline = {};
%%
%Files
fileNames = dir('MF_stim\*');
[~,sortIdx]=sort([fileNames.datenum]);
fileNames = fileNames(sortIdx);

%Get unique cells
allCellNames = {fileNames(:).name};
allCellNames = allCellNames(1:end-1);

allCellNames = regexp(allCellNames,'Cell\d\d\d\d','match');
allCellNames = unique([allCellNames{:}]);
allCellNames = allCellNames(:);

%% Read protocols
fileProtocols = dir('MF_stim\protocols\*');
[~,sortIdx]=sort([fileProtocols.datenum]);
fileProtocols = fileProtocols(sortIdx);

allProtNames = {fileProtocols(:).name};
allProtNames = allProtNames(endsWith(allProtNames, '.txt'));

prot_timings = cellfun(@(x) {csvread(fullfile(fileProtocols(1).folder,x))},...
                    allProtNames);

%% Count spikes at indicated cell
currCell = 'Cell1561';
all_file_names = {fileNames.name};
idx = find(~cellfun(@isempty,strfind(all_file_names,currCell)));
curr_file_names = all_file_names(idx);

%Separate protocols
prot_file_names = {};
prot_file_names{1} = curr_file_names(contains(curr_file_names,'100Hz'));
%use same order as protnames
prot_file_names{2} = curr_file_names(contains(curr_file_names,'MF5_39'));
prot_file_names{3} = curr_file_names(contains(curr_file_names,'MF5_65'));
prot_file_names{4} = curr_file_names(contains(curr_file_names,'MF20_94'));

T = 30;
startP = 5;
stimDur = 0.201;
endP = 20;
rangeT2 = round((startP+stimDur)*Fs:endP*Fs);
freqs = [];
spks = [];
traces = [];
Spk = [];
sPause = [];

minPeak = 60;
maxPeak = 1000;

ftrace = figure;

for pp = 1:numel(prot_file_names)
    
    if pp == 1 %100Hz use old code
        T = 30;
        blankPeriod = round(5*Fs):round(5.0025*Fs);
        blankAdd = round(0.01*Fs);
        blankAll = blankPeriod;
        for ii = 1:19
            blankAll = [blankAll, blankPeriod+blankAdd*ii];
        end
    else %Use real timings and multipli
        T = 90;
        blankAll = [];
        curr_prot_timings = prot_timings{pp-1};
        curr_prot_timings = curr_prot_timings/1000;
        curr_prot_timings = [curr_prot_timings, curr_prot_timings+30, curr_prot_timings+60];
        for ii = 1:numel(curr_prot_timings)
            curr_timing = curr_prot_timings(ii);
            blankAll = [blankAll, round(curr_timing*Fs):round((curr_timing+0.0025)*Fs)];
        end
        
    end
    
    for ii = 1:numel(prot_file_names{pp})
        
        data = IBWread(fullfile(fileNames(1).folder,prot_file_names{pp}{ii}));
        [pv, pid] = findpeaks(-data.y(1:Fs*T),...
            'MinPeakProminence',minPeak,...'MinPeakHeight',20,...
            'MinPeakDistance',Fs/500,'MinPeakWidth',1);
        [pid,pid_fltr] = down_then_up(data.y(1:Fs*T),pid);
        pv = pv(pid_fltr);
        
        pid = pid(pv<maxPeak);  pv = pv(pv<maxPeak);
        badPID = ismember(pid, blankAll);
        pid = pid(~badPID);  pv = pv(~badPID);
        
        
        freqs{pp}(:,ii) = time2rate(pid,Fs,T);
        spks{pp}{ii} = pid*(T*Fs);
        traces{pp}(:,ii) = data.y(1:Fs*T);
        
        Spk{pp}(ii) = sum(pid>startP*Fs & pid<endP*Fs);
        pausePos = find(pid>(startP+stimDur)*Fs, 1, 'first');
        if ~isempty(pausePos)
            sPause{pp}(ii) = pid(pausePos)/Fs-(startP+stimDur);
        else
            sPause{pp}(ii) = NaN;
        end
        
        plot(-data.y(1:Fs*T))
        hold on; plot(pid,pv,'.');
        xlim([Fs*3 Fs*endP])
        limY = [min(-data.y(rangeT2)) max(-data.y(rangeT2))];
        limY = limY + [-diff(limY)*0.05 diff(limY)*0.05];
        ylim(limY)
        title(num2str(ii))
        hold off
        pause
        
    end
end
close(ftrace);
fclose all;

%% Save cell
cd('MF_stim\saved')
save([currCell,'_analyzed.mat'],'spks','traces','freqs','Spk','sPause')
cd('..')
cd('..')

%% Construct graph

figure('Color','w','Position', [101 125 1231 414])

xtime = 1/Fs:1/Fs:30;

ax1 = subplot(2,1,1);

%UBC baseline

hold on
for ii = 1:2
    plot(xtime',freqs{1}(:,ii),'Color',[0.7 0.7 0.7])
end
plot(xtime,mean(freqs{1}(:,1:2),2),'k')
hold off
title('UBC baseline')
ylabel('Frequency (Hz)');

ax2 = subplot(2,1,2);

%UBC post MF
hold on
for ii = 3:4
    plot(xtime',freqs{1}(:,ii),'Color',[0.7 0.7 0.7])
end
plot(xtime,mean(freqs{1}(:,3:4),2),'k')
hold off
title('UBC post-MF')
ylabel('Frequency (Hz)');
xlabel('Time (s)');

linkaxes([ax1 , ax2],'xy')
ylim([0 150])
standardFig();

%%
figure('Color','w','Position', [101 125 1231 414])

xtime = 1/Fs:1/Fs:30;

ax1 = subplot(2,1,1);
%MF input, prefered direction
plot(xtime,time2rate(round(prot_timings{1}*20),Fs,30),'k')
title('MF input (pref. direction)')
ylabel('Frequency (Hz)');

%UBC response, prefered direction
ax2 = subplot(2,1,2);
curr_mf_resp = reshape(freqs{2},[600000,3]);
hold on
for ii = 1:3
    plot(xtime',curr_mf_resp(:,ii),'Color',[0.7 0.7 0.7])
end
plot(xtime,mean(curr_mf_resp,2),'k')
hold off
title('UBC response (pref. direction)')
ylabel('Frequency (Hz)');
xlabel('Time (s)');
ylim([0 150])
linkaxes([ax1 , ax2],'x')

standardFig();

%%
figure('Color','w','Position', [101 125 1231 414])

xtime = 1/Fs:1/Fs:30;

%MF input, non-prefered direction
ax1 = subplot(2,1,1);
plot(xtime,time2rate(round(prot_timings{2}*20),Fs,30),'k')
title('MF input (non-pref. direction)')
ylabel('Frequency (Hz)');

%UBC response, non-prefered direction
ax2 = subplot(2,1,2);
curr_mf_resp = reshape(freqs{3},[600000,3]);
hold on
for ii = 1:3
    plot(xtime',curr_mf_resp(:,ii),'Color',[0.7 0.7 0.7])
end
plot(xtime,mean(curr_mf_resp,2),'k')
hold off
title('UBC response (non-pref. direction)')
ylabel('Frequency (Hz)');
xlabel('Time (s)');
ylim([0 150])
linkaxes([ax1 , ax2],'x')
standardFig();
%%
figure('Color','w','Position', [101 125 1231 414])

xtime = 1/Fs:1/Fs:30;

%MF input, bursts
ax1 = subplot(2,1,1);
plot(xtime,time2rate(round(prot_timings{3}*20),Fs,30),'k')
title('MF input (bursts)')
ylabel('Frequency (Hz)');

%UBC response, non-prefered direction
ax2 = subplot(2,1,2);
curr_mf_resp = reshape(freqs{4},[600000,3]);
hold on
for ii = 1:3
    plot(xtime',curr_mf_resp(:,ii),'Color',[0.7 0.7 0.7])
end
plot(xtime,mean(curr_mf_resp,2),'k')
hold off
title('UBC response (bursts)')
ylabel('Frequency (Hz)');
xlabel('Time (s)');
ylim([0 150])
linkaxes([ax1 , ax2],'x')
standardFig();


%% Overview stuff
%% Load cells
Fs = 20000;

fileNames = dir('MF_stim\saved\*');
fileNames = fileNames(contains({fileNames(:).name},'.mat'));


allData = cell(size(fileNames));

for ii = 1:numel(fileNames)
    allData{ii} = load(fullfile(fileNames(ii).folder,fileNames(ii).name));    
end

%% Read protocols
fileProtocols = dir('MF_stim\protocols\*');
[~,sortIdx]=sort([fileProtocols.datenum]);
fileProtocols = fileProtocols(sortIdx);

allProtNames = {fileProtocols(:).name};
allProtNames = allProtNames(endsWith(allProtNames, '.txt'));

prot_timings = cellfun(@(x) {csvread(fullfile(fileProtocols(1).folder,x))},...
                    allProtNames);


%% Figure with burst

f_mf_burst = figure('Color','w','Position', [156.3455 1.8727 970.4727 857.8909]);

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
add_scale_bar(ax_burst_input,[1,50],scale_opts);


% Panel for MF input
ax_pos_mf = [left_edge_mf top_edge-burst_p_height mf_p_width burst_p_height];
ax_mfburst_input = axes('Position', ax_pos_mf);
plot(x_time,time2rate(round(prot_timings{3}*20),Fs,30),'k')
title('In vivo bursting MF')

standardAx(ax_mfburst_input);
ax_mfburst_input.XRuler.Visible = 'off';
ax_mfburst_input.YRuler.Visible = 'off';
add_scale_bar(ax_mfburst_input,[1,250],scale_opts);



%Panel for fast cell burst reponse
curr_cell_data = allData{3};
curr_freqs = curr_cell_data.freqs{1}(:,1:2);
fast_ylim = [0 200];

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
curr_mf_resp = reshape(curr_cell_data.freqs{4},[600000,3]);

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
curr_cell_data = allData{1};
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
curr_mf_resp = reshape(curr_cell_data.freqs{4},[600000,3]);

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
curr_cell_data = allData{2};
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
curr_mf_resp = reshape(curr_cell_data.freqs{4},[600000,3]);

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
scale_opts = struct();
scale_opts.origin = [27 8];
add_scale_bar(ax_off_mf,off_scale_bar,scale_opts);


%% Figure with MF (burst) just 1 cell

mf_idx = 4;

%Anonymous function to get some baseline
get_last_from_prev = @(x) x.freqs{mf_idx-1}(end-Fs:end,1);

curr_cell_data = allData{1};
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
curr_cell_data = allData{2};
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
curr_cell_data = allData{3};
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
curr_cell_data = allData{1};
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
curr_cell_data = allData{2};
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
curr_cell_data = allData{3};
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
curr_cell_data = allData{1};
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
curr_cell_data = allData{2};
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