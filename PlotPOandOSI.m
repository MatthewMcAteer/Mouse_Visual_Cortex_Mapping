function [ POandOSIFigure, AllOSI, AllPO ] = PlotPOandOSI( TC, NumCells, Orientations )
%PLOTPOANDOSI function

AngRad = Orientations*pi/180;        

% initializes the vectors        
AllOSI = zeros(1,NumCells);
AllPO = zeros(1,NumCells);
        
for cell = 1:NumCells
    
    TC_cell = TC(cell,:);

    OSI = abs(sum(TC_cell.*exp(2.*1i.*AngRad))./sum(TC_cell));
    PrefOri = 0.5.*( angle( sum(TC_cell.*exp(2.*1i.*AngRad)) ) );
    PO = PrefOri.*(180/pi);
    if PO < 0
        PO = PO+180;
    end
        
    AllOSI(1,cell) = OSI;
    AllPO(1,cell) = PO;    
        
end

POandOSIFigure = figure('Name','Preferred Orientations & OSI');

subplot(1,2,1)        
hist(AllOSI)      
xlabel('OSI')        
subplot(1,2,2)
hist(AllPO)  
xlabel('Preferred Orientation (deg)')

end
