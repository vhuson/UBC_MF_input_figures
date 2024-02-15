function plot_ubc_w_pars(curr_data,...
    mp,sp,Fs)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
plot((1:numel(curr_data))/Fs,curr_data,'k')



hold on
scatter(mp.fast_tpeak,sp.fast_peak);
scatter(mp.slow_tpeak,sp.slow_peak);
line([0 numel(curr_data)/Fs],...
    repmat(mp.baseline,1,2),'Color',[0.7 0.7 0.7],...
    'LineStyle','--');
line([0 mp.pause],repmat(sp.freqThres,1,2),'Color','r');
line([sp.firstHalf_fast sp.lastHalf_fast]/Fs,...
    repmat(mp.baseline+mp.fast_amp/2,1,2),'Color','g');
line([sp.firstHalf sp.lastHalf]/Fs,...
    repmat(mp.baseline+mp.slow_amp/2,1,2),'Color','b');
hold off

end