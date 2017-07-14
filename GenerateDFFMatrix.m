function [ DFF, NumCells ] = GenerateDFFMatrix(rawF, vidlength, FrameRate)
%GENERATEDFFMATRIX function

NumCells = size(rawF,1);

for cell=1:NumCells
    
    rawF_cell = rawF(cell,:);
    rawF_rounded = round(rawF_cell/10)*10; % rounds to nearest multiple of 10
    baseline = mode(rawF_rounded);
    dff_cell = ((rawF_cell) - (baseline))/(baseline);
        
    DFF(cell,:) = dff_cell;
            
end

old_length = size(DFF,2); % number of columns
new_length = vidlength * FrameRate; % 5fps * 576seconds

for cell = 1:NumCells

   DFF_cell = DFF(cell,:); 

   % stores the interpolated vector in a row of the DFF_new matrix
   DFF_new(cell,:) = interp1(DFF_cell,linspace(1,old_length,new_length));

end
DFF = DFF_new; % replaces matrix with interpolated one

end
