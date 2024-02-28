function [curr_ax] = plot_UBC_parameter_ests(main_pars, supp_pars, smoothTrace, avgTrace)
%UNTITLED11 Summary of this function goes here
%   Detailed explanation goes here
plot(avgTrace);

hold on;
plot(smoothTrace);
plot([1 numel(smoothTrace)],[main_pars.baseline main_pars.baseline])

plot(supp_pars.fast_tpeak_samples,main_pars.fast_amp+main_pars.baseline, 'ro')

plot(supp_pars.slow_tpeak_samples,main_pars.slow_amp+main_pars.baseline, 'go')

plot([1 supp_pars.freqStart],[supp_pars.freqThres supp_pars.freqThres],'k')


plot([supp_pars.firstHalf supp_pars.lastHalf],...
    [main_pars.slow_amp main_pars.slow_amp]./2 +main_pars.baseline,'g')

hold off

end