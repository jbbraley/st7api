function [heat] = getPlateThickness(self,uID,LCase)
%% getPlateThickness
% 
% 
% 
% author: John Braley
% create date: 09-Nov-2016 12:44:09
global psPlateZPlus	
% Handle zero entry
if nargin<2; uID = 1; end

%preallocate
heat.conv_coeff = zeros(length(self.plateID),1);
heat.conv_ambient = conv_coeff;
heat.rad_coeff = conv_coeff;
heat.rad_ambient = conv_coeff;
    
for ii = 1:length(self.plateID)
    % Intitialize st7 output
    cresults = zeros(1,2);
    rresults = zeros(1,2);

    % get plate convection coefficients
    [iErr, cresults] = calllib('St7API','St7GetPlateFaceConvection2',uID,self.plateID(ii),LCase,...
    psPlateZPlus,cresults);
    HandleError(iErr)	
    
    % get plate convection coefficients
    [iErr, rresults] = calllib('St7API','St7GetPlateFaceRadiation2',uID,self.plateID(ii),LCase,...
    psPlateZPlus,rresults);
    HandleError(iErr)
    
    heat.conv_coeff(ii) = cresults(1);
    heat.conv_ambient(ii) = cresults(2);
    heat.rad_coeff(ii) = rresults(1);
    heat.rad_ambient(ii) = rresults(2);
end
	
	
end
