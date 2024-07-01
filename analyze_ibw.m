%% Load ibws and analyze

%% Get filenames and unique cell names
% curr_path = 'data_raw\MF_stim_fastshutdown';
% curr_path = 'data_raw\MF_stim_trains';
% curr_path = 'data_raw\MF_stim_trains_pharma';
% curr_path = 'data_raw\MF_stim_invivo_pharma\**\*';
% curr_path = 'data_raw\MF_stim';
curr_path = 'data_raw\MF_stim_CPP_washin';

[fileNames, allCellNames] = ...
    get_files_and_cellnames(curr_path);

%% Run spike detection
currCell = allCellNames{5};

opts = struct();
opts.max_peak =1000;
opts.min_peak = 40;
opts.cut_peak = 15;
opts.cut_peak_max = 500;
opts.min_width = 0.1e-3;
opts.use_old = false;

opts.prot_start = 1;
opts.rec_start = 1;
%artifact removal
opts.fbuff = 19;
opts.bbuff = 90;
opts.art_pad = 5;


[freqs,spks,traces,freqs_prot,spks_prot,Spk,sPause,...
    curr_file_names,use_old,freqs_old,Spk_old,sPause_old] = ...
    run_UBC_spike_detection(currCell, fileNames,opts);

%Replace old values were wanted
Spk{1}(use_old{1}) = Spk_old{1}(use_old{1});
sPause{1}(use_old{1}) = sPause_old{1}(use_old{1});
freqs{1}(use_old{1}) = freqs_old{1}(use_old{1});
freqs{2}(use_old{2}) = freqs_old{2}(use_old{2});


%% Fix spks
% for ii = 1:numel(spks)
%     for jj = 1:numel(spks{ii})
%         T = numel(freqs{ii}{jj})/20000;
%         spks_new{ii}{jj} = spks{ii}{jj}./(T*20000)./20000;
%     end
% end

%% Remove outlier spikes
%
ftrace = figure;

rem_p = 2;
rem_t = 1:numel(freqs{rem_p});
maxHz = 300;
Fs = 20000;

spks_new = spks;
freqs_new = freqs;
for ii = 1:numel(rem_t)
    curr_t = rem_t(ii);
    T = numel(freqs{rem_p}{curr_t})/Fs;

    curr_spks = spks{rem_p}{curr_t};

    %Remove crazy spikes
    hz_idx = 1./diff(curr_spks);
    upper_lim = min([median(hz_idx)+mad(hz_idx)*10, maxHz]);
    bad_idx = find(hz_idx>upper_lim)+1;
    % curr_spks(bad_idx) = [];

    cnt = 1;
    while cnt <= numel(bad_idx)
        curr_spks(bad_idx(1)) = [];

        hz_idx = 1./diff(curr_spks);
        bad_idx = find(hz_idx>upper_lim)+1;
    end

    bad_idx = find(hz_idx>upper_lim)+1;
    curr_spks(bad_idx) = [];
    
    curr_pid = round(curr_spks*Fs);
    curr_freq = time2rate(curr_spks*Fs,Fs,T);
    
    spks_new{rem_p}{curr_t} = curr_spks;
    freqs_new{rem_p}{curr_t} = curr_freq;

    %Plot results
    old_pid = round(spks_prot{rem_p}{curr_t}*Fs);
    plot_UBC_spike_detection(ftrace,rem_p,curr_t,freqs_prot,...
        old_pid,traces{rem_p}{curr_t},...
        traces{rem_p}{curr_t},curr_pid,...
        traces{rem_p}{curr_t}(curr_pid),...
        old_pid,traces{rem_p}{curr_t}(old_pid),...
        freqs,freqs_new,Fs,T)

    pause

    
end

%spks = spks_new; freqs = freqs_new;
%}
%% Discard a trace
%{
disc_p = 2;
disc_t = 6;
disc_global = get_overall_idx(curr_file_names,[disc_p,disc_t]);

freqs{disc_p}(disc_t) = [];
spks{disc_p}(disc_t) = [];
traces{disc_p}(disc_t) = [];
freqs_prot{disc_p}(disc_t) = [];
spks_prot{disc_p}(disc_t) = [];
curr_file_names(disc_global) = [];


if disc_p == 1
Spk{disc_p}(disc_t) = [];
sPause{disc_p}(disc_t) = [];
end

%}
%% Get half-width and amplitude
Fs = 20000;

par_opts = struct();
par_opts.OFF = false;
par_opts.baseRange = 1;
par_opts.startPoint = 5.0;
par_opts.endPoint = 20;
par_opts.smooth = 180;

[Amp, HD, baseline,sPause] = get_UBC_HD_and_amp(freqs,Fs,sPause,par_opts);

