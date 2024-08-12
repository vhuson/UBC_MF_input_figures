function [main_pars,supp_pars,smoothTrace] = getUBCparameters2(avgTrace,baseTrace,stim_end,Fs,opts)
%getUBCparameters Calculates basic UBC response parameters
%   Takes in an average trace where 0 is the time of stimulation, 
%   to do the calculations on
%   Also needs a vector to average for baseline firing rates.

%{
figure; plot(avgTrace); hold on
plot(smoothTrace); hold on
scatter(slow_tpeak,slow_amp)

scatter(fast_tpeak,fast_amp)
scatter([firstHalf lastHalf],repmat(slow_amp/2,1,2))
scatter([firstHalf_fast lastHalf_fast],repmat(fast_amp/2,1,2))
%}

base_opts.restrict_nspikes = false; %passing num_samples replaces HD_x2
base_opts.restrict_peak = false; %pass a 2 sample indexes to define window
base_opts.post_stim_pars = false;

if nargin < 4
    Fs = 20000;
end

if nargin < 5
    opts = base_opts;
else
    opts = merge_structs(base_opts,opts);
end

%Baseline
baseline = mean(baseTrace);

%Log time scale
[logFreqs,logMarks] = log_scale_resample(avgTrace,0,Fs);
%Smooth
smooth_log_freqs = medfilt1(logFreqs,round(Fs*0.1));
%Back to normal timescale
smoothTrace = interp1(logMarks,smooth_log_freqs,(1:numel(avgTrace))/Fs);
smoothTrace(isnan(smoothTrace)) = baseline;

%First peak after stimulation
start_point = round((stim_end - 0.01)*Fs) +1;
[post_stim_amp, post_stim_tpeak] = max(smoothTrace(start_point:end));
post_stim_tpeak = post_stim_tpeak + start_point -1;

%Fast peak (always unrestricted)
overhang = round((0.1+stim_end)*Fs);
fast_window = 1:overhang;
[fast_amp, fast_tpeak] = max(smoothTrace(fast_window));

%Slow peak (can be restricted)
if ~islogical(opts.restrict_peak)
    overhang = opts.restrict_peak(1);
    slow_window = overhang:opts.restrict_peak(2);
else
    overhang =fast_tpeak+Fs*0.05;
    slow_window = overhang:numel(avgTrace);
end

[slow_amp, slow_tpeak] = max(smoothTrace(slow_window));

if slow_tpeak == 1 && islogical(opts.restrict_peak)
    slow_amp = fast_amp;
    slow_tpeak = fast_tpeak;
else
    slow_tpeak = slow_tpeak + overhang;
end

if opts.post_stim_pars %post_stim_tpeak
    par_amp = post_stim_amp;
    par_tpeak = post_stim_tpeak;
else
    par_amp = slow_amp;
    par_tpeak = slow_tpeak;
end

%Pause
freqThres = min([6, max([par_amp, fast_amp])/2]);
freqStart = find(smoothTrace(1:par_tpeak)<freqThres,1,'last');
if isempty(freqStart)
    freqStart = 0;
end

pause = freqStart/Fs;


%Pause for excitatory UBCs
freqThres_exc = (par_amp-baseline)/3+baseline;
freqStart_exc = find(smoothTrace(1:par_tpeak)<freqThres_exc,1,'last');
if isempty(freqStart_exc)
    freqStart = 0;
end

pause_exc = freqStart_exc/Fs;
    

%Half-width
if (par_amp-baseline) > 1
    [firstHalf] = findUBChalfWidth(smoothTrace(1:par_tpeak)-baseline,...
        par_amp-baseline,'first');
    [lastHalf] = findUBChalfWidth(smoothTrace(par_tpeak:end)-baseline,...
        par_amp-baseline,'last')+par_tpeak-1;
else
    firstHalf = 0;
    lastHalf = 0;
end
HD = (lastHalf - firstHalf)/Fs;
    

%Half-width (fast)
if (fast_amp-baseline) > 1
    [firstHalf_fast] = findUBChalfWidth(smoothTrace(1:fast_tpeak)-baseline,...
        fast_amp-baseline,'first');
    [lastHalf_fast] = findUBChalfWidth(smoothTrace(fast_tpeak:end)-baseline,...
        fast_amp-baseline,'last')+fast_tpeak-1;
else
    firstHalf_fast = 0;
    lastHalf_fast = 0;
end

HD_fast = (lastHalf_fast - firstHalf_fast)/Fs;


%Number of spikes
if ~islogical(opts.restrict_nspikes)
    HD_x2 = opts.restrict_nspikes;
