function rate = time2rate(idx,Fs,T)
% idx: vector with sorted x positions of peaks
% Fs: Sampling rate (i.e. 20000 for 50us sampling interval)
% T: time in seconds of the full trace

% Chong padding
% idx = [-1; idx(:); 2*Fs*T-idx(end)];
% irate = 1./diff(idx/Fs);
% rate = interp1(sort([idx(1:end-1);idx(2:end)-1]),reshape([irate irate]',[],1),1:round(T*Fs),'nearest');
if isempty(idx)
    idx =1;
end

% Zero padding
irate = [0; 1./diff(idx(:)/Fs); 0];
idx = [1; idx(:); round(Fs*T)];

rate = zeros(1,round(Fs*T));
for ii = 1:numel(irate)
    rate(idx(ii):idx(ii+1)) = irate(ii);
end