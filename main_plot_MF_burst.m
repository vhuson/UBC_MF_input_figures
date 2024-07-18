%% Get files, general means, and ONidx

setup_workspace_alldata



%% Gather all mean burst data
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


%% Main figure
f_burst = figure('Position', [488 1.8000 680.3150 857.9636],...
    'Color','w');


%Run panel scripts
% example_cell_panel
example_cell_panel_reordered

heatmap_panel

summary_lineplots_panel


%Tweak figure
fig_opts = struct();
fig_opts.FontSize = 10;
standardFig(f_burst,fig_opts);



%Add labels
plot_labels = repmat({[]},1,27);
plot_labels{1} = 'a';
% plot_labels{6} = 'b';
% plot_labels{11} = 'c';
plot_labels{26} = 'b';
plot_labels(31:33) = {'c','d','e'};
[~,t_labels] = labelPlots(f_burst,plot_labels);

for ii = 1:numel(t_labels)
    t_labels{ii}.Position(1) = t_labels{ii}.Position(1)-14;
    
end

% exportgraphics(f_burst,'pdf\240717_fig2.pdf','ContentType','vector')

%% Other figure scripts


heatmap_figure
stacked_traces_figure
example_summary_figure



%% OLD2
%% Make baseline pharma figure

all_base_freqs      = [1 2.5 5];
prot_spec_dur = [2 10];
washin_state = [0 1 1 0 0];

%Retrieve all data
[all_full_pharma_base3,all_peak_pharma_base3,all_ss_pharma_base3,...
    mean_peak_pharma_base3, min_trace_leng_pharma_base3] = ...
    get_baseline_data(allData,Fs,all_base_freqs,prot_spec_dur,...
    washin_state);

washin_fltr = ~isnan(mean_peak_pharma_base3(:,1));


washin_state = [1 0 0 0 0];

%Get traces 1
[all_full_pharma_base1,all_peak_pharma_base1,all_ss_pharma_base1,...
    mean_peak_pharma_base1, min_trace_leng_pharma_base1] = ...
    get_baseline_data(allData(washin_fltr),Fs,all_base_freqs,prot_spec_dur,...
    washin_state);

%Calculate number of spikes at SS
[base_n_spikes_ss_pharma1] = get_baseline_n_spikes(...
    all_ss_pharma_base1,all_baseline(washin_fltr),Fs,min_trace_leng_pharma_base1);

%Calculate number of spikes at peak
[base_n_spikes_peak_pharma1] = get_baseline_n_spikes(...
    mean_peak_pharma_base1,all_baseline(washin_fltr),Fs,min_trace_leng_pharma_base1);


washin_state = [0 1 0 0 0];

%Get traces 2
[all_full_pharma_base2,all_peak_pharma_base2,all_ss_pharma_base2,...
    mean_peak_pharma_base2, min_trace_leng_pharma_base2] = ...
    get_baseline_data(allData(washin_fltr),Fs,all_base_freqs,prot_spec_dur,...
    washin_state);

%Calculate number of spikes at SS
[base_n_spikes_ss_pharma2] = get_baseline_n_spikes(...
    all_ss_pharma_base2,all_baseline(washin_fltr),Fs,min_trace_leng_pharma_base2);

%Calculate number of spikes at peak
[base_n_spikes_peak_pharma2] = get_baseline_n_spikes(...
    mean_peak_pharma_base2,all_baseline(washin_fltr),Fs,min_trace_leng_pharma_base2);




washin_state = [0 1 1 0 0];

%Get traces 3
[all_full_pharma_base3,all_peak_pharma_base3,all_ss_pharma_base3,...
    mean_peak_pharma_base3, min_trace_leng_pharma_base3] = ...
    get_baseline_data(allData(washin_fltr),Fs,all_base_freqs,prot_spec_dur,...
    washin_state);

%Calculate number of spikes at SS
[base_n_spikes_ss_pharma3] = get_baseline_n_spikes(...
    all_ss_pharma_base3,all_baseline(washin_fltr),Fs,...
    min_trace_leng_pharma_base3);

%Calculate number of spikes at peak
[base_n_spikes_peak_pharma3] = get_baseline_n_spikes(...
    mean_peak_pharma_base3,all_baseline(washin_fltr),Fs,...
    min_trace_leng_pharma_base3);



