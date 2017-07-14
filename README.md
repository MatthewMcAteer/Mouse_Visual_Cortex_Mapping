# Mouse Visual Cortex Mapping
The Primary Visual Cortex is made up of numerous cells. Do neighboring cells respond to similar orientations or is V1 randomly organized

Hubel and Wiesel famously determined that V1 was highly organized into line orientation domains that were specifically sensitive to certain line angles. This organization pattrns is seen in most higher mammals such as cats, monkeys and humans.

Hubel and Wiesel's originl experiments involved electrophysiological recording. In recent years, however, two-photon calcium imaging has become a more useful tool for studying neuronal activity. Two-photon calcium imaging allows for visualizing neurons and their spatial relationship to one another.

Raw fluorescence traces for neurons imaged using Two-photon microscopy were extracted using ImageJ. The program MATLAB was then used to plot orientation tuning curves for each neuron.

The main script for this program is the MATLAB script MouseVisualCortexMapping_Main.m. Open this to run the program.

The program first promts the user for input files (The Results.txt text file, and the img108.mat image data and ROIs_108.mat Region Of Interest data are the defaults). The LoadFluorescenceData.m function loads the data from the Results.txt into a matrix.

The change in fluorescence relative to the baseline of one cell is calculated using OneCellCalculateAndPlotDFF.m (producing the first figure for this data), followed by the calculation of these differences for all cells using GenerateDFFMatrix.m (NOTE: This component of the program assumes the length of the recording of the video of the neurons was 576 seconds, with a framerate of 5 fps. In future versions this might be specifiable by a user input).

The next task of the program is to plot the responses for one cell to each orientation using PlotTrialAveragedResponseOneCell.m. This produces the second figure from this data. For interpreting the data, there does appear to be subjective differences in responses, but there currently isn't a script for automating that part of the analysis.

The program then calculates an orientation tuning curve for one cell as a test. It starts by calculating the time-averaged ON and OFF responses, taking into account the number of samples per orientation, the number of orientations, the IDs of the frames of the first ON period, and the IDs of the frames of the first OFF period. This is done by TimeAverageONOFFResponses.m. PlotTuningCurveOneCell.m takes the outputs from this and produces the 3rd figure of the program.

This is repeated for all the cells for which there are ROIs. TimeAverageONOFFResponsesALL.m calculates the ON intervals and OFF intervals for all cells, and then PlotTuningCurveMultiCell.m creates a plot of 8 of these cells.

The program calculates the requisite population statistics. First, SubtractThresholdTC.m subtracts and thresholds the tuning curve, resulting in statistics for the preferred orientations (PO) and orientation sensitivity indicies (OSI). Then, PlotPOandOSI.m plots a histogram of which orientations there were the greatest sensitivities to.

Finally, the orientation map, the 6th figure, is created by GenerateOrientationMap.m. This creates false color labels for the cells in the Two-photon microscope image, based on which orientation they were most sensitive too.

For the time being there is not a way of analysing the level of organiztion in the orientation map.
