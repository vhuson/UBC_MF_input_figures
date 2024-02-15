function [filtered_data] = adaptive_median_windowsize(data)
    num_data = numel(data);
    window_size = 5; % initialize minimum window size
    threshold1 = 1;
    threshold2 = 10;
    
    maximum_window_size = 200;
    minimum_window_size = 5;
    for i = 1:length(data)
        start_idx = max([i-window_size,1]);
        stop_idx = min([i+window_size, num_data]);
        local_variance = var(data(start_idx:stop_idx));
        if local_variance > threshold1 % high variance, increase window size
            window_size = min(window_size + 2, maximum_window_size);
        elseif local_variance < threshold2 % low variance, decrease window size
            window_size = max(window_size - 2, minimum_window_size);
        end

        start_idx = max([i-window_size,1]);
        stop_idx = min([i+window_size, num_data]);
        filtered_data(i) = median(data(start_idx:stop_idx));
    end
end