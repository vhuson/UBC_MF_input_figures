%% Get files, general means, and ONidx

setup_workspace_alldata

%% Gather all train data
washin = [1 0 0 0 0];
file_match = 'TRAIN10';
[all_mean_trains,all_full_trains,all_idx] = get_mean_by_filecode(...
    allData,file_match,washin);

file_match = 'TRAIN5';
[all_mean_trains_5,all_full_trains_5,all_idx_5] = get_mean_by_filecode(...
    allData,file_match,washin);

train_fltr_10 = ~cellfun(@isempty,all_mean_trains);
train_fltr_5 = ~cellfun(@isempty,all_mean_trains_5);


%Get parameters (train5 hardcoded)
[all_train_slow_amp,all_train_slow_HD,all_train_pause,all_train_n_spikes,...
    ~,~,all_train_burst_baseline,all_n_spikes_stim,all_n_spikes_post] = ...
    get_train_parameters(all_mean_trains_5(train_fltr_5),Fs);



[fltr_ONidx_t10] = get_fltr_ONidx(ONidx,find(train_fltr_10));
[fltr_ONidx_t5] = get_fltr_ONidx(ONidx,find(train_fltr_5));


% Gather all mean burst data
all_burst_durs      = [0.01 0.02 0.05 0.10 0.2];
all_burst_tails     = [2.9    3    10   10   10];
washin_state = [1 0 0 0 0];

%Get traces
[all_mean_bursts,all_full_bursts] = ...
    get_burst_data(allData,Fs,all_burst_durs, all_burst_tails,...
    washin_state);

%Get UBC parameters
[all_burst_slow_amp,all_burst_slow_HD,all_burst_pause,all_burst_n_spikes,...
    all_burst_fast_amp,all_burst_fast_HD,all_burst_baseline] = get_allburst_parameters(...
    all_mean_bursts,all_baseline,Fs);


%Use baseline for NaNs
for ii = 1:size(all_mean_bursts{1},1)
    curr_trace = all_mean_bursts{1}(ii,:);

    %Fill with zeros
    curr_trace(isnan(curr_trace)) = 0;

    %Fill up to first spike with baseline
    first_nozero = find(curr_trace ~= 0,1,"first");
    curr_trace(1:first_nozero) = all_baseline(ii);

    %Put back into array
    all_mean_bursts{1}(ii,:) = curr_trace;
    
end


%Protocol templates
%burst
input_burst = zeros(1,210000);
input_burst(0.5*Fs:0.7*Fs) = 100;

%Train5
input_train_5 = zeros(1,800001);
input_train_5(5*Fs:33*Fs) = 5;
input_train_5(8*Fs:9*Fs) = 10;
input_train_5(12*Fs:13*Fs) = 20;
input_train_5(16*Fs:17*Fs) = 30;
input_train_5(20*Fs:21*Fs) = 40;
input_train_5(24*Fs:25*Fs) = 50;
input_train_5(28*Fs:29*Fs) = 60;
input_train_5(32*Fs:33*Fs) = 20;
input_train_5(36*Fs:37*Fs) = 20;

train5_step_times = [5, 8, 12, 16, 20, 24, 28, 32, 36];

%Train10
input_train_10 = zeros(1,800001);
input_train_10(5*Fs:33*Fs) = 10;
input_train_10(8*Fs:9*Fs) = 20;
input_train_10(12*Fs:13*Fs) = 30;
input_train_10(16*Fs:17*Fs) = 40;
input_train_10(20*Fs:21*Fs) = 50;
input_train_10(24*Fs:25*Fs) = 60;
input_train_10(28*Fs:29*Fs) = 80;
input_train_10(32*Fs:33*Fs) = 40;
input_train_10(36*Fs:37*Fs) = 20;

%% Main figure
f_train = figure('Position', [488 1.8000 680.3150 857.9636],...
    'Color','w');

train5_examples_panel
train5_burst_examples_panel

train5_burst_heatmap_panel
train5_heatmap_panel

train5_summaries_panel


%Tweak figure
fig_opts = struct();
fig_opts.FontSize = 10;
standardFig(f_train,fig_opts);

%Add labels
plot_labels = repmat({[]},1,27);
plot_labels{15} = 'a';
plot_labels{8} = 'b';
plot_labels{22} = 'c';
plot_labels{24} = 'd';
plot_labels{25} = 'e';
plot_labels{26} = 'f';
plot_labels{27} = 'g';

labelPlots(f_train,plot_labels);

%% Other plots
train5_20s_figure

%% Plot trains stacked

f_train = figure('Position', [57.7273 20.2000 1.4287e+03 761.8909],...
    'Color','w');

plot_5 = true;

input_burst = zeros(1,210000);
input_burst(0.5*Fs:0.7*Fs) = 100;
input_train = zeros(1,800001);

