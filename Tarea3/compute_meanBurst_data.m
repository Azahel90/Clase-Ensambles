function  ttactivtn= compute_meanBurst_data(behav,mode,trialmode)
%%%%Cond contains the spike times per task and condition for each trial
%%%%Behv contains the epoch times in the tasks
raster = 1;

%----------Poisson  Train Analysis------------------%
%initialize variables
MAXACTIVATTON = 40;             % maximum number of activation or burst periods
NO = 0;                         %flag
YES = 1;                        %flag

MaxNumberExtraSpikes = 10;%30-10 15 20     %   /* Number of spikes after eob that burst detector searches for increased SI */
MaxExtraTime = 30; %60,120              %           /* time after eob that burst detector searches for increased SI */

anchor_time = 50;

%   /*** Use natural ln() of probability, e.g.   ** ln(0.01) = 4.61, i.e., 0.01 probability  */
signif_level = 0.005;
prob = -log (signif_level);

n = 1;

for jcell=1:size(behav,2)
    
    Behavior = behav{jcell}.Behav(:,14);
    periodC = 500;
    %     periodC = mean(behav{jcell}.Behav(:,9));
    cond = behav{jcell}.Spikes;
    Controlttspks = 0;
    trialtime = 0;
    
    %%%%computing the global firing rate including the control period
    for this_trial = 1 : size(Behavior,1)% *** INNER TRIAL LOOP ***
        
        if(strcmp(mode,'Control'))
            numtrials = size(Behavior,1);
            %500 ms before the fistr Stim until de fisrst Stim
            beginperiodT =  0;
            endperiod = periodC;
            trialtime = trialtime + periodC;
        else
            
            beginperiodT = 0;
            endperiod = Behavior(this_trial,1);
            trialtime = trialtime + endperiod;
        end
        
        spikes_times = cond(this_trial);
        vecP = [beginperiodT,endperiod];
        Cttspks =cellfun(@(x) histcounts(x,vecP), spikes_times,'UniformOutput',1);
        Controlttspks = Controlttspks + Cttspks;
        
    end
    
    Clspks(jcell,1) =Controlttspks;
    
end
%
Controlttspks = Clspks;
avg_rate = Controlttspks/(trialtime);% * (numtrials/12) ; %Hz(eventos por segundo)


MiniBurstTime = zeros(size(behav,2),1);
MinBurstSpike = zeros(size(behav,2),1);


%avg_rate < 0.009   %low activity sharper ramps
MiniBurstTime(avg_rate < 0.009 ) = 90;%70,90
MinBurstSpike(avg_rate <0.009 )  = 10;%/6

MiniBurstTime(avg_rate > 0.009) = 110;%70 , 110
MinBurstSpike(avg_rate > 0.009) = 15;%/6 , 15

%%%%Getting the spikes times per interval and task
[Gspike_time,Gtotalsp] = GetMeanGSpiketimes(behav,trialmode);%-50 and +50ms from the interval


