%% Get files, general means, and ONidx

setup_workspace_alldata


%% Gather baseline data
all_base_freqs      = [1 2.5 5];
prot_spec_dur = [2 10];
washin_state = [1 0 0 0 0];

%Retrieve all data
[all_full_traces,all_peak_segments,all_ss_segments,...
    mean_peak_segments, min_trace_leng,pre_prot_baseline_traces] = ...
    get_baseline_data(allData,Fs,all_base_freqs,prot_spec_dur,...
    washin_state);

%Get peak and n-spikes info for each separate segment
[constant_input_pars, constant_input_pars_base_corr] = get_all_baseline_n_spikes(...
    all_full_traces,all_baseline,Fs,all_base_freqs);


%Calculate number of spikes at SS
[base_n_spikes_ss,base_amplitude_ss,base_async_ss,base_ratio_ss] = get_baseline_n_spikes(...
    all_ss_segments,all_baseline,Fs,min_trace_leng);

%Calculate number of spikes at peak
[base_n_spikes_peak] = get_baseline_n_spikes(...
    mean_peak_segments,all_baseline,Fs,min_trace_leng);




%% Other figures
stacked_constant_input_figure

heatmap_constant_input_figure


%% Example cells
%19, 29 51
typ_cell_IDs = {'1657','1685','1758'};
[typ_cell_idxs,typ_cell_num] = UBC_cell_ID2idx(fileNames,typ_cell_IDs,ONidx);

f_base_typ = figure('Position', [125.8000 98.7455 1.3318e+03 622.2545],...
    'Color','w');

typ_cell_num = sort([typ_cell_num, 37, 60]);

base_width = 0.17;
base_w_unit = base_width/5;
base_height = 0.1;
top_margin = 0.96;
left_margin = 0.04;
base_space = 0.04;
base_hspace = 0.02;

pos_ax = [left_margin-base_width-base_hspace,...
    top_margin+base_space,...
    base_width, base_height];

%Concatenate and fill zeros
[full_baseline_incl_traces] = concat_inst_freqs(all_full_traces,...
    pre_prot_baseline_traces,Fs);


all_colors = repmat([0 0 0],3,1);
lim_x = [0 11];
lim_x_ss = [8.95 10.95];
y_scalebar_size = [20 20 20 20 20];

zerod_x = [0 0 0];
trace_labels = {'1 Hz','2.5 Hz','5 Hz'};

opts = struct();
opts.axis_off = true;
opts.pad = false;

ax_base_typ = cell(size(typ_cell_num));
scale_opts = struct();
scale_opts.xlabel = 's';

ax_burst_typ = {};
ax_burst_typ_ss = {};
%Loop over cells
for ii = 1:numel(typ_cell_num)
    curr_cell = typ_cell_num(ii);
    pos_ax = [left_margin,...
              top_margin-base_height*ii-base_space*(ii-1),...
              base_width, base_height];

    %Loop over input freqs
    for jj = 1:numel(full_baseline_incl_traces)
        pos_ax(1) = left_margin + (base_width + base_hspace) * (jj-1);
        pos_ax(3) = base_width;
        [ax_burst_typ{ii}{jj}] = plot_burst_traces_overlay(full_baseline_incl_traces(jj),Fs,...
            ONidx,curr_cell,all_colors(1,:),0,...
            [],lim_x,f_base_typ,pos_ax,opts);


        pos_ax(1) = left_margin + (base_width + base_hspace*1.3) * numel(full_baseline_incl_traces)...
                                + base_w_unit*2.2*(jj-1);
        pos_ax(3) = base_w_unit*2;
        [ax_burst_typ_ss{ii}{jj}] = plot_burst_traces_overlay(full_baseline_incl_traces(jj),Fs,...
            ONidx,curr_cell,all_colors(1,:),0,...
            [],lim_x_ss,f_base_typ,pos_ax,opts);

        if ii == 1
            title(ax_burst_typ{ii}{jj},trace_labels{jj})
            if jj ==2
                title(ax_burst_typ_ss{ii}{jj},"End of train")
            end
        end

        if jj == 1
            text(ax_burst_typ{ii}{jj},0,0,['#',num2str(curr_cell)],'Units','normalized',...
                'Position',[-0.01 0.5],'VerticalAlignment','middle',...
                'HorizontalAlignment','right')

        end

    end
    same_ylim([ax_burst_typ{ii},ax_burst_typ_ss{ii}],'YMinValue',50);
    % same_ylim();
    
    scale_opts = struct();
    if ii == numel(typ_cell_num)
        scale_opts.xlabel = 's';
        scale_opts.ylabel = 'spk/s';
    end
    add_scale_bar(ax_burst_typ{ii}{1},[1,y_scalebar_size(ii)],scale_opts);
    add_scale_bar(ax_burst_typ_ss{ii}{end},[0.5,0],scale_opts);

