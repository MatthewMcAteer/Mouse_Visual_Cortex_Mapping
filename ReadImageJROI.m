function [sROI] = ReadImageJROI(cstrFilenames)
% READIMAGEJROI function

bOpt_SubPixelResolution = 128;

if (nargin < 1)
   disp('*** ReadImageJROI: Incorrect usage');
   help ReadImageJROI;
   return;
end

if (iscell(cstrFilenames))
   cvsROI = cellfun(@ReadImageJROI, CellFlatten(cstrFilenames), 'UniformOutput', false);
   
   sROI = cvsROI;
   return;
   
else
   strFilename = cstrFilenames;
   clear cstrFilenames;
end


[nul, nul, strExt] = fileparts(strFilename); 
if (isequal(lower(strExt), '.zip'))
   cstrFilenames_short = listzipcontents_rois(strFilename);
   strROIDir = tempname;
   unzip(strFilename, strROIDir);
   
   for (nFileIndex = 1:length(cstrFilenames_short))
      cstrFilenames{1, nFileIndex} = [strROIDir '/' char(cstrFilenames_short(nFileIndex, 1))];
   end
   cvsROIs = ReadImageJROI(cstrFilenames);
   delete([strROIDir filesep '*.roi']);
   rmdir(strROIDir);
   
   sROI = cvsROIs;
   return;
end


if (~exist(strFilename, 'file'))
   error('ReadImageJROI:FileNotFound', ...
      '*** ReadImageJROI: The file [%s] was not found.', strFilename);
end

fidROI = fopen(strFilename, 'r', 'ieee-be');

strMagic = fread(fidROI, [1 4], '*char');

if (~isequal(strMagic, 'Iout'))
   error('ReadImageJROI:FormatError', ...
      '*** ReadImageJROI: The file was not an ImageJ ROI format.');
end
sROI.nVersion = fread(fidROI, 1, 'int16');
nTypeID = fread(fidROI, 1, 'uint8');
fseek(fidROI, 1, 'cof');
sROI.vnRectBounds = fread(fidROI, [1 4], 'int16');
nNumCoords = fread(fidROI, 1, 'uint16');
vfLinePoints = fread(fidROI, 4, 'float32');
nStrokeWidth = fread(fidROI, 1, 'int16');
nShapeROISize = fread(fidROI, 1, 'uint32');
nStrokeColor = fread(fidROI, 1, 'uint32');
nFillColor = fread(fidROI, 1, 'uint32');
nROISubtype = fread(fidROI, 1, 'int16');
nOptions = fread(fidROI, 1, 'int16');
nArrowStyle = fread(fidROI, 1, 'uint8');
nArrowHeadSize = fread(fidROI, 1, 'uint8');
nRoundedRectArcSize = fread(fidROI, 1, 'int16');
sROI.nPosition = fread(fidROI, 1, 'uint32');
nHeader2Offset = fread(fidROI, 1, 'uint32');

if (nHeader2Offset > 0) && ~fseek(fidROI, nHeader2Offset+32+4, 'bof') 
   fseek(fidROI, nHeader2Offset+4, 'bof');
   sROI.vnPosition = fread(fidROI, 3, 'uint32')';
   vnNameParams = fread(fidROI, 2, 'uint32')';
   nOverlayLabelColor = fread(fidROI, 1, 'uint32');
   nOverlayFontSize = fread(fidROI, 1, 'int16');
   fseek(fidROI, 1, 'cof');
   nOpacity = fread(fidROI, 1, 'uint8');
   nImageSize = fread(fidROI, 1, 'uint32');
   fStrokeWidth = fread(fidROI, 1, 'float32');
   vnROIPropertiesParams = fread(fidROI, 2, 'uint32')';
   nCountersOffset = fread(fidROI, 1, 'uint32');
   
else
   sROI.vnPosition = [];
   vnNameParams = [0 0];
   nOverlayLabelColor = [];
   nOverlayFontSize = []; 
   nOpacity = []; 
   nImageSize = [];
   fStrokeWidth = [];
   vnROIPropertiesParams = [0 0];
   nCountersOffset = 0;
end


if (isempty(vnNameParams) || any(vnNameParams == 0) || fseek(fidROI, sum(vnNameParams), 'bof'))
   [nul, sROI.strName] = fileparts(strFilename); %#ok<ASGLU>

else
   fseek(fidROI, vnNameParams(1), 'bof');
   sROI.strName = fread(fidROI, vnNameParams(2), 'int16=>char')';
end

fseek(fidROI, 52, 'bof');
fAspectRatio = fread(fidROI, 1, 'float32');

fseek(fidROI, 64, 'bof');

