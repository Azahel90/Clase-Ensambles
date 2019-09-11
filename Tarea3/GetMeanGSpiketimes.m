function [spike_time,totalsp] = GetMeanGSpiketimes(behav,mode)

% BEG = 50;%50ms
% END = 50;

len = size(behav{1}.Behav,1);
if(strcmp(mode,'first'))
    v1 = 1:12:len;
    v2 = v1 + 5;
elseif(strcmp(mode,'last'))
    %Tomando los ultimos 6 ensayos
    aux1 = 1:12:len;
    v2  = [aux1(2:end) - 1, len];
    v1 = aux1 +6;
else
    v1 = 1:12:len;
    v2  = [v1(2:end) - 1, len];
end


for jcell=1:size(behav,2)
    %  periodC = min(behav{this_trial}.Behav(:,9));
    Behavior = behav{jcell}.Behav(:,[9,13]);
    cond = behav{jcell}.Spikes;
    
    for Cond  = 1:8
        Spikes= cell(1);
        Nsp=0;
        for this_trial = v1(Cond) : v2(Cond)
            
            
            %        beginperiod = Behavior(this_trial,1)- BEG;
            beginperiod = 500;
            
            endperiod   = Behavior(this_trial,2);
            
            vecP = [beginperiod,endperiod];
            spikes_times = cond(this_trial);
            [nsp,~,counts] =cellfun(@(x) histcounts(x,vecP), spikes_times,'UniformOutput',0);
            qtimes = cellfun(@(x,y) y(x==1),counts,spikes_times,'UniformOutput',0);
            spikes = cellfun(@(x) x-beginperiod,qtimes,'UniformOutput',false);
            
            nsp = cell2mat(nsp);
            Nsp =nsp + Nsp;
            Spikes= cellfun(@(x,y) sort(vertcat(x,y)),spikes,Spikes,'UniformOutput',0);
        end
        temtimes{jcell}{Cond,1}= Spikes{:};
        nn{jcell}{Cond,1} = Nsp;
    end
    
end
spike_time = (temtimes);
totalsp = nn;

end