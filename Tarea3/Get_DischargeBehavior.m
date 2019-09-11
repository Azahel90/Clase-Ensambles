function  [DataBase_SUA,ALLCompleteTrials] = Get_DischargeBehavior(Discharge,BehTimes,sua_id)

 

%taskn = taskn+1; %control = 1
TotalLearningtrials = 24;

tint(1) = 1;
tint(2) = 1;
tint(3) = 5;
tint(4) = 5;
tint(5) = 4;
tint(6) = 4;

repe(1) = 1;
repe(2) = 1;
repe(3) = 1;
repe(4) = 1;
repe(5) = 1;
repe(6) = 1;
repe(7) = 1;
repe(8) = 1;

TSyn_fr{6} = [];
TBehT = [];
TTASKS = 7;
BINSIZE = 25; %ms
WINDOWSIZE = 250; %ms

this_task = 6;%SP2


rtrial = 1;
ttvalidtrials = 0;
for trial = 1:numel(Discharge(this_task).trial)
    if isempty(Discharge(this_task).trial(trial).interv) == 0
        ttvalidtrials =  ttvalidtrials+1;
    end%%if there is activity in this task
end
if ttvalidtrials == 120
    clear intervals
    for trial = 1:TotalLearningtrials
        intervals(trial) = Discharge(this_task).trial(trial).interv;
    end
    
    if this_task < 5 %timing tasks
        shorterinterval = min(intervals); %T1 = 200 T3 = 870
    else %space tasks
        shorterinterval = 0;
    end
    
    for trial = 1:ttvalidtrials
        
        if Discharge(this_task).trial(trial).traintest == 1  %&& Discharge(this_task).trial(trial).error == 0 %only correct test trials
            
            relativeval = GetRelativeVal(Discharge(this_task).trial(trial).interv, Discharge(this_task).trial(trial).distan, this_task);
            block = GetBlock(this_task);
            
            Correct_Stim_Rep(relativeval,repe(relativeval)) = Discharge(this_task).trial(trial).error;
            repe(relativeval) = repe(relativeval)+1;
            
            cate = Discharge(this_task).trial(trial).cate;
            error = Discharge(this_task).trial(trial).error;
            
            if error == 0 & cate == 1
                response = 0;
            elseif error == 707 & cate == 1
                response = 1;
            elseif error == 0 & cate == 2
                response = 1;
            elseif error == 707 & cate == 2
                response = 0;
            end
            
            BehT(rtrial,1) = Discharge(this_task).trial(trial).interv;
            BehT(rtrial,2) = Discharge(this_task).trial(trial).distan;
            BehT(rtrial,3) = Discharge(this_task).trial(trial).error;
            BehT(rtrial,4) = Discharge(this_task).trial(trial).cate;
            BehT(rtrial,5) = response;
            BehT(rtrial,6) = relativeval;
            BehT(rtrial,7) = block;
            
            for ii = 1: 7 %behavioral times in bins starting with the first stimulus time
                BehT(rtrial,7+ii) = round(BehTimes(this_task,trial).t(ii));
            end
            Syn_fr{rtrial} = Discharge(this_task).trial(trial).spk_times;
            
            
            rtrial = rtrial+1;
            
        end
        
        
    end
    
    [ix,idb] = sort(BehT(:,2));
    
    DataBase_SUA.ID = sua_id;
    DataBase_SUA.Behav =  BehT(idb,:);
    for ii = 1:96
       DataBase_SUA.Spikes{ii} = Syn_fr{idb(ii)};
    end
    
    ALLCompleteTrials = 1;
    
    
    

else
    DataBase_SUA = 1;
    ALLCompleteTrials = 0;
end
    


