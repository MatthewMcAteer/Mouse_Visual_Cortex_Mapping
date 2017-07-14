function [ AveON, AveOFF ] = TimeAverageONOFFResponsesALL( DFF, NumCells, NumTrials, SamplesPerOri, NumOrientations, ON_period, OFF_period)
% TIMEAVERAGEONOFFRESPONSESALL

% initialize matrices function
AveON = zeros(NumCells,NumOrientations,NumTrials);
AveOFF = zeros(NumCells,NumOrientations,NumTrials);

for cell = 1:NumCells            
        
    dff_cell = DFF(cell,:); % extract dff trace for our cell
    dff_reshaped = reshape(dff_cell,SamplesPerOri,NumOrientations,NumTrials);
            
    AveON(cell,:,:) = mean(dff_reshaped(ON_period,:,:), 1);
    AveOFF(cell,:,:) = mean(dff_reshaped(OFF_period,:,:), 1);
end


end
