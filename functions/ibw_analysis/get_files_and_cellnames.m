function [fileNames, allCellNames] = get_files_and_cellnames(file_path)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

fileNames = dir([file_path,'\*']);
[~,sortIdx]=sort([fileNames.datenum]);
fileNames = fileNames(sortIdx);

%Get unique cells
allCellNames = {fileNames(:).name};
allCellNames = allCellNames(1:end-1);

allCellNames = regexp(allCellNames,'Cell\d\d\d\d','match');
allCellNames = unique([allCellNames{:}]);
allCellNames = allCellNames(:);
end