else
    if (slow_amp-baseline) > 1
        HD_x2 = max([round(lastHalf+(HD*Fs)),round(lastHalf_fast+(HD_fast*Fs))]);
        HD_x2 = min([HD_x2, numel(avgTrace)]);
    else
        HD_x2 = min([10*Fs, numel(avgTrace)]);
    end
end
n_spikes = (sum(avgTrace(1:HD_x2))-baseline*HD_x2)/Fs;
n_spikes_not_normalized = sum(avgTrace(1:HD_x2))/Fs;

% 
% %Check to see if trace makes sense
% % slow_est = (HD*slow_amp-baseline);
% % fast_est = (HD_fast*fast_amp-baseline);
% slow_est = (slow_tpeak/Fs*1.5*(slow_amp-baseline));
% fast_est = (fast_tpeak/Fs*1.5*(fast_amp-baseline));
% bad_est = [slow_est , fast_est]/3 > n_spikes;
% %Also fail if time to peak is slower than half-width
% bad_est(1) = bad_est(1) | slow_tpeak/Fs > HD;
% bad_est(2) = bad_est(2) | (fast_tpeak/Fs-pause) > HD_fast;
% %Also fail slow if too far from actual trace
% bad_est(1) =  bad_est(1) | slow_amp/avgTrace(slow_tpeak) < 0.75;
% 
% if any(bad_est)
%     temp_pause = pause;
%     %Not enough spikes might be a strange peak
%     fprintf(['\nBad trace!\nn_spikes = ',num2str(n_spikes),...
%         '\nslow estimate = ',num2str(slow_est),...
%         '\nfast estimate = ',num2str(fast_est),'\n'])
% 
%     if bad_est(1)
%         %Zero slow results
%         slow_amp = 0;
%         slow_tpeak = 0;
% %         pause = 0;
%         HD = 0;
%         firstHalf = 0;
%         lastHalf = 0;
%     end
%     if bad_est(2)
%         %Check HD/pause ratio to make sure
% %         if temp_pause > HD_fast*2.5
%         %Zero fast results
%         fast_amp = 0;
%         fast_tpeak = 0;
%         HD_fast = 0;
% %         end
%     end
% 
% end



main_pars = struct('baseline',baseline,'fast_amp',fast_amp-baseline,...
            'fast_tpeak',fast_tpeak/Fs,'slow_amp',slow_amp-baseline,...
            'slow_tpeak',slow_tpeak/Fs, 'post_stim_amp',post_stim_amp-baseline,...
            'post_stim_tpeak',post_stim_tpeak/Fs,...
            'pause',pause,'pause_exc',pause_exc,...
            'n_spikes',n_spikes,'HD',HD,'HD_fast',HD_fast);
        

supp_pars = struct('freqThres', freqThres, 'freqStart', freqStart,...
                    'freqThres_exc', freqThres_exc, 'freqStart_exc', freqStart_exc,...
                    'firstHalf',firstHalf, 'lastHalf', lastHalf,...
                    'firstHalf_fast',firstHalf_fast,...
                    'lastHalf_fast', lastHalf_fast,...
                    'fast_peak',fast_amp,'slow_peak',slow_amp,...
                    'post_stim_peak',post_stim_amp,'post_stim_tpeak_samples',post_stim_tpeak,...
                    'fast_tpeak_samples', fast_tpeak,...
                    'slow_tpeak_samples', slow_tpeak,...
                    'HD_x2',HD_x2,'n_spikes_not_normalized',n_spikes_not_normalized);       


end

function [half_point] = findUBChalfWidth(trace,peak_max,firstlast)
half_unfound = true;
curr_start = 1;
if strcmp(firstlast,'last')
    trace = fliplr(trace);
end
while half_unfound
    half_point = find(trace(curr_start:end) > peak_max/2,1,'first');
    half_unfound = false;
    if isempty(half_point)
        half_point = 0;
        if strcmp(firstlast,'last')
            half_point = numel(trace);
        end
        break
    end
%     curr_avg = mean(trace(curr_start + half_point:end));
    percent_below0 = sum(trace(curr_start + half_point:end)-peak_max/2 <0)...
        /numel(trace(curr_start + half_point:end));
    if percent_below0 > 0.15
        add_point = max([half_point, numel(trace)/1000]);
        curr_start = curr_start + round(add_point);
        half_unfound = true;
    end
end
half_point = half_point + curr_start-1;
if strcmp(firstlast,'last')
    half_point = numel(trace)-half_point;
end

end

