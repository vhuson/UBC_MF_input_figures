function [pid_good,pid_fltr] = down_then_up(data_trace,pid)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
width = 40;

pid_fltr = false(size(pid));
for ii = 1:numel(pid)
    pre_range = pid(ii)-width:pid(ii)-5;
    post_range = pid(ii)+5:pid(ii)+width;
    pre_range(pre_range<1) = [];
    post_range(post_range>(numel(data_trace))) = [];


    pre_spike = data_trace(pre_range);
    post_spike = data_trace(post_range);
    
    pre_spike = sort(pre_spike,'descend');
    post_spike = sort(post_spike,'descend');
    
    pid_fltr(ii) = all(post_spike(1:4) > pre_spike(1:4));
    % pid_fltr(ii) = mean(post_spike) > mean(pre_spike);
end
pid_good = pid(pid_fltr);
end