if plot_5
    
    input_train(5*Fs:33*Fs) = 5;
    input_train(8*Fs:9*Fs) = 10;
    input_train(12*Fs:13*Fs) = 20;
    input_train(16*Fs:17*Fs) = 30;
    input_train(20*Fs:21*Fs) = 40;
    input_train(24*Fs:25*Fs) = 50;
    input_train(28*Fs:29*Fs) = 60;
    input_train(32*Fs:33*Fs) = 20;
    input_train(36*Fs:37*Fs) = 20;
else
    input_train(5*Fs:33*Fs) = 10;
    input_train(8*Fs:9*Fs) = 20;
    input_train(12*Fs:13*Fs) = 30;
    input_train(16*Fs:17*Fs) = 40;
    input_train(20*Fs:21*Fs) = 50;
    input_train(24*Fs:25*Fs) = 60;
    input_train(28*Fs:29*Fs) = 80;
    input_train(32*Fs:33*Fs) = 40;
    input_train(36*Fs:37*Fs) = 20;
end
train_fltr = ~cellfun(@isempty,all_mean_trains);
all_train_burst = all_mean_bursts{5};
all_train_burst(~train_fltr,:) = [];

all_mean_trains_array = all_mean_trains(train_fltr);

all_mean_trains_array = cellfun(@(x) {medfilt1(x,Fs*0.01)},all_mean_trains_array);


all_mean_trains_array = vertcat(all_mean_trains_array{:});


all_mean_trains_5_array = all_mean_trains_5(train_fltr);

all_mean_trains_5_array = cellfun(@(x) {medfilt1(x,Fs*0.01)},all_mean_trains_5_array);


all_mean_trains_5_array = vertcat(all_mean_trains_5_array{:});




all_mean_trains_10 = all_mean_trains_array;
if plot_5
    all_mean_trains_array = all_mean_trains_5_array;
end

[select_cells] = get_fltr_ONidx(ONidx,find(train_fltr));

% TRAIN5 selection
% select_cells = select_cells([6,15,21]);
% TRAIN10 selection
% select_cells = select_cells([2,10,14]);

%Add input
all_train_burst = [input_burst; all_train_burst];
all_mean_trains_array = [input_train; all_mean_trains_array];
select_cells = [1 select_cells+1];




pos_ax = [0.0500   0.07    0.2    0.85];
stack_opts = struct();
stack_opts.Visible = 'off';
[burst_stack_train] = plot_stacked_traces(...
    all_train_burst,Fs,select_cells,f_train,pos_ax,stack_opts);
burst_stack_train{1}.Title.String = '20x 100 Hz';
set_axstack_par(burst_stack_train,'XLim',[0 10]);


pos_ax = [0.2650    0.07    0.61   0.85];
[train_stack_1] = plot_stacked_traces(...
    all_mean_trains_array,Fs,select_cells,f_train,pos_ax,stack_opts);
train_stack_1{1}.Title.String = 'Train input';
train_stack_1{1}.Title.Position(2) = 90;

same_ylim_stack({burst_stack_train,train_stack_1})

scale_opts = struct();
scale_opts.xlabel = 's';
scale_opts.origin = [41,0];
add_scale_bar(train_stack_1{end},[3 0],scale_opts);
scale_opts.origin = [9,0];
add_scale_bar(burst_stack_train{end},[1 0],scale_opts);

%Label train input
if plot_5
    text(train_stack_1{1},0,2,'0','VerticalAlignment','bottom')
    text(train_stack_1{1},5,7,'5','VerticalAlignment','bottom')
    text(train_stack_1{1},8.5,12,'10','VerticalAlignment','bottom','HorizontalAlignment','center')
    text(train_stack_1{1},12.5,22,'20','VerticalAlignment','bottom','HorizontalAlignment','center')
    text(train_stack_1{1},16.5,32,'30','VerticalAlignment','bottom','HorizontalAlignment','center')
    text(train_stack_1{1},20.5,42,'40','VerticalAlignment','bottom','HorizontalAlignment','center')
    text(train_stack_1{1},24.5,52,'50','VerticalAlignment','bottom','HorizontalAlignment','center')
    text(train_stack_1{1},28.5,62,'60','VerticalAlignment','bottom','HorizontalAlignment','center')
    text(train_stack_1{1},32.5,22,'20','VerticalAlignment','bottom','HorizontalAlignment','center')
    text(train_stack_1{1},33.2,2,'0','VerticalAlignment','bottom')
    text(train_stack_1{1},36.5,22,'20','VerticalAlignment','bottom','HorizontalAlignment','center')
