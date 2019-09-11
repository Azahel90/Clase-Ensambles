function [MChoice_P,MDifffrompoint5,TChoice_P,TDifffrompoint5] = ComputeChoiceP_MeanofeachMagnitude(Behv, Syn_fr) 

clear P_Psych MeanDischar FR_Low FR_High DischOUT 
FR_Low = [];
FR_High = [];

Choice_P = [];
Difffrompoint5 = [];
%%% This loop constructs the inputs for the functions %%%
for magnitude = 1:8
    clear idx Epoch_fr idLow lowFr idHigh highFr idLowT lowFrT idHighT highFrT FR_Low FR_High
    %%% Number of long responses for this magnitude
    idx = find(Behv(:, 6) == magnitude);
    P_Psych(magnitude, 2) = sum(Behv(idx, 5)); % p of response 'long'
    P_Psych(magnitude, 1) = unique(Behv(idx, 2));  % Space Magnitude
    
    %%% Firing rate for the repetitions of this magnitude
    Epoch_fr = Syn_fr (idx);
    
    %%% Mean firing rate for this magnitude
    MeanDischar(magnitude) = mean(Epoch_fr);
    
    %%% Get the firing rates for short and long responses
    idLow = intersect(find(Behv(:, 6) == magnitude), find(Behv(:, 5) == 0));
    lowFr = Syn_fr (idLow);    
    FR_Low = [lowFr];
    idHigh = intersect(find(Behv(:, 6) == magnitude), find(Behv(:, 5) == 1));
    highFr = Syn_fr (idHigh);    
    FR_High = [highFr];
    
    if numel(FR_High)<3 || numel(FR_Low) <3 %ENOUGH TRIALS FOR HOGH AND LOW RESPONSES
        Choice_P(magnitude) = NaN;
        Difffrompoint5(magnitude) = NaN;
    else
          [Choice_P(magnitude),CI,Difffrompoint5(magnitude)] = rocindex(FR_High, FR_Low);
       
    end
    
end % magnitude loop


MChoice_P = nanmedian( Choice_P(3:6));
TChoice_P= nanmedian( Choice_P);

  if MChoice_P < 0.4
            MChoice_P = 1 - MChoice_P;
  end
  
   if TChoice_P < 0.4
           TChoice_P = 1 - TChoice_P;
  end

Tval = 8 - sum(isnan(Difffrompoint5));
Mval = 4 - sum(isnan(Difffrompoint5(3:6)));

MDifffrompoint5 = nansum(Difffrompoint5(3:6))/Mval;
TDifffrompoint5 = nansum(Difffrompoint5)/Tval;



