function [] = fix_ydata_error(ax1)
%UNTITLED17 Summary of this function goes here
%   Detailed explanation goes here
for ii = 1:numel(ax1.Children)
    try
        curr_ydata = ax1.Children(ii).YData;
        y_nans = isnan(curr_ydata);

        if any(y_nans)
            nonan_ydata = curr_ydata(~y_nans);
            if all(nonan_ydata == 0)
                %Need to fix this
                nan_locs = find(~y_nans);
                ax1.Children(ii).YData(nan_locs(2)) = 1e-3;


            end

        end
        
    end

end
end