%%% Plots raster/SDF for categorization tasks
%%% Germán Mendoza 08-2016

close all
clear ttsig
ttsig =ListMagnitudePFok;
ww = numel(ttsig);


cellok = 1;
for cellidx = 1:ww
    cellidx 
    sua_id = ttsig(cellidx);
    [cond, line_timesS, baseline_fr, epoch_fr] = ExtractRasterSpikesHM_MovementTimes(sua, sua_id, 1, TOTALRUNS, TOTALCHANNELS);
    
    [temDataBase_SUA,complete] = Get_DischargeBehavior(cond, line_timesS,sua_id);
    if complete
        DataBase_SUA{cellok} = temDataBase_SUA;
        cellok = cellok+1;
    end

end

disp 'done'