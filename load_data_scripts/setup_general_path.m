%Set up path
mfile_name          = mfilename('fullpath');
[pathstr,name,ext]  = fileparts(mfile_name);
cd(pathstr);
cd('..')

addpath(genpath('functions'))
addpath(genpath('plot_MF_baseline_pharma_scripts'))
addpath(genpath('plot_MF_baseline_scripts'))
addpath(genpath('plot_MF_burst_pharma_scripts'))
addpath(genpath('plot_MF_burst_scripts'))
addpath(genpath('plot_MF_train_pharma_scripts'))
addpath(genpath('plot_MF_train_scripts'))