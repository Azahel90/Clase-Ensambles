%%% Plots raster/SDF for categorization tasks
%%% Germ�n Mendoza 08-2016

close all

ww = numel(DataBase_SUAok);

SDF_MAX = 60;
%%% Graph
AlignEpoch = 2; % 1 = trial beg, 2 = 1st stim, 3 = 2nd stim, 4 = targets on, 5 = out of central circle, 6 = target in, 7 = reward
monkey = 1;
clear BestModel;

%--------------Activations Periods-------%
Cttactivtnall = compute_meanBurst_data(DataBase_SUAok,'Control','all');
%----------------------------------------%
for cellidx = 4:ww
    
    sua_id = DataBase_SUAok{cellidx}.ID;
    SpikesCell = DataBase_SUAok{cellidx}.Spikes;
    line_timesS = DataBase_SUAok{cellidx}.Behav;
    Acctivtn   = Cttactivtnall{cellidx};
    DrawRasterfromSUA_CategorizationOK2(sua_id, SpikesCell, line_timesS, AlignEpoch, SDF_MAX,Acctivtn , monkey);
    [CoefsSUA{cellidx}] = ComputeEncoding(sua_id, SpikesCell, line_timesS);
    close all
    clear Acctivtn
    
end

disp 'done'