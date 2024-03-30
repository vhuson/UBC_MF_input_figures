% f_train = figure('Position', [488 1.8000 680.3150 857.9636],...
%     'Color','w');

%Define axis position
num_cols = 3;
num_rows = 1;

left_margin = 0.1;
bottom_margin = 0.1707;
base_width = 0.18;
base_space = 0.14;

graph_height = 0.14;

all_left_edges = (base_width + base_space) .* (0:(num_cols-1)) + left_margin;


%Get data
% all_plot_par = {all_train_slow_amp,...
%                     all_train_n_spikes,...
%                     all_train_slow_HD,...
%                     all_train_pause};

% all_plot_par = {all_train_slow_amp,...
%                     all_train_n_spikes,...
%                     all_n_spikes_stim,...
%                     all_n_spikes_post};

all_plot_par = {all_train_slow_amp,...
                    all_n_spikes_stim,...
                    all_n_spikes_post};

% all_plot_par = {all_train_slow_amp,...
%                     all_train_n_spikes,...
%                     all_train_burst_baseline(2:end)};

%Data specific options
% all_ylabels = {'Peak response (\Deltaspk/s)',...
%                 "Response spikes (n)",...
%                 'Half-width (s)',...
%                 'Pause (s)'};

% all_ylabels = {'Peak response (\Deltaspk/s)',...
%                 "Response spikes (n)",...
%                 'Stim spikes (n)',...
%                 'Post spikes (n)'};
% 
all_ylabels = {'Peak response (\Deltaspk/s)',...
                'Stim spikes (n)',...
                'Post spikes (n)'};

% all_ylabels = {'Peak response (\Deltaspk/s)',...
%                 "Response spikes (n)",...
%                 'Steady state (spk/s)'};


% all_min_vals = [1 1 0.01];
all_min_vals = [1 -Inf -20];



%Train plot pars
plot_steps = 1:6;
% plot_steps = [2, 7, 8];
step_size = [10, 20, 30, 40, 50, 60, 20, 20];


%Plot settings
summary_on = fltr_ONidx_t5;
% summary_off = OFFidx(end-1:end);
summary_off = fltr_ONidx_t5(end-3:end);
    

opts = struct();
opts.input_n = step_size(plot_steps);
% opts.input_n = [1 2 3];
opts.YScale = 'log';
% opts.XScale = 'log';
opts.XLabel = "Input step (spk/s)";

opts.XTick = opts.input_n;
opts.XTickLabel = step_size(plot_steps);
opts.min_val = 1;


ax_train_par = {};

%Loop over all panels
for p_idx = 1:num_cols
    %Set axis position
    pos_ax = [all_left_edges(p_idx),  bottom_margin, base_width, graph_height];

    %Panel specific options
    opts.YLabel = all_ylabels{p_idx};
    opts.min_val = all_min_vals(p_idx);

    if p_idx == num_cols
        opts.bar = true;
    end
    if p_idx == 2
        opts.max_val = 70;
    else
        opts.max_val = Inf;
    end
    [ax_train_par{p_idx},cb1] = UBC_par_line_plot2(...
        summary_on,summary_off,all_plot_par{p_idx}(plot_steps),f_train,pos_ax,opts);
    xlim([opts.input_n(1) opts.input_n(end)])
    
    %Turn off OFF stuff
    summary_off = [];

    %Offset XLim a little bit
    ax_train_par{p_idx}.XLim(1) = ax_train_par{p_idx}.XLim(1)...
        - diff(ax_train_par{p_idx}.XLim) * 0.05;
    % fix_powered_ylabels(ax_train_par{p_idx})
    opts.YScale = 'linear';
    ax_train_par{p_idx}.XTickLabelRotation = 0;
end
fix_powered_ylabels(ax_train_par{1})
