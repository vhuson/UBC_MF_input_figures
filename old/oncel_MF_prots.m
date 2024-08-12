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
fileNames = dir('MF_stim_prots\*');
[~,sortIdx]=sort([fileNames.datenum]);
fileNames = fileNames(sortIdx);

%Get unique cells
allCellNames = {fileNames(:).name};
allCellNames = allCellNames(1:end-1);

allCellNames = regexp(allCellNames,'Cell\d\d\d\d','match');
allCellNames = unique([allCellNames{:}]);
allCellNames = allCellNames(:);


%% Count spikes at indicated cell
currCell = 'Cell1623';
all_file_names = {fileNames.name};
idx = contains(all_file_names,currCell);
curr_file_names = all_file_names(idx);
curr_file_names = curr_file_names(1:end-5);

%Separate protocols
prot_file_names = {};
prot_file_names{1} = curr_file_names(contains(curr_file_names,'100Hz'));
%use same order as protnames
prot_file_names{2} = curr_file_names(~contains(curr_file_names,'100Hz'));

plot_on = true;

T = 30;
startP = 5;
stimDur = 0.201;
endP = 20;
rangeT2 = round((startP+stimDur)*Fs:endP*Fs);
freqs = [];
freqs_prot = [];
spks = [];
spks_prot = [];
traces = [];
Spk = [];
sPause = [];

minPeak = 40;
altMinPeak = 30;
% altIdx = [1,1;1,2;1,3;1,4;1,5];
altIdx = [0,0];
maxPeak = 1000;

if plot_on
    ftrace = figure('Position', [81 109 1.2888e+03 534.4000]);
end
for pp = 1:numel(prot_file_names)
    
    if pp == 1 %100Hz use old code
        flexible_parameters = false;
        T = 30;
        blankPeriod = round(5*Fs):round(5.0025*Fs);
        blankAdd = round(0.01*Fs);
        blankAll = blankPeriod;
        for ii = 1:19
            blankAll = [blankAll, blankPeriod+blankAdd*ii];
        end
        Fs = 20000;
    else %Use real timings and multipli
        flexible_parameters = true;
        blankAll = [];

        
    end
    curr_altIdx = altIdx(ismember(altIdx(:,1),pp),2);
    for ii = 1:numel(prot_file_names{pp})
        if ismember(ii,curr_altIdx)
            curr_minPeak = altMinPeak;
        else
            curr_minPeak = minPeak;
        end
        
        data = IBWread(fullfile(fileNames(1).folder,prot_file_names{pp}{ii}));
        if flexible_parameters
            T = data.Nsam*data.dx;            
            Fs = 1/data.dx;
        end
        
        
        [pv, pid] = findpeaks(-data.y(1:Fs*T),...
            'MinPeakProminence',curr_minPeak,...'MinPeakHeight',20,...
            'MinPeakDistance',Fs/500,'MinPeakWidth',1);
        
        pid_all = pid; pv_all = pv;
        
        pid = pid(pv<maxPeak);  pv = pv(pv<maxPeak);
        badPID = ismember(pid, blankAll);
        pid = pid(~badPID);  pv = pv(~badPID);
        
        pid_prot = pid_all(pv_all>=maxPeak);  pv_prot = pv_all(pv_all>=maxPeak);
        
        freqs{pp}{ii} = time2rate(pid,Fs,T);
        spks{pp}{ii} = pid*(T*Fs);
        traces{pp}{ii} = data.y(1:Fs*T);
        
        freqs_prot{pp}{ii} = time2rate(pid_prot,Fs,T);
        spks_prot{pp}{ii} = pid_prot/Fs;
        
        if ~flexible_parameters
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
            ylabel('Stimulation (spk/s)')
            title(num2str(ii))
            
            subplot(5,1,2:3)            
            plot(1/Fs:1/Fs:T,data.y(1:Fs*T),'k')
            ylabel('Recording (pA)')            
            hold on; plot(pid/Fs,-pv,'r.');
            hold off;
            if flexible_parameters
                xlim([0 T])
                if ~isempty(pid)
                ylim_range = arrayfun(@(x) {x-5:x+5},pid);
                ylim_range = [ylim_range{:}];
                ylim_range(ylim_range>numel(data.y)) = [];
                ylim_range(ylim_range<1) = [];
                
                limY = [min(data.y(ylim_range)) max(data.y(ylim_range))];
                limY = limY + [-diff(limY)*0.05 diff(limY)*0.05];
                ylim(limY)    
                end
            else
                xlim([3 endP])
                limY = [min(data.y(rangeT2)) max(data.y(rangeT2))];
                limY = limY + [-diff(limY)*0.05 diff(limY)*0.05];
                ylim(limY)
            end
            
            subplot(5,1,4:5)
            plot(1/Fs:1/Fs:T,freqs{pp}{ii},'k')
            ylabel('Response (spk/s)')
            xlabel('Time (s)')
            linkaxes(ftrace.Children,'x')
%             standardFig();
            pause
        end
    end
end
if plot_on
    close(ftrace);
end
fclose all;

%% Get half-width and amplitude
freqs2 = freqs{1};
freqs2 = vertcat(freqs2{:})';


OFF = false;
smoothFreqs = medfilt2(freqs2(1:100:end,:),[30 1]);
baseRange = 1;
startPoint = 5.0;
endPoint = 20;

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

post_stim = find(diff(find(contains(curr_file_names,'100Hz'))) > 2)+0.5;
if isempty(post_stim)
    post_stim = numel(freqs{1})+0.5;
end
typCell = 2;
cellRange = [1:numel(freqs{1})];
startT = 4.5;
stimEnd = 5.2001;
endT = 	20.0;
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
caxis([0 median(Amp(cellRange))+mean(baseline(cellRange))])
hold on
line([0 T*Fs],[post_stim post_stim],'color','r')
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
plot(xTime(rangeT),mean(freqs2(rangeT,1:floor(post_stim)),2),'k')
if post_stim > numel(freqs{1})+2
hold on
plot(xTime(rangeT),mean(freqs2(rangeT,ceil(post_stim):ceil(post_stim)+2),2),'r')
plot(xTime(rangeT),mean(freqs2(rangeT,cellRange(end)-2:cellRange(end)-2),2),'Color',[0.7 0.7 0.7])
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
line([post_stim post_stim],ax4.YLim,'color','r')
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
line([post_stim post_stim],ax5.YLim,'color','r')
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
line([post_stim post_stim],ax6.YLim,'color','r')
hold off


% currCell2 = currCell;
% sgtitle([currCell2(1:4),' ',currCell2(5:end)]) 

%% Save cell
% cd('savedDCoN')
cd('MF_stim_prots_saved')
% cd('DCoN_All/savedDCoN_strych')

saveas(gcf,[currCell,'.png'])
save([currCell,'_analyzed.mat'],...
    'spks','traces','freqs','smoothFreqs','Spk','sPause',...
    'HD','Amp','baseline','curr_file_names','freqs_prot',...
    'spks_prot')
cd('..')

        

%% Plot different burst styles, new set
all_bw_peaks = [100];
all_bw_widths = [0.01 0.02 0.05 0.1 0.2];

%Guess right prots based on lenght and sequence
burst_prots = find(cellfun(@numel,freqs_prot{2}) > 500000 & ...
                        cellfun(@numel,freqs_prot{2}) < 600002);
% burst_prots(find(diff(burst_prots) > 1,1,'first')+1:end) = [];

