function [split_idx, match_prots_times] = find_prot_by_freq(prot_spec_freq,prot_spec_dur,spks_prot,freqs_prot,Fs)
%UNTITLED Summary of this function goes here


%Construct spike profile
spike_profile = [];
for ii = 1:numel(prot_spec_freq)
    isi = 1/prot_spec_freq(ii);
    if isi == Inf
        isi = prot_spec_dur(ii);
        reps = 1;
    else
        reps = ceil(prot_spec_dur(ii)/isi)-1;
    end
    spike_profile = [spike_profile, repmat(isi,1,reps)];
end
spike_profile = round(spike_profile,2,'significant');
spike_profile = spike_profile(:);
profile_len = numel(spike_profile);


size_freqs_prots = cellfun(@numel,spks_prot);

all_prots = [spks_prot{:}];
all_prots_freqs = [freqs_prot{:}];

match_prots = [];
match_prots_times = [];

for ii = 1:numel(all_prots)
    curr_prot = all_prots{ii};
    curr_dur = numel(all_prots_freqs{ii})/Fs;

    curr_profile = diff([1/Fs; curr_prot; curr_dur]);
    curr_profile_round = round(curr_profile,2,'significant');
    curr_profile_round = curr_profile_round(:);

    %No information for first value assume its a zero for at least 2s
    curr_profile_round(1) = max([curr_profile_round(1),2]);

    num_pos = numel(curr_profile_round)-profile_len+1;

    for pos = 1:num_pos
        %Check if first and last values meet minimum
        if curr_profile_round(pos) >= spike_profile(1) && ...
            curr_profile_round(pos+profile_len-1) >= spike_profile(end)
            %Check values within tolerance
            diff_score = abs(curr_profile_round((pos+1):(pos+profile_len-2)) - ...
                            spike_profile(2:end-1));

            if all(diff_score<1e-4)
                %That's a hit, mark position and time
                match_prots = [match_prots,ii];
                match_prots_times = [match_prots_times,sum(curr_profile(1:pos))];
            end                

        end
    end


end

%Convert match indexing to split indexing
idx1 = ones(numel(match_prots),1);
idx2 = match_prots(:);

idx2_fltr = match_prots > size_freqs_prots(1);
idx1(idx2_fltr) = 2;
idx2(idx2_fltr) = idx2(idx2_fltr) - size_freqs_prots(1);

split_idx = [idx1, idx2];

end