if exist('burst_pharma_data_analyzed','var') && burst_pharma_data_analyzed
    disp('Analyzed burst data already in workspace')
else %No workspace setup time to load
%% Gather burst pharma data
%First need to gather baseline data for all washin states
washin_states = {[1 0 0 0 0],[0 1 0 0 0],[0 1 1 0 0],[0 1 1 1 0]};
[washin_base_rates] = get_washin_baselines(allData,washin_states,Fs);

all_burst_durs      = [0.01 0.02 0.05 0.10 0.2];
all_burst_tails     = [2.9    3    10   10   10];
washin_state = [0 1 1 0 0];

%Get traces
[all_mean_pharma_bursts3,~] = ...
    get_burst_data(allData,Fs,all_burst_durs, all_burst_tails,...
    washin_state);

washin_fltr = ~isnan(all_mean_pharma_bursts3{end}(:,1));

%USe mglur2 first


%Restrict slow peak to end of stimulation
% all_starts = round(all_burst_durs*Fs);
% all_ends = cellfun(@(x) size(x,2),all_mean_pharma_bursts1)-round(0.5*Fs);
% all_peak_windows = arrayfun(@(x,y) {repmat({[x,y]},numel(allData(washin_fltr)),1)},all_starts,all_ends);
burstpar_opts = struct('post_stim_amp',true);
% burstpar_opts.restrict_peaks = all_peak_windows;

washin_state = [0 1 0 0 0];

%Get traces 2
[all_mean_pharma_bursts2,all_full_pharma_bursts2] = ...
    get_burst_data(allData(washin_fltr),Fs,all_burst_durs, all_burst_tails,...
    washin_state);
all_median_pharma_bursts2 = ...
    get_burst_data(allData(washin_fltr),Fs,all_burst_durs, all_burst_tails,...
    washin_state,struct('get_median',true));

%Get UBC parameters 2
[all_pharma_slow_amp2,all_pharma_slow_HD2,all_pharma_pause2,...
    all_pharma_n_spikes2,~,~,~,~,all_supp_pars2] = get_allburst_parameters(...
    all_median_pharma_bursts2,washin_base_rates{2}(washin_fltr),Fs,burstpar_opts);


all_nspike_limits = repmat({cell(size(all_supp_pars2{1}))},1,numel(all_supp_pars2));


for ii = 1:numel(all_supp_pars2)
    for jj = 1:numel(all_supp_pars2{ii})
        curr_HDx2 = all_supp_pars2{ii}{jj}.HD_x2;
        all_nspike_limits{ii}{jj} = curr_HDx2;
    end
end

burstpar_opts.limit_nspikes = all_nspike_limits;


washin_state = [1 0 0 0 0];

%Get traces 1
[all_mean_pharma_bursts1,all_full_pharma_bursts1] = ...
    get_burst_data(allData(washin_fltr),Fs,all_burst_durs, all_burst_tails,...
    washin_state);
all_median_pharma_bursts1 = ...
    get_burst_data(allData(washin_fltr),Fs,all_burst_durs, all_burst_tails,...
    washin_state,struct('get_median',true));

%Get UBC parameters 1
[all_pharma_slow_amp1,all_pharma_slow_HD1,all_pharma_pause1,...
    all_pharma_n_spikes1,~,~,~,~,all_supp_pars1] = get_allburst_parameters(...
    all_median_pharma_bursts1,washin_base_rates{1}(washin_fltr),Fs,burstpar_opts);



washin_state = [0 1 1 0 0];

%Get traces 3
[all_mean_pharma_bursts3,all_full_pharma_bursts3] = ...
    get_burst_data(allData(washin_fltr),Fs,all_burst_durs, all_burst_tails,...
    washin_state);
all_median_pharma_bursts3 = ...
    get_burst_data(allData(washin_fltr),Fs,all_burst_durs, all_burst_tails,...
    washin_state,struct('get_median',true));

%Get UBC parameters 3
[all_pharma_slow_amp3,all_pharma_slow_HD3,all_pharma_pause3,...
    all_pharma_n_spikes3,~,~,~,~,all_supp_pars3] = get_allburst_parameters(...
    all_median_pharma_bursts3,washin_base_rates{3}(washin_fltr),Fs,burstpar_opts);






all_peak_windows = repmat({cell(size(all_supp_pars3{1}))},1,numel(all_supp_pars3));



for ii = 1:numel(all_supp_pars3)
    % curr_min_start = round(all_burst_durs(ii)*Fs);
    curr_min_start = 1;
    for jj = 1:numel(all_supp_pars3{ii})
        curr_start = all_supp_pars3{ii}{jj}.freqStart;
        curr_last_half = all_supp_pars3{ii}{jj}.lastHalf;
        curr_HDx2 = all_supp_pars3{ii}{jj}.HD_x2;
        curr_slow_tpeak = all_supp_pars3{ii}{jj}.slow_tpeak_samples;
        curr_fast_tpeak = all_supp_pars3{ii}{jj}.fast_tpeak_samples;
        
        %Make sure we don't start before fast peak
        if curr_slow_tpeak > curr_fast_tpeak 
            curr_start = max([curr_start, curr_fast_tpeak+Fs*0.05]);
        end
        curr_start = max([curr_start, curr_min_start]);
        
        %Make sure we have a last half even when there was no peak
        if curr_last_half < 1
            curr_last_half = floor(curr_HDx2/2);
        end
        if curr_last_half < curr_min_start
            curr_last_half = max([curr_min_start, curr_HDx2]);
        end
        
        %Make sure we have a window
        if curr_start > curr_last_half
            curr_start = curr_min_start;
        end

        all_peak_windows{ii}{jj} = [curr_start curr_last_half];
        % all_peak_windows{ii}{jj} = [curr_start curr_HDx2];
    end
