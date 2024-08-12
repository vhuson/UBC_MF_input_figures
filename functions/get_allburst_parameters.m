function [all_slow_amp,all_slow_HD,all_pause,all_n_spikes,...
    all_fast_amp,all_fast_HD,all_burst_baseline,all_main_pars,all_supp_pars] = get_allburst_parameters(...
    all_mean_bursts,all_baseline,Fs,opts)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
base_opts.restrict_peaks = false; %add cell array with windows to restrict
base_opts.limit_nspikes = false; %add cell array with limits to restrict
base_opts.post_stim_amp = false;
base_opts.post_stim_par = false;

if nargin < 4
    opts = base_opts;
else
    opts = merge_structs(base_opts,opts);
end

stim_start = 0.5;
stim_dur = [0.01 0.02 0.05 0.1 0.2];

all_fast_amp = repmat({nan(size(all_baseline))},size(all_mean_bursts));
all_fast_HD  = all_fast_amp;
all_slow_amp = all_fast_amp;
all_slow_HD  = all_fast_amp;
all_pause    = all_fast_amp;
all_n_spikes = all_fast_amp;
all_burst_baseline = all_fast_amp;
all_main_pars = repmat({cell(size(all_baseline))},size(all_mean_bursts));
all_supp_pars = all_main_pars;


for ii = 1:numel(all_baseline)
    for jj = 1:numel(all_mean_bursts)
        curr_trace = all_mean_bursts{jj}(ii,:);
        curr_trace(isnan(curr_trace)) = all_baseline(ii);

        curr_start = round(stim_start * Fs);
        
        par_opts = struct();
        if ~islogical(opts.restrict_peaks)
            par_opts.restrict_peak = opts.restrict_peaks{jj}{ii};
        else
            par_opts.restrict_peak = false; 
        end
        if ~islogical(opts.limit_nspikes)
            par_opts.restrict_nspikes = opts.limit_nspikes{jj}{ii};
        else
            par_opts.restrict_nspikes = false; 
        end
        if opts.post_stim_par
            par_opts.post_stim_pars = true;
        end
        [main_pars, supp_pars] = getUBCparameters2(...
            curr_trace(curr_start:end),curr_trace(1:curr_start-1),stim_dur(jj),Fs,par_opts);
        
        % make a plot/?
        if false
        dummy_main_pars = main_pars;
        dummy_supp_pars = supp_pars;
        dummy_main_pars.slow_tpeak = main_pars.post_stim_tpeak;
        dummy_supp_pars.slow_peak = supp_pars.post_stim_peak;
        plot_ubc_w_pars(curr_trace(curr_start:end),dummy_main_pars,dummy_supp_pars,Fs)
        title([num2str(ii),' : ',num2str(jj)]);
        pause
        end

        all_fast_amp{jj}(ii) = main_pars.fast_amp;
        all_fast_HD{jj}(ii)  = main_pars.HD_fast;
        if opts.post_stim_amp
            all_slow_amp{jj}(ii) = main_pars.post_stim_amp;
        else
            all_slow_amp{jj}(ii) = main_pars.slow_amp;
        end
        all_slow_HD{jj}(ii)  = main_pars.HD;
        all_pause{jj}(ii)    = main_pars.pause;
        all_n_spikes{jj}(ii) = main_pars.n_spikes;
        all_burst_baseline{jj}(ii) = main_pars.baseline;

        all_main_pars{jj}{ii} = main_pars;
        all_supp_pars{jj}{ii} = supp_pars;

    end
end

end