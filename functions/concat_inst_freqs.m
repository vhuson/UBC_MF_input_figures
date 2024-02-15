function [fulltrace] = concat_inst_freqs(tracearray1,tracearray2,Fs)

if ~iscell(tracearray1)
    tracearray1 = {tracearray1};
end
if ~iscell(tracearray2)
    tracearray2 = {tracearray2};
end

%Concatenate and fill zeros
fulltrace = {};
for ii = 1:numel(tracearray1)
    for jj = 1:size(tracearray1{ii},1)
        %Fill zeros if necessary
        filled_trace = tracearray1{ii}(jj,:);
        filled_baseline = tracearray2{ii}(jj,:);
        first_nozero = find(filled_trace ~= 0,1,"first");
        last_nozero = find(fliplr(filled_baseline) ~= 0,1,"first");
        
        
        if ~isempty(first_nozero) && ~isempty(last_nozero)
            %zero is not appropriate, fill.
            est_inst_freq = 1/((last_nozero + first_nozero)/Fs);

            filled_trace(1:first_nozero) = est_inst_freq;
            filled_baseline(end-last_nozero:end) = est_inst_freq;
        end
        
        fulltrace{ii}(jj,:) = [filled_baseline, filled_trace];
    end
end

end