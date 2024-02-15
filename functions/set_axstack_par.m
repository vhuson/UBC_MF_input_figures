function [] = set_axstack_par(axstack,par,value)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
for ii = 1:numel(axstack)
    set(axstack{ii},par,value)
end
end