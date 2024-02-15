function [norm_traces] = norm_UBC(all_trace_mat,norm_on,norm_off,OFFidx)
%NORM_UBC normalize UBCs, to different numbers based on OFFidx
%   Detailed explanation goes here
if nargin < 4
    OFFidx = [];
end

norm_traces = all_trace_mat;
norm_traces = norm_traces./norm_on;
if ~isempty(OFFidx)
    norm_traces(OFFidx,:) = all_trace_mat(OFFidx,:)./norm_off(OFFidx);
end
end