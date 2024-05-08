%% train 5 pharma
sampling_rate = 20000;

% burst input timings
input_inst_freq_samples = input_train_5;

% Get cell names and sort
cell_IDs = {fileNames(:).name};
cell_IDs = cellfun(@(x) {x(1:8)},cell_IDs);

cell_IDs = cell_IDs(train_pharma_fltr);
cell_IDs = cell_IDs(fltr_ONidx_tpharma);
cell_IDs = cell_IDs(:);


washin_IDs = {'Baseline'	'LY 341495'	'NBQX'	'JNJ 16259685'}';
% Get mean responses and sort
mean_inst_firing_rates = all_mean_trains_pharma;
mean_inst_firing_rates = cellfun(@(x) {x(fltr_ONidx_tpharma)},mean_inst_firing_rates);
mean_inst_firing_rates = [mean_inst_firing_rates{:}];
% Truncate longer ones
mean_inst_firing_rates = cellfun(@(x) {x(1:800001)},mean_inst_firing_rates);
temp = {};
temp{1,1} = vertcat(mean_inst_firing_rates{:,1});
temp{1,2} = vertcat(mean_inst_firing_rates{:,2});
temp{1,3} = vertcat(mean_inst_firing_rates{:,3});
temp{1,4} = vertcat(mean_inst_firing_rates{:,4});
mean_inst_firing_rates = temp;


% Get all responses and sort
all_inst_firing_rates = all_full_trains_pharma;
all_inst_firing_rates = cellfun(@(x) {x(fltr_ONidx_tpharma)},all_inst_firing_rates);
all_inst_firing_rates = [all_inst_firing_rates{:}];
%Stack individual cells
all_inst_firing_rates = cellfun(@(x) {vertcat(x{:})},all_inst_firing_rates);


all_inst_firing_rates = cell2table(all_inst_firing_rates,...
    "VariableNames",washin_IDs);

mean_inst_firing_rates = cell2table(mean_inst_firing_rates,...
    "VariableNames",washin_IDs);



save("Fig5_trainpharma_inst_firing_rates.mat","sampling_rate","input_inst_freq_samples","cell_IDs","mean_inst_firing_rates","all_inst_firing_rates","washin_IDs",'-v7.3');



%% train 5
sampling_rate = 20000;

% burst input timings
input_inst_freq_samples = input_train_5;

% Get cell names and sort
cell_IDs = {fileNames(:).name};
cell_IDs = cellfun(@(x) {x(1:8)},cell_IDs);

cell_IDs = cell_IDs(train_fltr_5);
cell_IDs = cell_IDs(fltr_ONidx_t5);
cell_IDs = cell_IDs(:);


% washin_IDs = {'Baseline'	'LY 341495'	'NBQX'	'JNJ 16259685'}';
% Get mean responses and sort
mean_inst_firing_rates = all_mean_trains_5(train_fltr_5);
% Truncate longer ones
mean_inst_firing_rates = cellfun(@(x) {x(1:800001)},mean_inst_firing_rates);
mean_inst_firing_rates = mean_inst_firing_rates(fltr_ONidx_t5);
mean_inst_firing_rates = vertcat(mean_inst_firing_rates{:});


% Get all responses and sort
all_inst_firing_rates = all_full_trains_5(train_fltr_5);
all_inst_firing_rates = all_inst_firing_rates(fltr_ONidx_t5);
%Stack individual cells
all_inst_firing_rates = cellfun(@(x) {vertcat(x{:})},all_inst_firing_rates);




save("Fig4_train_inst_firing_rates.mat","sampling_rate","input_inst_freq_samples","cell_IDs","mean_inst_firing_rates","all_inst_firing_rates",'-v7.3');

%% pharma burst
sampling_rate = 20000;

% burst input timings
input_times_sec = {[0.5],[0.5,0.51],[0.5:0.01:0.54],[0.5:0.01:0.59],[0.5:0.01:0.69]};
% input_times_sec = cell2table(input_times_sec,"VariableNames",["1x" "2x 100Hz" "5x 100Hz" "10x 100Hz" "20x 100Hz"]);

% Get cell names and sort
cell_IDs = {fileNames(:).name};
cell_IDs = cellfun(@(x) {x(1:8)},cell_IDs);

cell_IDs = cell_IDs(washin_fltr);
cell_IDs = cell_IDs(fltr_ONidx);
cell_IDs = cell_IDs(:);


washin_IDs = {'Baseline'	'LY 341495'	'NBQX'	'JNJ 16259685'}';
% Get mean responses and sort
mean_inst_firing_rates = {};
mean_inst_firing_rates(1,:) = all_mean_pharma_bursts1;
mean_inst_firing_rates(2,:) = all_mean_pharma_bursts2;
mean_inst_firing_rates(3,:) = all_mean_pharma_bursts3;
mean_inst_firing_rates(4,:) = all_mean_pharma_bursts4;

mean_inst_firing_rates = cellfun(@(x) {x(fltr_ONidx,:)},mean_inst_firing_rates);


% Get all responses and sort
all_inst_firing_rates = {};
all_inst_firing_rates(1,:) = all_full_pharma_bursts1;
all_inst_firing_rates(2,:) = all_full_pharma_bursts2;
all_inst_firing_rates(3,:) = all_full_pharma_bursts3;
all_inst_firing_rates(4,:) = all_full_pharma_bursts4;

all_inst_firing_rates = cellfun(@(x) {x(fltr_ONidx)},all_inst_firing_rates);


all_inst_firing_rates = cell2table(all_inst_firing_rates,...
    "VariableNames",["1x" "2x 100Hz" "5x 100Hz" "10x 100Hz" "20x 100Hz"],'RowNames',washin_IDs);

mean_inst_firing_rates = cell2table(mean_inst_firing_rates,...
    "VariableNames",["1x" "2x 100Hz" "5x 100Hz" "10x 100Hz" "20x 100Hz"],'RowNames',washin_IDs);


save("Fig3_burstpharma_inst_firing3.mat","sampling_rate","input_times_sec","cell_IDs","mean_inst_firing_rates","all_inst_firing_rates","washin_IDs",'-v7.3');

%% Simple burst
sampling_rate = 20000;

% burst input timings
input_times_sec = {[0.5],[0.5,0.51],[0.5:0.01:0.54],[0.5:0.01:0.59],[0.5:0.01:0.69]};

% Get cell names and sort
cell_IDs = {fileNames(:).name};
cell_IDs = cellfun(@(x) {x(1:8)},cell_IDs);

cell_IDs = cell_IDs(ONidx);
cell_IDs = cell_IDs(:);

% Get mean responses and sort
mean_inst_firing_rates = all_mean_bursts;
mean_inst_firing_rates = cellfun(@(x) {x(ONidx,:)},mean_inst_firing_rates);


% Get all responses and sort
all_inst_firing_rates = all_full_bursts;
all_inst_firing_rates = cellfun(@(x) {x(ONidx)},all_inst_firing_rates);


all_inst_firing_rates = cell2table(all_inst_firing_rates,...
    "VariableNames",["1x" "2x 100Hz" "5x 100Hz" "10x 100Hz" "20x 100Hz"]);

mean_inst_firing_rates = cell2table(mean_inst_firing_rates,...
    "VariableNames",["1x" "2x 100Hz" "5x 100Hz" "10x 100Hz" "20x 100Hz"]);


save("Fig2_inst_firing_rates.mat","sampling_rate","input_times_sec","cell_IDs","mean_inst_firing_rates","all_inst_firing_rates");