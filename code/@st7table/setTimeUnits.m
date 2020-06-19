function setTimeUnits(self,uID,unit_type)
%% create
% creates new table in st7 model
% 
% still need to populate all the table types
% author: 
% create date: 19-Jun-2020 12:55:40
	
if nargin<2; uID = 1; end

global ttVsTime ttStrainTime
global tuMilliSec tuSec tuMin tuHour tuDay

switch self.type
    case 'time'
        type = ttVsTime;
    case 'straintime'
        type = ttStrainTime;
    otherwise
        disp('not a time table, no changes made')
        return
end
switch unit_type
    case 'msec'
        unit = tuMilliSec;
    case 'sec'
        unit = tuSec;
    case 'min'
        unit = tuMin;
    case 'hour'
        unit = tuHour;
    case 'day'
        unit = tuDay;
end

[iErr] = calllib('St7API','St7SetTimeTableUnits',uID,type,self.id,...
    unit);
HandleError(iErr)
	
	
	
end
