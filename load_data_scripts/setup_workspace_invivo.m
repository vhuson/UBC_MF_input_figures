%% In vivo like inputs workspace setyp
%Set up path
mfile_name          = mfilename('fullpath');
[pathstr,name,ext]  = fileparts(mfile_name);
cd(pathstr);
cd('..')


addpath(genpath('functions'))
addpath(genpath('plot_MF_invivo_scripts'))

if exist('invivo_workspace','var') && invivo_workspace
    %Preserve workspace for later?
    disp('In vivo-like data already loaded in workspace')
else %No workspace setup time to load
%% Load cells
Fs = 20000;

% fileNames_invivo = dir('data_raw\MF_stim\saved\*');
% fileNames_invivo = fileNames_invivo(contains({fileNames_invivo(:).name},'.mat'));
% 
% fileNames_invivo2 = dir('data_analyzed\MF_stim_fastshutdown\*');
% fileNames_invivo2 = fileNames_invivo2(contains({fileNames_invivo2(:).name},'.mat'));
% 
% fileNames_invivo = [fileNames_invivo; fileNames_invivo2];

fileNames_invivo = dir('data_analyzed\MF_stim_invivo_all\*');
fileNames_invivo = fileNames_invivo(contains({fileNames_invivo(:).name},'.mat'));


badCellNames = {'Cell1848_analyzed.mat'};
removeCells = find(cellfun(@(x) ismember(x,badCellNames),{fileNames_invivo(:).name}));



if ~isempty(removeCells)
    fileNames_invivo(removeCells) = [];
end


allData_invivo = cell(size(fileNames_invivo));

for ii = 1:numel(fileNames_invivo)
    allData_invivo{ii} = load(fullfile(fileNames_invivo(ii).folder,fileNames_invivo(ii).name));    
end

%% Read protocols
fileProtocols = dir('data_raw\MF_stim\protocols\*');
[~,sortIdx]=sort([fileProtocols.datenum]);
fileProtocols = fileProtocols(sortIdx);

allProtNames = {fileProtocols(:).name};
allProtNames = allProtNames(endsWith(allProtNames, '.txt'));

prot_timings = cellfun(@(x) {csvread(fullfile(fileProtocols(1).folder,x))},...
                    allProtNames);


%% Get all median stats

all_HD_invivo = cellfun(@(x) x.medianStats.HD,allData_invivo);
all_pause_invivo = cellfun(@(x) x.medianStats.pause,allData_invivo);
all_Amp_invivo = cellfun(@(x) x.medianStats.Amp,allData_invivo);
all_baseline_invivo = cellfun(@(x) x.medianStats.baseline,allData_invivo);

%{
figure;
plot(1:numel(all_HD),sort(all_HD),'ko')
set(gca,'YScale','log');

%}

%% Get sorting index
%Select Pure OFF by Amp
OFFidx_invivo = find(all_Amp_invivo<8);
%Add manually
OFFnames = {};
cellIdx = find(cellfun(@(x) contains(x,OFFnames),{fileNames_invivo.name}));
OFFidx_invivo = [OFFidx_invivo,cellIdx];
%Remove manually
OFFnames = {'Cell1839'};
cellIdx = find(cellfun(@(x) contains(x,OFFnames),{fileNames_invivo.name}));
OFFidx_invivo(ismember(OFFidx_invivo,cellIdx)) = [];



%Sort non OFF by HD or fit width
% [~,ONidx] = sort(mHD2);
[~,ONidx_invivo] = sort(all_HD_invivo);
ONidx_invivo = ONidx_invivo(:)';
ONidx_invivo = [ONidx_invivo(~ismember(ONidx_invivo,OFFidx_invivo)) ONidx_invivo(ismember(ONidx_invivo,OFFidx_invivo))];

%Sort OFFs by pause
[~, OFFsort] = sort(all_pause_invivo(ONidx_invivo(end-numel(OFFidx_invivo)+1:end)));
ONidx_invivo(end-numel(OFFidx_invivo)+1:end) = ONidx_invivo(OFFsort+(numel(ONidx_invivo)-numel(OFFidx_invivo)));
OFFidx_invivo = ONidx_invivo(end-numel(OFFidx_invivo)+1:end);
%Remove bad cells
% badCells = [120    40    14    49   31];
% ONidx(ismember(ONidx,badCells)) = [];
%}


%% Gather all smooth pursuit and burst data
washin = [1 0 0 0 0];

file_match = 'IVburst';
[all_raw_IVburst] = get_mean_by_filecode(...
    allData_invivo,file_match,washin);

file_match = 'MF20_94';
[all_raw_IVburst2] = get_mean_by_filecode(...
    allData_invivo,file_match,washin);

old_idx = ~cellfun(@isempty,all_raw_IVburst2);
all_raw_IVburst(old_idx) = all_raw_IVburst2(old_idx);


file_match = 'SPpref';
[all_raw_IVSP] = get_mean_by_filecode(...
    allData_invivo,file_match,washin);

file_match = 'MF5_39';
[all_raw_IVSP2] = get_mean_by_filecode(...
    allData_invivo,file_match,washin);

old_idx = ~cellfun(@isempty,all_raw_IVSP2);
all_raw_IVSP(old_idx) = all_raw_IVSP2(old_idx);

%% Get mean traces
all_mean_IVburst = cell(size(all_raw_IVburst));
all_mean_IVSP = all_mean_IVburst;

all_full_IVburst = all_mean_IVburst;
all_full_IVSP = all_mean_IVburst;

for ii = 1:numel(all_raw_IVburst)
    curr_burst = all_raw_IVburst{ii};
    curr_SP    = all_raw_IVSP{ii};

    curr_length = numel(curr_burst);

    if curr_length == 1800003
        curr_burst_resps = reshape(curr_burst,[600001,3]);
        curr_SP_resps    = reshape(curr_SP,[600001,3]);
    elseif curr_length == 1200002
        curr_burst_resps = reshape(curr_burst,[600001,2]);
        curr_SP_resps    = reshape(curr_SP,[600001,2]);
    elseif curr_length == 3200003
        curr_burst(1:5*Fs) = []; %Cut off front bit
        curr_burst_resps = reshape(curr_burst(1:(600001*5)),[600001,5]);
        curr_burst_resps = curr_burst_resps(:,1:2:5);

        curr_SP(1:5*Fs) = []; %Cut off front bit
        curr_SP_resps = reshape(curr_SP(1:(600001*5)),[600001,5]);
        curr_SP_resps = curr_SP_resps(:,1:2:5);
    end
    
    all_full_IVburst{ii} = curr_burst_resps;
    all_full_IVSP{ii}    = curr_SP_resps;
    all_mean_IVburst{ii} = mean(curr_burst_resps,2);
    all_mean_IVSP{ii}    = mean(curr_SP_resps,2);

    all_mean_IVburst{ii} = all_mean_IVburst{ii}(1:600000);
    all_mean_IVSP{ii} = all_mean_IVSP{ii}(1:600000);
end
invivo_workspace = true;
end