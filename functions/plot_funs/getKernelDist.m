function [yViol,x] = getKernelDist(boxData,settings)
%GETKERNELDIST Get kernel distribution for violin plots
%   Detailed explanation goes here


violinData = sort(boxData);
violinData = violinData(:);
violinData(isnan(violinData)) = [];


%Remove outliers using boxplot dimensions
%get quantiles
if ~settings.violOutliers
    boxQuantiles = quantile(violinData,[0.25 0.75]);
    
    %Calc theoretical whiskers
    boxWhiskers = [boxQuantiles(1)-(1.5*(boxQuantiles(2)-boxQuantiles(1))),...
        boxQuantiles(2)+(1.5*(boxQuantiles(2)-boxQuantiles(1)))];
    
    
    outlierFltr = violinData >= boxWhiskers(1) & violinData <= boxWhiskers(2);
    violinData = violinData(outlierFltr);
end

bd = settings.violBandwidth;

violDist = fitdist(violinData,'Kernel','BandWidth',bd);
si = (violinData(end)-violinData(1))/500;
si = max([si,0.01]);
if settings.violTrunc
    x = violinData(1):si:violinData(end);
else
    x = icdf(violDist,0.005):si:icdf(violDist,0.995);
end
yViol = pdf(violDist,x);

end

