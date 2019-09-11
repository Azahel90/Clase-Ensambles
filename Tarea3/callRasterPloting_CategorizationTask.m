%%% Plots raster/SDF for categorization tasks
%%% Hugo Merchant 8/29/2019

close all

ww = numel(DataBase_SUAok);

SDF_MAX = 60;
%%% Graph
AlignEpoch = 2; % 1 = trial beg, 2 = 1st stim, 3 = 2nd stim, 4 = targets on, 5 = out of central circle, 6 = target in, 7 = reward
monkey = 1;

for cellidx = 1:ww
    cellidx
    sua_id = DataBase_SUAok{cellidx}.ID;
    SpikesCell = DataBase_SUAok{cellidx}.Spikes;
    line_timesS = DataBase_SUAok{cellidx}.Behav;
%     DrawRasterfromSUA_CategorizationOK(sua_id, SpikesCell, line_timesS, AlignEpoch,SDF_MAX, monkey);
    [CoefsSUA{cellidx}] = ComputeEncoding(sua_id, SpikesCell, line_timesS);
    close all
   
    
end

disp 'done'