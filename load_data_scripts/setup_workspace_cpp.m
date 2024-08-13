if exist('cpp_workspace','var') && cpp_workspace
    %Preserve workspace for later?
    disp('CPP data already loaded in workspace')
else %No workspace setup time to load
%% Get files
%
Fs = 20000;

fileNames = dir('data_analyzed\MF_stim_CPP_washin_saved\*');
fileNames = fileNames(contains({fileNames(:).name},'.mat'));


badCellNames = {};
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
cpp_workspace = true;
end