bw_peaks = round(cellfun(@max,freqs_prot{2}(burst_prots)),-1);
bw_widths = nan(size(bw_peaks));
all_resp = {};
mean_resp = {};
for ii = 1:numel(burst_prots)
    
    if bw_peaks(ii) == 0 %probably single stim experiment
        temp_peak = Inf;
        %Get spikes instead
        stim_locs = spks_prot{2}{burst_prots(ii)};
        stim_locs = round(stim_locs,1);
        stim_edges = nan(1,numel(stim_locs)*2);
        stim_edges(1:2:end) = stim_locs;
        stim_edges(2:2:end) = stim_locs + 0.01;
        stim_edges = round(stim_edges * Fs);
    else
        temp_peak = bw_peaks(ii);
        curr_prot = freqs_prot{2}{burst_prots(ii)};
        curr_prot = round(curr_prot,-1);
        stim_edges = find(abs(diff(curr_prot)) > 0);
        stim_edges = round(stim_edges,-1);
        stim_locs = round(stim_edges(1:2:end)/Fs);
    end
    if numel(stim_locs) ~= 5
        disp(['Burst prot does not seem right: ',num2str(ii)])
        
    else
        stim_width_est = diff(stim_edges(3:4))/Fs + 1/temp_peak;
        
        [~,I] = min(abs(stim_width_est - all_bw_widths));
        bw_widths(ii) = all_bw_widths(I);
        
        resp_width = (diff(stim_edges([3,5]))-1)/Fs;
        
        
        all_resp{ii} = [];
        for jj = 1:numel(stim_locs)
            curr_resp = freqs{2}{burst_prots(ii)}...
                (stim_locs(jj)*Fs+1:round((stim_locs(jj)+resp_width)*Fs));
            all_resp{ii} =  [all_resp{ii}; curr_resp];
            
        end
        mean_resp{ii} = mean(all_resp{ii});
    end
end

burst_fig = figure('Position', [574 120 740 443.4000]);

%50Hz 0.05
subplot(2,3,1)
curr_idx = bw_widths == 0.01;
plot(1/Fs:1/Fs:resp_width,mean_resp{curr_idx},'k')
ylabel('Response (spk/s)');
title('100Hz for 10ms')
axis tight
%50Hz 0.1
subplot(2,3,2)
curr_idx = bw_widths == 0.02;
plot(1/Fs:1/Fs:resp_width,mean_resp{curr_idx},'k')
title('100Hz for 20ms')
axis tight
%100Hz 0.02
subplot(2,3,3)
curr_idx = bw_widths == 0.05;
plot(1/Fs:1/Fs:resp_width,mean_resp{curr_idx},'k')
title('100Hz for 50ms')
%ylabel('100 Hz\newlineResponse (spk/s)');
xlabel('Time (s)')
axis tight
%100Hz 0.05
subplot(2,3,4)
curr_idx = bw_widths == 0.1;
plot(1/Fs:1/Fs:resp_width,mean_resp{curr_idx},'k')
title('100Hz for 100ms')
ylabel('Response (spk/s)');
xlabel('Time (s)')
axis tight
%100Hz 0.1
subplot(2,3,5)
curr_idx = bw_widths == 0.2;
plot(1/Fs:1/Fs:resp_width,mean_resp{curr_idx},'k')
title('100Hz for 200ms')
axis tight
xlabel('Time (s)')

linkaxes(burst_fig.Children)
xlim([0 5])

sgtitle(currCell)
standardFig();

%% different baseline firings, new set
all_bw_peaks = [100 101, 102.5, 105, 110, 120, 140];

%Guess right prots based on lenght and sequence
baseline_prots = find(cellfun(@numel,freqs_prot{2}) == 400001);

baseline_peaks = cellfun(@(x) x(5.05*Fs), freqs_prot{2}(baseline_prots));
baseline_peaks(1:2:end) = [];
for ii = 1:numel(baseline_peaks)
    [~,I] = min(abs(baseline_peaks(ii)-all_bw_peaks));
    baseline_peaks(ii) = all_bw_peaks(I);
end

rate_base = {};
single_base ={};
all_resp_base = {};
rebound_base = {};
mean_resp_base = {};
for ii = 1:numel(baseline_peaks)
    curr_prot_single = freqs_prot{2}{baseline_prots(2*ii-1)};
    curr_prot_single = round(curr_prot_single,-2);
    stim_edges_single = find(abs(diff(curr_prot_single)) > 0);
    stim_loc = round(stim_edges_single(1),-2);
    rate_base{ii} = freqs{2}{baseline_prots(2*ii-1)}...
           (stim_loc-2*Fs:stim_loc-1);
    single_base{ii} = freqs{2}{baseline_prots(2*ii-1)}...
           (stim_loc:end);
    
    curr_prot = freqs_prot{2}{baseline_prots(2*ii)};
    curr_prot = round(curr_prot,-2);
    stim_edges = find(abs(diff(curr_prot)) > 0);
    stim_width_est = diff(stim_edges(3:4))/Fs + 1/baseline_peaks(ii);
    
       
    resp_width_base = round((diff(stim_edges([3,5]))-1)/Fs);
    stim_locs = round(stim_edges(1:2:end)/Fs,1);
    
    all_resp_base{ii} = [];
    for jj = 1:numel(stim_locs)
        curr_resp = freqs{2}{baseline_prots(2*ii)}...
           (stim_locs(jj)*Fs+1:(stim_locs(jj)+resp_width_base)*Fs);
        all_resp_base{ii} =  [all_resp_base{ii}; curr_resp];
        
    end
    mean_resp_base{ii} = mean(all_resp_base{ii});
    
    curr_resp = freqs{2}{baseline_prots(2*ii)};
    rebound_base{ii} = curr_resp(stim_locs(end)*Fs+1:end);
end


%50Hz 0.05
base_fig = figure('Position', [29.8000 13.8000 1.3712e+03 764.2000]);

subplot(4,7,1);
curr_idx = find(baseline_peaks == 100,1,'first');
plot_trace = rate_base{curr_idx};
plot((1:numel(plot_trace))/Fs,plot_trace,'color','k')
title(['Baseline Stim.: ', num2str(baseline_peaks(curr_idx)-100),' spk/s'])
ylabel('Base rate (spk/s)');
axis tight
xlim([0 round(numel(plot_trace),-1)/Fs]);

subplot(4,7,8);
plot_trace = single_base{curr_idx};
plot((1:numel(plot_trace))/Fs,plot_trace,'color','k')
ylabel('Single response (spk/s)');
axis tight
xlim([0 round(numel(plot_trace),-1)/Fs]);


subplot(4,7,15);
plot_trace = all_resp_base{curr_idx}(1,:);
plot((1:numel(plot_trace))/Fs,plot_trace,'color',[0.7 0.7 0.7])
hold on
plot_trace = all_resp_base{curr_idx}(5,:);
plot((1:numel(plot_trace))/Fs,plot_trace,'color','k')
hold off
ylabel('1st and 5th response (spk/s)');
legend('1st response','5th response');
axis tight
xlim([0 round(numel(plot_trace),-1)/Fs]);

subplot(4,7,22);
plot_trace = rebound_base{curr_idx};
plot((1:numel(plot_trace))/Fs,plot_trace,'color','k')
xlabel('Time (s)');
ylabel('Rebound response (spk/s)');
axis tight
xlim([0 round(numel(plot_trace),-1)/Fs]);

%%%%%%%%%%%%%%%%%%%%%%%%%
% Next protocol
%%%%%%%%%%%%%%%%%%%%%%%%%%%



subplot(4,7,2);
curr_idx = find(baseline_peaks == 101,1,'first');
plot_trace = rate_base{curr_idx};
plot((1:numel(plot_trace))/Fs,plot_trace,'color','k')
title(['Baseline Stim.: ', num2str(baseline_peaks(curr_idx)-100),' spk/s'])
% ylabel('Base rate (spk/s)');
axis tight
xlim([0 round(numel(plot_trace),-1)/Fs]);

subplot(4,7,9);
plot_trace = single_base{curr_idx};
plot((1:numel(plot_trace))/Fs,plot_trace,'color','k')
% ylabel('Single response (spk/s)');
axis tight
xlim([0 round(numel(plot_trace),-1)/Fs]);


subplot(4,7,16);
plot_trace = all_resp_base{curr_idx}(1,:);
plot((1:numel(plot_trace))/Fs,plot_trace,'color',[0.7 0.7 0.7])
hold on
plot_trace = all_resp_base{curr_idx}(5,:);
plot((1:numel(plot_trace))/Fs,plot_trace,'color','k')
hold off
% ylabel('1st and 5th response (spk/s)');
axis tight
xlim([0 round(numel(plot_trace),-1)/Fs]);

