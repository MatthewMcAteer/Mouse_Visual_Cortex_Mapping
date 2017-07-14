function [ MultiTuningCurveFigure, OFF_mean, ON_mean, ON_sem ] = PlotTuningCurveMultiCell(AveON, AveOFF, NumTrials, Orientations)
% PLOTTUNINGCURVEMULTICELL function

ON_mean = squeeze(mean(AveON,3));
ON_sem = std(AveON,[],3)/sqrt(NumTrials);
        
OFF_mean = mean(mean(AveOFF, 3), 2);

MultiTuningCurveFigure = figure('Name','Multiple Tuning Curves');

for cell = 1:8
    subplot(2,4,cell)
    
    OFF_line = OFF_mean(cell).*ones(size(Orientations));
    
    hold on
	errorbar(Orientations,ON_mean(cell,:),ON_sem(cell,:),'b') % plots ON tuning curve       
	plot(Orientations,OFF_line,'r') % plots OFF spontaneous activity
	xlim([-30 360])
	ylim([min(ylim)-0.1, max(ylim)])
        
end


end
