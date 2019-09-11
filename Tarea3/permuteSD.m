function  SD = permuteSD(Spks,samp_points,mode)
%
step = 25; %Step Window
winTimes=min(samp_points): step : max(samp_points);
windowLength = 250; %Window Size

if(strcmp(mode,'Permute'))
    iter = 1;
    while(iter <= 100)
        Sd = [];
        spike_times = randsample(Spks, numel(Spks));
        
        for wt=1:length(winTimes)
            Sd(wt) = sum(spike_times >= winTimes(wt) & spike_times <= (winTimes(wt) + windowLength))/ windowLength;
        end
        Sd = Sd  *  1000;
        SD(iter,:) = Sd;
        iter = iter + 1;
    end
    SD = mean(SD);
    
else
    for wt=1:length(winTimes)
        SD(wt) = sum(Spks >= winTimes(wt) & Spks <= (winTimes(wt) + windowLength)) / windowLength;
    end
    SD = SD  *  1000;
    
end