washin_state = [0 1 1 1 0];

%Get traces 4
[all_full_pharma_base4,all_peak_pharma_base4,all_ss_pharma_base4,...
    mean_peak_pharma_base4, min_trace_leng_pharma_base4] = ...
    get_baseline_data(allData(washin_fltr),Fs,all_base_freqs,prot_spec_dur,...
    washin_state);

%Calculate number of spikes at SS
[base_n_spikes_ss_pharma4] = get_baseline_n_spikes(...
    all_ss_pharma_base4,all_baseline(washin_fltr),Fs,...
    min_trace_leng_pharma_base4);

%Calculate number of spikes at peak
[base_n_spikes_peak_pharma4] = get_baseline_n_spikes(...
    mean_peak_pharma_base4,all_baseline(washin_fltr),Fs,...
    min_trace_leng_pharma_base4);


f_base_pharma = figure('Position', [488 1.8000 936.8000 780.8000],...
    'Color','w');


[fltr_ONidx] = get_fltr_ONidx(ONidx,find(washin_fltr));

select_cells = fltr_ONidx;


%1x
base_width = 0.3;
pos_bottom = 0.57;
pos_height = 0.39;

pos_ax = [0.0500    pos_bottom    base_width   pos_height];
[base_stack_1] = plot_stacked_traces(...
    all_full_pharma_base1{1},Fs,select_cells,f_base_pharma,pos_ax);
set_sensible_ylim(base_stack_1);
base_stack_1{1}.Title.String = '1 Hz';
base_stack_1{end}.XLabel.String = 'Time (s)';
base_stack_1{ceil(numel(base_stack_1)/2)}.YLabel.String = 'Response (spk/s)';



%2x 100Hz
pos_ax = [sum(pos_ax([1,3]))+0.01   pos_bottom    base_width    pos_height];
[base_stack_2] = plot_stacked_traces(...
    all_full_pharma_base1{2},Fs,select_cells,f_base_pharma,pos_ax);
set_sensible_ylim(base_stack_2);
base_stack_2{1}.Title.String = '2.5 Hz';
base_stack_2{end}.XLabel.String = 'Time (s)';


%5x 100Hz
pos_ax = [sum(pos_ax([1,3]))+0.01    pos_bottom    base_width    pos_height];
[base_stack_3] = plot_stacked_traces(...
    all_full_pharma_base1{3},Fs,select_cells,f_base_pharma,pos_ax);
set_sensible_ylim(base_stack_3);
base_stack_3{1}.Title.String = '5 Hz';
base_stack_3{end}.XLabel.String = 'Time (s)';

same_ylim_stack({base_stack_1, base_stack_2, base_stack_3});


base_width = 0.22;
base_space = 0.02;
base_height = 0.09;
base_length = 0.38;

all_peak_n_spikes_pharma = {base_n_spikes_peak_pharma1{1},...
    base_n_spikes_peak_pharma2{1},...
    base_n_spikes_peak_pharma3{1},...
    base_n_spikes_peak_pharma4{1}};
pos_ax = [0.05 base_height base_width base_length];
[ax_base_pharma_par1] = plot_burst_pharma_n_spikes_heatmap(...
    select_cells,all_peak_n_spikes_pharma,f_base_pharma,pos_ax);
title('Initial');
ylabel('Sorted cell (#)')


all_1HzSS_n_spikes_pharma = {base_n_spikes_ss_pharma1{1},...
    base_n_spikes_ss_pharma2{1},...
    base_n_spikes_ss_pharma3{1},...
    base_n_spikes_ss_pharma4{1}};
pos_ax = [sum(pos_ax([1,3]))+base_space base_height base_width base_length];
[ax_base_pharma_par2] = plot_burst_pharma_n_spikes_heatmap(...
    select_cells,all_1HzSS_n_spikes_pharma,f_base_pharma,pos_ax);
title('1 Hz Steady state');
yticklabels({''});


all_2_5HzSS_n_spikes_pharma = {base_n_spikes_ss_pharma1{2},...
    base_n_spikes_ss_pharma2{2},...
    base_n_spikes_ss_pharma3{2},...
    base_n_spikes_ss_pharma4{2}};

