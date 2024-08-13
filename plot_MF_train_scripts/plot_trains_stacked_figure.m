
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