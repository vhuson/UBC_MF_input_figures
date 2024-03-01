%Set up path
mfile_name          = mfilename('fullpath');
[pathstr,name,ext]  = fileparts(mfile_name);
cd(pathstr);

addpath(genpath('functions'))
addpath(genpath('plot_MF_baseline_pharma_scripts'))
addpath(genpath('plot_MF_baseline_scripts'))
addpath(genpath('plot_MF_burst_pharma_scripts'))
addpath(genpath('plot_MF_burst_scripts'))
addpath(genpath('plot_MF_train_pharma_scripts'))
addpath(genpath('plot_MF_train_scripts'))

%% Get files
%
Fs = 20000;

fileNames = dir('data_analyzed\MF_stim_prots_pharma_saved\*');
fileNames = fileNames(contains({fileNames(:).name},'.mat'));

fileNames2 = dir('data_analyzed\MF_stim_prots_pharma_saved_noWashin\*');
fileNames2 = fileNames2(contains({fileNames2(:).name},'.mat'));

fileNames3 = dir('data_analyzed\MF_stim_train_saved\*');
fileNames3 = fileNames3(contains({fileNames3(:).name},'.mat'));

fileNames4 = dir('data_analyzed\MF_stim_train_pharma_saved\*');
fileNames4 = fileNames4(contains({fileNames4(:).name},'.mat'));

fileNames = [fileNames; fileNames2; fileNames3; fileNames4];

badCellNames = {'Cell1747_analyzed.mat', 'Cell1748_analyzed.mat'};
removeCells = find(cellfun(@(x) ismember(x,badCellNames),{fileNames(:).name}));



if ~isempty(removeCells)
    fileNames(removeCells) = [];
end


allData = cell(size(fileNames));

for ii = 1:numel(fileNames)
    allData{ii} = load(fullfile(fileNames(ii).folder,fileNames(ii).name));
end


%% Get all median stats

all_HD = cellfun(@(x) x.medianStats.HD,allData);
all_pause = cellfun(@(x) x.medianStats.pause,allData);
all_Amp = cellfun(@(x) x.medianStats.Amp,allData);
all_baseline = cellfun(@(x) x.medianStats.baseline,allData);

%{
figure;
plot(1:numel(all_HD),sort(all_HD),'ko')
set(gca,'YScale','log');

%}

%% Get sorting index
%Select Pure OFF by Amp
OFFidx = find(all_Amp<8);
%Add manually
OFFnames = {};
cellIdx = find(cellfun(@(x) contains(x,OFFnames),{fileNames.name}));
OFFidx = [OFFidx,cellIdx];
%Remove manually
OFFnames = {};
cellIdx = find(cellfun(@(x) contains(x,OFFnames),{fileNames.name}));
OFFidx(ismember(OFFidx,cellIdx)) = [];



%Sort non OFF by HD or fit width
% [~,ONidx] = sort(mHD2);
[~,ONidx] = sort(all_HD);
ONidx = ONidx(:)';
ONidx = [ONidx(~ismember(ONidx,OFFidx)) ONidx(ismember(ONidx,OFFidx))];

%Sort OFFs by pause
[~, OFFsort] = sort(all_pause(ONidx(end-numel(OFFidx)+1:end)));
ONidx(end-numel(OFFidx)+1:end) = ONidx(OFFsort+(numel(ONidx)-numel(OFFidx)));
OFFidx = ONidx(end-numel(OFFidx)+1:end);
%Remove bad cells
% badCells = [120    40    14    49   31];
% ONidx(ismember(ONidx,badCells)) = [];
%}
