f_train = figure('Position', [488 1.8000 680.3150 857.9636],...
    'Color','w');

%Define axis position
num_cols = 4;
num_rows = 1;

left_margin = 0.08;
bottom_margin = 0.08;
base_width = 0.14;
base_space = 0.09;

graph_height = 0.14;

all_left_edges = (base_width + base_space) .* (0:(num_cols-1)) + left_margin;


%Get data
all_plot_par = {all_train_slow_amp,...
                    all_train_n_spikes,...
                    all_train_slow_HD,...
                    all_train_pause};

%Data specific options
all_ylabels = {'Peak response (\Deltaspk/s)',...
                "Response spikes (n)",...
                'Half-width (s)',...
                'Pause (s)'};

all_min_vals = [1 1 -Inf -Inf];



%Train plot pars
plot_steps = 1:6;
step_size = [10, 20, 30, 40, 50, 60, 20, 20];


%Plot settings
summary_on = fltr_ONidx_t5;
% summary_off = OFFidx(end-1:end);
summary_off = [];


opts = struct();
opts.input_n = step_size(plot_steps);
% opts.input_n = [0 1 2.5 5];
opts.YScale = 'log';
% opts.XScale = 'log';
opts.XLabel = "Input step (spk/s)";

opts.XTick = opts.input_n;
opts.XTickLabel = opts.input_n;
opts.min_val = 1;


ax_train_par = {};

%Loop over all panels
for p_idx = 1:num_cols
    %Set axis position
    pos_ax = [all_left_edges(p_idx),  bottom_margin, base_width, graph_height];

    %Panel specific options
    opts.YLabel = all_ylabels{p_idx};
    opts.min_val = all_min_vals(p_idx);


    [ax_train_par{p_idx}] = UBC_par_line_plot2(...
        summary_on,summary_off,all_plot_par{p_idx}(plot_steps),f_train,pos_ax,opts);
    xlim([opts.input_n(1) opts.input_n(end)])

    %Offset XLim a little bit
    ax_train_par{p_idx}.XLim(1) = ax_train_par{p_idx}.XLim(1)...
        - diff(ax_train_par{p_idx}.XLim) * 0.05;

    fix_powered_ylabels(ax_train_par{p_idx})
end