for jcell= 1:size(behav,2)
    clear sp_time totalsp  totalSp Sp_time sp
    
    totalSp = cell2mat(Gtotalsp{1,jcell});% total spikes from the right period
    sp= Gspike_time{1,jcell};% pull spikes from the right period
    
    
    n = n+1;
    
    idxSpks = find((totalSp >= MinBurstSpike(jcell)));
    Sp_time=sp(idxSpks);
    
    
    TTrial.spks{jcell} = Sp_time;
    TTrial.cellid{jcell} = idxSpks;
    
    for len =1:length(idxSpks)
        totalsp = totalSp(idxSpks(len));
        sp_time = sp{idxSpks(len)};
        
        %Log Probability for Activation Periods
        
        
        %----the starting point in the spike array...
        %-----in which to look for bursts-------------%
        first_spike_after_burst = 1;
        number_of_activations = 0;
        current_act_num = 0;
        act_num = 1;
        iterations = 0;
        iterate = YES;
        i = 0;
        
        %-----cleaning variables-----%
        clear activtn;
        [activtn.bob] = deal(0);
        [activtn.eob] = deal(0);
        [activtn.surprise] = deal(0);
        [activtn.lengh] = deal(0);
        [activtn.numspk] = deal(0);
        [activtn.bspk] = deal(0);
        [activtn.espk] = deal(0);
        [activtn.totspk] = deal(0);
        
        %------if there are less than MinBurstSpike...
        % spikes in interval, then no need to run...
        %-----burst detector-----%
        
        
        
        if (totalsp >= 20)%MinBurstSpike(idxSpks(len)))%Not Working for simultaneous
            %-----Este loop se queda-----%
            while((first_spike_after_burst <= totalsp-2) & (i < totalsp-2))
                %Interspike Intervals(ISIs)
                %-----Takes first 2 ISIs and finds average. If the average
                %rate for these 3 spikes is greater than the overall rate
                %(avg_rate), the burst is said to begin here.  If not, then
                %the rate for the next 2 isi's is calculated. */
                %                     endBurst = max(cellfun(@(x) max(length(x)) , Sp_time,'UniformOutput',1));
                %                         endBurst = max(totalsp);
                
                for (i = first_spike_after_burst: (totalsp-2))
                    
                    
                    isi = 0;
                    isi_rate = 0;
                    isi = (sp_time(i + 2) - sp_time(i));
                    isi = isi/3;
                    %                             isi = cellfun(@(x) ISIs(x,i),Sp_time,'UniformOutput',1);
                    isi_rate = 1/isi;
                    
                    if (isi_rate >= avg_rate(jcell))
                        %/* initialize variables */
                        
                        activtn(1,act_num).bob = 0;
                        activtn(1,act_num).eob = 0;
                        burst = NO;
                        sup_new = 0;
                        sup_max = 0;
                        on = NO;
                        CurrentNumberExtraSpikes = 0;
                        CurrentExtraTime = 0;
                        eob_anchor = 0;
                        max_eob = 0;
                        min_bob = 5000;                         %/* a bogus value */
                        iterations = 0;
                        
                        %----The beginning and end of each putative
                        %burst is calculated multiple times until...
                        %their time values are consistent for two
                        %iterations -----%.
                        %---do-while loop for multiple iterations...
                        %of burst detector-----%
                        while (iterate)
                            
                            %/* initialize variables */
                            
                            sup_max = 0;
                            sup_new = 0;
                            old_bob = activtn(1,act_num).bob;
                            old_eob = activtn(1,act_num).eob;
                            
                            %/* finds the number of spikes in anchor interval before current starting point */
                            
                            if (activtn(1,act_num).bob == 0)
                                
                                for  m = i: -1: 1
                                    %                                             Spm = cellfun(@(x) x(m),Sp_time);
                                    %                                             Spmanchor = cellfun(@(x) x(i)-anchor_time,Sp_time);
                                    %                                         if (sp_time(m) >= (sp_time(i) - anchor_time))
                                    if (sp_time(m) >= (sp_time(i) - anchor_time))
                                        eob_anchor = eob_anchor+1;
                                        
                                    else
                                        break;
                                    end
                                end
                                
                            else
                                
                                %/* determines number of spikes after first iteration when there is a current bob */
                                
                                for m = activtn(1,act_num).bob: -1 :  1
                                    
                                    if (sp_time(m) >= (sp_time(activtn(1,act_num).bob) - anchor_time))
                                        eob_anchor = eob_anchor+1;
                                    else
                                        break;
                                    end
                                end
                                
                            end %if activ.bob==0
                            
                            
                            %/*** This loop adds spikes for until the surprise index decreases
                            %for a user defined time or number %of spikes.
                            %** Finds End of Burst (eob)*/
                            
                            for (num_isi = 2: totalsp - i)
                                
                                if (activtn(1,act_num).bob == 0)
                                    
                                    %/* first iteration
                                    t = sp_time(i + num_isi) - (sp_time(i) - anchor_time);
                                else
                                    
                                    if (activtn(1,act_num).bob + num_isi <= totalsp)
                                        
                                        %/* after first %iteration */
                                        t = sp_time(activtn(1,act_num).bob + num_isi) - (sp_time(activtn(1,act_num).bob) - anchor_time);
                                        
                                    else
                                        break;
                                    end
                                end %if activ
                                
                                
                                num_spike = eob_anchor + num_isi;
                                %                                 sup_new = surprise(t, num_spike, avg_rate(idxSpks(len)));
                                sup_new = surprise(t, num_spike, avg_rate(jcell));
                                
                                sup_max;
                                
                                
                                if (sup_new >= sup_max)
                                    
                                    %/* first iteration
                                    if (activtn(1,act_num).bob == 0)
                                        
                                        activtn(1,act_num).eob = i + num_isi;
                                        
                                        %/* after first iteration */
                                    else
                                        
                                        activtn(1,act_num).eob = activtn(1,act_num).bob + num_isi;
                                    end
                                    
                                    sup_max = sup_new;
                                    CurrentNumberExtraSpikes=0;
                                    
                                else
                                    
                                    % MaxNumberExtraSpikes is the number of spikes
                                    %after eob in which the surprise index can increase above the
                                    %** current sup_max.  Currently set to 10.
                                    %** MaxExtraTime is the time after eob in which the surprise index
                                    % can increase above current sup_max.
                                    %** Currently set to 30ms; approximates EPSP decay.
                                    %      ** These numbers need to be determined by the user. */
                                    
                                    CurrentNumberExtraSpikes = CurrentNumberExtraSpikes + 1;
                                    
                                    
                                    %/* first iteration
                                    if (activtn(1,act_num).bob == 0)
                                        
                                        CurrentExtraTime = sp_time(i+num_isi) - sp_time(activtn(1,act_num).eob);
                                        
                                        %/* after first iteration */
                                    else
                                        
                                        CurrentExtraTime = sp_time(activtn(1,act_num).bob + num_isi) - sp_time(activtn(1,act_num).eob);
                                        
                                    end
                                    
                                    if (CurrentNumberExtraSpikes >= MaxNumberExtraSpikes | CurrentExtraTime >= MaxExtraTime)
                                        break;
                                        %num_isi = totalsp - i;%return;
                                    end
                                end %ifsumnew
                                
                            end %num_isi
                            
                            
                            
                            %/* initialize variables */
                            
                            CurrentNumberExtraSpikes = 0;
                            sup_new = 0;
                            sup_max = 0;
                            on = NO;
                            bob_anchor = 0;
                            eob_anchor = 0;
                            
                            
                            %/* resets min_bob at the 10th iteration */
                            
                            if (iterate & iterations == 10)
                                
                                min_bob = activtn(1,act_num).bob;
                                if (min_bob == 0)
                                    min_bob = 1;
                                end
                            end
                            
                            
                            %/* counts number of spikes in anchor_time after eob */
                            
                            for (m = activtn(1,act_num).eob+1: 1: totalsp)
                                
                                if (sp_time(m) <= (sp_time(activtn(1,act_num).eob) + anchor_time))
                                    bob_anchor = bob_anchor+1;
                                else
                                    break;
                                end
                            end
                            
                            
                            
                            %/*** This loop indexes backward in time to the end of the previous
                            %** burst and finds begin spike when surprise is max.
                            %** Finds Beginning Of Burst (bob).*/
                            
                            
                            
                            for (m = activtn(1,act_num).eob-1: -1 : first_spike_after_burst)
                                
                                t = anchor_time + sp_time(activtn(1,act_num).eob) - sp_time(m);
                                num_spike = bob_anchor + activtn(1,act_num).eob - m;
                                sup_new = surprise(t,num_spike,avg_rate(jcell));
                                
                                if (sup_new >= sup_max)
                                    
                                    activtn(1,act_num).bob = m;
                                    sup_max = sup_new;
                                end
                            end
                            
                            
                            
                            if ((activtn(1,act_num).bob == old_bob) & (activtn(1,act_num).eob == old_eob))
                                
                                iterate = NO;
                                
                            else
                                
                                iterate = YES;
                            end
                            
                            
                            
                            %/*** if caught in infinite loop on the same burst then only 20
                            %                                         ** iterations will be allowed and the max_bob and the min_eob
                            %                                         ** determined during these iterations will become bob and eob
                            %                                         ** for this burst.*/
                            
                            current_act_num = max(act_num, current_act_num);
                            
                            
                            if (current_act_num == act_num)
                                
                                max_eob = max(activtn(1,act_num).eob,max_eob);
                                min_bob = min(activtn(1,act_num).bob,min_bob);
                                iterations = iterations+1;
                            end
                            
                            if (iterations > 20)
                                
                                activtn(1,act_num).eob = max_eob;
                                activtn(1,act_num).bob = min_bob;
                                iterate = NO;
                                iterations = 0;
                                
                            end
                            
                        end %end while iterate
                        
                        if(activtn(1,act_num).bob	== 0 &  activtn(1,act_num).eob == 0)
                            activtn(1,act_num).bob = 1;
                            activtn(1,act_num).eob = 1;
                        end
                        
                        %/* finds surprise index of the current burst */
                        % condition
                        
                        tim = sp_time(activtn(1,act_num).eob) - sp_time(activtn(1,act_num).bob);
                        numspk = (activtn(1,act_num).eob-activtn(1,act_num).bob+1);
                        
                        sup_max = surprise(tim,numspk,avg_rate(jcell));
                        
                        
                        %/* resets first_spike_after_burst to look for the next burst */
                        first_spike_after_burst = activtn(1,act_num).eob + 1;
                        %/* test to check if burst meets minimum spike & probability criteria */
                        if ((sup_max > prob) & ((activtn(1,act_num).eob - activtn(1,act_num).bob)+1 >= MinBurstSpike(jcell)) & ((sp_time(activtn(1,act_num).eob) - sp_time(activtn(1,act_num).bob)) >= MiniBurstTime(jcell) ) )% & sp_time(activtn(1,act_num).bob) >=2 & totalsp > 10)
                            
                            number_of_activations = number_of_activations+1;
                            burst = YES;
                            activtn(1,act_num).surprise = sup_max;
                            activtn(1,act_num).lengh = tim;
                            activtn(1,act_num).numspk = numspk;
                            activtn(1,act_num).bspk = sp_time(activtn(1,act_num).bob);
                            activtn(1,act_num).espk = sp_time(activtn(1,act_num).eob);
                            activtn(1,act_num).totspk = totalsp;
                            
                            act_num = act_num+1;
                        end
                        
                        %/* if no burst was found, reset variables */
                        
                        if (burst == 0)
                            
                            activtn(1,act_num).bob = [];
                            activtn(1,act_num).eob = [];
                            max_eob = 0;
                            min_bob = 5000; %                        /* a bogus value */
                            iterate = YES;
                        end
                        
                        % ** resets iteration variables when the next activation
                        % period has been found
                        
                        if (current_act_num < act_num)
                            
                            iterations = 0;
                            max_eob = 0;
                            min_bob = 5000;       %                  /* a bogus value */
                            current_act_num = 0;
                            iterate = YES;
                            i = first_spike_after_burst; %modific
                        end
                        
                        break;
                        
                        
                    end%if isi
                    
                end%for firstspike
            end%for firstspike
            
            %adding data to output strcuture
            
            if(number_of_activations)
                ttactivtn{jcell}(len).num_act(1:number_of_activations,1) = number_of_activations;
                ttactivtn{jcell}(len).bob(1:number_of_activations,1) = vertcat(activtn.bob);
                ttactivtn{jcell}(len).eob(1:number_of_activations,1) = vertcat(activtn.eob);
                ttactivtn{jcell}(len).surprise(1:number_of_activations,1) = vertcat(activtn.surprise);
                ttactivtn{jcell}(len).lengh(1:number_of_activations,1) = vertcat(activtn.lengh);
                ttactivtn{jcell}(len).numspk(1:number_of_activations,1) = vertcat(activtn.numspk);
                ttactivtn{jcell}(len).bspk(1:number_of_activations,1) = vertcat(activtn.bspk);
                ttactivtn{jcell}(len).espk(1:number_of_activations,1) = vertcat(activtn.espk);
                ttactivtn{jcell}(len).totspk(1:number_of_activations,1) = totalsp;
                ttactivtn{jcell}(len).cell(1:number_of_activations,1) = idxSpks(len);
                
                [timeMaxPeakActivity,Peakidx] = GetPeakActivation(Sp_time{len,1},round(vertcat(activtn.bspk)),round(vertcat(activtn.espk)),totalsp,number_of_activations);
                
                ttactivtn{jcell}(len).PeakHz(1,1) = timeMaxPeakActivity;
                ttactivtn{jcell}(len).Peakidx(1,1) = Peakidx;
                
                
            else
                ttactivtn{jcell}(len).num_act(1,1) = 0;
                ttactivtn{jcell}(len).bob(1,1) = 0;
                ttactivtn{jcell}(len).eob(1,1) = 0;
                ttactivtn{jcell}(len).surprise(1,1) = 0;
                ttactivtn{jcell}(len).lengh(1,1) = 0;
                ttactivtn{jcell}(len).numspk(1,1) = 0;
                ttactivtn{jcell}(len).bspk(1,1) = 0;
                ttactivtn{jcell}(len).espk(1,1) = 0;
                ttactivtn{jcell}(len).totspk(1,1) = totalsp;
                ttactivtn{jcell}(len).cell(1,1) = idxSpks(len);
                ttactivtn{jcell}(len).Peakidx(1,1) = 0;
                ttactivtn{jcell}(len).PeakHz(1:number_of_activations) = 0;
                
                
            end
            
            
        else
            ttactivtn{jcell}(len).num_act(1,1) = 0;
            ttactivtn{jcell}(len).bob(1,1) = 0;
            ttactivtn{jcell}(len).eob(1,1) = 0;
            ttactivtn{jcell}(len).surprise(1,1) = 0;
            ttactivtn{jcell}(len).lengh(1,1) = 0;
            ttactivtn{jcell}(len).numspk(1,1) = 0;
            ttactivtn{jcell}(len).bspk(1,1) = 0;
            ttactivtn{jcell}(len).espk(1,1) = 0;
            ttactivtn{jcell}(len).totspk(1,1) = totalsp;
            ttactivtn{jcell}(len).cell(1,1) = idxSpks(len);
            ttactivtn{jcell}(len).Peakidx(1,1) = 0;
            
            ttactivtn{jcell}(len).PeakHz(1:number_of_activations) = 0;
            
            
            
            
        end
    end
    
end% number of trials





