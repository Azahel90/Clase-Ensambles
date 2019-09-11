function  [AllCoef] = ComputeEncoding(sua_id, Spikes, Behtimes)


Mat = [182 194 217 222 232 237 260 272];
TotalTrials = numel(Spikes);
trialcounter = zeros(30, 1);
Tname{1} = 'linear';
Tname{2} = 'power';
Tname{3} = 'exponential';
Tname{4} = 'logaritmic';
Tname{5} = 'gaussian';
Tname{6} = 'sigmoid';

%-----Sliding Window----------------%
Stim1 = mean(Behtimes(:,9));%1st stimulus time
Stim2 = mean(Behtimes(:,10));%2st stimulus time

sw_len= Stim1 : 25: Stim2;


for j = 1:length(sw_len)
    
    for trial = 1:TotalTrials
        
        stim = Behtimes(trial ,2);
        categ = Behtimes(trial ,4);
        [r, c] = find(Mat(:) == stim);
        positionInplot = getPositionInPlot(stim);
        
        trialcounter(positionInplot) = trialcounter(positionInplot) + 1;
        repetition = trialcounter(positionInplot); % Current repetition for this task, phase and stimulus.
        
        
        %-----Sliding Window----------------%
        Stim1 = Behtimes(trial,9);%1st stimulus time
        Stim2 = Behtimes(trial,10);%2st stimulus time
        
        SWindow = Stim1 : 25: Stim2;
        Behav = SWindow(j); Behav(2) = SWindow(j) + 250;
        StimDischarge2(trial,1) = getDischargeSWindow(Spikes{trial}, Behav,Behtimes(trial,:));
        idxStimDicharge(trial,1) = trial;
        %------------------------------------%
        
        %     StimDischarge(trial,1) = getDischargeStim(Spikes{trial}, Behtimes(trial,:));
        Distance(trial,1) = stim;
        %     DischargeperMag(repetition,r) = getDischargeStim(Spikes{trial}, Behtimes(trial,:));
        
    end
    DischargeperMag = reshape(StimDischarge2,12,8);
    %---Compute MI, Models and Choice Probability-----%
    AllCoef  = PermuteNeuralActivity(Distance, StimDischarge2, DischargeperMag,repetition,Mat,Tname);
    OriginalCoef{j} = AllCoef;
    OutCOef{j} = PermuteStimeDischarge;
end


    function   Out = PermuteStimeDischarge
        iter = 1;
        while(iter <= 100)
            %---Permuted Stim Discharge Rate each 250 ms-------%
            idxPermuted = randsample(idxStimDicharge,numel(idxStimDicharge));
            DistancePerm = Distance(idxPermuted);
            StimDischargePerm= StimDischarge2(idxPermuted);
            DischargeperMagPerm = reshape(StimDischargePerm,12,8);
            
            %return
            
            % --Permuted Neural Activty and compute MI, Models and Choice Probability---%
            PermCoef  = PermuteNeuralActivity(DistancePerm, StimDischargePerm, DischargeperMagPerm,repetition,Behtimes,Tname);
            %
            %
            C1(iter,:) = PermCoef.coef(1,:);%m
            C2(iter,:) = PermCoef.coef(2,:);%b
            C3(iter,:) = PermCoef.coef(3,:);%r2
            %
            mse(iter,:) = PermCoef.mse(1,:); %mse
            PermCoef = [];
            % close all
            iter  =iter + 1 ;
        end
        
        disp('Compara Distribucion')
        for k = 1:6
            index(1,k) = numel(find(C3(:,k) > AllCoef.coef(3,k)));
        end
        Out.COEFF.C1 =C1;
        Out.COEFF.C2 =C2;
        Out.COEFF.C3 =C3;
        Out.mse = mse;
        Out.Index = index;
    end
%
end
