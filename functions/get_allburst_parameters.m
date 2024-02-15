function [all_slow_amp,all_slow_HD,all_pause,all_n_spikes,...
    all_fast_amp,all_fast_HD,all_burst_baseline] = get_allburst_parameters(...
    all_mean_bursts,all_baseline,Fs)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
stim_start = 0.5;
stim_dur = [0.01 0.02 0.05 0.1 0.2];

all_fast_amp = repmat({nan(size(all_baseline))},size(all_mean_bursts));
all_fast_HD  = all_fast_amp;
all_slow_amp = all_fast_amp;
all_slow_HD  = all_fast_amp;
all_pause    = all_fast_amp;
all_n_spikes = all_fast_amp;
all_burst_baseline = all_fast_amp;


for ii = 1:numel(all_baseline)
    for jj = 1:numel(all_mean_bursts)
        curr_trace = all_mean_bursts{jj}(ii,:);
        curr_trace(isnan(curr_trace)) = all_baseline(ii);

        curr_start = round(stim_start * Fs);
        
        [main_pars] = getUBCparameters2(...
            curr_trace(curr_start:end),curr_trace(1:curr_start-1),stim_dur(jj),Fs);

        % plot_ubc_w_pars(curr_trace(curr_start:end),main_pars,supp_pars,Fs)
        % pause

        all_fast_amp{jj}(ii) = main_pars.fast_amp;
        all_fast_HD{jj}(ii)  = main_pars.HD_fast;
        all_slow_amp{jj}(ii) = main_pars.slow_amp;
        all_slow_HD{jj}(ii)  = main_pars.HD;
        all_pause{jj}(ii)    = main_pars.pause;
        all_n_spikes{jj}(ii) = main_pars.n_spikes;
        all_burst_baseline{jj}(ii) = main_pars.baseline;

    end
end

end