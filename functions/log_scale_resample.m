function [logFreqs, logMarks] = log_scale_resample(ubc_resp,stimEnd,Fs)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

%Make log time (This makes no sense)
endT = numel(ubc_resp)/Fs;

numPoints = endT*Fs-stimEnd*Fs;
logStart = exp(1/Fs);
logEnd = exp(endT-stimEnd);
logTime = log(logStart:(logEnd-logStart)/numPoints:logEnd);

expTime = 0:1/Fs:numPoints/Fs;

%Make log freqs
xq = logTime(28):1/Fs:logTime(end);

logFreqs = interp1(logTime(28:end),ubc_resp(stimEnd*Fs+27:end),xq);

logMarks = interp1(logTime(28:end),expTime(28:end),xq);
end