end


%% Summaries
f1 = figure('Color','w','Position',[257.5818 320 1.0909e+03 299.7636]);

base_width = 0.18;
base_space = 0.1;
bar_width = 0.05;



pos_ax = [0.1051 0.2227 base_width 0.7286];

[ax_base_n] = UBC_par_line_plot(...
    ONidx,OFFidx,base_n_spikes_ss,[0 0 0],-Inf,f1,pos_ax,...
    [1 2 3]);
xlim([0.9 3.1])
ax_base_n.XTickLabels = [1 2.5 5];
ylabel('End of train\newlineResponse spikes (n)')
xlabel('Input rate (Hz)')

pos_ax(1) = pos_ax(1)+base_width+base_space;
[ax_base_p] = UBC_par_line_plot(...
    ONidx,OFFidx,base_amplitude_ss,[0 0 0],-Inf,f1,pos_ax,...
    [1 2 3]);
xlim([0.9 3.1])
ax_base_p.XTickLabels = [1 2.5 5];
ylabel('End of train\newlinePeak (\Deltaspk/s)')
xlabel('Input rate (Hz)')
% [ax_base] = plot_baseline_spike_heatmap(...
%     ONidx,base_n_spikes_ss,base_n_spikes_peak,f1,pos_ax);


pos_ax(1) = pos_ax(1)+base_width+base_space;
pos_ax(3) = base_width+bar_width;
[ax_base_p] = UBC_par_line_plot(...
    ONidx,OFFidx,base_ratio_ss,[0 0 1],-0,f1,pos_ax,...
    [1 2 3]);
xlim([0.9 3.1])
ax_base_p.XTickLabels = [1 2.5 5];
ylabel('End of train\newlineSteady state / Peak')
xlabel('Input rate (Hz)')


% save_figure_larger(f1,4);

%%






%%


for ii = 1:numel(typ_cell_num)
    curr_cell = typ_cell_num(ii);
    pos_ax(1) = left_margin + (base_width + base_hspace) * (ii-1);
    pos_ax(2) = top_margin+base_space;
    [ax_base_typ{ii}] = plot_burst_examples_v2(all_full_traces,...
        Fs,all_baseline,select_cells,curr_cell,all_colors,lim_x,zerod_x,input_dur,[],opts,...
        f_base_typ,pos_ax,base_height,base_space);

    pos_ax2 = pos_ax;

    pos_ax2(2) = pos_ax2(2) - (base_height + base_space) * 4 - base_space;
    pos_ax2(3) = base_w_unit;
    ax_burst_typ2 = cell(1,4);
    [ax_burst_typ2{1}] = plot_burst_traces_overlay(all_full_traces(1),Fs,...
        ONidx,curr_cell,all_colors(1,:),0,...
        [],[-5e-5 0.95],f_base_typ,pos_ax2,opts);
    
    pos_ax2(1) = pos_ax2(1) + base_w_unit + base_w_unit/3;
    pos_ax2(3) = base_w_unit*2;

    [ax_burst_typ2{2}] = plot_burst_traces_overlay(all_full_traces(1),Fs,...
        ONidx,curr_cell,all_colors(1,:),0,...
        [],[8-5e-5 9.95],f_base_typ,pos_ax2,opts);

    pos_ax2(1) = pos_ax2(1) + base_w_unit*2 + base_w_unit/3;
    pos_ax2(3) = base_w_unit*2;

    [ax_burst_typ2{3}] = plot_burst_traces_overlay(all_full_traces(2),Fs,...
        ONidx,curr_cell,all_colors(1,:),0,...
        [],[8-5e-5 9.95],f_base_typ,pos_ax2,opts);

    pos_ax2(1) = pos_ax2(1) + base_w_unit*2 + base_w_unit/3;
    pos_ax2(3) = base_w_unit*2;

    [ax_burst_typ2{4}] = plot_burst_traces_overlay(all_full_traces(3),Fs,...
        ONidx,curr_cell,all_colors(1,:),0,...
        [],[8-5e-5 9.95],f_base_typ,pos_ax2,opts);
    same_ylim(ax_burst_typ2);

    %
    % pos_ax(2) = pos_ax(2) - base_height*6 - base_space*6;
    % [ax_base_typfast{6}] = plot_burst_traces_overlay(all_mean_bursts,Fs,...
    %         ONidx,curr_cell,all_colors,zerod_x,...
    %         [],lim_x+0.5,f_base_typ,pos_ax,opts);


    add_scale_bar(ax_base_typ{ii}{end},[1,0],scale_opts);
