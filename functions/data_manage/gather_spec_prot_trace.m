function [mean_match_traces,all_match_traces,all_idx,all_times] = ...
        gather_spec_prot_trace(allData,Fs,...
                    prot_spec_freq,prot_spec_dur,washin_state,pretime,opts)

%gather_spec_prot_trace Retrieve trace segments matching to spec_prot from
%all data
%   Detailed explanation goes here
% washin_state = [1 0 0 0 0];
% 
% prot_spec_freq = [0 100 0];
% prot_spec_dur = [2 0.05 9.95];
base_opts.ignore_first_dur = true;
base_opts.ignore_washout = true;
base_opts.get_median = false;

if nargin < 5
    %No washin_state given, ignore filtering
    washin_state = [];
end
if nargin < 6
    %No pretime given don't use
    pretime = 0;
end

if nargin < 7
    opts = base_opts;
else
    opts = merge_structs(base_opts,opts);
end

if opts.ignore_first_dur
    %First duration is a wild card usually tied to 0 frequency
    match_dur = sum(prot_spec_dur(2:end));
else
    %Take first duration as part of the protocol we want
    match_dur = sum(prot_spec_dur);
    
    if prot_spec_freq(1) > 0
    %First response is probably skipped add it to pretime and remove from
    %match dur
        pretime = pretime + 1/prot_spec_freq(1);
        match_dur = match_dur - 1/prot_spec_freq(1);
    end
end

if pretime > 0
    match_dur = match_dur + pretime;
end

%Setup outputs
mean_match_traces   = nan(numel(allData),round(match_dur*Fs));
all_match_traces    = cell(size(allData));
all_idx             = cell(size(allData));
all_times           = cell(size(allData));


%loop over all data
for ii = 1:numel(allData)
    %Set up cell variables
    spks_prot       = allData{ii}.spks_prot;
    freqs_prot      = allData{ii}.freqs_prot;
    curr_file_names = allData{ii}.curr_file_names;
    freqs           = allData{ii}.freqs;


    %Find right segments
    [split_idx, match_times] = find_prot_by_freq(prot_spec_freq,prot_spec_dur,...
        spks_prot,freqs_prot,Fs);
    %Clean match times to previous millisecond
    match_times = floor(match_times*1000)/1000;

    overall_idx = get_overall_idx(curr_file_names,split_idx);
    

    %Filter for right washin
    if ~isempty(washin_state)
        washinIDs = allData{ii}.washinIDs;
        %Filter based on washinID
        curr_washins    = washinIDs(overall_idx,:);
        if opts.ignore_washout
            washin_fltr     = all(curr_washins(:,1:end-1) == washin_state(:,1:end-1),2);
        else
            washin_fltr     = all(curr_washins == washin_state,2);
        end
        split_idx       = split_idx(washin_fltr,:);
        match_times     = match_times(washin_fltr);
    end

    %Add pre time if desired
    if pretime > 0
        match_times = match_times - pretime;
    end


    %Retrieve the selected segment
    [match_traces] = gather_spec_prot(freqs,Fs,split_idx,match_times,match_dur);
    

    %fill in outputs
    if opts.get_median
        mean_match_traces(ii,:) = median(match_traces,1);
    else
        mean_match_traces(ii,:) = mean(match_traces,1);
    end
    all_match_traces{ii}    = match_traces;
    all_idx{ii}             = split_idx;
    all_times{ii}           = match_times;
end

end