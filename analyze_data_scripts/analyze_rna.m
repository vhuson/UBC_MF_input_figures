if exist('rna_data_analyzed','var') && rna_data_analyzed
    disp('Analyzed rna data already in workspace')
else %No workspace setup time to load
ubcdat = readtable('..\data_analyzed\RNA_data\ubc_raw_expression.csv');
load('..\data_analyzed\RNA_data\umap_mock.mat')

% Get RNA counts
mcount = table2array(ubcdat(:,2:end));
mnames = ubcdat.Properties.VariableNames(2:end);



%Normalize counts
[n, k] = size(mcount);
mncount = mcount./repmat(sum(mcount,2),[1 k])*mean(sum(mcount,2));
mnncount = mncount./repmat(mean(mncount,1),[n 1]);

%Get log counts
mlogcount = log(1+mcount);
mlogncount = log(1+mncount);
mlognncount = log(mnncount);

rna_data_analyzed = true;
end