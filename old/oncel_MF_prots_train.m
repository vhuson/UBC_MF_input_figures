%% 2nd step analysis
%Add washin information tied to filenames
%Add baseline median parameters

%Perform 2nd level analysis with parameter tuning
% Save both parameters and results
% Save analysis date

%Save separate experiment file listing cell names tagged with:
% 1) washin complete
% 2) baseline series complete
% 3) Stability check complete


%better single plots

%% Prepare variables and get file list
try
    close(ftrace);
catch
end
try
    close(fpeak);
catch
end

fclose all;

%Sampling rate
Fs = 20000;


%%
%Files
% fileNames = dir('MF_stim_prots_pharma\noWashin\*');
% fileNames = dir('MF_stim_trains\*');
fileNames = dir('MF_stim_trains_pharma\*');
[~,sortIdx]=sort([fileNames.datenum]);
fileNames = fileNames(sortIdx);

%Get unique cells
allCellNames = {fileNames(:).name};
allCellNames = allCellNames(1:end-1);

allCellNames = regexp(allCellNames,'Cell\d\d\d\d','match');
allCellNames = unique([allCellNames{:}]);
allCellNames = allCellNames(:);


%% Count spikes at indicated cell
currCell = 'Cell1782';
all_file_names = {fileNames.name};
idx = contains(all_file_names,currCell);
curr_file_names = all_file_names(idx);
% curr_file_names = curr_file_names(1:end-5);

%initialize result variables
freqs = {};
freqs_old = {};
spks = {};
traces = {};

freqs_prot = {};
spks_prot = {};
Spk = {};
sPause = {};

%% New detection method
%Separate protocols
prot_file_names = {};
prot_file_names{1} = curr_file_names(contains(curr_file_names,'100Hz'));
%use same order as protnames
prot_file_names{2} = curr_file_names(~contains(curr_file_names,'100Hz'));

prot_start = 1;
rec_start = 1;
p1_pause = true;
p2_pause = true;
plot_on = true;

%Base parameters
max_peak = 2000;
min_peak = 40;
cut_peak = 20;
min_width = 0.1e-3;


%100Hz basic pars
startP = 5;
stimDur = 0.201;
endP = 20;


%Replicate parameters for each recording
all_maxpeak = cell(2,1);
all_maxpeak{1} = repmat(max_peak,size(prot_file_names{1}));
all_maxpeak{2} = repmat(max_peak,size(prot_file_names{2}));

all_minpeak = cell(2,1);
all_minpeak{1} = repmat(min_peak,size(prot_file_names{1}));
all_minpeak{2} = repmat(min_peak,size(prot_file_names{2}));

all_cutpeak = cell(2,1);
all_cutpeak{1} = repmat(cut_peak,size(prot_file_names{1}));
all_cutpeak{2} = repmat(cut_peak,size(prot_file_names{2}));

all_minwidth = cell(2,1);
all_minwidth{1} = repmat(min_width,size(prot_file_names{1}));
all_minwidth{2} = repmat(min_width,size(prot_file_names{2}));

use_old = {false(size(prot_file_names{1})), false(size(prot_file_names{2}))};
% use_old{1}(:) = true;
% use_old{2}(:) = true;
% all_minwidth{2}([6]) = 0.3e-3;
% all_minpeak{2}([12,13]) = 90;
if plot_on
    ftrace = figure('Position', [81 109 1.2888e+03 534.4000]);
