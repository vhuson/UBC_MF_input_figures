function [] = plot_UBC_spike_detection(ftrace,pp,ii,freqs_prot,pid_prot,detrend_trace,...
                                    corr_trace,pid,pv,pid_old,pv_old,...
                                    freqs_old,freqs,Fs,T,use_old)
if nargin < 16
    use_old = false;
end
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
set(0, 'currentfigure', ftrace);

subplot(5,1,1)
plot(1/Fs:1/Fs:T,freqs_prot{pp}{ii},'k')
xlim([0 T])
ylabel(['Stimulation (spk/s) n=',num2str(numel(pid_prot))])
title(num2str(ii))

subplot(5,1,2:3)
plot(1/Fs:1/Fs:T,corr_trace)
ylabel('Recording (pA)')
hold on;
plot(1/Fs:1/Fs:T,detrend_trace,'k')
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
if use_old
    plot(1/Fs:1/Fs:T,freqs{pp}{ii},'b')
else
    plot(1/Fs:1/Fs:T,freqs_old{pp}{ii},'b')
end
hold on
if use_old
    plot(1/Fs:1/Fs:T,freqs_old{pp}{ii},'k')
else
    plot(1/Fs:1/Fs:T,freqs{pp}{ii},'k')
end
hold off
xlim([0 T])
ylabel('Response (spk/s)')
xlabel('Time (s)')
linkaxes(ftrace.Children,'x')
end