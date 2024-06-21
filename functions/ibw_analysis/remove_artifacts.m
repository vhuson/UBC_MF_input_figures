function [corr_trace,art_trace] = remove_artifacts(detrend_trace,pid2,opts)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% take average of preceding and next artifact and see what we get
base_opts.fbuff = 19;
base_opts.bbuff = 35;
base_opts.pad = 1;
if nargin < 3
    opts = base_opts;
else
    opts = merge_structs(base_opts,opts);
end

corr_trace = detrend_trace;
corr_trace = corr_trace(:);

art_trace = zeros(size(corr_trace));

fbuff = opts.fbuff;
bbuff = opts.bbuff;

all_arts = zeros(numel(pid2),fbuff+bbuff+1);

%buffer trace at beginning and end
detrend_trace = [zeros(fbuff,1); detrend_trace(:); zeros(bbuff,1)];
pid2_shift = pid2+fbuff;
for ii = 1:numel(pid2_shift)
    %Check to see if we don't overlap with next artifact
    if ii < numel(pid2_shift)
        art_end = min([pid2_shift(ii)+bbuff, pid2_shift(ii+1)-fbuff]);
    else
        art_end = pid2_shift(ii)+bbuff;
    end
    art_start = pid2_shift(ii)-fbuff;
    art_range = art_end-art_start+1;
    
    all_arts(ii,1:art_range) = detrend_trace(art_start:art_end);
end


if ~isempty(pid2)
    %First artifact is impossible just zero it out
    first_arts = find([true; diff(pid2(:))>20000]);
    for ii = 1:numel(first_arts)
        first_art = first_arts(ii);
        
        curr_temp_art = all_arts(first_art,:);
        
        %Make sure everything stays in range
        trace_range = pid2(first_art)-fbuff:pid2(first_art)+bbuff;
        art_range = 1:fbuff+bbuff+1;
        bad_idxes = trace_range<1 | trace_range>numel(art_trace);
        trace_range(bad_idxes)  = [];
        art_range(bad_idxes)    = [];
        
        %Place estimated artifact in artifact trace
        art_trace(trace_range) = curr_temp_art(art_range);
        
        
        % %Remove it if it is included in the end
        % ends(ends == first_art) = ends(ends == first_art)-1;
        % ends(first_art) = first_art;
        % starts(first_art:pad+first_art) = first_art+1;
        % starts(first_art) =first_art;
    end
    pid2_clean = pid2;
    pid2_clean(first_arts) = [];
    
    pad = opts.pad;

    if ~isempty(pid2_clean) && numel(pid2_clean) > pad
        
        
        starts = (1:numel(pid2_clean))-pad;
        starts(1:pad) = 1;
        ends = (1:numel(pid2_clean))+pad;
        ends(end-(pad-1):end) = numel(pid2_clean);
        
        for ii = 1:numel(pid2_clean)
            %Get average artifact over over "pad" number of artifacts
            curr_temp_art = mean(all_arts(starts(ii):ends(ii),:),1);
            
            %Normalize up and down strokes
            curr_temp_art(curr_temp_art>0) = ...
                curr_temp_art(curr_temp_art>0)./max(curr_temp_art);
            curr_temp_art(curr_temp_art<0) = ...
                curr_temp_art(curr_temp_art<0)./-min(curr_temp_art);
            
            %Resize up and down strokes to current artifact
            curr_temp_art(curr_temp_art>0) = ...
                curr_temp_art(curr_temp_art>0).*max(all_arts(ii,:));
            curr_temp_art(curr_temp_art<0) = ...
                curr_temp_art(curr_temp_art<0).*-min(all_arts(ii,:));
            
            %Make sure everything stays in range
            trace_range = pid2_clean(ii)-fbuff:pid2_clean(ii)+bbuff;
            art_range = 1:fbuff+bbuff+1;
            bad_idxes = trace_range<1 | trace_range>numel(art_trace);
            trace_range(bad_idxes)  = [];
            art_range(bad_idxes)    = [];
            
            %Place estimated artifact in artifact trace
            art_trace(trace_range) = curr_temp_art(art_range);
        end
    end
end
corr_trace = corr_trace - art_trace;

% figure; plot(detrend_trace)
% hold on; plot(art_trace,'k');
% plot(corr_trace,'r');
% hold off
end