end
for pp = prot_start:numel(prot_file_names)
    for ii = rec_start:numel(prot_file_names{pp})
        %set parameters
        curr_maxpeak  = all_maxpeak{pp}(ii);
        curr_minPeak  = all_minpeak{pp}(ii);
        curr_cutPeak  = all_cutpeak{pp}(ii);
        curr_minWidth = all_minwidth{pp}(ii);
        curr_use_old  = use_old{pp}(ii);
        
        %Load data
        data = IBWread(...
            fullfile(fileNames(1).folder,prot_file_names{pp}{ii}));
        Fs = 1/data.dx;
        T = data.Nsam*data.dx;
        
        
        %Find stimulations and remove from trace
        detrend = medfilt1(data.y,Fs);
        detrend_trace = data.y-detrend;
        [pv_prot, pid_prot] = findpeaks(detrend_trace,...
            'MinPeakProminence',curr_maxpeak,...'MinPeakHeight',20,...
            'MinPeakDistance',Fs/1000,'MinPeakWidth',1);
        corr_trace = remove_artifacts(detrend_trace,pid_prot);
        
        
        %Find responses
        [pv, pid] = findpeaks(-corr_trace,...
            'MinPeakProminence',curr_minPeak,...'MinPeakHeight',20,...
            'MinPeakDistance',Fs*4e-3,'MinPeakWidth',Fs*curr_minWidth);
        pid(pv<curr_cutPeak) = [];
        pv(pv<curr_cutPeak) = [];
        [pid,pid_fltr] = down_then_up(corr_trace,pid);
        pv = pv(pid_fltr);
        %Find responses (old way)
        [pv_old, pid_old] = findpeaks(-detrend_trace,...
            'MinPeakProminence',curr_minPeak,...'MinPeakHeight',20,...
            'MinPeakDistance',Fs/1000,'MinPeakWidth',1);
        
        start_pids = pid_old-10;
        start_pids(start_pids<1) = 1;
        
        end_pids = pid_old+10;
        end_pids(end_pids>numel(detrend_trace)) = numel(detrend_trace);
        
        local_range = arrayfun(@(x,y) range(detrend_trace(x:y)),start_pids,end_pids);
                
        pid_old = pid_old(local_range<curr_maxpeak & local_range>curr_cutPeak);  
        pv_old = pv_old(local_range<curr_maxpeak & local_range>curr_cutPeak);
        
        if curr_use_old
            %Switch pids
            temp_pid = pid;
            pid = pid_old;
            pid_old = temp_pid;
            
            temp_pv = pv;
            pv = pv_old;
            pv_old = temp_pv;
        end
        
        %Save results
        freqs{pp}{ii} = time2rate(pid,Fs,T);
        freqs_old{pp}{ii} = time2rate(pid_old,Fs,T);
        spks{pp}{ii} = pid*(T*Fs);
        traces{pp}{ii} = data.y(1:Fs*T);
        
        freqs_prot{pp}{ii} = time2rate(pid_prot,Fs,T);
        spks_prot{pp}{ii} = pid_prot/Fs;
        
        
        %100Hz prot results only
        if pp == 1
            Spk{pp}(ii) = sum(pid>startP*Fs & pid<endP*Fs);
            pausePos = find(pid>(startP+stimDur)*Fs, 1, 'first');
            if ~isempty(pausePos)
                sPause{pp}(ii) = pid(pausePos)/Fs-(startP+stimDur);
            else
                sPause{pp}(ii) = NaN;
            end
        end
        
        
        if plot_on
            subplot(5,1,1)
            plot(1/Fs:1/Fs:T,freqs_prot{pp}{ii},'k')
            xlim([0 T])
            ylabel(['Stimulation (spk/s) n=',num2str(numel(pid_prot))])
            title(num2str(ii))
            
            subplot(5,1,2:3)
            plot(1/Fs:1/Fs:T,detrend_trace,'k')
            ylabel('Recording (pA)')
            hold on; 
            plot(1/Fs:1/Fs:T,corr_trace)
            plot(pid/Fs,-pv,'r.');
