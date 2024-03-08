function [corr_trace,art_trace] = remove_artifacts(detrend_trace,pid2)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% take average of preceding and next artifact and see what we get
        
corr_trace = detrend_trace;
corr_trace = corr_trace(:);

art_trace = zeros(size(corr_trace));

fbuff = 19;
bbuff = 35;

all_arts = nan(numel(pid2),fbuff+bbuff+1);

%buffer trace at beginning and end
detrend_trace = [zeros(fbuff,1); detrend_trace(:); zeros(bbuff,1)];
pid2_shift = pid2+fbuff;
for ii = 1:numel(pid2_shift)
    all_arts(ii,:) = detrend_trace(pid2_shift(ii)-fbuff:pid2_shift(ii)+bbuff);    
end

pad = 10;

starts = (1:numel(pid2))-pad;
starts(1:pad) = 1;
ends = (1:numel(pid2))+pad;
ends(end-(pad-1):end) = numel(pid2);

%First artifact is impossible just remove all together
first_arts = find([true; diff(pid2(:))>20000]);
for ii = 1:numel(first_arts)
    first_art = first_arts(ii);
    ends(ends == first_art) = ends(ends == first_art)-1;
    ends(first_art) = first_art;
    starts(first_art:pad+first_art) = first_art+1;
    starts(first_art) =first_art;
end
for ii = 1:numel(pid2)
    curr_temp_art = mean(all_arts(starts(ii):ends(ii),:),1);
curr_temp_art(curr_temp_art>0) = ...
    curr_temp_art(curr_temp_art>0)./max(curr_temp_art);
curr_temp_art(curr_temp_art<0) = ...
    curr_temp_art(curr_temp_art<0)./-min(curr_temp_art);

curr_temp_art(curr_temp_art>0) = ...
    curr_temp_art(curr_temp_art>0).*max(all_arts(ii,:));
curr_temp_art(curr_temp_art<0) = ...
    curr_temp_art(curr_temp_art<0).*-min(all_arts(ii,:));

%Make sure everything stays in range
trace_range = pid2(ii)-fbuff:pid2(ii)+bbuff;
art_range = 1:fbuff+bbuff+1;
bad_idxes = trace_range<1 | trace_range>numel(art_trace);
trace_range(bad_idxes)  = [];
art_range(bad_idxes)    = [];

art_trace(trace_range) = curr_temp_art(art_range);
end

corr_trace = corr_trace - art_trace;

% figure; plot(detrend_trace)
% hold on; plot(art_trace,'k');
% plot(corr_trace,'r');
% hold off
end

