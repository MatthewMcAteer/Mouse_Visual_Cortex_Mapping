function [ TuningCurveFigure ] = PlotTuningCurveOneCell(AveON, AveOFF, NumTrials, Orientations)
% PLOTTUNINGCURVEONECELL function
      
ON_mean = mean(AveON, 2);
ON_sem = std(AveON, [], 2) / sqrt(NumTrials);

OFF_mean = mean(mean(AveOFF, 2));
OFF_line = OFF_mean*ones(size(Orientations)); 

TuningCurveFigure = figure('Name','Tuning Curve');
hold on
errorbar(Orientations,ON_mean,ON_sem,'b') % plots ON tuning curve       
plot(Orientations,OFF_line,'r') % plots OFF spontaneous activity
xlim([-30 360])
ylim([min(ylim)-0.1, max(ylim)])
xlabel('Orientation (deg)')
ylabel('\DeltaF/F')

end