subplot(4,7,23);
plot_trace = rebound_base{curr_idx};
plot((1:numel(plot_trace))/Fs,plot_trace,'color','k')
xlabel('Time (s)');
% ylabel('Rebound response (spk/s)');
axis tight
xlim([0 round(numel(plot_trace),-1)/Fs]);

%%%%%%%%%%%%%%%%%%%%%%%%%
% Next protocol
%%%%%%%%%%%%%%%%%%%%%%%%%%%



subplot(4,7,3);
curr_idx = find(baseline_peaks == 102.5,1,'first');
plot_trace = rate_base{curr_idx};
plot((1:numel(plot_trace))/Fs,plot_trace,'color','k')
title(['Baseline Stim.: ', num2str(baseline_peaks(curr_idx)-100),' spk/s'])
% ylabel('Base rate (spk/s)');
axis tight
xlim([0 round(numel(plot_trace),-1)/Fs]);

subplot(4,7,10);
plot_trace = single_base{curr_idx};
plot((1:numel(plot_trace))/Fs,plot_trace,'color','k')
% ylabel('Single response (spk/s)');
axis tight
xlim([0 round(numel(plot_trace),-1)/Fs]);


subplot(4,7,17);
plot_trace = all_resp_base{curr_idx}(1,:);
plot((1:numel(plot_trace))/Fs,plot_trace,'color',[0.7 0.7 0.7])
hold on
plot_trace = all_resp_base{curr_idx}(5,:);
plot((1:numel(plot_trace))/Fs,plot_trace,'color','k')
hold off
% ylabel('1st and 5th response (spk/s)');
axis tight
xlim([0 round(numel(plot_trace),-1)/Fs]);

subplot(4,7,24);
plot_trace = rebound_base{curr_idx};
plot((1:numel(plot_trace))/Fs,plot_trace,'color','k')
xlabel('Time (s)');
% ylabel('Rebound response (spk/s)');
axis tight
xlim([0 round(numel(plot_trace),-1)/Fs]);


%%%%%%%%%%%%%%%%%%%%%%%%%
% Next protocol
%%%%%%%%%%%%%%%%%%%%%%%%%%%



subplot(4,7,4);
curr_idx = find(baseline_peaks == 105,1,'first');
plot_trace = rate_base{curr_idx};
plot((1:numel(plot_trace))/Fs,plot_trace,'color','k')
title(['Baseline Stim.: ', num2str(baseline_peaks(curr_idx)-100),' spk/s'])
% ylabel('Base rate (spk/s)');
axis tight
xlim([0 round(numel(plot_trace),-1)/Fs]);

subplot(4,7,11);
plot_trace = single_base{curr_idx};
plot((1:numel(plot_trace))/Fs,plot_trace,'color','k')
% ylabel('Single response (spk/s)');
axis tight
xlim([0 round(numel(plot_trace),-1)/Fs]);


subplot(4,7,18);
plot_trace = all_resp_base{curr_idx}(1,:);
plot((1:numel(plot_trace))/Fs,plot_trace,'color',[0.7 0.7 0.7])
hold on
plot_trace = all_resp_base{curr_idx}(5,:);
plot((1:numel(plot_trace))/Fs,plot_trace,'color','k')
hold off
% ylabel('1st and 5th response (spk/s)');
axis tight
xlim([0 round(numel(plot_trace),-1)/Fs]);

subplot(4,7,25);
plot_trace = rebound_base{curr_idx};
plot((1:numel(plot_trace))/Fs,plot_trace,'color','k')
xlabel('Time (s)');
% ylabel('Rebound response (spk/s)');
axis tight
xlim([0 round(numel(plot_trace),-1)/Fs]);


%%%%%%%%%%%%%%%%%%%%%%%%%
% Next protocol
%%%%%%%%%%%%%%%%%%%%%%%%%%%



subplot(4,7,5);
curr_idx = find(baseline_peaks == 110,1,'first');
plot_trace = rate_base{curr_idx};
plot((1:numel(plot_trace))/Fs,plot_trace,'color','k')
title(['Baseline Stim.: ', num2str(baseline_peaks(curr_idx)-100),' spk/s'])
% ylabel('Base rate (spk/s)');
axis tight
xlim([0 round(numel(plot_trace),-1)/Fs]);

subplot(4,7,12);
plot_trace = single_base{curr_idx};
plot((1:numel(plot_trace))/Fs,plot_trace,'color','k')
% ylabel('Single response (spk/s)');
axis tight
xlim([0 round(numel(plot_trace),-1)/Fs]);


subplot(4,7,19);
plot_trace = all_resp_base{curr_idx}(1,:);
plot((1:numel(plot_trace))/Fs,plot_trace,'color',[0.7 0.7 0.7])
hold on
plot_trace = all_resp_base{curr_idx}(5,:);
plot((1:numel(plot_trace))/Fs,plot_trace,'color','k')
hold off
% ylabel('1st and 5th response (spk/s)');
axis tight
xlim([0 round(numel(plot_trace),-1)/Fs]);

subplot(4,7,26);
plot_trace = rebound_base{curr_idx};
plot((1:numel(plot_trace))/Fs,plot_trace,'color','k')
xlabel('Time (s)');
% ylabel('Rebound response (spk/s)');
axis tight
xlim([0 round(numel(plot_trace),-1)/Fs]);

%%%%%%%%%%%%%%%%%%%%%%%%%
% Next protocol
%%%%%%%%%%%%%%%%%%%%%%%%%%%



subplot(4,7,6);
curr_idx = find(baseline_peaks == 120,1,'first');
plot_trace = rate_base{curr_idx};
plot((1:numel(plot_trace))/Fs,plot_trace,'color','k')
title(['Baseline Stim.: ', num2str(baseline_peaks(curr_idx)-100),' spk/s'])
% ylabel('Base rate (spk/s)');
axis tight
xlim([0 round(numel(plot_trace),-1)/Fs]);

subplot(4,7,13);
plot_trace = single_base{curr_idx};
plot((1:numel(plot_trace))/Fs,plot_trace,'color','k')
% ylabel('Single response (spk/s)');
axis tight
xlim([0 round(numel(plot_trace),-1)/Fs]);


subplot(4,7,20);
plot_trace = all_resp_base{curr_idx}(1,:);
plot((1:numel(plot_trace))/Fs,plot_trace,'color',[0.7 0.7 0.7])
hold on
plot_trace = all_resp_base{curr_idx}(5,:);
plot((1:numel(plot_trace))/Fs,plot_trace,'color','k')
hold off
% ylabel('1st and 5th response (spk/s)');
axis tight
xlim([0 round(numel(plot_trace),-1)/Fs]);

subplot(4,7,27);
plot_trace = rebound_base{curr_idx};
plot((1:numel(plot_trace))/Fs,plot_trace,'color','k')
xlabel('Time (s)');
% ylabel('Rebound response (spk/s)');
axis tight
xlim([0 round(numel(plot_trace),-1)/Fs]);

%%%%%%%%%%%%%%%%%%%%%%%%%
% Next protocol
%%%%%%%%%%%%%%%%%%%%%%%%%%%



subplot(4,7,7);
curr_idx = find(baseline_peaks == 140,1,'first');
plot_trace = rate_base{curr_idx};
plot((1:numel(plot_trace))/Fs,plot_trace,'color','k')
title(['Baseline Stim.: ', num2str(baseline_peaks(curr_idx)-100),' spk/s'])
% ylabel('Base rate (spk/s)');
axis tight
xlim([0 round(numel(plot_trace),-1)/Fs]);

subplot(4,7,14);
plot_trace = single_base{curr_idx};
plot((1:numel(plot_trace))/Fs,plot_trace,'color','k')
% ylabel('Single response (spk/s)');
axis tight
xlim([0 round(numel(plot_trace),-1)/Fs]);


subplot(4,7,21);
plot_trace = all_resp_base{curr_idx}(1,:);
plot((1:numel(plot_trace))/Fs,plot_trace,'color',[0.7 0.7 0.7])
hold on
plot_trace = all_resp_base{curr_idx}(5,:);
plot((1:numel(plot_trace))/Fs,plot_trace,'color','k')
hold off
% ylabel('1st and 5th response (spk/s)');
axis tight
xlim([0 round(numel(plot_trace),-1)/Fs]);

