% f_train = figure('Position', [488 1.8000 680.3150 857.9636],...
%     'Color','w');

%Plot options
peak_log = false;

%Define axis position
num_cols = 3;
num_rows = 1;

left_margin = 0.1;
bottom_margin = 0.1964;
total_width = 0.6850;

base_space = 0.1;

graph_height = 0.1143;

base_width = total_width / num_cols - base_space;

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

% all_plot_par = {all_train_slow_amp,...
%                     all_n_spikes_stim,...
%                     all_n_spikes_post};
% 
% all_plot_par2 = {all_train_slow_amp,...
%                     all_n_spikes_stim,...
%                     cellfun(@(x,y) {(x)./(x+y).*100},all_sum_spikes_stim,all_sum_spikes_post)};

all_plot_par = {all_n_spikes_stim,...
                all_n_spikes_post,...                    
                    all_train_half_decay};

% all_plot_par = {all_train_slow_amp,...
%                     all_n_spikes_stim_global_base,...
%                     all_n_spikes_post_global_base};

% all_plot_par = {all_train_slow_amp,...
%                     all_train_n_spikes,...
%                     all_train_burst_baseline(2:end)};

%Data labels
% all_ylabels = {'Peak (\Deltaspk/s)',...
%                 '\DeltaSpikes during step (n)',...
%                 '\DeltaSpikes after step (n)'};
all_ylabels = {'\DeltaSpikes during step (n)',...
                '\DeltaSpikes after step (n)',...
                'Step half-decay (s)'};

% all_ylabels = {'Peak (\Deltaspk/s)',...
%                 '\DeltaSpikes during step (n)',...
%                 'Spikes during step (%)'};



% all_min_vals = [1 1 0.01];
% if peak_log
%     all_min_vals = [1 -Inf -50];
% else
%     all_min_vals = [-Inf -Inf -50];
% end
% if peak_log
%     all_max_vals = [Inf 100 Inf];
% else
%     all_max_vals = [100 100 Inf];
% end

all_min_vals = [-Inf -50 0.1];
all_max_vals = [100 Inf 3];

all_plot_yscale = {'linear','linear','log'};


%Train plot pars
plot_steps = 1:6;
% plot_steps = [2, 7, 8];
step_size = [10, 20, 30, 40, 50, 60, 20, 20];


%Plot settings
summary_on = fltr_ONidx_t5;
% summary_off = OFFidx(end-1:end);
% summary_off = fltr_ONidx_t5(end-3:end);
% summary_off = [];
% all_summary_off = {[],[],fltr_ONidx_t5(end-1:end)};
all_summary_off = {[],[],[]};
    

opts = struct();
opts.input_n = step_size(plot_steps);
% opts.input_n = [1 2 3];
% if peak_log
%     opts.YScale = 'log';
% else
%     opts.YScale = 'linear';
% end
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
    opts.max_val = all_max_vals(p_idx);
    opts.YScale = all_plot_yscale{p_idx};
    summary_off = all_summary_off{p_idx};

    if p_idx == num_cols
        opts.bar = true;
    end
   
    [ax_train_par{p_idx},cb1] = UBC_par_line_plot2(...
        summary_on,summary_off,all_plot_par{p_idx}(plot_steps),f_train,pos_ax,opts);
    xlim([opts.input_n(1) opts.input_n(end)])
    
    %Turn off OFF stuff
    % summary_off = [];

    %Offset XLim a little bit
    ax_train_par{p_idx}.XLim(1) = ax_train_par{p_idx}.XLim(1)...
        - diff(ax_train_par{p_idx}.XLim) * 0.05;
    % fix_powered_ylabels(ax_train_par{p_idx})
    % opts.YScale = 'linear';
    ax_train_par{p_idx}.XTickLabelRotation = 0;

    % if strcmp(opts.YScale,'log')
    %     fix_powered_ylabels(ax_train_par{p_idx})
    % end

end

