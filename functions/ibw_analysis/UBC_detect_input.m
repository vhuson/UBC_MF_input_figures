function [ii_new,curr_max_peak,curr_min_peak,curr_cut_peak,curr_min_width,...
    curr_use_old,break_loop,curr_cut_peak_max] = UBC_detect_input(ii,detect_opts,use_old)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

%Initialize output
ii_new = ii;
curr_max_peak = detect_opts.max_peak;
curr_min_peak = detect_opts.min_peak;
curr_cut_peak = detect_opts.cut_peak;
curr_cut_peak_max = detect_opts.cut_peak_max;
curr_min_width = detect_opts.min_width;
curr_use_old = use_old;
break_loop = false;

changeBol = true;
while changeBol
    changeValues = [0 0 0 0 0 0];
    dochange = input('Change parameters (1:Yes 0/blank:No 99:Break loop): ');

    if isempty(dochange) || dochange == 0 %All good continue
        ii_new = ii+1;
        break;
    elseif dochange == 99
        break_loop = true;
        break;
    else
        change = input([newline,'Detection parameters are set to:',newline,...
            '1-min_peak: ',num2str(detect_opts.min_peak),newline,...
            '2-max_peak: ',num2str(detect_opts.max_peak),newline,...
            '3-cut_peak: ',num2str(detect_opts.cut_peak),newline,...
            '4-min_width: ',num2str(detect_opts.min_width),newline,...
            '5-use_old: ',num2str(use_old),newline,...
            '6-cut_peak_max: ',num2str(detect_opts.cut_peak_max),newline,...
            'Which number would you like to change? (blank=none 0=all)',newline]);

        if isempty(change) %All good continue
            ii_new = ii+1;
            break;
        elseif change == 0 %All bad change all
            changeValues(:) = 1;
            changeBol = false;
        elseif change <= 6
            changeValues(change) = 1;
            changeBol = false;
        end


        %Change the right values
        if changeValues(1)
            temp_min_peak = input(['min_peak was: ',num2str(detect_opts.min_peak),...
                'New min_peak: '],'s');
            if ~isempty(temp_min_peak)
                curr_min_peak = str2double(temp_min_peak);
            end
        end
        if changeValues(2)
            temp_max_peak = input(['max_peak was: ',num2str(detect_opts.max_peak),...
                'New max_peak: '],'s');
            if ~isempty(temp_max_peak)
                curr_max_peak = str2double(temp_max_peak);
            end
        end
        if changeValues(3)
            temp_cut_peak = input(['cut_peak was: ',num2str(detect_opts.cut_peak),...
                'New cut_peak: '],'s');
            if ~isempty(temp_cut_peak)
                curr_cut_peak = str2double(temp_cut_peak);
            end
        end
        if changeValues(4)
            temp_min_width = input(['min_width was: ',num2str(detect_opts.min_width),...
                'New min_width: '],'s');
            if ~isempty(temp_min_width)
                curr_min_width = str2double(temp_min_width);
            end
        end
        if changeValues(5)
            temp_use_old = input(['use_old was: ',num2str(use_old),...
                'New use_old: '],'s');
            if ~isempty(temp_use_old)
                curr_use_old = str2num(temp_use_old);
            end
        end
        if changeValues(6)
            temp_cut_peak_max = input(['cut_peak_max was: ',num2str(detect_opts.cut_peak_max),...
                'New cut_peak_max: '],'s');
            if ~isempty(temp_cut_peak_max)
                curr_cut_peak_max = str2double(temp_cut_peak_max);
            end
        end

    end

end



end