subplot(4,7,28);
plot_trace = rebound_base{curr_idx};
plot((1:numel(plot_trace))/Fs,plot_trace,'color','k')
xlabel('Time (s)');
% ylabel('Rebound response (spk/s)');
axis tight
xlim([0 round(numel(plot_trace),-1)/Fs]);


linkaxes(base_fig.Children,'y')
sgtitle(currCell)
standardFig();



%% Plot different burst styles
all_bw_peaks = [50, 100, 200];
all_bw_widths = [0.02 0.05 0.1];

%Guess right prots based on lenght and sequence
burst_prots = find(cellfun(@numel,freqs_prot{2}) > 500000);
burst_prots(find(diff(burst_prots) > 1,1,'first')+1:end) = [];

bw_peaks = round(cellfun(@max,freqs_prot{2}(burst_prots)),-1);
bw_widths = nan(size(bw_peaks));
all_resp = {};
mean_resp = {};
for ii = 1:numel(burst_prots)
    curr_prot = freqs_prot{2}{burst_prots(ii)};
    curr_prot = round(curr_prot,-1);
    stim_edges = find(abs(diff(curr_prot)) > 0);
    stim_locs = round(stim_edges(1:2:end)/Fs);
    if numel(stim_locs) ~= 5
        disp(['Burst prot does not seem right: ',num2str(ii)])
        
    else
        stim_width_est = diff(stim_edges(3:4))/Fs + 1/bw_peaks(ii);
        
        [~,I] = min(abs(stim_width_est - all_bw_widths));
        bw_widths(ii) = all_bw_widths(I);
        
        resp_width = (diff(stim_edges([3,5]))-1)/Fs;
        
        
        all_resp{ii} = [];
        for jj = 1:numel(stim_locs)
            curr_resp = freqs{2}{burst_prots(ii)}...
                (stim_locs(jj)*Fs+1:(stim_locs(jj)+resp_width)*Fs);
            all_resp{ii} =  [all_resp{ii}; curr_resp];
            
        end
        mean_resp{ii} = mean(all_resp{ii});
    end
end

burst_fig = figure('Position', [574 120 740 603]);

%50Hz 0.05
subplot(3,3,2)
curr_idx = bw_peaks == 50 & bw_widths == 0.05;
plot(1/Fs:1/Fs:resp_width,mean_resp{curr_idx},'k')
ylabel('50 Hz\newlineResponse (spk/s)');
axis tight
%50Hz 0.1
subplot(3,3,3)
curr_idx = bw_peaks == 50 & bw_widths == 0.1;
plot(1/Fs:1/Fs:resp_width,mean_resp{curr_idx},'k')
axis tight
%100Hz 0.02
subplot(3,3,4)
curr_idx = bw_peaks == 100 & bw_widths == 0.02;
plot(1/Fs:1/Fs:resp_width,mean_resp{curr_idx},'k')
ylabel('100 Hz\newlineResponse (spk/s)');
axis tight
%100Hz 0.05
subplot(3,3,5)
curr_idx = bw_peaks == 100 & bw_widths == 0.05;
plot(1/Fs:1/Fs:resp_width,mean_resp{curr_idx},'k')
axis tight
%100Hz 0.1
subplot(3,3,6)
curr_idx = bw_peaks == 100 & bw_widths == 0.1;
plot(1/Fs:1/Fs:resp_width,mean_resp{curr_idx},'k')
axis tight
%200Hz 0.02
subplot(3,3,7)
curr_idx = bw_peaks == 200 & bw_widths == 0.02;
plot(1/Fs:1/Fs:resp_width,mean_resp{curr_idx},'k')
ylabel('200 Hz\newlineResponse (spk/s)');
xlabel('Time (s)\newline20 ms');
axis tight
%200Hz 0.05
subplot(3,3,8)
curr_idx = bw_peaks == 200 & bw_widths == 0.05;
plot(1/Fs:1/Fs:resp_width,mean_resp{curr_idx},'k')
axis tight
xlabel('Time (s)\newline50 ms');

%200Hz 0.1
subplot(3,3,9)
curr_idx = bw_peaks == 200 & bw_widths == 0.1;
plot(1/Fs:1/Fs:resp_width,mean_resp{curr_idx},'k')
xlabel('Time (s)\newline100 ms');
axis tight

linkaxes(burst_fig.Children)

sgtitle(currCell)
standardFig();

%% 5s vs 1s intervals
all_bw_peaks = [50, 100, 200];
all_bw_widths = [0.02 0.05 0.1];

%Guess right prots based on lenght and sequence
burst_prots_1s = find(cellfun(@numel,freqs_prot{2}) < 200002);
right_prots = find(diff(burst_prots_1s) > 1);
burst_prots_1s = burst_prots_1s(right_prots(1)+1:right_prots(1)+8);

bw_peaks_1s = round(cellfun(@max,freqs_prot{2}(burst_prots_1s)),-1);
bw_widths_1s = nan(size(bw_peaks_1s));
all_resp_1s = {};
mean_resp_1s = {};
for ii = 1:numel(burst_prots_1s)
    curr_prot = freqs_prot{2}{burst_prots_1s(ii)};
    curr_prot = round(curr_prot,-1);
    stim_edges = find(abs(diff(curr_prot)) > 0);
    stim_width_est = diff(stim_edges(3:4))/Fs + 1/bw_peaks_1s(ii);
    
    [~,I] = min(abs(stim_width_est - all_bw_widths));
    bw_widths_1s(ii) = all_bw_widths(I);
    
    resp_width_1s = (diff(stim_edges([3,5]))-1)/Fs;
    stim_locs = round(stim_edges(1:2:end)/Fs);
    
    all_resp_1s{ii} = [];
    for jj = 1:numel(stim_locs)
        curr_resp = freqs{2}{burst_prots_1s(ii)}...
           (stim_locs(jj)*Fs+1:(stim_locs(jj)+resp_width_1s)*Fs);
        all_resp_1s{ii} =  [all_resp_1s{ii}; curr_resp];
        
    end
    mean_resp_1s{ii} = mean(all_resp_1s{ii});
end



fig_1v5 = figure('Position', [680 200 606 545]);
subplot(7,2,1)
plot((1:numel(freqs_prot{2}{burst_prots(1)}))/Fs,...
    freqs_prot{2}{burst_prots(1)},'k')
ylabel('Stim.\newlinepattern')
yticks([0 50])
yticklabels([0 1])
xlabel('Time (s)')
axis tight
ylim([0 50])

subplot(7,2,2)
plot((1:numel(freqs_prot{2}{burst_prots_1s(1)}))/Fs,...
    freqs_prot{2}{burst_prots_1s(1)},'k')
yticks([0 50])
yticklabels([0 1])
xlabel('Time (s)')
axis tight
ylim([0 50])

subplot(7,2,[3,5]) %50Hz 5s
curr_idx = bw_peaks == 50 & bw_widths == 0.1;
plot(1/Fs:1/Fs:5,all_resp{curr_idx}(1,1:Fs*5),'k')
hold on
plot(1/Fs:1/Fs:5,all_resp{curr_idx}(5,1:Fs*5),'r')
hold off
axis tight
ylabel('50 Hz\newlineResponse (spk/s)');

subplot(7,2,[4,6]) %50Hz 1s
curr_idx = find(bw_peaks_1s == 50 & bw_widths_1s == 0.1,1,'first');
plot(1/Fs:1/Fs:1,all_resp_1s{curr_idx}(1,1:Fs),'k')
hold on
plot(1/Fs:1/Fs:1,all_resp_1s{curr_idx}(5,1:Fs),'r')
hold off
axis tight
legend('1st response','5th response')

subplot(7,2,[7,9]) %100Hz 5s
curr_idx = bw_peaks == 100 & bw_widths == 0.1;
plot(1/Fs:1/Fs:5,all_resp{curr_idx}(1,1:Fs*5),'k')
hold on
plot(1/Fs:1/Fs:5,all_resp{curr_idx}(5,1:Fs*5),'r')
hold off
axis tight
ylabel('100 Hz\newlineResponse (spk/s)');

