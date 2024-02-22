function [washin_base_rates] = get_washin_baselines(allData,washin_states,Fs)
%UNTITLED15 Summary of this function goes here
%   Detailed explanation goes here
if nargin < 2
    washin_states = {[1 0 0 0 0],[0 1 0 0 0],[0 1 1 0 0],[0 1 1 1 0]};
end
if nargin < 3
    Fs = 20000;
end

%Check between 4 and 5sec (right before stimulation)
base_segment = (1:Fs) + 4*Fs - 1;

washin_base_rates = cell(size(washin_states));
for ii = 1:numel(washin_states)
    curr_washin = washin_states{ii};
    
    washin_base_rates{ii} = nan(size(allData));

    for jj = 1:numel(allData)
        currData = allData{jj};

        % Get idexes of current washin
        curr_washin_idxes = find(all(currData.washinIDs == curr_washin,2));
        if ~isempty(curr_washin_idxes)
            curr_split_idxes = arrayfun(@(x) {get_split_idx(currData.curr_file_names,...
                x)},curr_washin_idxes);
            curr_split_idxes = vertcat(curr_split_idxes{:});
            % Only keep basic protocol
            curr_split_idxes(curr_split_idxes(:,1) == 2,:) = [];

            %Get baselines of all current traces
            trial_base_rates = nan(size(curr_split_idxes,1),1);
            for kk = 1:size(curr_split_idxes,1)
                curr_freqs = currData.freqs{1}{curr_split_idxes(kk,2)};

                curr_base_rate = median(curr_freqs(base_segment));
                trial_base_rates(kk) = curr_base_rate;
            end
            cell_base_rates = mean(trial_base_rates);

            washin_base_rates{ii}(jj) = cell_base_rates;
        end
    end

end
end