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




% for j = 1:1

for trial = 1:TotalTrials
    
    stim = Behtimes(trial ,2);
    categ = Behtimes(trial ,4);
    [r, c] = find(Mat(:) == stim);
    positionInplot = getPositionInPlot(stim);
    
    trialcounter(positionInplot) = trialcounter(positionInplot) + 1;
    repetition = trialcounter(positionInplot); % Current repetition for this task, phase and stimulus.
    
    
    %-----Sliding Window----------------%
    %     Stim1 = Behtimes(trial,9);%1st stimulus time
    %     Stim2 = Behtimes(trial,10);%2st stimulus time
    %
    %     SWindow = Stim1 : 25: Stim2;
    %     Behav = SWindow(j); Behav(2) = SWindow(j) + 250;
    %     StimDischarge(trial,1) = getDischargeSWindow(Spikes{trial}, Behav,Behtimes(trial,:));
    %     idxStimDicharge(trial,1) = trial;
    %------------------------------------%
    
    StimDischarge(trial,1) = getDischargeStim(Spikes{trial}, Behtimes(trial,:));
    Distance(trial,1) = stim;
    DischargeperMag(repetition,r) = getDischargeStim(Spikes{trial}, Behtimes(trial,:));
end

% end

% DischargeperMag = reshape(StimDischarge,12,8);

%---Permuted Stim Discharge Rate each 250 ms-------%
% idxPermuted = randsample(idxStimDicharge,numel(idxStimDicharge));
% DistancePermuted = Distance(idxPermuted);
% StimDischargePermuted = StimDischarge(idxPermuted);


%---Compute MI, Models and Choice Probability-----%
PermuteNeuralActivity(Distance, StimDischarge, DischargeperMag,repetition,Mat,Tname);


return
%%%Mutual infromation
MI = MutualInformation(DischargeperMag);


x = Distance;
y = StimDischarge;
%%%%%compute curve fitting 6 models and plot predicted and actual
figure
colormap('jet');
cmap = colormap;
hold on;
%plot(x,y,'.k','MarkerSize', 12)
clear coef resid ypred

MeanDisch = mean(DischargeperMag);
SEMDisch = std(DischargeperMag)/sqrt(repetition);

maxX = max(Mat) + round(min(Mat)*.1);
minX = min(Mat) - round(min(Mat)*.1);
maxY = max(MeanDisch) + round(max(MeanDisch)*.2);
minY = min(MeanDisch) - round(max(MeanDisch)*.2);
TextY = max(MeanDisch) - round(max(MeanDisch)*.1);
axis([minX maxX minY  maxY])
set(gca,'xtick',Mat, 'linewidth', 1.5)
%set(gca,'ytick',[0 250 500 750 1000 1250 1500])
set(gca,'TickDir','out','TickLength', [0.02 0.02])
set(gca,'FontSize',10)

for model = 1:6
    model
    [coef(:,model),resid(:,model),ypred(:,model),mse(model)] = curvefitting6functions2019_V2(x,y,model);
    
    plot(x,ypred(:,model),'-','Color',[cmap(model*10,:)],'LineWidth',1.5)
    
end
xlabel('Distance (pixels)');
ylabel('Discharge rate');
legend(Tname{1},Tname{2},Tname{3},Tname{4},Tname{5},Tname{6},'Box','off');
plot(Mat, MeanDisch,'.','Color',[0 0 0],'MarkerSize',18);
errorbar(Mat, MeanDisch,SEMDisch,'.','Color',[0 0 0],'LineWidth',1);
hold off


%%%plot MSE all models
figure
hold on

plot(1:6,mse,'.r','MarkerSize',18)
set(gca,'xtick',[1:6], 'linewidth', 1.5)
set(gca,'xticklabel',[{Tname{1}, Tname{2},Tname{3},Tname{4},Tname{5},Tname{6}}], 'linewidth', 1.5)
set(gca,'TickDir','out','TickLength', [0.02 0.02])
set(gca,'FontSize',10)
xlabel('Model');
ylabel('MSE');
minY = min(mse) -  min(mse)*.1;
maxY = max(mse) +  max(mse)*.1;
axis([0 7 minY  maxY])
hold off

%%%plot residuals all models
figure
for model = 1:6
    model
    subplot(3,2,model);
    hold on
    plot(x,resid(:,model),'o','Color',[cmap(model*10,:)],'MarkerSize',4,'MarkerFaceColor',[cmap(model*10,:)])
    plot(x, zeros(numel(x),1),'-k','LineWidth',1.5)
    hold off
    
end
xlabel('Distance (pixels)');
ylabel('Residuals');
% set(gca, xlabel,'Distance (pixels)');
% set(gca, ylabel, 'Residuals');
%  text(-20, 0, 'Residuals', 'FontSize', 14,'Rotation',90);
%  text(220, , 'Residuals', 'FontSize', 14,'Rotation',90);

[Choice_P,ChoiceDiff05,Choice_PALL,ChoiceALLDiff05] = ComputeChoiceP_MeanofeachMagnitude(Behtimes, StimDischarge);




[bestmodel,idx] = min(mse);
NameBestModel = Tname{idx};
AllCoef.coef = coef;
AllCoef.mse = mse;
AllCoef.MI = MI;
AllCoef.Choice_P = Choice_P;
AllCoef.Choice_Sig = ChoiceDiff05;
AllCoef.Bestmodel = Tname{idx};