pos_ax = [sum(pos_ax([1,3]))+base_space  base_height base_width base_length];
[ax_base_pharma_par3] = plot_burst_pharma_n_spikes_heatmap(...
    select_cells,all_2_5HzSS_n_spikes_pharma,f_base_pharma,pos_ax);
title('2.5 Hz Steady state');
yticklabels({''});


all_5HzSS_n_spikes_pharma = {base_n_spikes_ss_pharma1{3},...
    base_n_spikes_ss_pharma2{3},...
    base_n_spikes_ss_pharma3{3},...
    base_n_spikes_ss_pharma4{3}};


pos_ax = [sum(pos_ax([1,3]))+base_space  base_height base_width base_length];
[ax_base_pharma_par4] = plot_burst_pharma_n_spikes_heatmap(...
    select_cells,all_5HzSS_n_spikes_pharma,f_base_pharma,pos_ax);
title('5 Hz Steady state');
yticklabels({''});



% save_figure_larger(f_burst,4);


%% Plot all train data
washin = [1 0 0 0 0];
file_match = 'TRAIN10';
[all_mean_trains,all_full_trains,all_idx] = get_mean_by_filecode(...
    allData,file_match,washin);

file_match = 'TRAIN5';
[all_mean_trains_5,all_full_trains_5,all_idx_5] = get_mean_by_filecode(...
    allData,file_match,washin);

f_train = figure('Position', [57.7273 20.2000 1.4287e+03 761.8909],...
    'Color','w');

plot_5 = false;

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

all_mean_trains = all_mean_trains(train_fltr);

all_mean_trains = cellfun(@(x) {medfilt1(x,Fs*0.01)},all_mean_trains);


all_mean_trains = vertcat(all_mean_trains{:});


all_mean_trains_5 = all_mean_trains_5(train_fltr);

all_mean_trains_5 = cellfun(@(x) {medfilt1(x,Fs*0.01)},all_mean_trains_5);


all_mean_trains_5 = vertcat(all_mean_trains_5{:});




all_mean_trains_10 = all_mean_trains;
if plot_5
    all_mean_trains = all_mean_trains_5;
end

[select_cells] = get_fltr_ONidx(ONidx,find(train_fltr));

% TRAIN5 selection
% select_cells = select_cells([6,15,21]);
% TRAIN10 selection
select_cells = select_cells([2,10,14]);

%Add input
all_train_burst = [input_burst; all_train_burst];
all_mean_trains = [input_train; all_mean_trains];
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
    all_mean_trains,Fs,select_cells,f_train,pos_ax,stack_opts);
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
    all_mean_trains,Fs,select_cells,f_train,pos_ax);
% set_sensible_ylim(train_stack_1);

train_stack_1{end}.XLabel.String = 'Time (s)';
% train_stack_1{ceil(numel(train_stack_1)/2)}.YLabel.String = 'Response (spk/s)';



%%  OLD
%% Make burst figure (just traces with heatmaps)
all_burst_durs      = [0.01 0.02 0.05 0.10 0.2];
all_burst_tails     = [2.9    3    10   10   10];
washin_state = [1 0 0 0 0];

%Get traces
[all_mean_bursts,all_full_bursts] = ...
    get_burst_data(allData,Fs,all_burst_durs, all_burst_tails,...
    washin_state);

%Get UBC parameters
[all_burst_slow_amp,all_burst_slow_HD,all_burst_pause,all_burst_n_spikes,...
    all_burst_fast_amp,all_burst_fast_HD] = get_allburst_parameters(...
    all_mean_bursts,all_baseline,Fs);



f_burst = figure('Position', [488 1.8000 936.8000 780.8000],...
    'Color','w');
numc = numel(allData);
select_cells = round(1:numc/numc:numc);
select_cells(end) = numc;
% select_cells(3) = select_cells(3)+1;
select_cells = ONidx(select_cells);


%1x
base_width = 0.035;
pos_bottom = 0.57;
pos_height = 0.39;

pos_ax = [0.0500    pos_bottom    1*base_width   pos_height];
[burst_stack_1] = plot_stacked_traces(...
    all_mean_bursts{1},Fs,select_cells,f_burst,pos_ax);
