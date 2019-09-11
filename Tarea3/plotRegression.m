function  [meanx,meany,sdy] = plotRegression(x,y,plotfigure)


%classInt = GetStimuliTimeSpace(task);
classInt = [182 194 217 222 232 237 260 272]; 

[sint,indx] = sort(x);

xs = x(indx);
ys = y(indx);

numClass = histc(xs,classInt);
maxDat = 8; %categories stimuli

if plotfigure
    colormap('default');
    cmap = colormap;
    ColorStep = 10;%4;
end

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

if plotfigure
    close all;
    figure(2);
    hold on;
    
    errorbar(PlotData(:,1),PlotData(:,2),PlotData(:,3),'.','Color',[cmap((1),:)],'LineWidth',1.5);
    plot(PlotData(:,1),PlotData(:,2),'o','MarkerFaceColor',[cmap((1),:)],'MarkerEdgeColor',[cmap((1),:)],'MarkerSize',8);
    
    maxX = max(PlotData(:,1)) + min(PlotData(:,1))*.1;
    minX = min(PlotData(:,1)) - min(PlotData(:,1))*.1;
    maxY = max(PlotData(:,2)) + max(PlotData(:,2))*.2;
    axis([minX maxX 0 maxY])
    set(gca,'xtick',classInt, 'linewidth', 2)
    %set(gca,'ytick',[0 250 500 750 1000 1250 1500])
    set(gca,'TickDir','out','TickLength', [0.02 0.02])
    set(gca,'FontSize',10)
    %axis square
    % hold off;
end

meanx = PlotData(:,1);
meany = PlotData(:,2);
sdy = PlotData(:,3);
