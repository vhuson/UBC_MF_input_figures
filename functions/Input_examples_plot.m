Fs = 20000;
input_train = zeros(1,800001);
input_x = (1:800001)/Fs;


%Just repeated bursts
x_locs = sort([3:3:35, 3.2:3:35.2]);
y_locs = repmat([100 0],1,11);

% %Train 5
% x_locs = [5 8  9 12 13 16 17 20 21 24 25 28 29 32 33 36 37];
% y_locs = [5 10 5 20 5  30 5  40 5  50 5  60 5  20 0  20 0];

%Train 10
% x_locs = [5  8  9  12 13 16 17 20 21 24 25 28 29 32 33 36 37];
% y_locs = [10 20 10 30 10 40 10 50 10 60 10 80 10 40 0  20 0];

% % Baseline increase set
% x_locs = [3 13 14 17 18 21 22 25 26 29 30 33];
% y_locs = [5 60 10 60 20 60 30 60 40 60 40 0];


% Baseline stable set
% x_locs = [3  13 14 17 18 21 22 25 26 29 30 33 34 37];
% y_locs = [20 60 20 60 20 60 20 60 20 60 20 80 20 0];

for ii = 1:numel(x_locs)-1
    curr_range = round(x_locs(ii)*Fs): round(x_locs(ii+1)*Fs);
    input_train(curr_range) = y_locs(ii);

end


%MF like input
% input_train = time2rate(round((prot_timings{3}+3000)*20),Fs,40+1/Fs);

figure('Position', [129.2909 502.8182 1.2707e+03 187.6364]);
ax1 = axes('Position',[0.1300 0.2534 0.7750 0.5652]);
plot(input_x,input_train,'k');
axis tight
ylabel('Input (spk/s)')
xlabel('Time (s)')
% ylim([0 100])
hold on
for ii = 1:numel(x_locs)-1
    text(x_locs(ii)+0.15,y_locs(ii)+2,num2str(y_locs(ii)),...
        'VerticalAlignment','bottom','HorizontalAlignment','left')

end
hold off

text(0,0,['Total input spikes = ',num2str(floor(sum(input_train)/Fs))],...
    'Units','normalized','Position',[1 1],...
    'VerticalAlignment','bottom','HorizontalAlignment','right')

% text(0,0,['Total input spikes = ',num2str(numel(prot_timings{3}))],...
%     'Units','normalized','Position',[1 1],...
%     'VerticalAlignment','bottom','HorizontalAlignment','right')
% hold on
% line(ax1.XLim,repmat(10,1,2),'Color',[0.7 0.7 0.7],'LineWidth',1.5)
% line(ax1.XLim,repmat(20,1,2),'Color',[0.7 0.7 0.7],'LineWidth',1.5)
% line(ax1.XLim,repmat(60,1,2),'Color',[0.7 0.7 0.7],'LineWidth',1.5)
% line(ax1.XLim,repmat(80,1,2),'Color',[0.7 0.7 0.7],'LineWidth',1.5)
% 
% ax1.YTick = [10, 20, 60, 80];
% 
% hold off
standardFig()