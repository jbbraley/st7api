function setPlateOffset(self, uID)
%% setPlateThickness
% 
% 
% 
% author: John Braley
% create date: 13-Sep-2016 17:24:39
	
% Handle zero entry
if nargin<2; uID = 1; end

% Thickness
Doubles = [self.offset]; % vertical offset in inches
	
% Beam Strand7 property identifier
propNum = self.propNum;

% get plate id numbers for property
plateNum = [];
for ii = 1:length(propNum)
    elem_nums = api.getElementbyProp(uID,'plate',propNum(ii));
    plateNum = [plateNum elem_nums];
end

% Loop though properties
for ii = 1:length(plateNum)
% set plate thickness for Strand7 plate property
iErr = calllib('St7API','St7SetPlateOffset1',uID,plateNum(ii),...
    Doubles);
HandleError(iErr)	
end
	
end
