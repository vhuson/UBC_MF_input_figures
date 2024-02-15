function [match_traces] = gather_spec_prot(freqs,Fs,split_idx,match_times,match_dur)
%gather_spec_prot Take in idexes and return trace fragments
%   Detailed explanation goes here

%Get match starts but only use next sample
match_starts = round(match_times*Fs)+1;
match_dur_samples = round(match_dur*Fs);

match_ends = match_starts+match_dur_samples-1;


match_traces = nan(numel(match_times),match_dur_samples);
for ii = 1:size(split_idx,1)
    curr_trace = freqs{split_idx(ii,1)}{split_idx(ii,2)};

    match_traces(ii,:) = curr_trace(match_starts(ii):match_ends(ii));

end

end