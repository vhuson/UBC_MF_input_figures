function [washinIDs] = get_washinIDs(curr_file_names,washinID_states)
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here

base_prot_list = find(contains(curr_file_names,'100Hz'));
base_prot_jumps = diff(base_prot_list) > 2;
washin_borders = base_prot_list(base_prot_jumps);
washin_borders = washin_borders(2:end) - 4;
try
washin_borders(end+1) = base_prot_list(find(base_prot_jumps,1,'last')+4);
catch
    disp('No Washout?')
end
for ii = 1:numel(washin_borders)
    disp(washin_borders(ii))
    disp(curr_file_names{washin_borders(ii)})
    disp(newline)
    context_start = (washin_borders(ii) - 4);
    context_end = min([(washin_borders(ii) + 6), numel(curr_file_names)]);
    context_file_names = curr_file_names(context_start:context_end);
    cellfun(@disp,context_file_names);
    disp(newline)
    pause    
end
washin_borders = [1, washin_borders, numel(curr_file_names)+1];

washinIDs = false(numel(curr_file_names),numel(washinID_states));
for ii = 1:numel(washin_borders)-1
    curr_range = washin_borders(ii):washin_borders(ii+1)-1;
    curr_ID_states = repmat(washinID_states{ii},numel(curr_range),1);
    washinIDs(washin_borders(ii):washin_borders(ii+1)-1,:) = ...
        curr_ID_states;   
end
end