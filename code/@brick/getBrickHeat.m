function [heat] = getBrickHeat(self,uID,LCase,faceNum,type)
%% getPlateThickness
% 
% faceNum = brick face number (St7 enumeration)
% type - 'radiation' or 'convection' (or both).

% author: John Braley
% create date: 09-Nov-2016 12:44:09
% Handle zero entry
if nargin<2; uID = 1; end
if nargin<3; LCase = 1; end
if nargin<4 || isempty(faceNum); faceNum = 1:6; end
if nargin<5 || isempty(type); type = {'convection';'radiation'}; end
      
if any(strcmp(type,'convection')) || any(strcmp(type,'conv'))
    heat.conv_coeff = zeros(length(self.id),length(faceNum));
    heat.conv_ambient = heat.conv_coeff;
    for ii = 1:length(self.id)
        for jj = 1:length(faceNum)  
            % Intitialize st7 output
            cresults = zeros(1,2);
            % get brick convection coefficients
            try
                [iErr, cresults] = calllib('St7API','St7GetBrickConvection2',uID,self.id(ii),...
                    faceNum(jj),LCase,cresults);
            catch
                if iErr~=10
                   HandleError(iErr)	
                end
            end
            
            heat.conv_coeff(ii,jj) = cresults(1);
            heat.conv_ambient(ii,jj) = cresults(2);
        end
    end
end
if any(strcmp(type,'radiation')) || any(strcmp(type,'rad'))
    heat.rad_coeff = zeros(length(self.id),length(faceNum));
    heat.rad_ambient = heat.rad_coeff;
    for ii = 1:length(self.id)
        for jj = 1:length(faceNum)  
            rresults = zeros(1,2);
            % get brick radiation coefficients
            try
                [iErr, rresults] = calllib('St7API','St7GetBrickRadiation2',uID,self.id(ii),...
                    faceNum(jj),LCase,rresults);
            catch
                if iErr~=10
                   HandleError(iErr)	
                end
            end
            heat.rad_coeff(ii,jj) = rresults(1);
            heat.rad_ambient(ii,jj) = rresults(2);
        end        
    end
end
	
	
end
