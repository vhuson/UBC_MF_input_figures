%%
f1 = figure('Color','w','Position',[163.3273 110.9636 906.7636 598.6909]);

base_width = 0.20;
bar_width = 0.07;
base_height = 0.3;
base_space = 0.07;

pos_ax = [0.1 0.65 base_width base_height];%[0.07 0.07 base_width 0.2064];


% base_n_spikes = [base_n_spikes_peak,base_n_spikes_ss];
% [ax_base_par1] = UBC_par_line_plot(...
%     ONidx,OFFidx,base_n_spikes,[0 1 1],0.01,f1,pos_ax,...
%     [1 2 3 4]);
% ylabel("Response spikes (n)")


opts = struct();
opts.title_text = '1Hz';
opts.ylabel_text = 'Steady state\newlineResponse spikes (n)';
opts.xlabel_text = 'Sorted cell #';

opts.xlim = [0 numel(select_cells)+1];
opts.curr_color = [1 0.5 0];
opts.plot_line = 0;
opts.upperbound = 10;
% opts.lowerbound = 0.1;

input_idx = 1;
curr_dataset = base_n_spikes_ss_pharma2;
num_par = curr_dataset{input_idx}(select_cells);
% den_par = base_n_spikes_ss{1}(ONidx);
den_par = ones(size(num_par));

ax_ratio = {};
[ax_ratio{input_idx}] = changed_par_normalized_plot(...
    num_par,...
    den_par,...
    1:numel(select_cells),f1,pos_ax,opts);
opts.ylabel_text = '';

input_idx = 2;
pos_ax(1) = pos_ax(1) + base_width + base_space;
num_par = curr_dataset{input_idx}(select_cells);
opts.title_text = '2.5Hz';
[ax_ratio{input_idx}] = changed_par_normalized_plot(...
    num_par,...
    den_par,...
    1:numel(select_cells),f1,pos_ax,opts);

input_idx = 3;
pos_ax(1) = pos_ax(1) + base_width + base_space;
num_par = curr_dataset{input_idx}(select_cells);
opts.title_text = '5Hz';
[ax_ratio{input_idx}] = changed_par_normalized_plot(...
    num_par,...
    den_par,...
    1:numel(select_cells),f1,pos_ax,opts);

% same_ylim(ax_ratio)

%
pos_ax(1) = 0.1;
pos_ax(2) = 0.2491;


opts = struct();
opts.plot_line = false;
opts.curr_color = [0.8 0 0];
opts.upperbound = 10;


input_idx = 1;
opts.overlay = ax_ratio{input_idx};
curr_dataset = base_n_spikes_ss_pharma3;

num_par = curr_dataset{input_idx}(select_cells);

changed_par_normalized_plot(...
    num_par,...
    den_par,...
    1:numel(select_cells),f1,pos_ax,opts);


input_idx = 2;
opts.overlay = ax_ratio{input_idx};
num_par = curr_dataset{input_idx}(select_cells);
changed_par_normalized_plot(...
    num_par,...
    den_par,...
    1:numel(select_cells),f1,pos_ax,opts);

input_idx = 3;
opts.overlay = ax_ratio{input_idx};
num_par = curr_dataset{input_idx}(select_cells);
changed_par_normalized_plot(...
    num_par,...
    den_par,...
    1:numel(select_cells),f1,pos_ax,opts);

legend({'', '-mGluR2','-AMPAR'},'Box','off')


curr_YTick = -10:5:10;
curr_YTickLabel = cellfun(@num2str,num2cell(curr_YTick),'UniformOutput',false);
curr_YTickLabel{end} = ['>',curr_YTickLabel{end}];

same_ylim(ax_ratio,'YTick',curr_YTick,'YTickLabel',curr_YTickLabel)