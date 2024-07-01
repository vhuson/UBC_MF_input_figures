%Calculate correlation of half-decay vs half-width


step60_HD = all_train_half_decay{6};
base_halfwidth = all_HD(train_fltr_5);

%Exclude off cells
step60_HD(fltr_ONidx_t5(end-3:end)) = [];
base_halfwidth(fltr_ONidx_t5(end-3:end)) = [];

% [rho,pval] = corr(step60_HD,base_halfwidth,'Type','Pearson')
[rho,pval] = corr(step60_HD,base_halfwidth,'Type','Spearman')