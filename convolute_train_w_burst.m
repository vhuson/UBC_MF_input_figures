%% Get files, general means, and ONidx

setup_workspace_alltrain

%% Gather traces
all_burst_durs      = [0.01 0.02 0.05 0.10 0.2];
all_burst_tails     = [2.9    3    10   10   10];
washin_state = [1 0 0 0 0];

%Get traces
[all_mean_bursts,all_full_bursts] = ...
    get_burst_data(allData,Fs,all_burst_durs, all_burst_tails,...
    washin_state);


file_match = 'TRAIN5';
[all_mean_trains_5,all_full_trains_5,all_idx_5] = get_mean_by_filecode(...
    allData,file_match,washin_state);

% spk_timings = allData{1}.spks_prot{2}{all_idx_5{1}{1}(2)};

spk_timings = [5:1/5:7.8,...
                8:1/10:9,... 10
                9.2:1/5:11.8,...
                12:1/20:13,... 20
                13.2:1/5:15.8,...
                16:1/30:17,... 30
                17.2:1/5:19.8,...
                20:1/40:21,.... 40
                21.2:1/5:23.8,...
                24:1/50:25,... 50
                25.2:1/5:27.8,...
                28:1/60:29,... 60
                29.2:1/5:31.8,...
                32:1/20:33,... 20
                36:1/20:37];

spk_timings_fs = round(spk_timings *Fs);

%% Isolate specific cell train and burst trace
for cell_count = 28:31
curr_cell = ONidx(cell_count);
% curr_cell = UBC_cell_ID2idx(fileNames,{'1774'},ONidx);



burst20 = all_mean_bursts{5}(curr_cell,:);
curr_baseline = mean(burst20(1:9999));

burst1 = all_mean_bursts{1}(curr_cell,:);
burst2 = all_mean_bursts{2}(curr_cell,:);
burst5 = all_mean_bursts{3}(curr_cell,:);
burst10 = all_mean_bursts{4}(curr_cell,:);

burst20_scaled1 = (burst20-curr_baseline)/20 + curr_baseline;
burst20_scaled2 = (burst20-curr_baseline)/10 + curr_baseline;
burst20_scaled5 = (burst20-curr_baseline)/4 + curr_baseline;
burst20_scaled10 = (burst20-curr_baseline)/2 + curr_baseline;

train5 = all_mean_trains_5{curr_cell};
% 
% fig1 = figure;
% ax1 = axes;
% plot_fs(burst5,Fs,ax1);
% set(ax1.Children,'Color','k')
% 
% hold on
% plot_fs(burst20_scaled5,Fs,ax1);
% hold off

% Computed train trace
burst20_scaled_nobase = (burst20-curr_baseline)/20;
% curr_baseline = mean(burst1(1:9999));
% burst20_scaled_nobase = burst1-curr_baseline;
burst_len = numel(burst20_scaled_nobase);

comp_train5 = zeros(1,spk_timings_fs(end)+burst_len);
comp_train5 = comp_train5+curr_baseline;

for ii = 1:numel(spk_timings_fs)
    curr_spk = spk_timings_fs(ii)-0.5*Fs+1;
    curr_end = curr_spk+burst_len-1;

    comp_train5(curr_spk:curr_end) = ...
        comp_train5(curr_spk:curr_end) + burst20_scaled_nobase;
end
comp_train5(comp_train5<0) = 0;

%Scale computed train to train
fltr_train5 = medfilt1(train5,Fs*0.5);
fltr_train5_peak = max(fltr_train5(28*Fs:31*Fs));

fltr_comp_train5 = medfilt1(comp_train5,Fs*0.5);
comp_train5_peak = max(fltr_comp_train5(28*Fs:31*Fs));

scaled_comp_train5 = comp_train5;
scaled_comp_train5 = scaled_comp_train5 ./ comp_train5_peak;
scaled_comp_train5 = scaled_comp_train5 .* fltr_train5_peak;


fig1 = figure( 'Position', [66.4545 180.7818 1.4531e+03 672.8727]);


%Plot 20x and 1x response
ax_b1 = subplot(2,5,1);
plot_fs(burst1,Fs,ax_b1);
set(ax_b1.Children,'Color','k')
xlim([0 7])
title('1x')
ylabel('Response (spks)')

ax_b20 = subplot(2,5,6);
plot_fs(burst20,Fs,ax_b20);
set(ax_b20.Children,'Color','k')
xlim([0 7])
title('20x')
ylabel('Response (spks)')


ax1 = subplot(2,5,2:5);
plot_fs(train5,Fs,ax1);
set(ax1.Children,'Color','k')


hold on
plot_fs(comp_train5,Fs,ax1);
hold off
xlim([0 40])
title('Train and computed train')

ax2 = subplot(2,5,7:10);
plot_fs(train5,Fs,ax2);
set(ax2.Children,'Color','k')

hold on
plot_fs(scaled_comp_train5,Fs,ax2);
hold off
xlim([0 40])
title('Train and computed train (scaled to 60 step)')
xlabel('Time (s)');
standardFig(fig1);
pause
end