%             plot(pid_good/Fs,-pv_good,'gx');
            plot(pid_old/Fs,-pv_old,'bo');
            hold off;
            
            xlim([0 T])
            if ~isempty(pid)
                ylim_range = arrayfun(@(x) {x-10:x+10},pid);
                ylim_range = [ylim_range{:}];
                ylim_range(ylim_range>numel(detrend_trace)) = [];
                ylim_range(ylim_range<1) = [];
                
                limY = [min(corr_trace(ylim_range)) max(corr_trace(ylim_range))];
                limY = limY + [-diff(limY)*0.05 diff(limY)*0.05];
                ylim(limY)
            end
            
            subplot(5,1,4:5)
            plot(1/Fs:1/Fs:T,freqs_old{pp}{ii},'b')
            hold on            
            plot(1/Fs:1/Fs:T,freqs{pp}{ii},'k')
            hold off
            xlim([0 T])
            ylabel('Response (spk/s)')
            xlabel('Time (s)')
            linkaxes(ftrace.Children,'x')
            %             standardFig();
            if pp > 1 || p1_pause
                if p2_pause || p1_pause
                    pause
                end
            end
        end
       
    end
end

close(ftrace)
fclose all;


%% Get half-width and amplitude
freqs2 = freqs{1};
freqs2 = vertcat(freqs2{:})';
Amp = [];
HD = [];
baseline = [];

OFF = false;
smoothFreqs = medfilt2(freqs2(1:100:end,:),[20  1]);
baseRange = 1;
startPoint = 5.0;
endPoint = 10;

%Search for pause based on half baseline amplitude



fpeak = figure;
for i = 1:numel(freqs{1})
    baseline(i) = mean(smoothFreqs(Fs*(startPoint-baseRange)/100:Fs*startPoint/100,i));
    [Amp(i), maxX] = max(smoothFreqs(Fs*startPoint/100:Fs*endPoint/100,i));
    Amp(i) = Amp(i)-baseline(i);
    
    firstHalf = find((smoothFreqs(Fs*startPoint/100:Fs*endPoint/100,i)-baseline(i))>Amp(i)/2,1,'first');
    lastHalf = find((smoothFreqs(Fs*startPoint/100:Fs*endPoint/100,i)-baseline(i))>Amp(i)/2,1,'last');
    if isempty(firstHalf) || isempty(lastHalf)
        firstHalf = 0;
        lastHalf = 0;
    end
    HD(i) = (lastHalf - firstHalf)/Fs*100;
    
    if OFF
        firstHalf_OFF = find((smoothFreqs(Fs*startPoint/100:Fs*endPoint/100,i))<baseline(i)/2,1,'first');
        lastHalf_OFF = find((smoothFreqs((Fs*startPoint/100)+firstHalf_OFF:Fs*endPoint/100,i))>baseline(i)/2,1,'first')+firstHalf_OFF;
        if isempty(firstHalf_OFF) || isempty(lastHalf_OFF)
            firstHalf_OFF = 0;
            lastHalf_OFF = 0;
        end
        sPause{1}(i) = (lastHalf_OFF - firstHalf_OFF)/Fs*100;
    end
    
    plot(1:0.01:((endPoint-(startPoint-baseRange))*200+1),freqs2(Fs*(startPoint-baseRange):Fs*endPoint,i)); hold on
    plot(smoothFreqs(Fs*(startPoint-baseRange)/100:Fs*endPoint/100,i))
    title(num2str(i))
    scatter(maxX+(baseRange*Fs/100),Amp(i)+baseline(i),'r');
    if OFF
        line([firstHalf_OFF+(baseRange*Fs/100), lastHalf_OFF+(baseRange*Fs/100)],([baseline(i)/2, baseline(i)/2]),'Color','r');
    else
        line([firstHalf+(baseRange*Fs/100), lastHalf+(baseRange*Fs/100)],([Amp(i)/2, Amp(i)/2])+baseline(i),'Color','r');
    end
    hold off
    pause
end

close(fpeak)

%% plot individual
T=30;
xTime = 1/Fs:1/Fs:T;

traces2 = traces{1};
traces2 = [traces2{:}];

fig1 = figure('Color','w','Position', [209 181 974 581]);