end

%%
pos_ax(1) = left_margin + base_width + base_hspace;
pos_ax(2) = top_margin+base_space;

curr_cell = typ_cell_num(2);

[ax_burst_typmid] = plot_burst_examples_v2(all_full_traces,...
    Fs,all_baseline,select_cells,curr_cell,all_colors,lim_x,zerod_x,input_dur,[],opts,...
    f_base_typ,pos_ax,base_height,base_space);
% %%
% pos_ax(2) = pos_ax(2) - base_height*6 - base_space*6;
% [ax_burst_typmid{6}] = plot_burst_traces_overlay(all_mean_bursts,Fs,...
%         ONidx,curr_cell,all_colors,zerod_x,...
%         [],lim_x+0.5,f_base_typ,pos_ax,opts);

add_scale_bar(ax_burst_typmid{end},[1,0],scale_opts);


pos_ax(1) = left_margin + base_width*2 + base_hspace*2;
pos_ax(2) = top_margin+base_space;

curr_cell = typ_cell_num(3);

[ax_burst_typslow] = plot_burst_examples_v2(all_full_traces,...
    Fs,all_baseline,select_cells,curr_cell,all_colors,lim_x,zerod_x,input_dur,[],opts,...
    f_base_typ,pos_ax,base_height,base_space);


% %%
% pos_ax(2) = pos_ax(2) - base_height*6 - base_space*6;
% [ax_burst_typslow{6}] = plot_burst_traces_overlay(all_mean_bursts,Fs,...
%         ONidx,curr_cell,all_colors,zerod_x,...
%         [],lim_x+0.5,f_base_typ,pos_ax,opts);

add_scale_bar(ax_burst_typslow{end},[1,0],scale_opts);


title(ax_base_typfast{1},'Fast')
title(ax_burst_typmid{1},'Medium')
title(ax_burst_typslow{1},'Slow')


%%

pos_ax = [0.5600    0.0700    0.150    0.8900];
[ax_stack_4] = plot_stacked_base_overlay(...
    all_ss_segments,all_baseline,Fs,select_cells,f1,pos_ax);
ax_stack_4{1}.Title.String = 'Steady state';
ax_stack_4{end}.XLabel.String = 'Time (s)';

same_ylim_stack({ax_stack_1, ax_stack_2, ax_stack_3,ax_stack_4});

% pos_ax = [0.7700    0.0700    0.170    0.8900];
% [ax_base] = plot_baseline_spikechange(...
%     ONidx,base_n_spikes_ss,base_n_spikes_peak,f1,pos_ax);


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
opts.xlim = [0 numel(ONidx)+1];
% opts.curr_color = all_colors(input_idx,:);
opts.plot_line = 0;
opts.upperbound = 10;
% opts.lowerbound = 0.1;

input_idx = 1;
num_par = base_n_spikes_ss{input_idx}(ONidx);
% den_par = base_n_spikes_ss{1}(ONidx);
den_par = ones(size(num_par));

ax_ratio = {};
[ax_ratio{input_idx}] = changed_par_normalized_plot(...
    num_par,...
    den_par,...
    1:numel(ONidx),f1,pos_ax,opts);
opts.ylabel_text = '';

input_idx = 2;
pos_ax(1) = pos_ax(1) + base_width + base_space;
num_par = base_n_spikes_ss{input_idx}(ONidx);
opts.title_text = '2.5Hz';
[ax_ratio{input_idx}] = changed_par_normalized_plot(...
    num_par,...
    den_par,...
    1:numel(ONidx),f1,pos_ax,opts);

input_idx = 3;
pos_ax(1) = pos_ax(1) + base_width + base_space;
num_par = base_n_spikes_ss{input_idx}(ONidx);
opts.title_text = '5Hz';
[ax_ratio{input_idx}] = changed_par_normalized_plot(...
    num_par,...
    den_par,...
    1:numel(ONidx),f1,pos_ax,opts);

same_ylim(ax_ratio)

%
pos_ax(1) = 0.1;
pos_ax(2) = 0.2491;


opts.title_text = '';
opts.ylabel_text = 'Normalized Change';
opts.xlabel_text = 'Sorted cell #';
opts.plot_line = 0;
opts.upperbound = 2;
opts.lowerbound = -2;

num_par = base_n_spikes_ss{3}(ONidx) - base_n_spikes_ss{1}(ONidx);
den_par = abs(base_n_spikes_ss{1}(ONidx));



[ax_ratio_test] = changed_par_normalized_plot(...
    num_par,...
    den_par,...
    1:numel(ONidx),f1,pos_ax,opts);

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
%%

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