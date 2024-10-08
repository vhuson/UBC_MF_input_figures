function [pv,pid,pv_old,pid_old,pid_prot,corr_trace,detrend_trace] = detectUBC_spikes(data,opts)
%UNTITLED2 Summary of this function goes here

base_opts.max_peak = 2000;
base_opts.min_peak = 40;
base_opts.cut_peak = 20;
base_opts.cut_peak_max = 2000;
base_opts.min_width = 0.1e-3;
base_opts.fbuff = 19;
base_opts.bbuff = 35;
base_opts.art_pad = 1;

if nargin < 2
    opts = base_opts;
else
    opts = merge_structs(base_opts,opts);
end

curr_maxpeak = opts.max_peak;
curr_minPeak = opts.min_peak;
curr_minWidth = opts.min_width;
curr_cutPeak = opts.cut_peak;
curr_cutPeak_max = opts.cut_peak_max;

Fs = 1/data.dx;
T = data.Nsam*data.dx;


%Find stimulations and remove from trace
detrend = medfilt1(data.y,Fs);
detrend_trace = data.y-detrend;

[~, pid_prot] = findpeaks(detrend_trace,...
    'MinPeakProminence',curr_maxpeak,...'MinPeakHeight',20,...
    'MinPeakDistance',Fs/1000,'MinPeakWidth',1);

art_opts = struct('fbuff',opts.fbuff,'bbuff',opts.bbuff,'pad',opts.art_pad);
corr_trace = remove_artifacts(detrend_trace,pid_prot,art_opts);


%Find responses
[pv, pid] = findpeaks(-corr_trace,...
    'MinPeakProminence',curr_minPeak,...'MinPeakHeight',20,...
    'MinPeakDistance',Fs*4e-3,'MinPeakWidth',Fs*curr_minWidth);
pid(pv<curr_cutPeak) = [];
pv(pv<curr_cutPeak) = [];
pid(pv>curr_cutPeak_max) = [];
pv(pv>curr_cutPeak_max) = [];
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

pid_old = pid_old(local_range<curr_cutPeak_max & local_range>curr_cutPeak);
pv_old = pv_old(local_range<curr_cutPeak_max & local_range>curr_cutPeak);


end

