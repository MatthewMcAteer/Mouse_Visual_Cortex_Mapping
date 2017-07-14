function [ OrientationMap ] = GenerateOrientationMap( AllOSI, AllPO, TC, img, ROIs, NumCells )
%GENERATEORIENTATIONMAP function

OrientationMap = figure('Name','Orientation Map');

% displays average projection image
image(img) 
axis square

% setup colors
color = hsv(180); 

% loops for each cell
for cell = 1:NumCells
    
    % get ROI coordinates
    roi = ROIs{cell}.mnCoordinates;    
    
    % color based on preferred orientation	        
    if max(TC(cell,:)) == 0  % not visually responsive = black
        roicolor = zeros(1,3); 
        
    elseif AllOSI(cell) < 0.25 % broadly tuned = white
        roicolor = ones(1,3); 
        
    else % not visually responsive
        roicolor = color(ceil(AllPO(cell)),:);
        
    end    
    
    % draws colored ROI
    patch(roi(:,1),roi(:,2),ones(1,size(roi,1)),'FaceColor',roicolor)    
end     
        
colormap(color)
colorbar('Ticks',[0:60:360]/180, 'TickLAbels',0:30:180)
axis off
title('Population Orientation Map')

end
