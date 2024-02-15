%%
curr_selection = select_cells;
% figure('Position', [612.2000 242 435.8000 288.6000]); 

pharm_burst_idx = 5;
trace_array = {all_mean_pharma_bursts1{pharm_burst_idx},...
                all_mean_pharma_bursts2{pharm_burst_idx},...
                all_mean_pharma_bursts3{pharm_burst_idx},...
                all_mean_pharma_bursts4{pharm_burst_idx}};


seed_colors = [0 0 0;
                1 0.6 0;
                0.8 0 0;
                0   0   1];


all_colors = seed_map(seed_colors,4);
% zerod_x = [0.5 0.51 0.54 0.59 0.69];
zerod_x = repmat(0.5,1,4);

% trace_labels = {'1x','2x','5x','10x','20x'};
trace_labels = {'Baseline','−mGluR2','−AMPAR','−mGluR1'};

%%
figure('Position', [612.2000 242 435.8000 288.6000]); 
% all_colors = copper(5);



curr_cell = curr_selection(curr_idx);

plot((1:numel(trace_array{1}(curr_cell,:)))/Fs-zerod_x(1),...
    trace_array{1}(curr_cell,:),'Color',all_colors(1,:))

hold on
for jj = 2:numel(trace_array)
plot((1:numel(trace_array{jj}(curr_cell,:)))/Fs-zerod_x(jj),...
    trace_array{jj}(curr_cell,:),'Color',all_colors(jj,:))
end
hold off
title(['Cell #',num2str(curr_idx)])
legend(trace_labels,'Box','off')
ylabel('Response (spk/s)')
xlabel('Time (s)')
xlim([-0.5 5])
standardFig();

