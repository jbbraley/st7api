function [num_tables, max_id] = getExisting(self,uID)
%% create
% creates new table in st7 model
% 
% still need to populate all the table types
% author: 
% create date: 19-Jun-2020 12:55:40
	
if nargin<2; uID = 1; end

global ttVsTime ttVsTemperature ttVsFrequency ttStressStrain ttForceDisplacement...
    ttMomentCurvature ttMomentRotation ttAccVsTime ttForceVelocity ttVsPosition...
    ttStrainTime

switch self.type
    case 'time'
        type = ttVsTime;
    case {'temp'; 'temperature'}
        type = ttVsTemperature;
    case {'freq'; 'frequency'}
        type = ttVsFrequency;
    case {'stressstrain'}
        type = ttStressStrain;
end

[num_tables, max_id, iErr] = calllib('St7API','St7GetNumTables',uID,type,0,0);
HandleError(iErr)

	
end
