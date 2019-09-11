%%% Plots raster/SDF for categorization tasks
%%% Germán Mendoza 08-2016

close all
%%% Data
sua = suaM1SMA;%suaM1SMA;
[TOTALRUNS, TOTALCHANNELS, cells] = size (sua);

if TOTALCHANNELS == 16
    monkey = 2;
elseif TOTALCHANNELS == 7
    monkey = 1; 
end

%%% Cells
% ttsig = find([sua.numtasks] >1);
clear ttsig
DataBase_SUA = [];
ttsig =ListMagnitudesmaok;%ListMagnitudePFok;ListMagnitudesmaok
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


for ii = 1:24
    DataBase_SUAok{ii+13}=DataBase_SUA{ii};
end