else
    text(train_stack_1{1},5,12,'10','VerticalAlignment','bottom')
    text(train_stack_1{1},8.5,22,'20','VerticalAlignment','bottom','HorizontalAlignment','center')
    text(train_stack_1{1},12.5,32,'30','VerticalAlignment','bottom','HorizontalAlignment','center')
    text(train_stack_1{1},16.5,42,'40','VerticalAlignment','bottom','HorizontalAlignment','center')
    text(train_stack_1{1},20.5,52,'50','VerticalAlignment','bottom','HorizontalAlignment','center')
    text(train_stack_1{1},24.5,62,'60','VerticalAlignment','bottom','HorizontalAlignment','center')
    text(train_stack_1{1},28.5,82,'80','VerticalAlignment','bottom','HorizontalAlignment','center')
    text(train_stack_1{1},32.5,42,'40','VerticalAlignment','bottom','HorizontalAlignment','center')
    text(train_stack_1{1},33.2,2,'0','VerticalAlignment','bottom')
    text(train_stack_1{1},36.5,22,'20','VerticalAlignment','bottom','HorizontalAlignment','center')
end
%% Plot all train pharma data
washin = [0 1 1 0 0];
file_match = 'TRAIN5';
[all_mean_trains_pharma3,~] = get_mean_by_filecode(...
    allData,file_match,washin);

train_pharma_fltr = ~cellfun(@isempty,all_mean_trains_pharma3);

washin = [1 0 0 0 0];
[all_mean_trains_pharma1,~] = get_mean_by_filecode(...
    allData(train_pharma_fltr),file_match,washin);

washin = [0 1 0 0 0];
[all_mean_trains_pharma2,~] = get_mean_by_filecode(...
    allData(train_pharma_fltr),file_match,washin);

washin = [0 1 1 0 0];
[all_mean_trains_pharma3,~] = get_mean_by_filecode(...
    allData(train_pharma_fltr),file_match,washin);

washin = [0 1 1 1 0];
[all_mean_trains_pharma4,~] = get_mean_by_filecode(...
    allData(train_pharma_fltr),file_match,washin);




f_train_pharma = figure('Position', [488 1.8000 936.8000 780.8000],...
    'Color','w');



all_mean_trains_pharma1 = cellfun(@(x)...
    {medfilt1(x,Fs*0.01)},all_mean_trains_pharma1);
all_mean_trains_pharma2 = cellfun(@(x)...
    {medfilt1(x,Fs*0.01)},all_mean_trains_pharma2);
all_mean_trains_pharma3 = cellfun(@(x)...
    {medfilt1(x,Fs*0.01)},all_mean_trains_pharma3);
all_mean_trains_pharma4 = cellfun(@(x)...
    {medfilt1(x,Fs*0.01)},all_mean_trains_pharma4);


all_mean_trains_pharma1 = vertcat(all_mean_trains_pharma1{:});
all_mean_trains_pharma2 = vertcat(all_mean_trains_pharma2{:});
all_mean_trains_pharma3 = vertcat(all_mean_trains_pharma3{:});
all_mean_trains_pharma4 = vertcat(all_mean_trains_pharma4{:});


[select_cells] = get_fltr_ONidx(ONidx,find(train_pharma_fltr));


base_width = 0.2;
base_gap = 0.02;

pos_ax = [0.0500   0.07    base_width    0.85];
[train_stack_1] = plot_stacked_traces(...
    all_mean_trains_pharma1,Fs,select_cells,f_train_pharma,pos_ax);
train_stack_1{ceil(numel(train_stack_1)/2)}.YLabel.String = 'Response (spk/s)';
title(train_stack_1{1},'Baseline')


pos_ax = [sum(pos_ax([1,3]))+base_gap   0.07    base_width    0.85];
[train_stack_2] = plot_stacked_traces(...
    all_mean_trains_pharma2,Fs,select_cells,f_train_pharma,pos_ax);
title(train_stack_2{1},'-mGluR2')

pos_ax = [sum(pos_ax([1,3]))+base_gap   0.07    base_width    0.85];
[train_stack_3] = plot_stacked_traces(...
    all_mean_trains_pharma3,Fs,select_cells,f_train_pharma,pos_ax);
title(train_stack_3{1},'-AMPAR')


pos_ax = [sum(pos_ax([1,3]))+base_gap   0.07    base_width    0.85];
[train_stack_4] = plot_stacked_traces(...
    all_mean_trains_pharma4,Fs,select_cells,f_train_pharma,pos_ax);
title(train_stack_4{1},'-mGluR1')

same_ylim_stack({train_stack_1, train_stack_2, train_stack_3,train_stack_4});


%%

burst_stack_train{1}.Title.String = '20x 100 Hz';
set_axstack_par(burst_stack_train,'XLim',[0 10]);
burst_stack_train{end}.XTick = [0.5, 2.5 4.5 6.5 8.5];
burst_stack_train{end}.XTickLabel = {'0', '2', '4', '6', '8'};
burst_stack_train{ceil(numel(burst_stack_train)/2)}.YLabel.String = 'Response (spk/s)';


pos_ax = [0.2650    0.07    0.61   0.85];
[train_stack_1] = plot_stacked_traces(...
    all_mean_trains_array,Fs,select_cells,f_train,pos_ax);
% set_sensible_ylim(train_stack_1);

train_stack_1{end}.XLabel.String = 'Time (s)';
% train_stack_1{ceil(numel(train_stack_1)/2)}.YLabel.String = 'Response (spk/s)';

