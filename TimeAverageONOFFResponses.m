function [ AveON, AveOFF ] = TimeAverageONOFFResponses( DFF, cell, NumTrials, SamplesPerOri, NumOrientations, ON_period, OFF_period )
%TIMEAVERAGEONOFFRESPONSE function
        
dff_cell = DFF(cell, :); % extract dff trace for our cell
dff_reshaped = reshape(dff_cell,SamplesPerOri,NumOrientations,NumTrials);
        
AveON = mean(dff_reshaped(ON_period,:,:), 1);
AveOFF = mean(dff_reshaped(OFF_period,:,:), 1);

AveON = squeeze(AveON);
AveOFF = squeeze(AveOFF);

end
