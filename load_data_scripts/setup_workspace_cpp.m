if exist('cpp_workspace','var') && cpp_workspace
    %Preserve workspace for later?
    disp('CPP data already loaded in workspace')
else %No workspace setup time to load
%% Get files
%
Fs = 20000;

fileNames_cpp = dir('..\data_analyzed\MF_stim_CPP_washin_saved\*');
fileNames_cpp = fileNames_cpp(contains({fileNames_cpp(:).name},'.mat'));


badCellNames = {};
removeCells = find(cellfun(@(x) ismember(x,badCellNames),{fileNames_cpp(:).name}));



if ~isempty(removeCells)
    fileNames_cpp(removeCells) = [];
end


allData_cpp = cell(size(fileNames_cpp));

for ii = 1:numel(fileNames_cpp)
    allData_cpp{ii} = load(fullfile(fileNames_cpp(ii).folder,fileNames_cpp(ii).name));
end


%% Get all median stats

all_HD_cpp = cellfun(@(x) x.medianStats.HD,allData_cpp);
all_pause_cpp = cellfun(@(x) x.medianStats.pause,allData_cpp);
all_Amp_cpp = cellfun(@(x) x.medianStats.Amp,allData_cpp);
all_baseline_cpp = cellfun(@(x) x.medianStats.baseline,allData_cpp);

%{
figure;
plot(1:numel(all_HD),sort(all_HD),'ko')
set(gca,'YScale','log');

%}

%% Get sorting index
%Select Pure OFF by Amp
OFFidx_cpp = find(all_Amp_cpp<8);
%Add manually
OFFnames = {};
cellIdx = find(cellfun(@(x) contains(x,OFFnames),{fileNames_cpp.name}));
OFFidx_cpp = [OFFidx_cpp,cellIdx];
%Remove manually
OFFnames = {};
cellIdx = find(cellfun(@(x) contains(x,OFFnames),{fileNames_cpp.name}));
OFFidx_cpp(ismember(OFFidx_cpp,cellIdx)) = [];



%Sort non OFF by HD or fit width
% [~,ONidx] = sort(mHD2);
[~,ONidx_cpp] = sort(all_HD_cpp);
ONidx_cpp = ONidx_cpp(:)';
ONidx_cpp = [ONidx_cpp(~ismember(ONidx_cpp,OFFidx_cpp)) ONidx_cpp(ismember(ONidx_cpp,OFFidx_cpp))];

%Sort OFFs by pause
[~, OFFsort] = sort(all_pause_cpp(ONidx_cpp(end-numel(OFFidx_cpp)+1:end)));
ONidx_cpp(end-numel(OFFidx_cpp)+1:end) = ONidx_cpp(OFFsort+(numel(ONidx_cpp)-numel(OFFidx_cpp)));
OFFidx_cpp = ONidx_cpp(end-numel(OFFidx_cpp)+1:end);
%Remove bad cells
% badCells = [120    40    14    49   31];
% ONidx(ismember(ONidx,badCells)) = [];
%}
cpp_workspace = true;
end