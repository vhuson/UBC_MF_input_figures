function [all_slow_amp,all_slow_HD,all_pause,all_n_spikes,...
    all_fast_amp,all_fast_HD,all_burst_baseline,...
    all_n_spikes_stim,all_n_spikes_post] = ...
                                get_train_parameters(mean_train_traces,Fs,opts)
%get_train_parameters: Get UBC instant frequency response parameters
%Note fast parameters are rarely meaningful in the train responses
base_opts.global_basetrace = false;

if nargin < 2
    Fs = 20000;
end

if nargin < 3
    opts = base_opts;
else
    opts = merge_structs(base_opts,opts);
end

plot_on = true;

% Set parameters of the train
step_starts = [5, 8, 12, 16, 20, 24, 28, 32, 36];
step_size = [5, 10, 20, 30, 40, 50, 60, 20, 20];

step_dur = 1;
post_step_dur = 3;
start_delay = 0.0;

%Account for empty cells
empty_fltr = cellfun(@isempty,mean_train_traces);

%Initialize output variables
all_fast_amp = repmat({nan(size(mean_train_traces))},size(step_starts(2:end)'));
all_fast_HD  = all_fast_amp;
all_slow_amp = all_fast_amp;
all_slow_HD  = all_fast_amp;
all_pause    = all_fast_amp;
all_n_spikes = all_fast_amp;
all_n_spikes_stim = all_fast_amp;
all_n_spikes_post = all_fast_amp;
all_burst_baseline = all_fast_amp;

if plot_on
    figure;
end

%Loop over all traces
for ii = find(~empty_fltr')

    curr_trace = mean_train_traces{ii};
    
    % Get global baseline and just use
    if opts.global_basetrace
        base_trace = curr_trace(1:5*Fs-1);
    end
    % Loop over all segments to analyze (Skipping first for now)
    for jj=2:numel(step_starts)
        
        %Get index of current segment
        curr_start = (step_starts(jj) + start_delay) *Fs+1;
        curr_step_end = (step_starts(jj) +step_dur)*Fs;
        curr_end = (step_starts(jj) +step_dur+post_step_dur)*Fs;
        
        %Get baseline from 1s preceding current segment
        if ~opts.global_basetrace
            base_trace = curr_trace(curr_start-Fs:curr_start-1);
        end

        [main_pars, supp_pars, smoothTrace] = getUBCparameters2(...
            curr_trace(curr_start:curr_end),base_trace,step_dur-start_delay,Fs);

        %Recalculate n_spikes
        main_pars.n_spikes = sum(curr_trace(curr_start:curr_end)) /Fs - ...
            main_pars.baseline * (step_dur+post_step_dur);
        
        n_spikes_stim = sum(curr_trace(curr_start:curr_step_end)) /Fs - ...
            main_pars.baseline * (step_dur);
        n_spikes_post = sum(curr_trace(curr_step_end+1:curr_end)) /Fs - ...
            main_pars.baseline * (post_step_dur);

        if plot_on
            plot_UBC_parameter_ests(main_pars, supp_pars, ...
                smoothTrace,curr_trace(curr_start:(curr_start + step_dur*Fs)))
            title(['Cell #',num2str(ii),' step:',num2str(step_size(jj))])
            pause
        end

        %Store (same segments together)
        all_fast_amp{jj-1}(ii) = main_pars.fast_amp;
        all_fast_HD{jj-1}(ii)  = main_pars.HD_fast;
        all_slow_amp{jj-1}(ii) = main_pars.slow_amp;
        all_slow_HD{jj-1}(ii)  = main_pars.HD;
        all_pause{jj-1}(ii)    = main_pars.pause_exc;
        all_n_spikes{jj-1}(ii) = main_pars.n_spikes;
        all_n_spikes_stim{jj-1}(ii) = n_spikes_stim;
        all_n_spikes_post{jj-1}(ii) = n_spikes_post;
        all_burst_baseline{jj-1}(ii) = main_pars.baseline;
    end

end
end