subplot(7,2,[8,10]) %100Hz 1s
curr_idx = find(bw_peaks_1s == 100 & bw_widths_1s == 0.1,1,'first');
plot(1/Fs:1/Fs:1,all_resp_1s{curr_idx}(1,1:Fs),'k')
hold on
plot(1/Fs:1/Fs:1,all_resp_1s{curr_idx}(5,1:Fs),'r')
hold off
axis tight

subplot(7,2,[11,13]) %200Hz 5s
curr_idx = bw_peaks == 200 & bw_widths == 0.1;
plot(1/Fs:1/Fs:5,all_resp{curr_idx}(1,1:Fs*5),'k')
hold on
plot(1/Fs:1/Fs:5,all_resp{curr_idx}(5,1:Fs*5),'r')
hold off
axis tight
ylabel('200 Hz\newlineResponse (spk/s)');
xlabel('Time (s)\newline5s interval');

subplot(7,2,[12,14]) %200Hz 1s
curr_idx = find(bw_peaks_1s == 200 & bw_widths_1s == 0.1,1,'first');
plot(1/Fs:1/Fs:1,all_resp_1s{curr_idx}(1,1:Fs),'k')
hold on
plot(1/Fs:1/Fs:1,all_resp_1s{curr_idx}(5,1:Fs),'r')
hold off
axis tight
xlabel('Time (s)\newline1s interval');



linkaxes(fig_1v5.Children(1:end-2))
xlim([0 1])
sgtitle(currCell)
standardFig();

%% different baseline firings
all_bw_peaks = [100, 105, 110, 120, 130, 140];

%Guess right prots based on lenght and sequence
baseline_prots = find(cellfun(@numel,freqs_prot{2}) < 200002 & cellfun(@numel,freqs_prot{2}) > 100001);
right_prots = find(diff(baseline_prots) == 1);
baseline_prots = baseline_prots(right_prots(1):right_prots(end)+1);

baseline_peaks = cellfun(@(x) x(5.05*Fs), freqs_prot{2}(baseline_prots));
for ii = 1:numel(baseline_peaks)
    [~,I] = min(abs(baseline_peaks(ii)-all_bw_peaks));
    baseline_peaks(ii) = all_bw_peaks(I);
end
baseline_peaks(baseline_peaks == 150) = 130;

all_resp_base = {};
mean_resp_base = {};
for ii = 1:numel(baseline_prots)
    curr_prot = freqs_prot{2}{baseline_prots(ii)};
    curr_prot = round(curr_prot,-2);
    stim_edges = find(abs(diff(curr_prot)) > 0);
    stim_width_est = diff(stim_edges(3:4))/Fs + 1/baseline_peaks(ii);
    
       
    resp_width_base = round((diff(stim_edges([3,5]))-1)/Fs);
    stim_locs = round(stim_edges(1:2:end)/Fs);
    
    all_resp_base{ii} = [];
    for jj = 1:numel(stim_locs)
        curr_resp = freqs{2}{baseline_prots(ii)}...
           (stim_locs(jj)*Fs+1:(stim_locs(jj)+resp_width_base)*Fs);
        all_resp_base{ii} =  [all_resp_base{ii}; curr_resp];
        
    end
    mean_resp_base{ii} = mean(all_resp_base{ii});
end

%50Hz 0.05
base_fig = figure('Position', [680 125 693 653]);

curr_ax = subplot(4,2,1:2);
stim_locs = [5*Fs:5.1*Fs, ...
                6*Fs:6.1*Fs, ...
                7*Fs:7.1*Fs, ...
                8*Fs:8.1*Fs, ...
                9*Fs:9.1*Fs];
currStim = zeros(1,Fs*10);
currStim(stim_locs) = 100;
plot(1/Fs:1/Fs:10,currStim)
hold on
plot(1/Fs:1/Fs:10,currStim+5)
plot(1/Fs:1/Fs:10,currStim+10)
plot(1/Fs:1/Fs:10,currStim+20)
plot(1/Fs:1/Fs:10,currStim+30)
plot(1/Fs:1/Fs:10,currStim+40)
hold off
ylabel('Stimulation (spk/s)')
xlabel('Time (s)')
curr_l = legend('0','5','10','20','30','40');
axis tight
curr_ax.Position = [0.1300 0.7597 0.6379 0.1562];
curr_l.Position = [0.7941 0.7691 0.0951 0.1304];




subplot(4,2,3)
curr_idx = find(baseline_peaks == 100,1,'first');
plot(1/Fs:1/Fs:1,all_resp_base{curr_idx}(:,1:Fs),'color',[0.7 0.7 0.7])
hold on
plot(1/Fs:1/Fs:1,mean_resp_base{curr_idx}(1,1:Fs),'k')
hold off
% curr_idx = find(bw_peaks_1s == 100 & bw_widths_1s == 0.1,1,'first');
% plot(1/Fs:1/Fs:1,mean_resp_1s{curr_idx}(1,1:Fs),'k')
ylabel('Response (spk/s)');
title('Baseline 0 spk/s')
axis tight

subplot(4,2,4)
curr_idx = find(baseline_peaks == 105,1,'first');
plot(1/Fs:1/Fs:1,all_resp_base{curr_idx}(:,1:Fs),'color',[0.7 0.7 0.7])
hold on
plot(1/Fs:1/Fs:1,mean_resp_base{curr_idx}(1,1:Fs),'k')
hold off
title('Baseline 5 spk/s')
axis tight

subplot(4,2,5)
curr_idx = find(baseline_peaks == 110,1,'first');
plot(1/Fs:1/Fs:1,all_resp_base{curr_idx}(:,1:Fs),'color',[0.7 0.7 0.7])
hold on
plot(1/Fs:1/Fs:1,mean_resp_base{curr_idx}(1,1:Fs),'k')
hold off
ylabel('Response (spk/s)');
title('Baseline 10 spk/s')
axis tight

subplot(4,2,6)
curr_idx = find(baseline_peaks == 120,1,'first');
plot(1/Fs:1/Fs:1,all_resp_base{curr_idx}(:,1:Fs),'color',[0.7 0.7 0.7])
hold on
plot(1/Fs:1/Fs:1,mean_resp_base{curr_idx}(1,1:Fs),'k')
hold off
title('Baseline 20 spk/s')
axis tight

subplot(4,2,7)
curr_idx = find(baseline_peaks == 130,1,'first');
plot(1/Fs:1/Fs:1,all_resp_base{curr_idx}(:,1:Fs),'color',[0.7 0.7 0.7])
hold on
plot(1/Fs:1/Fs:1,mean_resp_base{curr_idx}(1,1:Fs),'k')
hold off
ylabel('Response (spk/s)');
xlabel('Time (s)')
title('Baseline 30 spk/s')
axis tight

subplot(4,2,8)
curr_idx = find(baseline_peaks == 140,1,'first');
plot(1/Fs:1/Fs:1,all_resp_base{curr_idx}(:,1:Fs),'color',[0.7 0.7 0.7])
hold on
plot(1/Fs:1/Fs:1,mean_resp_base{curr_idx}(1,1:Fs),'k')
hold off
title('Baseline 40 spk/s')
xlabel('Time (s)')
axis tight
linkaxes(base_fig.Children(1:end-1))
sgtitle(currCell)
standardFig();



%% Baseline firing, new set
all_bw_peaks = [100, 105, 110, 120, 130, 140];

%Guess right prots based on lenght and sequence
baseline_prots = find(cellfun(@numel,freqs_prot{2}) == 400001);

baseline_peaks = cellfun(@(x) x(10.05*Fs), freqs_prot{2}(baseline_prots));
for ii = 1:numel(baseline_peaks)
    [~,I] = min(abs(baseline_peaks(ii)-all_bw_peaks));
    baseline_peaks(ii) = all_bw_peaks(I);
end
baseline_peaks(baseline_peaks == 150) = 130;

