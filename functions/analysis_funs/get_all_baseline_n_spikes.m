function [raw_pars, basecorr_pars, supp_pars] = get_all_baseline_n_spikes(...
    all_full_traces,all_baselines,Fs,all_base_freqs)
%UNTITLED12 Summary of this function goes here
%   Detailed explanation goes here

%Find out what minimum trace length is
seg_samples = round(Fs./all_base_freqs);
min_samples = min(seg_samples);


%Initialize output variables
all_trace_segments = cell(size(all_full_traces));
all_corr_trace_segments = cell(size(all_full_traces));

all_peaks         = cell(size(all_full_traces));
all_avg_rate      = cell(size(all_full_traces));
all_async_full    = cell(size(all_full_traces));
all_async_min     = cell(size(all_full_traces));
all_n_spikes_full = cell(size(all_full_traces));
all_n_spikes_min  = cell(size(all_full_traces));

all_peaks_basecorr         = cell(size(all_full_traces));
all_async_full_basecorr    = cell(size(all_full_traces));
all_async_min_basecorr     = cell(size(all_full_traces));
all_n_spikes_full_basecorr = cell(size(all_full_traces));
all_n_spikes_min_basecorr  = cell(size(all_full_traces));

all_baseline_n_spikes_full = cell(size(all_full_traces));
all_baseline_n_spikes_min  = cell(size(all_full_traces));

