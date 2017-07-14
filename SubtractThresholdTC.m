function [ TC, NumOrientations ] = SubtractThresholdTC( OFF_mean, ON_mean, ON_sem )
% SUBTRACTTHRESHOLDTC

NumOrientations = size(ON_mean,2);
        
OFF_mean = repmat(OFF_mean,1,NumOrientations); 

TC = ON_mean-OFF_mean;
TC(TC<0) = 0;        

end