all_resp_base = {};
mean_resp_base = {};
for ii = 1:numel(baseline_prots)
    curr_prot = freqs_prot{2}{baseline_prots(ii)};
    curr_prot = round(curr_prot,-2);
    stim_edges = find(abs(diff(curr_prot)) > 0);
    stim_width_est = diff(stim_edges(3:4))/Fs + 1/baseline_peaks(ii);
    
       
    resp_width_base = round((diff(stim_edges([3,5]))-1)/Fs);
    stim_locs = round(stim_edges(1:2:end)/Fs);
    
    all_resp_base{ii} = [];
    for jj = 1:numel(stim_locs)
        curr_resp = freqs{2}{baseline_prots(ii)}...
           (stim_locs(jj)*Fs+1:(stim_locs(jj)+resp_width_base)*Fs);
        all_resp_base{ii} =  [all_resp_base{ii}; curr_resp];
        
    end
    mean_resp_base{ii} = mean(all_resp_base{ii});
end

%50Hz 0.05
base_fig = figure('Position', [680 125 693 653]);

curr_ax = subplot(4,2,1:2);
stim_locs = [5*Fs:5.1*Fs, ...
                6*Fs:6.1*Fs, ...
                7*Fs:7.1*Fs, ...
                8*Fs:8.1*Fs, ...
                9*Fs:9.1*Fs];
currStim = zeros(1,Fs*10);
currStim(stim_locs) = 100;
plot(1/Fs:1/Fs:10,currStim)
hold on
plot(1/Fs:1/Fs:10,currStim+5)
plot(1/Fs:1/Fs:10,currStim+10)
plot(1/Fs:1/Fs:10,currStim+20)
plot(1/Fs:1/Fs:10,currStim+30)
plot(1/Fs:1/Fs:10,currStim+40)
hold off
ylabel('Stimulation (spk/s)')
xlabel('Time (s)')
curr_l = legend('0','5','10','20','30','40');
axis tight
curr_ax.Position = [0.1300 0.7597 0.6379 0.1562];
curr_l.Position = [0.7941 0.7691 0.0951 0.1304];




subplot(4,2,3)
curr_idx = find(baseline_peaks == 100,1,'first');
plot(1/Fs:1/Fs:1,all_resp_base{curr_idx}(:,1:Fs),'color',[0.7 0.7 0.7])
hold on
plot(1/Fs:1/Fs:1,mean_resp_base{curr_idx}(1,1:Fs),'k')
hold off
% curr_idx = find(bw_peaks_1s == 100 & bw_widths_1s == 0.1,1,'first');
% plot(1/Fs:1/Fs:1,mean_resp_1s{curr_idx}(1,1:Fs),'k')
ylabel('Response (spk/s)');
title('Baseline 0 spk/s')
axis tight

subplot(4,2,4)
curr_idx = find(baseline_peaks == 105,1,'first');
plot(1/Fs:1/Fs:1,all_resp_base{curr_idx}(:,1:Fs),'color',[0.7 0.7 0.7])
hold on
plot(1/Fs:1/Fs:1,mean_resp_base{curr_idx}(1,1:Fs),'k')
hold off
title('Baseline 5 spk/s')
axis tight

subplot(4,2,5)
curr_idx = find(baseline_peaks == 110,1,'first');
plot(1/Fs:1/Fs:1,all_resp_base{curr_idx}(:,1:Fs),'color',[0.7 0.7 0.7])
hold on
plot(1/Fs:1/Fs:1,mean_resp_base{curr_idx}(1,1:Fs),'k')
hold off
ylabel('Response (spk/s)');
title('Baseline 10 spk/s')
axis tight

subplot(4,2,6)
curr_idx = find(baseline_peaks == 120,1,'first');
plot(1/Fs:1/Fs:1,all_resp_base{curr_idx}(:,1:Fs),'color',[0.7 0.7 0.7])
hold on
plot(1/Fs:1/Fs:1,mean_resp_base{curr_idx}(1,1:Fs),'k')
hold off
title('Baseline 20 spk/s')
axis tight

subplot(4,2,7)
curr_idx = find(baseline_peaks == 130,1,'first');
plot(1/Fs:1/Fs:1,all_resp_base{curr_idx}(:,1:Fs),'color',[0.7 0.7 0.7])
hold on
plot(1/Fs:1/Fs:1,mean_resp_base{curr_idx}(1,1:Fs),'k')
hold off
ylabel('Response (spk/s)');
xlabel('Time (s)')
title('Baseline 30 spk/s')
axis tight

subplot(4,2,8)
curr_idx = find(baseline_peaks == 140,1,'first');
plot(1/Fs:1/Fs:1,all_resp_base{curr_idx}(:,1:Fs),'color',[0.7 0.7 0.7])
hold on
plot(1/Fs:1/Fs:1,mean_resp_base{curr_idx}(1,1:Fs),'k')
hold off
title('Baseline 40 spk/s')
xlabel('Time (s)')
axis tight
linkaxes(base_fig.Children(1:end-1))
sgtitle(currCell)
standardFig();

%% Analyze smooth pursuit stuff

%Guess right prots based on lenght and sequence
smpu_prots = find(cellfun(@numel,freqs_prot{2}) > 660000);


%Extract individual trials for analysis
smpu_resp = {};
smpu_base = {};
smpu_stim = {};
for ii = 1:numel(smpu_prots)
    curr_prot = freqs_prot{2}{smpu_prots(ii)};
    curr_resp = freqs{2}{smpu_prots(ii)};
    curr_prot = round(curr_prot,-1);
    for jj = 1:15
        curr_time = 2.2*(jj-1);
        smpu_base{ii}(jj) = curr_prot(round((0.5+curr_time)*Fs));
        smpu_stim{ii}(jj) = curr_prot(round((1.5+curr_time)*Fs));
        
        smpu_resp{ii}{jj} = curr_resp(round(curr_time*Fs:(curr_time+2.2)*Fs)+1);
        smpu_resp{ii}{jj}(end) = [];
    end
end
all_smpu_prots = [smpu_base{:}]+[smpu_stim{:}]/100;
unq_smpu_prots = unique(all_smpu_prots);
unq_smpu_base = floor(unq_smpu_prots);
unq_smpu_stim = round(rem(unq_smpu_prots,1)*100);

smpu_prot_resp = {};
for ii = 1:numel(unq_smpu_prots)
    curr_prot_idx = find(all_smpu_prots == unq_smpu_prots(ii));
    curr_prot_idx_ii = ceil(curr_prot_idx/15);
    curr_prot_idx_jj = mod(curr_prot_idx,15);
    curr_prot_idx_jj(curr_prot_idx_jj == 0) = 15;
    for jj = 1:5
        smpu_prot_resp{ii}{jj} = smpu_resp{...
            curr_prot_idx_ii(jj)}{...
            curr_prot_idx_jj(jj)};
    end    
end