for ii = 1:numel(all_full_traces)

    curr_traces = all_full_traces{ii};
    base_freq = all_base_freqs(ii);
    baseline_rate = all_baselines(ii);

    %Initialize output variables
    freq_trace_segments = cell(size(curr_traces,1),1);
    freq_corr_trace_segments = cell(size(curr_traces,1),1);

    freq_peaks         = cell(size(curr_traces,1),1);
    freq_avg_rate      = cell(size(curr_traces,1),1);
    freq_async_full    = cell(size(curr_traces,1),1);
    freq_async_min     = cell(size(curr_traces,1),1);
    freq_n_spikes_full = cell(size(curr_traces,1),1);
    freq_n_spikes_min  = cell(size(curr_traces,1),1);

    freq_peaks_basecorr         = cell(size(curr_traces,1),1);
    freq_async_full_basecorr    = cell(size(curr_traces,1),1);
    freq_async_min_basecorr     = cell(size(curr_traces,1),1);
    freq_n_spikes_full_basecorr = cell(size(curr_traces,1),1);
    freq_n_spikes_min_basecorr  = cell(size(curr_traces,1),1);

    
    freq_baseline_n_spikes_full = cell(size(curr_traces,1),1);
    freq_baseline_n_spikes_min  = cell(size(curr_traces,1),1);

    for jj = 1:size(curr_traces,1)
        %Segment trace into separate responses
        [curr_trace_segments] = segment_freqs_trace(curr_traces(jj,:),Fs,base_freq);

        %Remove background firing from neighboring segments
        curr_corr_trace_segments = curr_trace_segments;

        [row_hits, col_hits] = find(diff(curr_corr_trace_segments,[],2)' ~= 0);
        if ~isempty(col_hits)
            first_spikes = row_hits([true; (diff(col_hits) == 1)]);

            [row_hits, col_hits] = find(diff(fliplr(curr_corr_trace_segments),[],2)' ~= 0);
            first_encounters_idx = [true; (diff(col_hits) == 1)];
            last_spikes = row_hits(first_encounters_idx);
            
            cnt = 1;
            for kk = col_hits(first_encounters_idx)
                curr_corr_trace_segments(kk,1:first_spikes(cnt)) = 0;
                C(kk,end-(last_spikes(cnt)-1):end) = 0;
                cnt = cnt+1;
            end
        end
        % curr_corr_trace_segments was intended to be used to get more
        % accurate parameter estimates but it doesn't work for unclear
        % reasons so it is no longer used in the following parameter
        % estimates:

        %Get parameters full and minimal
        curr_peaks = max(curr_trace_segments(:,1:min_samples),[],2);

        curr_avg_rate = mean(curr_trace_segments,2);


        curr_async_full = mean(curr_trace_segments(:,end-100:end),2);
        curr_async_min = mean(curr_trace_segments(:,min_samples-100:min_samples),2);
        
        curr_n_spikes_full = sum(curr_trace_segments,2)./Fs;
        curr_n_spikes_min = sum(curr_trace_segments(:,1:min_samples),2)./Fs;
        
        
        %Get baseline corrected parameters
        curr_peaks_basecorr = curr_peaks - baseline_rate;

        curr_async_full_basecorr = curr_async_full - baseline_rate;
        curr_async_min_basecorr = curr_async_min - baseline_rate;

        curr_baseline_n_spikes_full = baseline_rate.*(seg_samples(ii)/Fs);
        curr_n_spikes_full_basecorr = curr_n_spikes_full - curr_baseline_n_spikes_full;

        curr_baseline_n_spikes_min = baseline_rate.*(min_samples/Fs);
        curr_n_spikes_min_basecorr = curr_n_spikes_min - curr_baseline_n_spikes_min;
        

        %Store results
        freq_trace_segments{jj} = curr_trace_segments;
        freq_corr_trace_segments{jj} = curr_corr_trace_segments;

        freq_peaks{jj} = curr_peaks;
        freq_avg_rate{jj} = curr_avg_rate;
        freq_async_full{jj} = curr_async_full;
        freq_async_min{jj} = curr_async_min;
        freq_n_spikes_full{jj} = curr_n_spikes_full;
        freq_n_spikes_min{jj} = curr_n_spikes_min;

        freq_peaks_basecorr{jj} = curr_peaks_basecorr;
        freq_async_full_basecorr{jj} = curr_async_full_basecorr;
        freq_async_min_basecorr{jj} = curr_async_min_basecorr;
        freq_n_spikes_full_basecorr{jj} = curr_n_spikes_full_basecorr;
        freq_n_spikes_min_basecorr{jj} = curr_n_spikes_min_basecorr;


        freq_baseline_n_spikes_full{jj} = curr_baseline_n_spikes_full;
        freq_baseline_n_spikes_min{jj} = curr_baseline_n_spikes_min;

    end

    %Store results in output variables
    all_trace_segments{ii} = freq_trace_segments;
    all_corr_trace_segments{ii} = freq_corr_trace_segments;

    all_peaks{ii} = freq_peaks;
    all_avg_rate{ii} = freq_avg_rate;
    all_async_full{ii} = freq_async_full;
    all_async_min{ii} = freq_async_min;
    all_n_spikes_full{ii} = freq_n_spikes_full;
    all_n_spikes_min{ii} = freq_n_spikes_min;

    all_peaks_basecorr{ii} = freq_peaks_basecorr;
    all_async_full_basecorr{ii} = freq_async_full_basecorr;
    all_async_min_basecorr{ii} = freq_async_min_basecorr;
    all_n_spikes_full_basecorr{ii} = freq_n_spikes_full_basecorr;
    all_n_spikes_min_basecorr{ii} = freq_n_spikes_min_basecorr;

    all_baseline_n_spikes_full{ii} = freq_baseline_n_spikes_full;
    all_baseline_n_spikes_min{ii} = freq_baseline_n_spikes_min;


end

%Package in output structures
raw_pars = struct('peaks',all_peaks,'avg_rate',all_avg_rate,...
    'async_full',all_async_full,'async_min',all_async_min,...
    'n_spikes_full',all_n_spikes_full,'n_spikes_min',all_n_spikes_min);

basecorr_pars = struct('peaks',all_peaks_basecorr,...
    'async_full',all_async_full_basecorr,'async_min',all_async_min_basecorr,...
    'n_spikes_full',all_n_spikes_full_basecorr,'n_spikes_min',all_n_spikes_min_basecorr);

supp_pars = struct('trace_segments',all_trace_segments,...
        'corr_trace_segments',all_corr_trace_segments,...
        'baseline_n_spikes_full',all_baseline_n_spikes_full,...
        'baseline_n_spikes_min',all_baseline_n_spikes_min);

end