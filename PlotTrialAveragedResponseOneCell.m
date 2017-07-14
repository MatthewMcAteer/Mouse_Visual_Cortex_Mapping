function [ dff_reshaped, dff_avg ] = PlotTrialAveragedResponseOneCell( DFF, FrameRate, SamplesPerTrial, NumTrials, cell )
%PLOTTRIALAVERAGEDRESPONSEONECELL function

dff_cell = DFF(cell, :); % extracts dff trace for the cell
dff_reshaped = reshape(dff_cell, SamplesPerTrial, NumTrials);
dff_avg = mean(dff_reshaped, 2);

% plots dff_avg        
t = (0:SamplesPerTrial-1)/FrameRate;
plot(t,dff_avg)
hold on;

% plots bars indicating ON period
for i = 1:12
	plot([8*i-4,8*i],min(dff_avg)*ones(1,2),'r','LineWidth',3)
end
xlabel('Time (s)')
ylabel('\DeltaF/F')

end

