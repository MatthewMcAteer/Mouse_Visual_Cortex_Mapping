prompt = {'What is the name of the file with the fluorescence data?','What is the name of the file with the image?','What is the name of the file with the ROIs?'};
dlg_title = 'User Inputs';
num_lines = 1;
defaultans = {'Results.txt','img108.mat','ROIs_108.mat'};
InputAnswer = inputdlg(prompt,dlg_title,num_lines,defaultans); 

%% STEP 1: Loads the text file containing fluorescence data from ImageJ
Results = InputAnswer{1};
[rawF, rows, cols] = LoadFluorescenceData(Results);

% Saves the rawF variable into a .mat file for troubleshooting
save('rawF.mat','rawF');

%need to add pause feature here

%% STEP 2: Computing the change in fluorescence relative to baseline of each cell

cell = 1; % We will test by extracting from this cell only at first

Figure1 = figure('Name','DFF for one cell');
[dff_cell, baseline, rawF_rounded, rawF_cell] = OneCellCalculateAndPlotDFF(rawF, cell);

vidlength = 576; % 576 seconds as a default
FrameRate = 5;  % 5 fps

[ DFF, NumCells ] = GenerateDFFMatrix(rawF, vidlength, FrameRate);
save('DFF.mat','DFF');

%% STEP 3: Plotting the responses for one cell to each orientation
% Plot trial-Averaged Response of One Cell
SamplesPerTrial = 480; % 480 Samples Per Trial
NumTrials = 6; % 6 trials

Figure2 = figure('Name','Averaged Trial Responses for one cell');
[ dff_reshaped, dff_avg ] = PlotTrialAveragedResponseOneCell( DFF, FrameRate, SamplesPerTrial, NumTrials, cell );

% For interpreting the data, there does appear to be differences in
% responses
% currently don't have a program for automating that part of the analysis

%% STEP 4: Plotting an Orientation Tuning Curve
% Calculate Time-Averaged ON and OFF Responses

SamplesPerOri = 40;
NumOrientations = 12;
ON_period = 21:40;
OFF_period = 11:20;

[AveON, AveOFF] = TimeAverageONOFFResponses(DFF, cell, NumTrials, SamplesPerOri, NumOrientations, ON_period, OFF_period);
save('Ave_cell1.mat','AveON','AveOFF');

% Plot the Tuning Curve

Orientations = 0:30:330;
Figure3 = PlotTuningCurveOneCell(AveON, AveOFF, NumTrials, Orientations);

%% STEP 5: Plotting Tuning Curves for All Cells
% Calculate Time-Averaged ON and OFF Responses
[ AveON, AveOFF ] = TimeAverageONOFFResponsesALL( DFF, NumCells, NumTrials, SamplesPerOri, NumOrientations, ON_period, OFF_period);

save('Ave_all.mat','AveON','AveOFF');

% Plot Multiple Tuning Curves
[ Figure4, OFF_mean, ON_mean, ON_sem ] = PlotTuningCurveMultiCell(AveON, AveOFF, NumTrials, Orientations);
save('TC.mat','OFF_mean','ON_mean','ON_sem');

%% STEP 6: Computing Population Statistics
% Subtract and Threshold Tuning Curve
[ TC, NumOrientations ] = SubtractThresholdTC( OFF_mean, ON_mean, ON_sem );
save('TC_sub.mat','TC');
% Plot Histograms of Preferred Orientation and OSI
[ Figure5, AllOSI, AllPO ] = PlotPOandOSI( TC, NumCells, Orientations );

%% STEP 7: Generating a Population Orientation Map
load(InputAnswer{2});
load(InputAnswer{3});

% Generate the Map
[ Figure6 ] = GenerateOrientationMap( AllOSI, AllPO, TC, img108, ROIs_108, NumCells );

% Organized or Disorganized?

