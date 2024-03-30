function [fig1] = plot_individual_UBC(traces,Fs,curr_file_names,Amp,baseline,...
    HD,sPause,freqs,currCell,opts)
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here
base_opts.typCell = 1;
base_opts.cellRange = 1:numel(freqs{1});
base_opts.startT = 4.5;
base_opts.stimEnd = 5.2001;
base_opts.endT = 	10;

if nargin < 10
    opts = base_opts;
else
    opts = merge_structs(base_opts,opts);
end


freqs2 = freqs{1};
freqs2 = vertcat(freqs2{:})';


T=30;
xTime = 1/Fs:1/Fs:T;

traces2 = traces{1};
traces2 = [traces2{:}];

fig1 = figure('Color','w','Position', [209 181 974 581]);

post_stim = find(diff(find(contains(curr_file_names,'100Hz'))) > 2)+2.5;
if isempty(post_stim)
    post_stim = numel(freqs{1})+0.5;
end
typCell = opts.typCell;
cellRange = opts.cellRange;
startT = opts.startT ;
stimEnd = opts.stimEnd;
endT = 	opts.endT;
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
end