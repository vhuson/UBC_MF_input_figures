f_base = figure('Position', [403.3273 218.3091 837.8182 280.1455],...
    'Color','w');


% Generic cell to hold any parameter for heatmap plot
array_constant_input_par = {};

for ii = 1:numel(constant_input_pars)
    % plot peaks
    % array_constant_input_par{ii} = [constant_input_pars(ii).peaks{:}]';
    % curr_ylabel = 'Response peak (norm.)';

    % plot n_spikes constant window
    array_constant_input_par{ii} = [constant_input_pars(ii).n_spikes_min{:}]';
    curr_ylabel = 'Response spikes (norm.)';

    % plot average rate
    % array_constant_input_par{ii} = [constant_input_pars(ii).avg_rate{:}]';
    % curr_ylabel = 'Average resp. freq. (norm.)';

end



left_margin = 0.08;
bottom_margin = 0.2;
base_width = 0.21;
bar_width = 0.07;
base_space = 0.09;

graph_height = 0.6;
ax_base_par = {};


%Normalize per cell
norm_on = max([array_constant_input_par{:}],[],2);
norm_on(norm_on < 0.5) = 0.5;

opts = struct();
opts.norm_on = norm_on;
opts.XLim = [0.7 10.3];
opts.YLabel = curr_ylabel;
opts.XLabel = "Input spike (#)";

base_input_freqs = [1 2.5 5];

for p_idx = 1:3
    if p_idx > 1
        opts.YLabel = '';
    end

    pos_ax = [left_margin+(base_width+base_space)*(p_idx-1),...
        bottom_margin, base_width, graph_height];

    [curr_ax] = ubc_par_overtime(array_constant_input_par{p_idx},ONidx,...
        pos_ax,f_base,opts);
    title([num2str(base_input_freqs(p_idx)),' Hz'])
end

