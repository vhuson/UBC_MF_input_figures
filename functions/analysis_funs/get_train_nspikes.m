function [all_nspikes, all_nspikes_base_corr, all_nspikes_global_basecorr] = get_train_nspikes(mean_train_traces,spike_windows,Fs,opts)
%get_train_parameters: Get UBC instant frequency response parameters
%Note fast parameters are rarely meaningful in the train responses
base_opts = struct();

if nargin < 3
    Fs = 20000;
end

if nargin < 4
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
curr_nspikes = repmat({nan(size(mean_train_traces))},size(step_starts(2:end)'));
all_nspikes = repmat({curr_nspikes},size(spike_windows));
all_nspikes_base_corr = all_nspikes;
all_nspikes_global_basecorr = all_nspikes;

if plot_on
    figure;
end

%Loop over all traces
for ii = find(~empty_fltr')

    curr_trace = mean_train_traces{ii};
    
    % Get global baseline and just use
    global_base_trace = curr_trace(1:step_starts(1)*Fs-1);
    global_baseline = mean(global_base_trace);
    
    % Loop over all segments to analyze (Skipping first for now)
    for jj=2:numel(step_starts)

        %Get index of current segment
        curr_start = (step_starts(jj) + start_delay) *Fs+1;


        %Get baseline from 1s preceding current segment
        base_trace = curr_trace(curr_start-Fs-1:curr_start-1);
            

        %Loop over all spike_windows
        for window_idx = 1:numel(spike_windows)
            curr_window = spike_windows{window_idx};

            %Get index of current window
            curr_w_start = (step_starts(jj) + curr_window(1)) *Fs+1;
            curr_w_end = (step_starts(jj) + curr_window(2)) *Fs;


            %Calculate n_spikes
            curr_nspikes = sum(curr_trace(curr_w_start:curr_w_end)) /Fs;
            curr_nspikes_basecorr = curr_nspikes - ...
                mean(base_trace) * diff(curr_window);
            curr_nspikes_global_basecorr = curr_nspikes - ...
                global_baseline * diff(curr_window);
            
            %Put in array
            all_nspikes{window_idx}{jj-1}(ii) = curr_nspikes;
            all_nspikes_base_corr{window_idx}{jj-1}(ii) = curr_nspikes_basecorr;
            all_nspikes_global_basecorr{window_idx}{jj-1}(ii) = curr_nspikes_global_basecorr;

        end
    end
end

end