switch nTypeID
   case 1
      sROI.strType = 'Rectangle';
      sROI.nArcSize = nRoundedRectArcSize;
      
      if (nShapeROISize > 0)
         sROI.strSubtype = 'Shape';
         if (nTypeID ~= 1)
            error('ReadImageJROI:FormatError', ...
               '*** ReadImageJROI: A composite ROI must be a Rectangle type.');
         end
         sROI.vfShapes = fread(fidROI, nShapeROISize, 'float32');
      end
      
      
   case 2
      sROI.strType = 'Oval';
      
   case 3
      sROI.strType = 'Line';
      sROI.vnLinePoints = round(vfLinePoints);
      
      if (nROISubtype == 2)
         sROI.strSubtype = 'Arrow';
         sROI.bDoubleHeaded = nOptions & 2;
         sROI.bOutlined = nOptions & 4;
         sROI.nArrowStyle = nArrowStyle;
         sROI.nArrowHeadSize = nArrowHeadSize;
      end
      
      
   case 0
      sROI.strType = 'Polygon';
      sROI.mnCoordinates = read_coordinates;
      
   case 7
      sROI.strType = 'Freehand';
      sROI.mnCoordinates = read_coordinates;
      
      if (nROISubtype == 3)
         sROI.strSubtype = 'Ellipse';
         sROI.vfEllipsePoints = vfLinePoints;
         sROI.fAspectRatio = fAspectRatio;
      end
      
   case 8
      sROI.strType = 'Traced';
      sROI.mnCoordinates = read_coordinates;
      
   case 5
      sROI.strType = 'PolyLine';
      sROI.mnCoordinates = read_coordinates;
      
   case 4
      sROI.strType = 'FreeLine';
      sROI.mnCoordinates = read_coordinates;
      
   case 9
      sROI.strType = 'Angle';
      sROI.mnCoordinates = read_coordinates;
      
   case 10
      sROI.strType = 'Point';
      [sROI.mfCoordinates, vnCounters] = read_coordinates;
      
      if (isempty(vnCounters))
         sROI.vnCounters = zeros(nNumCoords, 1);
         sROI.vnSlices = ones(nNumCoords, 1);
      else
         sROI.vnCounters = bitand(vnCounters, 255);
         sROI.vnSlices = bitshift(vnCounters, -8, 'uint32');
      end
      
   case 6
      sROI.strType = 'NoROI';
      
   otherwise
      error('ReadImageJROI:FormatError', ...
         '--- ReadImageJROI: The ROI file contains an unknown ROI type.');
end

if (sROI.nVersion >= 218)
   sROI.nStrokeWidth = nStrokeWidth;
   sROI.nStrokeColor = nStrokeColor;
   sROI.nFillColor = nFillColor;
   sROI.bSplineFit = nOptions & 1;
   
   if (nROISubtype == 1)

      sROI.strSubtype = 'Text';

      fseek(fidROI, 64, 'bof');
      
      sROI.nFontSize = fread(fidROI, 1, 'uint32');
      sROI.nFontStyle = fread(fidROI, 1, 'uint32');
      nNameLength = fread(fidROI, 1, 'uint32');
      nTextLength = fread(fidROI, 1, 'uint32');
      
      sROI.strFontName = fread(fidROI, nNameLength, 'uint16=>char');
      
      sROI.strText = fread(fidROI, nTextLength, 'uint16=>char');
   end
end

fclose(fidROI);

   function [mnCoordinates, vnCounters] = read_coordinates
      
      if bitand(nOptions, bOpt_SubPixelResolution)
         fseek(fidROI, 64 + 4*nNumCoords, 'bof');
         vnX = fread(fidROI, [nNumCoords 1], 'single');
         vnY = fread(fidROI, [nNumCoords 1], 'single');
         
      else
         vnX = fread(fidROI, [nNumCoords 1], 'int16');
         vnY = fread(fidROI, [nNumCoords 1], 'int16');
         vnX(vnX < 0) = 0;
         vnY(vnY < 0) = 0;
         vnX = vnX + sROI.vnRectBounds(2);
         vnY = vnY + sROI.vnRectBounds(1);
      end
      
      mnCoordinates = [vnX vnY];
      if (nCountersOffset ~= 0)
         fseek(fidROI, nCountersOffset, 'bof');
         vnCounters = fread(fidROI, [nNumCoords 1], 'uint32');
      else
         vnCounters = [];
      end
   end

   function [filelist] = listzipcontents_rois(zipFilename)
      import java.util.zip.*;
      import java.io.*;
      filelist={};
      in = ZipInputStream(FileInputStream(zipFilename));
      entry = in.getNextEntry();
      while (entry~=0)
         name = entry.getName;
         if (name.endsWith('.roi'))
            filelist = cat(1,filelist,char(name));
         end;
         entry = in.getNextEntry();
      end;
      in.close();
   end


   function [cellArray] = CellFlatten(varargin)
            
      if (nargin == 0)
         disp('*** CellFlatten: Incorrect usage');
         help CellFlatten;
         return;
      end
      
      if (iscell(varargin{1}))
         cellArray = CellFlatten(varargin{1}{:});
      else
         cellArray = varargin(1);
      end
      
      for (nIndexArg = 2:length(varargin))
         if (iscell(varargin{nIndexArg}))
            cellReturn = CellFlatten(varargin{nIndexArg}{:});
            cellArray = [cellArray cellReturn{:}];
         else
            cellArray = [cellArray varargin{nIndexArg}];
         end
      end
   end
end
