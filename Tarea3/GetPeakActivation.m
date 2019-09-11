function  [MaxPeakActivity,MaxPeakIndex] = GetPeakActivation(Sp_time,beginact,endinact,Numspk,numact)


KERNEL_WIDTH = 60 ;
sigma = 1;%

out = Sp_time;


for ac = 1:numact
    samp_points=[beginact(ac):sigma:endinact(ac)];
    this_duration_sdf = ksdensity(out, samp_points, 'kernel', 'normal', 'width', KERNEL_WIDTH);
    this_duration_sdf = this_duration_sdf * Numspk * 1000;

    
    samp_points2 =[beginact(ac):1:endinact(ac)];
%Las espigas se mantienen en segundos
    % convert sdf to hz
    begx = find(samp_points2(:) == beginact(ac));
    endx = find(samp_points2(:) == endinact(ac));
    [maxsdf(ac),nnmx] = max(this_duration_sdf(begx:endx)); %Magnitude
    nnmx = nnmx+begx-1;
    MaxPeakAc(ac) = samp_points(nnmx); %Tiempo por 1000 para ponerlo en ms    
end

[~,inxtem] = max(maxsdf(:));

MaxPeakActivity = MaxPeakAc(inxtem);

MaxPeakIndex = inxtem;

