function [Amp, HD, baseline,sPause] = get_UBC_HD_and_amp(freqs,Fs,sPause,opts)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here
base_opts.OFF = false;
base_opts.baseRange = 1;
base_opts.startPoint = 5.0;
base_opts.endPoint = 10;
base_opts.smooth = 20;

if nargin < 2
    opts = base_opts;
else
    opts = merge_structs(base_opts,opts);
end

OFF = opts.OFF;
baseRange = opts.baseRange;
startPoint = opts.startPoint;
endPoint = opts.endPoint;


%Initialize output
Amp = [];
HD = [];
baseline = [];

freqs2 = freqs{1};

freqs2 = vertcat(freqs2{:})';
smoothFreqs = medfilt2(freqs2(1:100:end,:),[opts.smooth  1]);

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
end