function [ax_base] = plot_baseline_spikechange(...
    ONidx,base_n_spikes_ss,base_n_spikes_peak,f1,ax_position)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
if nargin == 3
    f1 = figure('Position', [488 1.8000 406.6000 780.8000]);
    ax_position = [0.1300 0.1100 0.7750 0.8150];
elseif nargin == 4
    ax_position = [0.1300 0.1100 0.7750 0.8150];
end
color_code = [0, 0, 0;
                0.2 0.2 0.2;
                0.4 0.4 0.4;
                0.6 0.6 0.6];

ax_base = axes(f1,'Position',ax_position);
hold on
line([0 0],[0 numel(ONidx)+10],'Color','k')
pl1 = plot(base_n_spikes_ss{3}(ONidx),1:numel(ONidx),".",...
    "Color",color_code(4,:),"MarkerSize",18);

pl2 = plot(base_n_spikes_ss{2}(ONidx),1:numel(ONidx),'.',...
    "Color",color_code(3,:),"MarkerSize",18);
pl3 = plot(base_n_spikes_ss{1}(ONidx),1:numel(ONidx),'.',...
    "Color",color_code(2,:),"MarkerSize",18);
pl4 = plot(base_n_spikes_peak{1}(ONidx),1:numel(ONidx),'.',...
    "Color",color_code(1,:),"MarkerSize",18);
hold off
set(ax_base,"YDir","reverse","YLim",[0 numel(ONidx)+0.5])

legend([pl4 pl3 pl2 pl1],'Initial','1 Hz SS','2.5 Hz SS','5 Hz SS',...
    'Location','southeast','Box','off')
ylabel('Sorted cell (#)')
xlabel('Response spikes (n)')
if nargin == 3
    standardFig(f1);
else
    standardAx(ax_base);
end
end