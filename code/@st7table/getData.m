function getData(self,uID)
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

[num_rows, iErr] = calllib('St7API','St7GetNumTableTypeRows',uID,type,self.id,0);
HandleError(iErr)

data_array = zeros(1,2*num_rows);
[data_array, iErr] = calllib('St7API','St7GetTableTypeData',uID,type,self.id,...
    num_rows,data_array);
HandleError(iErr)

self.data_array = data_array;	
	
	
end
