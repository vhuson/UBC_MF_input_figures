%% Load ibws and analyze

%% Get filenames and unique cell names
[fileNames, allCellNames] = ...
    get_files_and_cellnames('data_raw\MF_stim_fastshutdown');

%% Run spike detection
currCell = allCellNames{6};

opts = struct();
opts.max_peak = 2000;
opts.min_peak = 40;
opts.cut_peak = 75;
opts.min_width = 0.1e-3;
opts.use_old = false;

opts.prot_start = 1;
opts.rec_start = 1;
[freqs,spks,traces,freqs_prot,spks_prot,Spk,sPause,...
    curr_file_names,use_old,freqs_old,Spk_old,sPause_old] = ...
    run_UBC_spike_detection(currCell, fileNames,opts);

%Replace old values were wanted
Spk{1}(use_old{1}) = Spk_old{1}(use_old{1});
sPause{1}(use_old{1}) = sPause_old{1}(use_old{1});
freqs{1}(use_old{1}) = freqs_old{1}(use_old{1});
freqs{2}(use_old{2}) = freqs_old{2}(use_old{2});

%% Discard a trace
%{
disc_p = 2;
disc_t = 4;
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
par_opts.smooth = 10;

[Amp, HD, baseline,sPause] = get_UBC_HD_and_amp(freqs,Fs,sPause,par_opts);

%% Plot individual
fig_opts = struct();
fig_opts.typCell = 4;
fig_opts.cellRange = [1:numel(freqs{1})];
fig_opts.startT = 4.5;
fig_opts.stimEnd = 5.2001;
fig_opts.endT = 	10;


[fig1] = plot_individual_UBC(traces,Fs,curr_file_names,Amp,baseline,...
    HD,sPause,freqs,currCell,fig_opts);


%% Add washin information
%{
    plotCurrentUBC(freqs,freqs_prot,traces,curr_file_names,Fs)
%}

washinStates = {'Baseline','LY 341495','NBQX',...
    'JNJ 16259685','Washout'};
washinID_states = {[1,0,0,0,0];...
                    [0,1,0,0,0];...
                    [0,1,1,0,0];...
                    [0,1,1,1,0];...
                    [0,0,0,0,1]};

washinConcentrations = {'','1 uM','5 uM','1 uM',''};


                
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
washinIDs = get_washinIDs(curr_file_names,washinID_states);



%% Calculate stats based on median freqs
med_opts = struct();
med_opts.baseRange = 1;
med_opts.startPoint = 5.0;
med_opts.stimDur = 0.2;
med_opts.endPoint = 30;
med_opts.delay_startPoint = 0.0;
med_opts.smooth = 5;

[medianStats, smoothFreqs] = get_median_UBC_stats(curr_file_names,freqs,Fs,washinIDs,med_opts);


%% Save cell
% cd('savedDCoN')
cd('data_analyzed\MF_stim_fastshutdown')
% cd('MF_stim_train_saved')
% cd('MF_stim_prots_pharma_saved_noWashin')
% cd('DCoN_All/savedDCoN_strych')

saveas(gcf,[currCell,'.png'])
save([currCell,'_analyzed.mat'],...
    'spks','traces','freqs','smoothFreqs','Spk','sPause',...
    'HD','Amp','baseline','curr_file_names','freqs_prot',...
    'spks_prot','washinStates','washinConcentrations','washinIDs',...
    'medianStats')
cd('..')
cd('..')
%{
currCell = 'Cell1675';

cd('MF_stim_prots_pharma_saved_noWashin')
save([currCell,'_analyzed.mat'],'washinStates','washinConcentrations','washinIDs',...
    'medianStats','bw_prots','-append')
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