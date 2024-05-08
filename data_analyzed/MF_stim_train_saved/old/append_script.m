%% Add additional "washin" information
test = curr_file_names';
currCell = curr_file_names{1}(1:8)
%%


%% add to washin
repeat_start = 23;
washinStates{5} = 'Repeat stress trials'
washinIDs(repeat_start:end,5) = true;




%% append to saved file

cd('data_analyzed\MF_stim_train_saved')
save([currCell,'_analyzed.mat'],'washinStates','washinConcentrations','washinIDs',...
    '-append')
disp(['saved ',currCell])
cd('..')
cd('..')