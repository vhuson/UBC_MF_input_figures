function [base_n_spikes,base_amplitude,base_async,base_ratio] = get_baseline_n_spikes(...
    base_data,baseline_rates,Fs,min_trace_leng)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
if ~iscell(base_data)
    base_data = {base_data};
end

if nargin == 3 %Trace length not given
    %Get maximum consistent trace length
    min_trace_leng = cellfun(@size,base_data,'UniformOutput',false);
    min_trace_leng = vertcat(min_trace_leng{:});
    min_trace_leng = min(min_trace_leng(:,2));
end

base_n_spikes = cell(size(base_data));
base_amplitude = cell(size(base_data));
base_async = cell(size(base_data));
base_ratio = cell(size(base_data));
for ii = 1:numel(base_data)
    curr_peak = max(base_data{ii}(:,1:min_trace_leng),[],2);
    curr_async = mean(base_data{ii}(:,end-100),2);
    curr_n_spikes = sum(base_data{ii}(:,1:min_trace_leng),2)./Fs;
    curr_baseline = baseline_rates.*(min_trace_leng/Fs);

    base_n_spikes{ii} = curr_n_spikes-curr_baseline;
    base_amplitude{ii} = curr_peak - baseline_rates;
    base_async{ii} = curr_async - baseline_rates;

    min_peak = base_amplitude{ii};
    min_peak(min_peak< 10) = 0;

    base_ratio{ii} = base_async{ii}./min_peak;
end

end