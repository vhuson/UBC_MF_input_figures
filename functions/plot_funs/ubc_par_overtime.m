function [curr_ax] = ubc_par_overtime(curr_par_array,ONidx,...
    pos_ax,curr_fig,opts)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
base_opts.norm_on = false;
base_opts.norm_off = [];
base_opts.norm_OFFidx = [];

base_opts.XLim = false;
base_opts.YLabel = '';
base_opts.XLabel = '';

if nargin < 5
    opts = base_opts;
else
    opts = merge_structs(base_opts,opts);
end

%Set colormap
seed_colors = [1 0 0;
                1 0.5 0.2;
                0.4 1 0.4;
                0.2 0.5 1;
                0 0 1];

all_colors = seed_map(seed_colors,numel(ONidx));

curr_ax = axes(curr_fig,"Position",pos_ax);


%Normalize
if ~islogical(opts.norm_on)
    norm_on = opts.norm_on;
    norm_off = opts.norm_off;
    norm_OFFidx = opts.norm_OFFidx;

    [norm_traces] = norm_UBC(curr_par_array,norm_on,norm_off,norm_OFFidx);
    norm_traces = norm_traces(ONidx,:);
end



x_vector = 1:size(norm_traces,2);


% Random permutation
rng(2);
cell_order = randperm(numel(ONidx));


hold(curr_ax,"on")
for ii = cell_order
        plot(x_vector,norm_traces(ii,:),'Color',all_colors(ii,:))
end
plot(x_vector,mean(norm_traces),'-ko',...
    'MarkerFaceColor','w','LineWidth',1.5)

hold(curr_ax,"off")

if islogical(opts.XLim)
    xlim([x_vector(1) x_vector(end)])
else
    xlim(opts.XLim)
end

xlabel(opts.XLabel);
ylabel(opts.YLabel)

standardAx(curr_ax);



end