function [ rawF, rows, cols ] = LoadFluorescenceData(Results)
% LOADFLUORESCENCEDATA function

% A is the structure in which the Results from are loaded into
% The fluorescence data is located in Results.txt
A = importdata(Results);
rawData = A.data'; % extract and transpose

% The data should have dimensions of 74 rows x 2184 columns

[rows, cols] = size(A);
% The number of columns is the total number of frames. 
% The number of rows is the total number of cells (ROIs) plus one additional row.
% The additional row is removed in the following step.

rawF = rawData(2:74,:);

end
