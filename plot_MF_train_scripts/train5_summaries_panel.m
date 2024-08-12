% f_train = figure('Position', [488 1.8000 680.3150 857.9636],...
%     'Color','w');

%Plot options
peak_log = false;

%Define axis position
num_cols = 3;
num_rows = 1;

left_margin = 0.1;
bottom_margin = 0.1764;
% total_width = 0.6850;
total_width = 0.8643;

base_space = 0.12;
extra_space = 0.04; %For legend

graph_height = 0.1143;

base_width = (total_width-base_space*num_cols-extra_space) / (num_cols+1);

all_left_edges = (base_width + base_space) .* (0:num_cols) + left_margin;

%Add extra space after first plot
all_left_edges(2:end) = all_left_edges(2:end) + extra_space;
% all_left_edges(4) = all_left_edges(4) + extra_space;

%remove extra panel for now
all_left_edges(3) = [];



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

% all_plot_par = {specific_nspikes_base_corr{1},...
%                 specific_nspikes_base_corr{2},...                    
%                     all_train_half_decay};

% all_plot_par = {specific_nspikes_global_basecorr{1},...
%                 specific_nspikes_global_basecorr{2},...                    
%                     all_train_half_decay};

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

% all_ylabels = {'\DeltaSpikes during step 0.9-1s (n)',...
%                 '\DeltaSpikes after step 2-3s (n)',...
%                 'Step half-decay (s)'};

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
all_plot_steps = {[1:6],[1:6],[2:6]};
% plot_steps = [2, 7, 8];
step_size = [10, 20, 30, 40, 50, 60, 20, 20];


%Plot settings
summary_on = fltr_ONidx_t5;
% summary_off = OFFidx(end-1:end);
% summary_off = fltr_ONidx_t5(end-3:end);
% summary_off = [];
all_summary_off = {[],[],fltr_ONidx_t5(end-3:end)};
% all_summary_off = {[],[],[]};
    

opts = struct();

% opts.input_n = [1 2 3];
% if peak_log
%     opts.YScale = 'log';
% else
%     opts.YScale = 'linear';
% end
% opts.XScale = 'log';
opts.XLabel = "Input step (spk/s)";


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

    plot_steps = all_plot_steps{p_idx};
    opts.input_n = step_size(plot_steps);
    opts.XTick = opts.input_n;
    opts.XTickLabel = step_size(plot_steps);

    % if p_idx == 2
    %     opts.bar = true;
    % else
    %     opts.bar = false;
    % end
   
    [ax_train_par{p_idx},cb1] = UBC_par_line_plot2(...
        summary_on,summary_off,all_plot_par{p_idx}(plot_steps),f_train,pos_ax,opts);
    xlim([opts.input_n(1) opts.input_n(end)])

    % if p_idx == 2
    %     cb1.Position = [0.7111 0.1985 0.0128 0.0695];
    % end
    
    if p_idx == 1
        % add legend line color bar
        seed_colors = [1 0 0;
            1 0.5 0.2;
            0.4 1 0.4;
            0.2 0.5 1;
            0 0 1];

        legend_colors = seed_map(seed_colors,numel(summary_on));
        % legend_colors = legend_colors(1:(numel(ONidx)-numel(OFFidx)),:);

        legend_pos = [pos_ax(1)+base_width+0.02 pos_ax(2)+0.02 0.0128 0.0695];

        legend_opts = struct();
        % legend_opts.n_shown = 5;
        legend_opts.n_pos =[1 15 31];
        [cl_ax] = colorline_legend(legend_colors,legend_pos,f_train,legend_opts);

    end
    %Turn off OFF stuff
    % summary_off = [];


    %Offset XLim a little bit
    ax_train_par{p_idx}.XLim(1) = ax_train_par{p_idx}.XLim(1)...
        - diff(ax_train_par{p_idx}.XLim) * 0.05;
    
    if strcmp(ax_train_par{p_idx}.YScale,'linear')
        ax_train_par{p_idx}.YLim(1) = ax_train_par{p_idx}.YLim(1)...
            - diff(ax_train_par{p_idx}.YLim) * 0.05;
    else
        ax_train_par{p_idx}.YLim(1) = exp(log(ax_train_par{p_idx}.YLim(1))...
            - diff(log(ax_train_par{p_idx}.YLim)) * 0.05);
    end

    ax_train_par{p_idx}.XTickLabel(2:end-1) = {''}; 
    % fix_powered_ylabels(ax_train_par{p_idx})
    % opts.YScale = 'linear';
    ax_train_par{p_idx}.XTickLabelRotation = 0;

    % if strcmp(opts.YScale,'log')
    %     fix_powered_ylabels(ax_train_par{p_idx})
    % end

end

 % ax_train_par{p_idx}.YRuler.MinorTick = 'off';