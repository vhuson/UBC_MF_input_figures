function [fit_amp,fit_peak_x,fit_halfwidth,fit_distwidth,f1] = log_gausian_ubc_fit(yData,xData,Fs2,plot_on)
% perform log gaussian fit
% Fs2 = 200;
% % yData = clean_trace_segment-mean(clean_base_trace);
% yData = curr_trace(curr_start:curr_end)-mean(clean_base_trace);
% yData = yData(Fs:end);
% yData(yData<0) = 0;
% yData = yData(1:100:end);
% xData = (1:numel(yData))/Fs2;
if nargin < 4
    plot_on = false;
end

[xData, yData] = prepareCurveData( xData,  yData);

ft = fittype( 'a*exp(-((log(x)-b)/c)^2)', 'independent', 'x', 'dependent', 'y' );
fit_opts = fitoptions( 'Method', 'NonlinearLeastSquares' );

fit_opts.Display = 'Off';
fit_opts.Lower = [-Inf -Inf -Inf];
fit_opts.StartPoint = [1 1.93102153656157 0.532975735252197];
fit_opts.Upper = [Inf Inf Inf];


fit_opts.Upper(1) = max(yData)*1.2;
fit_opts.Lower(1) = max(yData)*0.8;
[fit_opts.StartPoint(1),maxLoc] = max(yData);
fit_opts.StartPoint(2) = log(maxLoc/Fs2);

[fitresult, gof] = fit( xData, yData, ft, fit_opts );

fit_amp = fitresult.a;
% fit_shift = fitresult.b;
fit_peak_x = exp(fitresult.b);
fit_distwidth = fitresult.c;

%Get width by using inverse function
fit_halfwidth = exp(fitresult.b+fitresult.c*(log(2))^0.5)...
    -exp(fitresult.b-fitresult.c*(log(2))^0.5);

%plot
if plot_on
    f1 = figure( 'Name', 'untitled fit 1' );
    h = plot( fitresult, xData, yData );
    legend( h, 'test vs. logfitx', 'untitled fit 1', 'Location', 'NorthEast', 'Interpreter', 'none' );
    grid on
    disp(fit_peak_x)
    disp(fit_halfwidth)
    %     set(gca,'XScale','log')
    % pause
    % close(f1);
else
    f1 = [];
end
end