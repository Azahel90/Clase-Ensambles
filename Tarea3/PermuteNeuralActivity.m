function  AllCoef = PermuteNeuralActivity(Distance, StimDischarge, DischargeperMag,repetition,Behtimes,Tname)
%%%Mutual infromation
 MI = MutualInformation(DischargeperMag);          


x = Distance;
y = StimDischarge;

%%%%%compute curve fitting 6 models and plot predicted and actual
% figure
% colormap('jet');
% cmap = colormap;
% hold on;
%plot(x,y,'.k','MarkerSize', 12)
clear coef resid ypred

MeanDisch = mean(DischargeperMag);
SEMDisch = std(DischargeperMag)/sqrt(repetition);
% 
% maxX = max(Mat) + round(min(Mat)*.1);
% minX = min(Mat) - round(min(Mat)*.1);
% maxY = max(MeanDisch) + round(max(MeanDisch)*.2);
% minY = min(MeanDisch) - round(max(MeanDisch)*.2);
% TextY = max(MeanDisch) - round(max(MeanDisch)*.1);
% axis([minX maxX minY  maxY])
% set(gca,'xtick',Mat, 'linewidth', 1.5)
% %set(gca,'ytick',[0 250 500 750 1000 1250 1500])
% set(gca,'TickDir','out','TickLength', [0.02 0.02])
% set(gca,'FontSize',10)

for model = 1:6
%     model
    [coef(:,model),resid(:,model),ypred(:,model),mse(model)] = curvefitting6functions2019_V2(x,y,model);
        
%     plot(x,ypred(:,model),'-','Color',[cmap(model*10,:)],'LineWidth',1.5)
%     close
end  
% xlabel('Distance (pixels)');
% ylabel('Discharge rate');
% legend(Tname{1},Tname{2},Tname{3},Tname{4},Tname{5},Tname{6},'Box','off');
% plot(Mat, MeanDisch,'.','Color',[0 0 0],'MarkerSize',18);
% errorbar(Mat, MeanDisch,SEMDisch,'.','Color',[0 0 0],'LineWidth',1);
% hold off
% close

%%%plot MSE all models
% figure
% hold on 
% 
% plot(1:6,mse,'.r','MarkerSize',18)
% set(gca,'xtick',[1:6], 'linewidth', 1.5)
% set(gca,'xticklabel',[{Tname{1}, Tname{2},Tname{3},Tname{4},Tname{5},Tname{6}}], 'linewidth', 1.5)
% set(gca,'TickDir','out','TickLength', [0.02 0.02])
% set(gca,'FontSize',10)
% xlabel('Model');
% ylabel('MSE');
% minY = min(mse) -  min(mse)*.1;
% maxY = max(mse) +  max(mse)*.1;
% axis([0 7 minY  maxY])
% hold off

%%%plot residuals all models
% figure
% for model = 1:6
%     model
%      subplot(3,2,model);       
%      hold on
%      plot(x,resid(:,model),'o','Color',[cmap(model*10,:)],'MarkerSize',4,'MarkerFaceColor',[cmap(model*10,:)])
%      plot(x, zeros(numel(x),1),'-k','LineWidth',1.5)
%    hold off
%     
% end  
% xlabel('Distance (pixels)');
% ylabel('Residuals');

% close
% set(gca, xlabel,'Distance (pixels)');
% set(gca, ylabel, 'Residuals');
%  text(-20, 0, 'Residuals', 'FontSize', 14,'Rotation',90); 
%  text(220, , 'Residuals', 'FontSize', 14,'Rotation',90); 

%-----Descomentar--------%
%  [Choice_P,ChoiceDiff05,Choice_PALL,ChoiceALLDiff05] = ComputeChoiceP_MeanofeachMagnitude(Behtimes, StimDischarge);
%                           
%  
% 
% 
[bestmodel,idx] = min(mse);
NameBestModel = Tname{idx};
AllCoef.coef = coef;
AllCoef.mse = mse;
AllCoef.MI = MI;
% AllCoef.Choice_P = Choice_P;
% AllCoef.Choice_Sig = ChoiceDiff05;
AllCoef.Bestmodel = Tname{idx};




