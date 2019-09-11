function  [meanx,meany,sdy] = getMeans(x,y)


classInt = [182 194 217 222 232 237 260 272]; 

[sint,indx] = sort(x);

xs = x(indx);
ys = y(indx);

numClass = histc(xs,classInt);
maxDat = 8; %categories stimuli

bcl = 1;
nnrow = 1;
for bin = 1:maxDat
    
    clear temTimerow1 temTimerow2
    bcl = bcl;
    ecl = bcl + numClass(bin)-1;
    
    temTimerow1(:,1) = xs(bcl:ecl);
    temTimerow2(:,1) = ys(bcl:ecl);
    bcl = bcl + numClass(bin);
    nnEs = numel(temTimerow1);
    PlotData(bin,1) = mean(temTimerow1);
    PlotData(bin,2) = mean(temTimerow2);
    PlotData(bin,3) = (std(temTimerow2)/sqrt(nnEs));
end


meanx = PlotData(:,1);
meany = PlotData(:,2);
sdy = PlotData(:,3);
