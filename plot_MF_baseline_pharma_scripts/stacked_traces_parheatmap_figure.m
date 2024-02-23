%%

f_base_pharma = figure('Position', [488 1.8000 936.8000 780.8000],...
    'Color','w');


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
