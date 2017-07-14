function [ dff_cell, baseline, rawF_rounded, rawF_cell ] = OneCellCalculateAndPlotDFF(rawF, cell )
%ONECELLCALCULATEANDPLOTDFF

rawF_cell = rawF(cell,:);
rawF_rounded = round(rawF_cell/10)*10; % round to nearest multiple of 10
baseline = mode(rawF_rounded);
dff_cell = ((rawF_cell) - (baseline))/(baseline);

        
subplot(2,1,1)
plot(rawF_cell)
ylabel('raw F')
axis tight        
        
subplot(2,1,2)
plot(dff_cell)
ylabel('DFF')
axis tight


end
