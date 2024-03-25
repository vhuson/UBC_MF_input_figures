function [freqs,spks,traces,freqs_prot,spks_prot,Spk,sPause,...
    curr_file_names,use_old,freqs_old,Spk_old,sPause_old] = ...
    run_UBC_spike_detection(currCell, fileNames,opts)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
%Detection parameters
base_opts.max_peak = 2000;
base_opts.min_peak = 40;
base_opts.cut_peak = 20;
base_opts.min_width = 0.1e-3;

%Loop options
base_opts.prot_start = 1;
base_opts.rec_start = 1;
base_opts.p1_pause = true;
base_opts.p2_pause = true;
base_opts.plot_on = true;

base_opts.use_old = false;


%100Hz basic pars
base_opts.startP = 5;
base_opts.stimDur = 0.201;
base_opts.endP = 20;

%Artifact removal options
base_opts.fbuff = 19;
base_opts.bbuff = 35;
base_opts.art_pad = 1;

if nargin < 3
    opts = base_opts;
else
    opts = merge_structs(base_opts,opts);
end

%initialize result variables
freqs = {};
freqs_old = {};
spks = {};
traces = {};

freqs_prot = {};
spks_prot = {};
Spk = {};
sPause = {};
Spk_old = {};
sPause_old = {};


% Get right filenames
all_file_names = {fileNames.name};
idx = contains(all_file_names,currCell);
curr_file_names = all_file_names(idx);


%Seperate protcols out
prot_file_names = {};
prot_file_names{1} = curr_file_names(contains(curr_file_names,'100Hz'));
%use same order as protnames
prot_file_names{2} = curr_file_names(~contains(curr_file_names,'100Hz'));


%Unpack options
%Detection parameters
max_peak = opts.max_peak;
min_peak = opts.min_peak;
cut_peak = opts.cut_peak;
min_width = opts.min_width;

%Loop parameters
prot_start = opts.prot_start;
rec_start = opts.rec_start;
p1_pause = opts.p1_pause;
p2_pause = opts.p2_pause;
plot_on = opts.plot_on;

%100Hz basic pars
startP = opts.startP;
stimDur = opts.stimDur;
endP = opts.endP;

%Replicate parameters for each recording
all_maxpeak = cell(2,1);
all_maxpeak{1} = repmat(max_peak,size(prot_file_names{1}));
all_maxpeak{2} = repmat(max_peak,size(prot_file_names{2}));

all_minpeak = cell(2,1);
all_minpeak{1} = repmat(min_peak,size(prot_file_names{1}));
all_minpeak{2} = repmat(min_peak,size(prot_file_names{2}));

all_cutpeak = cell(2,1);
all_cutpeak{1} = repmat(cut_peak,size(prot_file_names{1}));
all_cutpeak{2} = repmat(cut_peak,size(prot_file_names{2}));

all_minwidth = cell(2,1);
all_minwidth{1} = repmat(min_width,size(prot_file_names{1}));
all_minwidth{2} = repmat(min_width,size(prot_file_names{2}));

% Initialize use old variable
if opts.use_old
    use_old = {true(size(prot_file_names{1})), true(size(prot_file_names{2}))};
    disp("Old is on")
else
    use_old = {false(size(prot_file_names{1})), false(size(prot_file_names{2}))};

end

if plot_on
    ftrace = figure('Position', [81 109 1.2888e+03 534.4000]);
end

pp = prot_start;
break_loop = false;
while pp <= numel(prot_file_names)
    ii = rec_start;
    while ii <= numel(prot_file_names{pp})
        %set parameters
        detect_opts = struct();
        detect_opts.max_peak = all_maxpeak{pp}(ii);
        detect_opts.min_peak = all_minpeak{pp}(ii);
        detect_opts.cut_peak = all_cutpeak{pp}(ii);
        detect_opts.min_width = all_minwidth{pp}(ii);
        %Artifact removal options
        detect_opts.fbuff = opts.fbuff;
        detect_opts.bbuff = opts.bbuff;
        detect_opts.art_pad = opts.art_pad;


        %Load data
        data = IBWread(...
            fullfile(fileNames(1).folder,prot_file_names{pp}{ii}));
        Fs = 1/data.dx;
        T = data.Nsam*data.dx;

        [pv,pid,pv_old,pid_old,pid_prot,corr_trace,detrend_trace] = ...
            detectUBC_spikes(data,detect_opts);

        
        %Save results
        freqs{pp}{ii} = time2rate(pid,Fs,T);
        freqs_old{pp}{ii} = time2rate(pid_old,Fs,T);
        spks{pp}{ii} = pid*(T*Fs);
        traces{pp}{ii} = data.y(1:Fs*T);
        
        freqs_prot{pp}{ii} = time2rate(pid_prot,Fs,T);
        spks_prot{pp}{ii} = pid_prot/Fs;

        %100Hz prot results only
        if pp == 1
            Spk{pp}(ii) = sum(pid>startP*Fs & pid<endP*Fs);
            pausePos = find(pid>(startP+stimDur)*Fs, 1, 'first');
            if ~isempty(pausePos)
                sPause{pp}(ii) = pid(pausePos)/Fs-(startP+stimDur);
            else
                sPause{pp}(ii) = NaN;
            end

            Spk_old{pp}(ii) = sum(pid_old>startP*Fs & pid_old<endP*Fs);
            pausePos_old = find(pid_old>(startP+stimDur)*Fs, 1, 'first');
            if ~isempty(pausePos_old)
                sPause_old{pp}(ii) = pid_old(pausePos_old)/Fs-(startP+stimDur);
            else
                sPause_old{pp}(ii) = NaN;
            end
        end

        %Do plot?
        if plot_on
            %Plot results
            plot_UBC_spike_detection(ftrace,pp,ii,freqs_prot,pid_prot,detrend_trace,...
                                    corr_trace,pid,pv,pid_old,pv_old,...
                                    freqs_old,freqs,Fs,T)

            %Ask user input
            [ii_new,curr_max_peak,curr_min_peak,curr_cut_peak,curr_min_width,...
                curr_use_old, break_loop] = UBC_detect_input(ii,detect_opts,use_old{pp}(ii));
            
            
            all_maxpeak{pp}(ii) = curr_max_peak;
            all_minpeak{pp}(ii) = curr_min_peak;
            all_cutpeak{pp}(ii) = curr_cut_peak;
            all_minwidth{pp}(ii)= curr_min_width;
            use_old{pp}(ii)     = curr_use_old;
            
            ii = ii_new;

            if break_loop
                break;
            end
        else
            ii = ii+1;
        end
    end

    if break_loop
        break;
    end

    pp = pp+1;
end