%% Plot individual
fig_opts = struct();
fig_opts.typCell = 5;
fig_opts.cellRange = [1:numel(freqs{1})];
fig_opts.startT = 4.5;
fig_opts.stimEnd = 5.2001;
fig_opts.endT = 	20;
% fig_opts.post_stim = [10,19,29,39]+0.5;

[fig1] = plot_individual_UBC(traces,Fs,curr_file_names,Amp,baseline,...
    HD,sPause,freqs,currCell,fig_opts);


%% Add washin information
%{
    plotCurrentUBC(freqs,freqs_prot,traces,curr_file_names,Fs)
%}

temp_file_names = curr_file_names;
%{
%Fix filenames with basic protocol in the middle
fixed_files = curr_file_names;
mark_str = 'IVburst';
mark_prots = cellfun(@(x) ~isempty(strfind(x,mark_str)),fixed_files);

%Locations of names to change relative to marked prot
change_locs = [1,2];

for ii = find(mark_prots)
    fixed_files(ii+change_locs) = {'diff'};
end

temp_file_names = fixed_files;
%}

% washinStates = {'Baseline','LY 341495','NBQX',...
%     'JNJ 16259685','Washout','Washout'};
% washinID_states = {[1,0,0,0,0];...
%                     [0,1,0,0,0];...
%                     [0,1,1,0,0];...
%                     [0,1,1,1,0];...
%                     [0,0,0,0,1]};
% 
% washinConcentrations = {'','5 uM','5 uM','1 uM',''};

washinStates = {'Baseline','R-CPP','Washout'};
washinID_states = {[1,0,0];...
                    [0,1,0];...
                    [0,0,1]};

washinConcentrations = {'','5 uM',''};


                
% washinStates = {'Baseline','Stability 1','Stability 2',...
%     'Stability 3','Stability 4'};
% washinID_states = {[1,0,0,0,0];...
%                     [1,1,0,0,0];...
%                     [1,0,1,0,0];...
%                     [1,0,0,1,0];...
%                     [1,0,0,0,1]};                
%                 
% washinConcentrations = {'','','','',''};

%Suggest borders based on gaps
washinIDs = get_washinIDs(temp_file_names,washinID_states);



%% Calculate stats based on median freqs
med_opts = struct();
med_opts.baseRange = 1;
med_opts.startPoint = 5.0;
med_opts.stimDur = 0.2;
med_opts.endPoint = 13;
med_opts.delay_startPoint = 0.0;
med_opts.smooth = 120;



[medianStats, smoothFreqs] = get_median_UBC_stats(curr_file_names,freqs,Fs,washinIDs,med_opts);


%% Save cell

% cd('data_analyzed\MF_stim_fastshutdown')
% cd('data_analyzed\MF_stim_train_saved')
% cd('data_analyzed\MF_stim_train_pharma_saved')
% cd('data_analyzed\MF_stim_invivo_all');
cd('data_analyzed\MF_stim_CPP_washin_saved');


saveas(gcf,[currCell,'.png'])
save([currCell,'_analyzed.mat'],...
    'spks','traces','freqs','smoothFreqs','Spk','sPause',...
    'HD','Amp','baseline','curr_file_names','freqs_prot',...
    'spks_prot','washinStates','washinConcentrations','washinIDs',...
    'medianStats')
cd('..')
cd('..')

%% overwrite previously saved data
%{
currCell = 'Cell1755';

cd('data_analyzed\MF_stim_train_saved')
save([currCell,'_analyzed.mat'],'freqs_prot','spks_prot','-append')
cd('..')
%}

%% DONT RUN MINDLESSLY!!!! Crop based on washinstates
%Rerun median stats and bw_prots if possibly affected



%Define boolean vector of what to keep!
keep_idx = (washinIDs(:,1) | washinIDs(:,2))...
    & (~washinIDs(:,3) & ~washinIDs(:,4) & ~washinIDs(:,5));





%Split index by prot type
keep_idx1  = keep_idx(contains(curr_file_names,'100Hz'));
keep_idx2  = keep_idx(~contains(curr_file_names,'100Hz'));


spks{1} = spks{1}(keep_idx1);
spks{2} = spks{2}(keep_idx2);

traces{1} = traces{1}(keep_idx1);
traces{2} = traces{2}(keep_idx2);

freqs{1} = freqs{1}(keep_idx1);
freqs{2} = freqs{2}(keep_idx2);

Spk{1} = Spk{1}(keep_idx1);

sPause{1} = sPause{1}(keep_idx1);
HD = HD(keep_idx1);
Amp = Amp(keep_idx1);
baseline = baseline(keep_idx1);

curr_file_names = curr_file_names(keep_idx);

freqs_prot{1} = freqs_prot{1}(keep_idx1);
freqs_prot{2} = freqs_prot{2}(keep_idx2);

spks_prot{1} = spks_prot{1}(keep_idx1);
spks_prot{2} = spks_prot{2}(keep_idx2);

washinIDs = washinIDs(keep_idx,:);