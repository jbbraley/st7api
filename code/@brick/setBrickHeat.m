function setBrickHeat(self,uID,LCase,faceNum)
%SETPLATEHEAT Summary of this function goes here
% faceNum - brick face number (St7 enumeration)
% assigns convection and radiation coefficient to brick faces
% Handle zero entry
if nargin<2; uID = 1; end
if nargin<3; LCase = 1; end
if nargin<4; faceNum = 1:4; end
if size(self.conv_coeff,1)==1; self.conv_coeff = self.conv_coeff*ones(length(self.plateID),length(faceNum)); end
if size(self.conv_ambient,1)==1; self.conv_ambient = self.conv_ambient*ones(length(self.plateID),length(faceNum)); end
if size(self.rad_coeff,1)==1; self.rad_coeff = self.rad_coeff*ones(length(self.plateID),length(faceNum)); end
if size(self.rad_ambient,1)==1; self.rad_ambient = self.rad_ambient*ones(length(self.plateID),length(faceNum)); end

% Assign heat parameters 
for ii = 1:length(self.plateID)
    for jj = 1:length(faceNum)
        if ~isempty(self.conv_coeff)
            % set brick convection coefficients
            [iErr] = calllib('St7API','St7SetBrickConvection2(',uID,self.id(ii),...
                faceNum(jj),LCase,[self.conv_coeff(ii,jj) self.conv_ambient(ii,jj)]);
            HandleError(iErr)	
        end
        if ~isempty(self.rad_coeff)
            % set brick radiation coefficients
            [iErr] = calllib('St7API','St7SetBrickRadiation2',uID,self.id(ii),...
                faceNum(jj),LCase,[self.rad_coeff(ii,jj) self.rad_ambient(ii,jj)]);
            HandleError(iErr)
        end
    end
end
end

