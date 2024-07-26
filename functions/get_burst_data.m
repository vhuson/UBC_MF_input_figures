function [all_mean_traces,all_full_traces] = ...
    get_burst_data(allData,Fs,all_burst_durs, all_burst_tails,...
    washin_state,opts)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% all_burst_durs      = [0.01 0.02 0.05 0.10 0.2];
% all_burst_tails     = [2.9    3    10   10   10];

base_opts.get_median = false;
base_opts.pretime = 0.5;
base_opts.get_1s = true;
base_opts.alt_tail = 1;
base_opts.fix_20x100 = true;

if nargin < 6
    opts = base_opts;
else
    opts = merge_structs(base_opts,opts);
end



%amount of time to get prior to stimulation
pretime = opts.pretime;

%Get alternative single stimuli
get_1s = opts.get_1s;
alt_tail = opts.alt_tail;

%Selective about 20x 100Hz
fix_20x100 = opts.fix_20x100;


all_full_traces     = cell(1,numel(all_burst_durs));
all_mean_traces     = cell(1,numel(all_burst_durs));
all_idx             = cell(1,numel(all_burst_durs));


prot_spec_freq = [0 100 0];

% prot_spec_dur = [2 10];
% washin_state = [1 0 0 0 0];

%Get basic traces and matches

for ii = 1:numel(all_burst_durs)
    burst_dur = all_burst_durs(ii);
    burst_tail = all_burst_tails(ii);
    
    prot_spec_dur = [2 burst_dur burst_tail-burst_dur];


    %Extract right traces
    prot_opts = struct();
    prot_opts.get_median = opts.get_median;
    [mean_match_traces,all_match_traces,all_match_idx] = ...
        gather_spec_prot_trace(allData,Fs,...
        prot_spec_freq,prot_spec_dur,washin_state,pretime,prot_opts);


    all_mean_traces{ii} = mean_match_traces;
    all_full_traces{ii} = all_match_traces;
    all_idx{ii}         = all_match_idx;
end


%Fix missing singles?
if get_1s
    
    burst_dur = 0.01;
    burst_tail = alt_tail;
    
    prot_spec_dur = [2 burst_dur burst_tail-burst_dur];

    %Extract right traces
    [mean_match_traces,all_match_traces,all_match_idx] = ...
        gather_spec_prot_trace(allData,Fs,...
        prot_spec_freq,prot_spec_dur,washin_state,0,prot_opts);

    idx_1s = all_burst_durs == 0.01;
    idx_nan = isnan(all_mean_traces{idx_1s}(:,1));

    curr_len = size(mean_match_traces,2);
    curr_start = round(pretime * Fs);
    curr_end = curr_len + curr_start;

    all_mean_traces{idx_1s}(idx_nan,curr_start+1:curr_end) = mean_match_traces(idx_nan,:);
    all_full_traces{idx_1s}(idx_nan)            = all_match_traces(idx_nan);
    all_idx{idx_1s}(idx_nan)                    = all_match_idx(idx_nan);
end


%Clean up 20x 100Hz?
if fix_20x100
    idx_20x100 = all_burst_durs == 0.2;

    all_idx_20x = all_idx{idx_20x100};

    for ii = 1:numel(all_idx_20x)
        curr_idxes = all_idx_20x{ii};
        use_idxes = false(size(curr_idxes(:,1)));

        if all(curr_idxes(:,1) == 1) && numel(use_idxes) > 3
            %We don't have a specific protocol, just use last 3
            use_idxes(end-2:end) = true;
        else
            use_idxes(curr_idxes(:,1) ~= 1) = true;        
        end

        all_full_traces{idx_20x100}{ii}(~use_idxes,:) = [];
        all_mean_traces{idx_20x100}(ii,:) = mean(all_full_traces{idx_20x100}{ii},1);
        all_idx{idx_20x100}{ii}(~use_idxes,:) = [];
    end

end

end