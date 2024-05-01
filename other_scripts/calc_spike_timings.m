%% save csv
curr_ms = double(round(all_locs*Fs))/20;

curr_prot = 'sine_20amp_1Hz_26base';
% curr_prot = 'exp_ramp_80Hz_x3';


csvwrite([curr_prot,'.txt'],curr_ms(:)')


%% sine solver
Fs = 20000;

base_rate = 15;
sin_freq = 0.5;
sin_amp = 15;
sin_start = 5;


% wave_fun = @(x) base_rate + ...
%                 sin((x-sin_start).*2*pi*sin_freq)*sin_amp;

wave_fun = zeros(1,50*Fs);
wave_fun(5*Fs:15*Fs) = base_rate;
wave_fun(15*Fs:45*Fs) = base_rate + sin((0:1/Fs:30).*2*pi*sin_freq)*sin_amp;
wave_fun(wave_fun<sin_freq) = sin_freq;

% step_height = 40;
% slope_dur = 0.5;
% step_dur = 1;
% step_start = 0.2;
% step_slope = (step_height-base_rate)/slope_dur;
% 
% wave_fun = @(x) base_rate + ...
%                 (max([min([(x-step_start),slope_dur]),0]) * step_slope) * (step_dur > (x-step_start));


%Move through the trace by half an ISI
forw_fun = @(x) x-(0.5/wave_fun(min([numel(wave_fun),round(x*Fs)])));
back_fun = @(x) x+(0.5/wave_fun(min([numel(wave_fun),round(x*Fs)])));


start_point = 5;
end_point = 45;

% Build forwards
all_locs = start_point;
curr_loc = back_fun(start_point);
while curr_loc < end_point
    err_fun = @(x) (curr_loc - forw_fun(x))^2;
    next_est = back_fun(curr_loc);
    next_loc = fminsearch(err_fun,next_est);

    if next_loc <= curr_loc
        %Bad find advance a bit
        curr_loc = curr_loc+0.01;
    else
        all_locs = [all_locs, next_loc];
        curr_loc = back_fun(next_loc);
        disp(curr_loc)
    end
end

%Build backward
% all_locs = 1;
% curr_loc = forw_fun(1);
% while curr_loc > -0.5
%     err_fun = @(x) (curr_loc - back_fun(x))^2;
%     next_est = forw_fun(curr_loc);
%     next_loc = fminsearch(err_fun,next_est);
% 
%     all_locs = [next_loc, all_locs];
%     curr_loc = forw_fun(next_loc);
%     disp(curr_loc)
% end



all_locs(all_locs<start_point) = [];
all_locs(all_locs>end_point) = [];


%draw result
figure; axes;
hold on
for ii = 1:numel(all_locs)
    curr_y = wave_fun(round(all_locs(ii)*Fs));
    curr_x = [all_locs(ii) - 0.5/curr_y,...
                all_locs(ii) + 0.5/curr_y];

    line(curr_x, repmat(curr_y,1,2))
end
Fs = 20000;
all_idx = round((all_locs-start_point)*Fs)+1;
inst_freq = time2rate(all_idx,Fs,(end_point-start_point)+1/Fs);
plot((1/Fs:1/Fs:((end_point-start_point)+1/Fs))+start_point,inst_freq)

curr_x = start_point:0.001:end_point;
curr_y = [];
for ii = 1:numel(curr_x)
    curr_y(ii) = wave_fun(round(curr_x(ii)*Fs));
end

plot(curr_x,curr_y,'k')
hold off



%% multiple linear ramps solver
Fs = 20000;
T = 55;
curr_y = zeros(1,T*Fs);
curr_x = (1:numel(curr_y))./Fs;

start_point = 3;
end_point = 50;

base_rate = 10;
step_heights = ones(1,9)*(80-base_rate);
slope_durs = [1, 0.5, 0.2, 1, 0.5, 0.2, 1, 0.5, 0.2];
step_durs = slope_durs+1;
step_starts = 8:4:40;
step_starts(2:end) = step_starts(2:end) + cumsum(slope_durs(1:end-1));

% step_fun = @(x) (max([min([(x-step_start),slope_dur]),0]) * step_slope) * (step_dur > (x-step_start));

% add steps
for ii = 1:numel(step_starts)
    step_height = step_heights(ii);
    slope_dur = slope_durs(ii);
    step_dur = step_durs(ii);
    step_start = step_starts(ii);

    step_slope = step_height/slope_dur;

    step_fun = @(x) (max([min([(x-step_start),slope_dur]),0]) * step_slope)...
        * (step_dur > (x-step_start));
    
    new_y = zeros(size(curr_x));
    for jj = 1:numel(new_y)
        new_y(jj) = step_fun(curr_x(jj));
    end
    curr_y = curr_y + new_y;
end
%add baseline

curr_y(start_point*Fs:end_point*Fs) = curr_y(start_point*Fs:end_point*Fs) + base_rate;

% figure; plot(curr_x,curr_y)


% forw_fun = @(x) round((x/Fs-(0.5/curr_y(x))*Fs));
% back_fun = @(x) round((x/Fs+(0.5/curr_y(x))*Fs));
forw_fun = @(x) round(round(x)-(0.5/curr_y(round(x)))*Fs);
back_fun = @(x) round(round(x)+(0.5/curr_y(round(x)))*Fs);

% Build forwards
all_locs = start_point*Fs;
curr_loc = back_fun(start_point*Fs);
while curr_loc < end_point*Fs
    err_fun = @(x) (curr_loc - forw_fun(x))^2;
    next_est = back_fun(curr_loc);
    next_loc = fminsearch(err_fun,next_est);
    next_loc = round(next_loc);

    all_locs = [all_locs, next_loc];
    curr_loc = back_fun(next_loc);
    % disp(curr_loc)
end

%Move out last loc to prefer rate rather than location
all_locs(end) = all_locs(end-1) + (1/base_rate)*Fs;

%draw result
figure; axes;
hold on

inst_freq = time2rate(all_locs,Fs,T);
plot(curr_x,inst_freq)

plot(curr_x,curr_y,'k')
% for ii = 1:numel(all_locs)
%     curr_freq = curr_y(all_locs(ii));
%     curr_isi = [all_locs(ii) - (0.5/curr_freq)*Fs,...
%                 all_locs(ii) + (0.5/curr_freq)*Fs];
% 
%     line(curr_isi/Fs, repmat(curr_freq,1,2))
% end

hold off




%% multiple 1-exp(-x) solver
Fs = 20000;
T = 55;
curr_y = zeros(1,T*Fs);
curr_x = (1:numel(curr_y))./Fs;

start_point = 3;
end_point = 47;

base_rate = 10;
step_heights = ones(1,9)*(80-base_rate);
slope_durs = repmat([0.4 0.8 1.2],1,3);
step_durs = ones(1,9)*1.5;
step_starts = 8:4:40;


% step_fun = @(x) (1-exp(-(max([x-step_start,0]))*(5/slope_dur)))...
%     *step_height * (step_dur > (x-step_start));



% add steps
for ii = 1:numel(step_starts)
    step_height = step_heights(ii);
    slope_dur = slope_durs(ii);
    step_dur = step_durs(ii);
    step_start = step_starts(ii);


    step_fun = @(x) (1-exp(-(max([x-step_start,0]))*(5/slope_dur)))...
    *step_height * (step_dur > (x-step_start));
    
    new_y = zeros(size(curr_x));
    for jj = 1:numel(new_y)
        new_y(jj) = step_fun(curr_x(jj));
    end
    curr_y = curr_y + new_y;
end
%add baseline

curr_y(start_point*Fs:end_point*Fs) = curr_y(start_point*Fs:end_point*Fs) + base_rate;

figure; plot(curr_x,curr_y)


% forw_fun = @(x) round((x/Fs-(0.5/curr_y(x))*Fs));
% back_fun = @(x) round((x/Fs+(0.5/curr_y(x))*Fs));
forw_fun = @(x) round(round(x)-(0.5/curr_y(round(x)))*Fs);
back_fun = @(x) round(round(x)+(0.5/curr_y(round(x)))*Fs);

% Build forwards
all_locs = start_point*Fs;
curr_loc = back_fun(start_point*Fs);
while curr_loc < end_point*Fs
    err_fun = @(x) (curr_loc - forw_fun(x))^2;
    next_est = back_fun(curr_loc);
    next_loc = fminsearch(err_fun,next_est);
    next_loc = round(next_loc);

    all_locs = [all_locs, next_loc];
    curr_loc = back_fun(next_loc);
    % disp(curr_loc)
end

%Move out last loc to prefer rate rather than location
all_locs(end) = all_locs(end-1) + (1/base_rate)*Fs;

%draw result
figure; axes;
hold on

% inst_freq = time2rate(all_locs,Fs,T);
% plot(curr_x,inst_freq)
stairs(all_locs(1:end-1)./Fs, 1./diff(all_locs./Fs))

plot(curr_x,curr_y,'k')
% for ii = 1:numel(all_locs)
%     curr_freq = curr_y(all_locs(ii));
%     curr_isi = [all_locs(ii) - (0.5/curr_freq)*Fs,...
%                 all_locs(ii) + (0.5/curr_freq)*Fs];
% 
%     line(curr_isi/Fs, repmat(curr_freq,1,2))
% end

hold off





%% linear ramp up solver
base_rate = 5;
step_height = 40;
slope_dur = 0.5;
step_dur = 1;
step_start = 0.2;
step_slope = (step_height-base_rate)/slope_dur;

step_fun = @(x) base_rate + ...
                (max([min([(x-step_start),slope_dur]),0]) * step_slope) * (step_dur > (x-step_start));

forw_fun = @(x) x-(0.5/step_fun(x));
back_fun = @(x) x+(0.5/step_fun(x));


start_point = -0.5;
end_point = 2;

% Build forwards
all_locs = start_point;
curr_loc = back_fun(start_point);
while curr_loc < end_point
    err_fun = @(x) (curr_loc - forw_fun(x))^2;
    next_est = back_fun(curr_loc);
    next_loc = fminsearch(err_fun,next_est);

    all_locs = [all_locs, next_loc];
    curr_loc = back_fun(next_loc);
    disp(curr_loc)
end

%Build backward
% all_locs = 1;
% curr_loc = forw_fun(1);
% while curr_loc > -0.5
%     err_fun = @(x) (curr_loc - back_fun(x))^2;
%     next_est = forw_fun(curr_loc);
%     next_loc = fminsearch(err_fun,next_est);
% 
%     all_locs = [next_loc, all_locs];
%     curr_loc = forw_fun(next_loc);
%     disp(curr_loc)
% end



all_locs(all_locs<start_point) = [];
all_locs(all_locs>end_point) = [];


%draw result
figure; axes;
hold on
for ii = 1:numel(all_locs)
    curr_y = step_fun(all_locs(ii));
    curr_x = [all_locs(ii) - 0.5/curr_y,...
                all_locs(ii) + 0.5/curr_y];

    line(curr_x, repmat(curr_y,1,2))
end
Fs = 20000;
all_idx = round((all_locs-start_point)*Fs)+1;
inst_freq = time2rate(all_idx,Fs,(end_point-start_point)+1/Fs);
plot((1/Fs:1/Fs:((end_point-start_point)+1/Fs))+start_point,inst_freq)

curr_x = start_point:0.001:end_point;
curr_y = [];
for ii = 1:numel(curr_x)
    curr_y(ii) = step_fun(curr_x(ii));
end

plot(curr_x,curr_y,'k')
hold off

%% 1 - exp(-x) solver
base_rate = 15;
step_height = 80;
step_dur = 1.2;

step_fun = @(x) (1-exp(-x*(5/step_dur)))*(step_height-base_rate)+base_rate;

forw_fun = @(x) x-(0.5/step_fun(x));
back_fun = @(x) x+(0.5/step_fun(x));

%get_midpoint
inv_fun = @(y) -(log(1-((y-base_rate)/(step_height-base_rate)))/(5/step_dur));
mid_freq = (step_height-base_rate)/2+base_rate;
mid_loc = inv_fun(mid_freq);

%Build backward
curr_loc = forw_fun(mid_loc);
all_locs = mid_loc;
while curr_loc > 0
    err_fun = @(x) (curr_loc - back_fun(x))^2;
    next_est = forw_fun(curr_loc);
    next_loc = fminsearch(err_fun,next_est);
    
    all_locs = [next_loc, all_locs];
    curr_loc = forw_fun(next_loc);
    disp(curr_loc)
end

%Build forwards
curr_loc = back_fun(mid_loc);
while curr_loc < step_dur
    err_fun = @(x) (curr_loc - forw_fun(x))^2;
    next_est = back_fun(curr_loc);
    next_loc = fminsearch(err_fun,next_est);
    
    all_locs = [all_locs, next_loc];
    curr_loc = back_fun(next_loc);
    disp(curr_loc)
end

all_locs(all_locs<0) = [];
all_locs(all_locs>step_dur) = [];

%draw result
figure; axes;
hold on
for ii = 1:numel(all_locs)
    curr_y = step_fun(all_locs(ii));
    curr_x = [all_locs(ii) - 0.5/curr_y,...
                all_locs(ii) + 0.5/curr_y];

    line(curr_x, repmat(curr_y,1,2))
end
Fs = 20000;
all_idx = round(all_locs*Fs);
inst_freq = time2rate(all_idx,Fs,step_dur);
plot(1/Fs:1/Fs:step_dur,inst_freq)
hold off

%%

full_mf = time2rate(round(prot_timings{1}*20),Fs,30);

single_step_mf = full_mf(170000:204000);
single_x_time = (1:numel(single_step_mf))/Fs;
single_x_time = single_x_time-0.6;
figure; ax1 = axes;
plot(single_x_time,single_step_mf);
hold on;
plot(single_x_time,step_fun(single_x_time));
hold off
ylim([0 100]);
%%
figure
x_time = (1:30*Fs)/Fs;
plot(x_time,time2rate(round(prot_timings{1}*20),Fs,30),'k')
