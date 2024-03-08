function [medianStats,smoothFreqs] = get_median_UBC_stats(...
    curr_file_names,freqs,Fs,washinIDs,opts)
%UNTITLED11 Summary of this function goes here
%   Detailed explanation goes here

base_opts.baseRange = 1;
base_opts.startPoint = 5.0;
base_opts.stimDur = 0.2;
base_opts.endPoint = 30;
base_opts.delay_startPoint = 0.0;
base_opts.smooth = 10;

if nargin < 4
    opts = base_opts;
else
    opts = merge_structs(base_opts,opts);
end

baseRange = opts.baseRange;
startPoint = opts.startPoint;
stimDur = opts.stimDur;
endPoint = opts.endPoint;

delay_startPoint = opts.delay_startPoint;

mBaseline=  [];
mAmp = [];
mHD = [];
mPause = [];
medianStats = struct();




smoothFreqs = [];
prot1_file_idx = contains(curr_file_names,'100Hz');

mFreq = mean(vertcat(freqs{1}{washinIDs(prot1_file_idx,1)}));

smoothFreq = medfilt1(mFreq(1:100:end),opts.smooth);


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
end