set_axstack_par(burst_stack_1,'XLim',[0.3 1.3]);
burst_stack_1{1}.Title.String = '1x';
burst_stack_1{ceil(numel(burst_stack_1)/2)}.YLabel.String = 'Response (spk/s)';
burst_stack_1{end}.XTick = [0.5];
burst_stack_1{end}.XTickLabel = {'0'};


%2x 100Hz
pos_ax = [sum(pos_ax([1,3]))+0.01   pos_bottom    2*base_width    pos_height];
[burst_stack_2] = plot_stacked_traces(...
    all_mean_bursts{2},Fs,select_cells,f_burst,pos_ax);
set_axstack_par(burst_stack_2,'XLim',[0.15 2.15]);
burst_stack_2{1}.Title.String = '2x 100 Hz';
burst_stack_2{end}.XTick = [0.5, 1.5];
burst_stack_2{end}.XTickLabel = {'0', '1'};


%5x 100Hz
pos_ax = [sum(pos_ax([1,3]))+0.01    pos_bottom    5*base_width    pos_height];
[burst_stack_3] = plot_stacked_traces(...
    all_mean_bursts{3},Fs,select_cells,f_burst,pos_ax);
set_axstack_par(burst_stack_3,'XLim',[0 5]);
burst_stack_3{1}.Title.String = '5x 100 Hz';
burst_stack_3{end}.XTick = [0.5, 2.5 4.5];
burst_stack_3{end}.XTickLabel = {'0', '2', '4'};


%10x 100Hz
pos_ax = [sum(pos_ax([1,3]))+0.01    pos_bottom    7*base_width   pos_height];
[burst_stack_4] = plot_stacked_traces(...
    all_mean_bursts{4},Fs,select_cells,f_burst,pos_ax);
burst_stack_4{1}.Title.String = '10x 100 Hz';
set_axstack_par(burst_stack_4,'XLim',[0 7]);
burst_stack_4{end}.XLabel.String = 'Time (s)';
burst_stack_4{end}.XTick = [0.5, 2.5 4.5 6.5];
burst_stack_4{end}.XTickLabel = {'0', '2', '4', '6'};


%20x 100Hz
pos_ax = [sum(pos_ax([1,3]))+0.01    pos_bottom    10*base_width    pos_height];
[burst_stack_5] = plot_stacked_traces(...
    all_mean_bursts{5},Fs,select_cells,f_burst,pos_ax);
burst_stack_5{1}.Title.String = '20x 100 Hz';
set_axstack_par(burst_stack_5,'XLim',[0 10]);
burst_stack_5{end}.XTick = [0.5, 2.5 4.5 6.5 8.5];
burst_stack_5{end}.XTickLabel = {'0', '2', '4', '6', '8'};

same_ylim_stack({burst_stack_1, burst_stack_2, burst_stack_3,burst_stack_4,burst_stack_5});


base_width = 0.22;
base_space = 0.02;

pos_ax = [0.05 0.07 base_width 0.4064];
[ax_burst_par1] = plot_burst_n_spikes_heatmap(...
    ONidx,all_burst_n_spikes,f_burst,pos_ax);

pos_ax = [sum(pos_ax([1,3]))+base_space 0.07 base_width 0.4064];
[ax_burst_par2] = plot_burst_log_par_heatmap(...
    ONidx,all_burst_slow_amp,f_burst,pos_ax);
title('Peak (\Deltaspk/s)');
ax_burst_par2.YTick = ax_burst_par1.YTick;

pos_ax = [sum(pos_ax([1,3]))+base_space  0.07 base_width 0.4064];
[ax_burst_par3] = plot_burst_log_par_heatmap(...
    ONidx,all_burst_slow_HD,f_burst,pos_ax);
title('Half-width (s)');
ax_burst_par3.YTick = ax_burst_par1.YTick;

pos_ax = [sum(pos_ax([1,3]))+base_space  0.07 base_width 0.4064];
[ax_burst_par4] = plot_burst_log_par_heatmap(...
    ONidx,all_burst_pause,f_burst,pos_ax);
title('Pause (s)');
ax_burst_par4.YTick = ax_burst_par1.YTick;





% save_figure_larger(f_burst,4);