f_smpu = figure('Position', [119.4000 122.6000 819.2000 596.8000]);
for ii = 1:15
    subplot(4,4,ii+1)
    plot((1:numel(smpu_prot_resp{ii}{1}))/Fs,...
        vertcat(smpu_prot_resp{ii}{:})','Color',[0.7 0.7 0.7])
    hold on
    plot((1:numel(smpu_prot_resp{ii}{1}))/Fs,...
        mean(vertcat(smpu_prot_resp{ii}{:})),'k')
    hold off
    title([num2str(unq_smpu_base(ii)),' -> ',...
        num2str(unq_smpu_stim(ii)),' (spk/s)'])
    axis tight
    if mod(ii+1,4) == 1
        ylabel('Resp. (spk/s)')
    end
    if ii > 11
        xlabel('Time (s)')
    end
end
linkaxes(f_smpu.Children)
standardFig();


%% Get all cells
fileNames = dir('MF_stim_prots_saved\*');
fileNames = fileNames(3:end);
fileNames(contains({fileNames(:).name},'.png')) = [];
fileNames = fileNames(1:7);

Fs = 20000;

allData = cell(size(fileNames));

for ii = 1:numel(fileNames)
    allData{ii} = load(fullfile(fileNames(ii).folder,fileNames(ii).name));    
end


%% Gather data
mean_pre_response = [];
mean_smooth_pursuit = [];
mean_burst_response = [];

all_rate_base = [];
all_single_base = [];
all_all_resp_base = [];
all_rebound_base = [];

median_HD = [];
median_Amp = [];
median_baseline = [];
for ii = 1:numel(allData)
    %Find continuous stim number
    curr_file_names = allData{ii}.curr_file_names;
    post_stim = find(diff(find(contains(curr_file_names,'100Hz'))) > 2);
    
    %get response and stimulation
    curr_freqs = allData{ii}.freqs;
    curr_freqs_prot = allData{ii}.freqs_prot;
    
    %Get mean response and half width
    mean_pre_response(ii,:) = mean(vertcat(curr_freqs{1}{1:post_stim}));
    median_HD(ii) = median(allData{ii}.HD(1:post_stim));
    median_Amp(ii) = median(allData{ii}.Amp(1:post_stim));
    median_baseline(ii) = median(allData{ii}.baseline(1:post_stim));
    
    %Get smooth pursuit stuff
    [smpu_prot_resp, unq_smpu_base, unq_smpu_stim] = ...
        getSmoothPursuit(curr_freqs_prot,curr_freqs);
    
    mean_smpu_resp = cellfun(@(x) {mean(vertcat(x{:}))},smpu_prot_resp);
    mean_smooth_pursuit(ii,:) = [mean_smpu_resp{:}];
    
    %Get different bursts
    [all_mean_bursts] = getBurstResponses(curr_freqs_prot,curr_freqs);
    mean_burst_response(ii,:) = all_mean_bursts;
    
    %Get baseline stuff
    [rate_base, single_base, all_resp_base, rebound_base] = getBaselineResponses(curr_freqs_prot,curr_freqs);
    all_rate_base{ii} = rate_base;
    all_single_base{ii} = single_base;
    all_all_resp_base{ii} = all_resp_base;
    all_rebound_base{ii} = rebound_base;
end

%% Smooth pursuit heatmap
figure;
colormap gray
ax1_prot = subplot(5,4,1);
stairs([0 1 1.2 6],[0 100 0 0],'k')
ax1_prot.XTick = [];

ax2_prot = subplot(5,4,2:4);
sp_prots = [unq_smpu_base', unq_smpu_stim']';
sp_prots = [sp_prots; zeros(1,15)];
stairs([sort([(2.2*(1:15))-2.2, (2.2*(1:15))-1.2, (2.2*(1:15))-0.2]),33],...
    [sp_prots(:);0],'k')
ax2_prot.XTick = [];
axis tight


ax1 = subplot(5,4,5:4:20);
[~,HDidx] = sort(median_HD);
HDidx = [HDidx(2:end), HDidx(1)];
norm_value = median_Amp(HDidx) + median_baseline(HDidx);

x_range = 4*Fs:10*Fs;
imagesc(mean_pre_response(HDidx,x_range)./norm_value')
caxis([0 1.2])
xticks(Fs*[1 6 11 16])
xticklabels(cellfun(@num2str,{0 5 10 15},'UniformOutput',false))
xlabel('Time (s)')
ylabel('Cell (#)')

ax2 = subplot(5,4,[6:8,10:12,14:16,18:20]);

imagesc(mean_smooth_pursuit(HDidx,:)./norm_value')
caxis([0 1.2])
xticks(sort(Fs*[0 (2.2*(1:15))-0.2 2.2*(1:15)]));
ax2.XTickLabels = [];


standardFig()


%% Burst response heatmap
figure;
colormap gray
ax1_prot = subplot(5,4,1);
stairs([0 1 1.2 6],[0 100 0 0],'k')
ax1_prot.XTick = [];

ax2_prot = subplot(5,4,2:4);
peak_order = [50, 100, 50, 100, 200, 100, 200, 200];
width_order = [0.05, 0.02, 0.1, 0.05, 0.02, 0.1, 0.05, 0.1];

peak_zeros = zeros(1,numel(peak_order)*2+1);
peak_zeros(1:2:end-1) = peak_order;

peak_timings = zeros(1,numel(peak_order)*2+1);
peak_timings(1:2:end) = 0:8;
peak_timings(2:2:end) = (0:7)+width_order;


stairs(peak_timings,peak_zeros,'k')
ax2_prot.XTick = [];
axis tight


ax1 = subplot(5,4,5:4:20);
[~,HDidx] = sort(median_HD);
HDidx = [HDidx(2:end), HDidx(1)];
norm_value = median_Amp(HDidx) + median_baseline(HDidx);

x_range = 4*Fs:10*Fs;
imagesc(mean_pre_response(HDidx,x_range)./norm_value')
caxis([0 1.2])
xticks(Fs*[1 6 11 16])
xticklabels(cellfun(@num2str,{0 5 10 15},'UniformOutput',false))
xlabel('Time (s)')
ylabel('Cell (#)')

ax2 = subplot(5,4,[6:8,10:12,14:16,18:20]);
time_cut = 5;
time_x = [];
for ii = 1:8
    time_x = [time_x , (1:Fs*time_cut)+Fs*5*(ii-1)];
end
   

imagesc(mean_burst_response(HDidx,time_x)./norm_value')
caxis([0 1.2])
xticks(peak_timings(1:2:end)*time_cut*Fs);
ax2.XTickLabels = [];


standardFig()

%%
fig = plotBaselineStuff(median_HD,median_Amp,median_baseline,Fs,mean_pre_response,all_rate_base);
sgtitle('Baseline firing rate')

fig = plotBaselineStuff(median_HD,median_Amp,median_baseline,Fs,mean_pre_response,all_single_base);
sgtitle('Single response')

fig = plotBaselineStuff(median_HD,median_Amp,median_baseline,Fs,mean_pre_response,all_rebound_base);
sgtitle('rebound response')

fig = plotBaselineStuff(median_HD,median_Amp,median_baseline,Fs,mean_pre_response,all_rebound_base);
sgtitle('rebound response')
%% Baseline response heatmap
figure;
colormap gray


ax1 = subplot(1,4,1);
[~,HDidx] = sort(median_HD);
% HDidx = [HDidx(2:end), HDidx(1)];
norm_value = median_Amp(HDidx) + median_baseline(HDidx);

x_range = 4*Fs:10*Fs;
imagesc(mean_pre_response(HDidx,x_range)./norm_value')
caxis([0 1.2])
xticks(Fs*[1 6 11 16])
xticklabels(cellfun(@num2str,{0 5 10 15},'UniformOutput',false))
xlabel('Time (s)')
ylabel('Cell (#)')

ax2 = subplot(1,4,2:4);
unpack_trace = cellfun(@(x) {[x{:}]},all_rate_base);
unpack_trace = vertcat(unpack_trace{:});

   

imagesc(unpack_trace(HDidx,:)./norm_value')
caxis([0 1.2])
xticks((1/Fs:2:14)*Fs);
ax2.XTickLabels = [0,1,2.5,5,10,20,40];

sgtitle('Baseline firing rate')
standardFig()

%% functions
function [smpu_prot_resp, unq_smpu_base, unq_smpu_stim] = getSmoothPursuit(curr_freqs_prot,curr_freqs,Fs)
%Get smooth pursuit stuff
if nargin == 2
    Fs = 20000;
end
smpu_prots = find(cellfun(@numel,curr_freqs_prot{2}) > 660000);


%Extract individual trials for analysis
smpu_resp = {};
smpu_base = {};
smpu_stim = {};
for kk = 1:numel(smpu_prots)
    curr_prot = curr_freqs_prot{2}{smpu_prots(kk)};
    curr_resp = curr_freqs{2}{smpu_prots(kk)};
    curr_prot = round(curr_prot,-1);
    for jj = 1:15
        curr_time = 2.2*(jj-1);
        smpu_base{kk}(jj) = curr_prot(round((0.5+curr_time)*Fs));
        smpu_stim{kk}(jj) = curr_prot(round((1.5+curr_time)*Fs));
        
        smpu_resp{kk}{jj} = curr_resp(round(curr_time*Fs:(curr_time+2.2)*Fs)+1);
        smpu_resp{kk}{jj}(end) = [];
    end
end
all_smpu_prots = [smpu_base{:}]+[smpu_stim{:}]/100;
unq_smpu_prots = unique(all_smpu_prots);
unq_smpu_base = floor(unq_smpu_prots);
unq_smpu_stim = round(rem(unq_smpu_prots,1)*100);

smpu_prot_resp = {};
for kk = 1:numel(unq_smpu_prots)
    curr_prot_idx = find(all_smpu_prots == unq_smpu_prots(kk));
    curr_prot_idx_ii = ceil(curr_prot_idx/15);
    curr_prot_idx_jj = mod(curr_prot_idx,15);
    curr_prot_idx_jj(curr_prot_idx_jj == 0) = 15;
    for jj = 1:5
        smpu_prot_resp{kk}{jj} = smpu_resp{...
            curr_prot_idx_ii(jj)}{...
            curr_prot_idx_jj(jj)};
    end
end

end

function [all_mean_bursts,all_resp,bw_peaks,bw_widths] = getBurstResponses(curr_freqs_prot,curr_freqs,Fs)
%Get smooth pursuit stuff
if nargin == 2
    Fs = 20000;
end
all_bw_peaks = [50, 100, 200];
all_bw_widths = [0.02 0.05 0.1];


burst_prots = find(cellfun(@numel,curr_freqs_prot{2}) > 500000 ...
                    & cellfun(@numel,curr_freqs_prot{2}) < 600002);
bw_peaks = round(cellfun(@max,curr_freqs_prot{2}(burst_prots)),-1);

%Extract individual trials for analysis
bw_widths = nan(size(bw_peaks));
all_resp = {};
% mean_resp = {};
for ii = 1:numel(burst_prots)
    curr_prot = curr_freqs_prot{2}{burst_prots(ii)};
    curr_prot = round(curr_prot,-1);
    stim_edges = find(abs(diff(curr_prot)) > 0);
    stim_locs = round(stim_edges(1:2:end)/Fs);
    if numel(stim_locs) ~= 5
        disp(['Burst prot does not seem right: ',num2str(ii)])
        
    else
        stim_width_est = diff(stim_edges(3:4))/Fs + 1/bw_peaks(ii);
        
        [~,I] = min(abs(stim_width_est - all_bw_widths));
        bw_widths(ii) = all_bw_widths(I);
        
        resp_width = (diff(stim_edges([3,5]))-1)/Fs;
        stim_locs = round(stim_edges(1:2:end)/Fs);
        
        all_resp{ii} = [];
        for jj = 1:numel(stim_locs)
            curr_resp = curr_freqs{2}{burst_prots(ii)}...
                (stim_locs(jj)*Fs+1:(stim_locs(jj)+resp_width)*Fs);
            all_resp{ii} =  [all_resp{ii}; curr_resp];
            
        end
        %mean_resp{ii} = mean(all_resp{ii});
    end
end

mean_burst_resp = cellfun(@(x) {mean(x)},all_resp);

%sort and concatenate
peak_order = [50, 100, 50, 100, 200, 100, 200, 200];
width_order = [0.05, 0.02, 0.1, 0.05, 0.02, 0.1, 0.05, 0.1];

all_mean_bursts = [];
for ii = 1:numel(peak_order)
    curr_idx = find(bw_peaks == peak_order(ii) & ...
        bw_widths == width_order(ii));
    all_mean_bursts = [all_mean_bursts, mean_burst_resp{curr_idx}];
end

end

function [rate_base, single_base, all_resp_base, rebound_base] = getBaselineResponses(curr_freqs_prot,curr_freqs,Fs)
if nargin == 2
    Fs = 20000;
end
all_bw_peaks = [100 101, 102.5, 105, 110, 120, 140];

%Guess right prots based on lenght and sequence
baseline_prots = find(cellfun(@numel,curr_freqs_prot{2}) == 400001);

baseline_peaks = cellfun(@(x) x(5.05*Fs), curr_freqs_prot{2}(baseline_prots));
baseline_peaks(1:2:end) = [];
for ii = 1:numel(baseline_peaks)
    [~,I] = min(abs(baseline_peaks(ii)-all_bw_peaks));
    baseline_peaks(ii) = all_bw_peaks(I);
end

rate_base = {};
single_base ={};
all_resp_base = {};
rebound_base = {};
mean_resp_base = {};
for ii = 1:numel(baseline_peaks)
    curr_prot_single = curr_freqs_prot{2}{baseline_prots(2*ii-1)};
    curr_prot_single = round(curr_prot_single,-2);
    stim_edges_single = find(abs(diff(curr_prot_single)) > 0);
    stim_loc = round(stim_edges_single(1),-2);
    rate_base{ii} = curr_freqs{2}{baseline_prots(2*ii-1)}...
           (stim_loc-2*Fs:stim_loc-1);
    single_base{ii} = curr_freqs{2}{baseline_prots(2*ii-1)}...
           (stim_loc:end);
    
    curr_prot = curr_freqs_prot{2}{baseline_prots(2*ii)};
    curr_prot = round(curr_prot,-2);
    stim_edges = find(abs(diff(curr_prot)) > 0);
    stim_width_est = diff(stim_edges(3:4))/Fs + 1/baseline_peaks(ii);
    
       
    resp_width_base = round((diff(stim_edges([3,5]))-1)/Fs);
    stim_locs = round(stim_edges(1:2:end)/Fs,0);
    
    all_resp_base{ii} = [];
    for jj = 1:numel(stim_locs)
        curr_resp = curr_freqs{2}{baseline_prots(2*ii)}...
           (stim_locs(jj)*Fs+1:(stim_locs(jj)+resp_width_base)*Fs);
        all_resp_base{ii} =  [all_resp_base{ii}; curr_resp];
        
    end
    mean_resp_base{ii} = mean(all_resp_base{ii});
    
    curr_resp = curr_freqs{2}{baseline_prots(2*ii)};
    rebound_base{ii} = curr_resp(stim_locs(end)*Fs+1:end);
end



end



function ax = makeUBCHeatmap(ax, currTraces,limX)
% if nargin == 2
%     limX = [4.5 15];
% end
% Fs2 = 20000;
imagesc(currTraces');
% caxis([0 max(mAmp)+mean(mBaseline)])
% caxis([0 1.2])
xlabel('Time (s)')
ylabel('Cell (#)')
% xlim(Fs2*limX)

% xticks(Fs2*[0 5 15 25])
% xticklabels(cellfun(@num2str,{-5 0 10 20},'UniformOutput',false))

% yticks([1 numel(ONidx)-numel(OFFidx) numel(ONidx)]);
set(ax,'TickDir','out','FontName','Arial','FontSize',8.8,'LineWidth',1)
box off
% title('Firing rate')
end

function fig = plotBaselineStuff(median_HD,median_Amp,median_baseline,Fs,mean_pre_response,baseline_data)
fig = figure;
colormap gray


ax1 = subplot(1,4,1);
[~,HDidx] = sort(median_HD);
% HDidx = [HDidx(2:end), HDidx(1)];
norm_value = median_Amp(HDidx) + median_baseline(HDidx);

x_range = 4*Fs:25*Fs;
imagesc(mean_pre_response(HDidx,x_range)./norm_value')
caxis([0 1.2])
xticks(Fs*[1 6 11 16])
xticklabels(cellfun(@num2str,{0 5 10 15},'UniformOutput',false))
xlabel('Time (s)')
ylabel('Cell (#)')

ax2 = subplot(1,4,2:4);
unpack_trace = cellfun(@(x) {[x{:}]},baseline_data);
unpack_trace = vertcat(unpack_trace{:});

   

imagesc(unpack_trace(HDidx,:)./norm_value')
caxis([0 1.2])
end_time = size(unpack_trace,2);
incr = end_time/7;
xticks(1:incr:end_time);
ax2.XTickLabels = [0,1,2.5,5,10,20,40];
xlabel('Baseline firing rate (spk/s)');
% sgtitle('Baseline firing rate')
standardFig()

end
