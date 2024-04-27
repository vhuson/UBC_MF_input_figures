function [all_slow_amp,all_slow_HD,all_pause,all_delta_spikes,...
    all_fast_amp,all_fast_HD,all_burst_baseline,...
    all_delta_spikes_stim,all_delta_spikes_post,...
    all_delta_spikes_stim_global_base, all_delta_spikes_post_global_base,...
    all_sum_spikes_stim,all_sum_spikes_post,all_train_half_decay] = ...
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

plot_on = false;

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
all_delta_spikes = all_fast_amp;
all_delta_spikes_stim = all_fast_amp;
all_delta_spikes_post = all_fast_amp;
all_delta_spikes_stim_global_base = all_fast_amp;
all_delta_spikes_post_global_base = all_fast_amp;
all_burst_baseline = all_fast_amp;
all_sum_spikes_stim = all_fast_amp;
all_sum_spikes_post = all_fast_amp;
all_train_half_decay = all_fast_amp;



if plot_on
    figure;
end

%Loop over all traces
for ii = find(~empty_fltr')

    curr_trace = mean_train_traces{ii};
    
    % Get global baseline and just use
    global_base_trace = curr_trace(1:5*Fs-1);
    global_baseline = mean(global_base_trace);
    
    % Loop over all segments to analyze (Skipping first for now)
    for jj=2:numel(step_starts)
        
        %Get index of current segment
        curr_start = (step_starts(jj) + start_delay) *Fs+1;
        curr_step_end = (step_starts(jj) +step_dur)*Fs;
        curr_end = (step_starts(jj) +step_dur+post_step_dur)*Fs;
        
        %Get baseline from 1s preceding current segment
        if ~opts.global_basetrace
            base_trace = curr_trace(curr_start-Fs*2-1:curr_start-1);
            clean_base_trace = clean_trace_segment_fun(...
                base_trace,step_size(1),2,0,Fs);
            clean_base_trace(1:Fs+1) = [];
            base_trace(1:Fs+1) = [];
            
        else
            base_trace = global_base_trace;
        end
        

        %Clean up potential noise from baseline firing
        clean_trace_segment = clean_trace_segment_fun(...
            curr_trace(curr_start:curr_end),step_size(1),post_step_dur,step_dur-8e-3,Fs);


        [main_pars, supp_pars, smoothTrace] = getUBCparameters2(...
            clean_trace_segment,clean_base_trace,step_dur-start_delay,Fs);
        if isempty(main_pars.pause_exc)
            main_pars.pause_exc = 0;
        end
        

        % Get half decay time
        [train_half_decay,train_hd_idx] = get_train_half_decay(clean_trace_segment,step_dur,...
            main_pars.slow_tpeak,main_pars.slow_amp,main_pars.baseline,Fs);

        


        %Recalculate n_spikes
        main_pars.n_spikes = sum(curr_trace(curr_start:curr_end)) /Fs - ...
            mean(base_trace) * (step_dur+post_step_dur);
        

        sum_spikes_stim = sum(curr_trace(curr_start:curr_step_end)) /Fs;
        n_spikes_stim = sum_spikes_stim - ...
            mean(base_trace) * (step_dur);

        sum_spikes_post = sum(curr_trace(curr_step_end+1:curr_end)) /Fs;
        n_spikes_post = sum_spikes_post - ...
            mean(base_trace) * (post_step_dur);

        %Calculate global spikes always
        n_spikes_stim_global_base = sum_spikes_stim - ...
            global_baseline * (step_dur);
        n_spikes_post_global_base = sum_spikes_post - ...
            global_baseline * (post_step_dur);

        if plot_on
            plot_UBC_parameter_ests(main_pars, supp_pars, ...
                smoothTrace,curr_trace(curr_start:(curr_start + step_dur*Fs)))
            title(['Cell #',num2str(ii),' step:',num2str(step_size(jj))])
            %Add to plot
            hold on
            plot(train_hd_idx,main_pars.slow_amp/2+main_pars.baseline,'bo');
            hold off
            disp(train_half_decay)
            pause
        end

        %Store (same segments together)
        all_fast_amp{jj-1}(ii) = main_pars.fast_amp;
        all_fast_HD{jj-1}(ii)  = main_pars.HD_fast;
        all_slow_amp{jj-1}(ii) = main_pars.slow_amp;
        all_slow_HD{jj-1}(ii)  = main_pars.HD;
        all_pause{jj-1}(ii)    = main_pars.pause_exc;
        all_delta_spikes{jj-1}(ii) = main_pars.n_spikes;
        all_delta_spikes_stim{jj-1}(ii) = n_spikes_stim;
        all_delta_spikes_post{jj-1}(ii) = n_spikes_post;
        all_delta_spikes_stim_global_base{jj-1}(ii) = n_spikes_stim_global_base;
        all_delta_spikes_post_global_base{jj-1}(ii) = n_spikes_post_global_base;
        all_burst_baseline{jj-1}(ii) = main_pars.baseline;

        all_sum_spikes_stim{jj-1}(ii) = sum_spikes_stim;
        all_sum_spikes_post{jj-1}(ii) = sum_spikes_post;

        all_train_half_decay{jj-1}(ii) = train_half_decay;
    end

end

end


function [clean_trace_segment] = clean_trace_segment_fun(curr_trace_segment,base_fr,trace_dur,offset,Fs)

%Clean up potential noise from baseline firing

%Get baseline firing input locations
base_rate_isi = 1/base_fr;
base_rate_isi_fs = round(base_rate_isi *Fs);
base_rate_idx = cumsum(ones(1,ceil(trace_dur/base_rate_isi))*base_rate_isi);
base_rate_idx = base_rate_idx + offset;
base_rate_idx = round(base_rate_idx*Fs);
base_rate_idx(end) = [];

% curr_trace_segment = curr_trace(curr_start:curr_end);
curr_trace_spks = abs(diff(curr_trace_segment)) > 0;

%Find the last spike preceding the input
br_last_spk = nan(size(base_rate_idx));
for br_n = 1:numel(base_rate_idx)
    %Find previous spike
    last_spk = find(curr_trace_spks(1:base_rate_idx(br_n)),1,'last');

    %define max distance 25% back
    window_cutoff = base_rate_idx(br_n) - base_rate_isi_fs*0.25;
    if isempty(last_spk) %no spike found
        %Use idx just before input
        br_last_spk(br_n) = base_rate_idx(br_n)-1;
    elseif last_spk >= window_cutoff %Good last spk take point before
        br_last_spk(br_n) = last_spk - 1;
    else %Last spike may belong to response to previous input
        br_last_spk(br_n) = last_spk + 1;
    end
end

% repeat for final spike of the trace
last_spk = find(curr_trace_spks,1,'last');
%define max distance
window_cutoff = base_rate_idx(end) + base_rate_isi_fs*0.75;
if isempty(last_spk) %no spike found
    %Use last index
    br_last_spk(end+1) = numel(curr_trace_spks);
elseif last_spk >= window_cutoff %Good last spk take point before
    br_last_spk(end+1) = last_spk - 1;
else %Last spike may belong to response to previous input
    br_last_spk(end+1) = last_spk + 1;
end

    
clean_trace_segment = curr_trace_segment;
for br_n = 1:numel(base_rate_idx)
    start_idx = br_last_spk(br_n);
    end_idx = br_last_spk(br_n+1);

    start_rate = curr_trace_segment(start_idx);
    end_rate = curr_trace_segment(end_idx);

    diff_rate = end_rate-start_rate;
    diff_idx = end_idx-start_idx;

    if diff_idx > 0
        if diff_rate ~= 0
            interp_trace = start_rate:diff_rate/diff_idx:end_rate;
        else
            interp_trace = repmat(start_rate,1,diff_idx+1);
        end

        clean_trace_segment(start_idx:end_idx) = interp_trace;
    end

end
% figure; plot(curr_trace_segment); hold on; plot(clean_trace_segment)

end

function [train_half_decay,train_hd_idx] = get_train_half_decay(...
    trace_segment,time_0,peak_time,peak_amp,baseline,Fs)
%find the moment of half-decay
search_start = round(max([time_0,peak_time])*Fs);
search_level = peak_amp/2 + baseline;

train_hd_idx = find(trace_segment(search_start:end)<search_level,1,"first");

if isempty(train_hd_idx)
    train_hd_idx = numel(trace_segment)+1;
else
    train_hd_idx = train_hd_idx+search_start;
end

train_half_decay = train_hd_idx/Fs - time_0;


end