end
burstpar_opts.restrict_peaks = all_peak_windows;



washin_state = [0 1 1 1 0];

%Get traces 4
[all_mean_pharma_bursts4,all_full_pharma_bursts4] = ...
    get_burst_data(allData(washin_fltr),Fs,all_burst_durs, all_burst_tails,...
    washin_state);
all_median_pharma_bursts4 = ...
    get_burst_data(allData(washin_fltr),Fs,all_burst_durs, all_burst_tails,...
    washin_state,struct('get_median',true));


%Get UBC parameters 4
[all_pharma_slow_amp4,all_pharma_slow_HD4,all_pharma_pause4,...
    all_pharma_n_spikes4,~,~,~,~,all_supp_pars4] = get_allburst_parameters(...
    all_median_pharma_bursts4,washin_base_rates{4}(washin_fltr),Fs,burstpar_opts);

% Just pharma onidx
[fltr_ONidx] = get_fltr_ONidx(ONidx,find(washin_fltr));


%Use baseline for NaNs
all_mean_pharma_bursts_all = {all_mean_pharma_bursts1,...
                              all_mean_pharma_bursts2,...
                              all_mean_pharma_bursts3,...
                              all_mean_pharma_bursts4};

for jj = 1:numel(all_mean_pharma_bursts_all)
    curr_mean_pharma_bursts = all_mean_pharma_bursts_all{jj};
    curr_baseline = washin_base_rates{jj}(washin_fltr);
    for ii = 1:size(curr_mean_pharma_bursts{1},1)
        curr_trace = curr_mean_pharma_bursts{1}(ii,:);

        %Fill with zeros
        curr_trace(isnan(curr_trace)) = 0;

        %Fill up to first spike with baseline
        first_nozero = find(curr_trace ~= 0,1,"first");
        curr_trace(1:first_nozero) = curr_baseline(ii);

        %Put back into array
        curr_mean_pharma_bursts{1}(ii,:) = curr_trace;

    end
    all_mean_pharma_bursts_all{jj} = curr_mean_pharma_bursts;
end
all_mean_pharma_bursts1 = all_mean_pharma_bursts_all{1};
all_mean_pharma_bursts2 = all_mean_pharma_bursts_all{2};
all_mean_pharma_bursts3 = all_mean_pharma_bursts_all{3};
all_mean_pharma_bursts4 = all_mean_pharma_bursts_all{4};

%% Calculate fractional increases and decreases

base_to_mglur2_percentchange = zeros(numel(all_supp_pars1{1}),numel(all_supp_pars1));
base_to_mglur2_delta = zeros(numel(all_supp_pars1{1}),numel(all_supp_pars1));
mglur2_to_ampar_percentchange = base_to_mglur2_percentchange;
mglur2_to_mglur1_percentchange = base_to_mglur2_percentchange;

mgluR2_normalized_to_20base = base_to_mglur2_percentchange;
base_normalized_to_20base = base_to_mglur2_percentchange;

normalized_to_20_base = cell(1,4);

for ii = 1:numel(all_supp_pars1)
    for jj = 1:numel(all_supp_pars1{1})
        curr_base_nspikes = all_supp_pars1{ii}{jj}.n_spikes_not_normalized;
        curr_mglur2_nspikes = all_supp_pars2{ii}{jj}.n_spikes_not_normalized;
        curr_ampar_nspikes = all_supp_pars3{ii}{jj}.n_spikes_not_normalized;
        curr_mglur1_nspikes = all_supp_pars4{ii}{jj}.n_spikes_not_normalized;
        
        mgluR2_normalized_to_20base(jj,ii) = all_supp_pars2{ii}{jj}.n_spikes_not_normalized...
                            ./ all_supp_pars1{5}{jj}.n_spikes_not_normalized;
        base_normalized_to_20base(jj,ii) = all_supp_pars1{ii}{jj}.n_spikes_not_normalized...
                            ./ all_supp_pars1{5}{jj}.n_spikes_not_normalized;

        
        normalized_to_20_base{1}(jj,ii) = all_supp_pars1{ii}{jj}.n_spikes_not_normalized...
                            ./ all_supp_pars1{5}{jj}.n_spikes_not_normalized;

        normalized_to_20_base{2}(jj,ii) = all_supp_pars2{ii}{jj}.n_spikes_not_normalized...
                            ./ all_supp_pars1{5}{jj}.n_spikes_not_normalized;

        normalized_to_20_base{3}(jj,ii) = all_supp_pars3{ii}{jj}.n_spikes_not_normalized...
                            ./ all_supp_pars1{5}{jj}.n_spikes_not_normalized;

        normalized_to_20_base{4}(jj,ii) = all_supp_pars4{ii}{jj}.n_spikes_not_normalized...
                            ./ all_supp_pars1{5}{jj}.n_spikes_not_normalized;
        


        


        base_to_mglur2_percentchange(jj,ii) = ...
            curr_mglur2_nspikes / curr_base_nspikes *100 -100;
        base_to_mglur2_delta(jj,ii) = ...
            curr_mglur2_nspikes - curr_base_nspikes;
        mglur2_to_ampar_percentchange(jj,ii) = ...
            curr_ampar_nspikes / curr_mglur2_nspikes *100 -100;
        mglur2_to_mglur1_percentchange(jj,ii) = ...
            curr_mglur1_nspikes / curr_mglur2_nspikes *100 -100;
    end
end

burst_pharma_data_analyzed = true;
end