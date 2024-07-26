f_burst_pharma = figure('Position', [488 1.8000 680.3150 857.9636],...
    'Color','w');

pos_ax = [0.1680 0.7464 0.2886 0.1915];


%Gather data
ax_pharm_p = {};

opts = struct('max_val',200);
opts.YLabel = '#Spike increase after mGluR2/3 (%)';
opts.XScale = 'log';
% opts.YScale = 'log';

all_pharma_currpar = {base_to_mglur2_percentchange(:,1),...
    base_to_mglur2_percentchange(:,2),...
    base_to_mglur2_percentchange(:,3),...
    base_to_mglur2_percentchange(:,4),...
    base_to_mglur2_percentchange(:,5)};


[ax_pharm_p{input_idx}] = UBC_par_line_plot2(...
    fltr_ONidx,[],all_pharma_currpar,f_burst_pharma,pos_ax,...
    opts);
xlim([0.8 23])


pos_ax = [0.1680 0.4678 0.2886 0.1915];

opts.YLabel = '#Spike increase after mGluR2/3';

all_pharma_currpar = {base_to_mglur2_delta(:,1),...
    base_to_mglur2_delta(:,2),...
    base_to_mglur2_delta(:,3),...
    base_to_mglur2_delta(:,4),...
    base_to_mglur2_delta(:,5)};


[ax_pharm_p{input_idx}] = UBC_par_line_plot2(...
    fltr_ONidx,[],all_pharma_currpar,f_burst_pharma,pos_ax,...
    opts);
xlim([0.8 23])





pos_ax = [0.1680 0.1678 0.2886 0.1915];
% opts.min_val = 1;
% opts.YScale = 'log';
opts.YLabel = '\DeltaSpike increase after mGluR2/3';

all_pharma_currpar =cellfun(@(x,y) {x-y},all_pharma_n_spikes2,all_pharma_n_spikes1);


[ax_pharm_p{input_idx}] = UBC_par_line_plot2(...
    fltr_ONidx,[],all_pharma_currpar,f_burst_pharma,pos_ax,...
    opts);
xlim([0.8 23])