post_stim = find(diff(find(contains(curr_file_names,'100Hz'))) > 2)+2.5;
if isempty(post_stim)
    post_stim = numel(freqs{1})+0.5;
end
typCell = 4;
cellRange = [1:numel(freqs{1})];
startT = 4.5;
stimEnd = 5.2001;
endT = 	10;
rangeT = round(startT*Fs:endT*Fs);
rangeT2 = round(stimEnd*Fs:endT*Fs);

%Typical
subplot(2,3,1);
plot(xTime(rangeT),traces2(rangeT,typCell),'k')
axis tight
limY = [min(traces2(rangeT2,typCell)) max(traces2(rangeT2,typCell))];
limY = limY + [-diff(limY)*0.05 diff(limY)*0.05];
ylim(limY)
ylabel('Current (pA)');
xlabel('Time (s)');


%Heatmap
subplot(2,3,2);
imagesc(freqs2(:,cellRange)');
caxis([0 median(Amp(:))+mean(baseline(:))])
hold on
for ii = 1:numel(post_stim)
    line([0 T*Fs],[post_stim(ii) post_stim(ii)],'color','r')
end
hold off

xlabel('Time(s)')
ylabel('Trials')
xlim(Fs*[startT endT])
if endT <= 10
    xticks(Fs*[0 1 2 3 4 5 6 7 8 9 10])
    xticklabels([0 1 2 3 4 5 6 7 8 9 10])
else
    xticks(Fs*[0 5 10 15 20 25 30])
    xticklabels([0 5 10 15 20 25 30])
end
% title('Firing rate')
currCell2 = currCell;
title([currCell2(1:4),' ',currCell2(5:end)])

%Average Freq
ax3 = subplot(2,3,3);
% plot(xTime(rangeT),mean(freqs2(rangeT,1:floor(post_stim(1))),2),'k')
for ii = 1:numel(post_stim)
    hold on
    plot(xTime(rangeT),mean(freqs2(rangeT,floor(post_stim(ii))-2:floor(post_stim(ii))),2))
    hold off
end

axis tight
ax3.YLim(1) = 0;
ylabel('Firing rate (Hz)');
xlabel('Time (s)');

%HalfWidth
ax4 = subplot(2,3,4);
plot(HD(cellRange),'ok')
ylabel('Half-decay (s)')
xlabel('Trials')
ax4.YLim(1) = 0;
% ylim([0 2])
xlim([0 numel(cellRange)+0.5])
hold on
for ii = 1:numel(post_stim)
    line([post_stim(ii) post_stim(ii)],ax4.YLim,'color','r')
end
hold off


%Amplitude
ax5 = subplot(2,3,5);
plot(Amp(cellRange),'ok')
ylabel('Amplitude (Hz)')
xlabel('Trials')
ax5.YLim(1) = 0;
% ylim([0 2])
xlim([0 numel(cellRange)+0.5])
hold on
for ii = 1:numel(post_stim)
    line([post_stim(ii) post_stim(ii)],ax5.YLim,'color','r')
end
hold off


%Pause
ax6 = subplot(2,3,6);
plot(sPause{1}(cellRange),'ok')
ylabel('Pause (s)')
xlabel('Trials')
ax6.YLim(1) = 0;
ax6.YLim(2) = max([ax6.YLim(2) 0.05]);
% ylim([0 2])
xlim([0 numel(cellRange)+0.5])
hold on
for ii = 1:numel(post_stim)
    line([post_stim(ii) post_stim(ii)],ax6.YLim,'color','r')
end
hold off


% currCell2 = currCell;
% sgtitle([currCell2(1:4),' ',currCell2(5:end)])

%% Add washin information
%{
    plotCurrentUBC(freqs,freqs_prot,traces,curr_file_names,Fs)
%}

washinStates = {'Baseline','LY 341495','NBQX',...
    'JNJ 16259685','Washout'};
washinID_states = {[1,0,0,0,0];...
                    [0,1,0,0,0];...
                    [0,1,1,0,0];...
                    [0,1,1,1,0];...
                    [0,0,0,0,1]};

washinConcentrations = {'','1 uM','5 uM','1 uM',''};


                
% washinStates = {'Baseline','Stability 1','Stability 2',...
%     'Stability 3','Stability 4'};
% washinID_states = {[1,0,0,0,0];...
%                     [1,1,0,0,0];...
%                     [1,0,1,0,0];...
%                     [1,0,0,1,0];...
%                     [1,0,0,0,1]};                
%                 
% washinConcentrations = {'','','','',''};

%Suggest borders based on gaps
base_prot_list = find(contains(curr_file_names,'100Hz'));
base_prot_jumps = diff(base_prot_list) > 2;
washin_borders = base_prot_list(base_prot_jumps);
washin_borders = washin_borders(2:end) - 4;
try
washin_borders(end+1) = base_prot_list(find(base_prot_jumps,1,'last')+4);
catch
    disp('No Washout?')
end
for ii = 1:numel(washin_borders)
    disp(washin_borders(ii))
    disp(curr_file_names{washin_borders(ii)})
    disp(newline)
    context_start = (washin_borders(ii) - 4);
    context_end = min([(washin_borders(ii) + 6), numel(curr_file_names)]);
    context_file_names = curr_file_names(context_start:context_end);
    cellfun(@disp,context_file_names);
    disp(newline)
    pause    
end
washin_borders = [1, washin_borders, numel(curr_file_names)+1];

washinIDs = false(numel(curr_file_names),numel(washinStates));
for ii = 1:numel(washin_borders)-1
    curr_range = washin_borders(ii):washin_borders(ii+1)-1;
    curr_ID_states = repmat(washinID_states{ii},numel(curr_range),1);
    washinIDs(washin_borders(ii):washin_borders(ii+1)-1,:) = ...
        curr_ID_states;   
end

%% Calculate stats based on median freqs
mBaseline=  [];
mAmp = [];
mHD = [];
mPause = [];
medianStats = struct();

baseRange = 1;
startPoint = 5.0;
stimDur = 0.2;
endPoint = 30;

delay_startPoint = 0.0;


smoothFreqs = [];
prot1_file_idx = contains(curr_file_names,'100Hz');

mFreq = mean(vertcat(freqs{1}{washinIDs(prot1_file_idx,1)}));

smoothFreq = medfilt1(mFreq(1:100:end),10);


%     else
%         smoothFreqs = mFreqs(ii,1:100:end);
%     end



%Search for pause based on half baseline amplitude
fpeak = figure;


mBaseline = mean(smoothFreq(Fs*(startPoint-baseRange)/100:Fs*startPoint/100));
[mAmp, maxX] = max(smoothFreq(Fs*(startPoint+stimDur)/100:Fs*endPoint/100));
mAmp = mAmp-mBaseline;

startPoint = startPoint + delay_startPoint;

freqThres = min([6, (mAmp+mBaseline)/2]);
freqStart = find(smoothFreq(Fs*(startPoint+stimDur)/100:Fs*(startPoint+stimDur)/100+maxX)<freqThres,1,'last');
if isempty(freqStart)
    freqStart = 0;
end
mPause = freqStart/Fs*100;

if freqStart > 0
    firstHalf = find((smoothFreq(Fs*(startPoint+stimDur)/100+freqStart:Fs*endPoint/100)-mBaseline)>mAmp/2,1,'first');
    firstHalf = firstHalf + freqStart + stimDur*Fs/100;
else
    firstHalf = find((smoothFreq(Fs*(startPoint)/100:Fs*endPoint/100)-mBaseline)>mAmp/2,1,'first');
end

lastHalf = find((smoothFreq(Fs*startPoint/100:Fs*endPoint/100)-mBaseline)>mAmp/2,1,'last');
if isempty(firstHalf) || isempty(lastHalf)
    firstHalf = 0;
    lastHalf = 0;
end
mHD = (lastHalf - firstHalf)/Fs*100;

startPoint = startPoint - delay_startPoint;
%     plot(1:0.01:((endPoint-(startPoint-baseRange))*200+1),freqs(Fs*(startPoint-baseRange):Fs*endPoint,i));
hold on
plot(mFreq(Fs*(startPoint-baseRange):100:Fs*endPoint));
plot(smoothFreq(Fs*(startPoint-baseRange)/100:Fs*endPoint/100),'k')
scatter(maxX+((baseRange+stimDur)*Fs/100),mAmp+mBaseline,'r');


line([firstHalf+((baseRange+delay_startPoint)*Fs/100), lastHalf+(baseRange+delay_startPoint)*Fs/100],([mAmp, mAmp]/2)+mBaseline,'Color','r');
line([(baseRange+stimDur+delay_startPoint)*Fs/100, freqStart+((baseRange+stimDur+delay_startPoint)*Fs/100)],([smoothFreq(Fs*(startPoint+stimDur+delay_startPoint)/100+freqStart), smoothFreq(Fs*(startPoint+stimDur+delay_startPoint)/100+freqStart)]),'Color','b');
hold off


medianStats.baseline = mBaseline;
medianStats.pause = mPause;
medianStats.Amp = mAmp;
medianStats.HD = mHD;

       
        
        

%% Save cell
% cd('savedDCoN')
cd('MF_stim_train_pharma_saved')
% cd('MF_stim_train_saved')
% cd('MF_stim_prots_pharma_saved_noWashin')
% cd('DCoN_All/savedDCoN_strych')

saveas(gcf,[currCell,'.png'])
save([currCell,'_analyzed.mat'],...
    'spks','traces','freqs','smoothFreqs','Spk','sPause',...
    'HD','Amp','baseline','curr_file_names','freqs_prot',...
    'spks_prot','washinStates','washinConcentrations','washinIDs',...
    'medianStats')
cd('..')
%{
currCell = 'Cell1675';

cd('MF_stim_prots_pharma_saved_noWashin')
save([currCell,'_analyzed.mat'],'washinStates','washinConcentrations','washinIDs',...
    'medianStats','bw_prots','-append')
cd('..')
%}


%% DONT RUN MINDLESSLY!!!! Crop based on washinstates
%Rerun median stats and bw_prots if possibly affected



%Define boolean vector of what to keep!
keep_idx = (washinIDs(:,1) | washinIDs(:,2))...
    & (~washinIDs(:,3) & ~washinIDs(:,4) & ~washinIDs(:,5));





%Split index by prot type
keep_idx1  = keep_idx(contains(curr_file_names,'100Hz'));
keep_idx2  = keep_idx(~contains(curr_file_names,'100Hz'));


spks{1} = spks{1}(keep_idx1);
spks{2} = spks{2}(keep_idx2);

traces{1} = traces{1}(keep_idx1);
traces{2} = traces{2}(keep_idx2);

freqs{1} = freqs{1}(keep_idx1);
freqs{2} = freqs{2}(keep_idx2);

Spk{1} = Spk{1}(keep_idx1);

sPause{1} = sPause{1}(keep_idx1);
HD = HD(keep_idx1);
Amp = Amp(keep_idx1);
baseline = baseline(keep_idx1);

curr_file_names = curr_file_names(keep_idx);

freqs_prot{1} = freqs_prot{1}(keep_idx1);
freqs_prot{2} = freqs_prot{2}(keep_idx2);

spks_prot{1} = spks_prot{1}(keep_idx1);
spks_prot{2} = spks_prot{2}(keep_idx2);

washinIDs = washinIDs(keep_idx,:);

%% Plot average train protocol stacked

%% Get files
Fs = 20000;

fileNames = dir('MF_stim_train_saved\*');
fileNames = fileNames(contains({fileNames(:).name},'.mat'));



badCellNames = {'Cell1747_analyzed.mat', 'Cell1748_analyzed.mat'};
removeCells = find(cellfun(@(x) ismember(x,badCellNames),{fileNames(:).name}));


allData = cell(size(fileNames));

for ii = 1:numel(fileNames)
    allData{ii} = load(fullfile(fileNames(ii).folder,fileNames(ii).name));    
end

if ~isempty(removeCells)
    allData(removeCells) = [];
    fileNames(removeCells) = [];
end

%% Get all median stats

all_HD = cellfun(@(x) x.medianStats.HD,allData);
all_pause = cellfun(@(x) x.medianStats.pause,allData);
all_Amp = cellfun(@(x) x.medianStats.Amp,allData);
all_baseline = cellfun(@(x) x.medianStats.baseline,allData);

%{
figure;
plot(1:numel(all_HD),sort(all_HD),'ko')
set(gca,'YScale','log');

%}

%% Get sorting index
%Select Pure OFF by Amp
OFFidx = find(all_Amp<8);
%Add manually
OFFnames = {};
cellIdx = find(cellfun(@(x) contains(x,OFFnames),{fileNames.name}));
OFFidx = [OFFidx,cellIdx];
%Remove manually
OFFnames = {};
cellIdx = find(cellfun(@(x) contains(x,OFFnames),{fileNames.name}));
OFFidx(ismember(OFFidx,cellIdx)) = [];



%Sort non OFF by HD or fit width
% [~,ONidx] = sort(mHD2);
[~,ONidx] = sort(all_HD);
ONidx = ONidx(:)';
ONidx = [ONidx(~ismember(ONidx,OFFidx)) ONidx(ismember(ONidx,OFFidx))];

%Sort OFFs by pause
[~, OFFsort] = sort(all_pause(ONidx(end-numel(OFFidx)+1:end)));
ONidx(end-numel(OFFidx)+1:end) = ONidx(OFFsort+(numel(ONidx)-numel(OFFidx)));

%Remove bad cells
% badCells = [120    40    14    49   31];
% ONidx(ismember(ONidx,badCells)) = [];

%% Select based on prot name
file_match = 'TRAIN10';
disp_num = numel(allData)+1;

fig1 = figure('Position',[488 1.8000 421.8000 780.8000]);
pos1 = [0.0500    0.0500    0.900    0.9300];
[all_positions] = get_stacked_axes_positions(pos1,0.08,disp_num);
all_positions = flipud(all_positions);

freq_change = [5,8,9,12,13,16,17,20,21,24,25,28,29,32,33,36,37];
freq_change = [];
for ii = 1:numel(allData)
    currData = allData{ONidx(ii)};
    [curr_trace,split_idx] = select_by_prot_code(currData,file_match);
    if ii == 1
        prot_trace = currData.freqs_prot{split_idx{1}(1)}{split_idx{1}(2)};
        ax1{ii} = axes('Position',all_positions(ii,:));
        hold on
        plot(((1:numel(prot_trace)))/Fs,prot_trace,'k');
        hold off
        ax1{ii}.XTick = [];
        ax1{ii}.YTick = [];
    end
    mean_trace = mean(vertcat(curr_trace{:}),1);
    flt_trace = medfilt1(mean_trace,Fs*0.1);

    ax1{ii+1} = axes('Position',all_positions(ii+1,:));
    hold on
    plot(((1:numel(mean_trace)))/Fs,flt_trace,'k');
    hold off

    ax1{ii+1}.YLim(1) = 0;
    if ii ~= numel(allData)
        ax1{ii+1}.XTick = [];
    end
    ax1{ii+1}.YTick = [];
    hold on
    for jj = 1:numel(freq_change)
        line(repmat(freq_change(jj),1,2),ax1{ii+1}.YLim,'Color',[0.7 0.7 0.7])

    end
    hold off

end
standardFig(fig1);