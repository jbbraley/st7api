function setPlateHeat(self,uID,LDcase,side)
%SETPLATEHEAT Summary of this function goes here
%   Detailed explanation goes here
global psPlateZPlus	psPlateZMinus
% Handle zero entry
if nargin<2; uID = 1; end
if nargin<3; LDcase = 1; end
if nargin<4 || isempty(side); side = {'positive','negative'}; end
if ~iscell(side); side = {side}; end
if size(self.conv_coeff,1)==1; self.conv_coeff = self.conv_coeff*ones(length(self.plateID),length(side)); end
if size(self.conv_ambient,1)==1; self.conv_ambient = self.conv_ambient*ones(length(self.plateID),length(side)); end
if size(self.rad_coeff,1)==1; self.rad_coeff = self.rad_coeff*ones(length(self.plateID),length(side)); end
if size(self.rad_ambient,1)==1; self.rad_ambient = self.rad_ambient*ones(length(self.plateID),length(side)); end

% Assign heat parameters 
for ii = 1:length(self.plateID)
    for jj = 1:length(side)
        switch side{jj}
            case {'positive'; 'pos'; '+'; 'plus'}
                plate_face = psPlateZPlus;
            case {'negative'; 'neg'; '-'; 'minus'}
                plate_face = psPlateZMinus;
        end
        iErr = calllib('St7API','St7SetPlateFaceConvection2',uID,self.plateID(ii),...
            LDcase,plate_face,[self.conv_coeff(ii) self.conv_ambient]);
        HandleError(iErr);

        iErr = calllib('St7API','St7SetPlateFaceRadiation2',uID,self.plateID(ii),...
            LDcase,plate_face,[self.rad_coeff(ii) self.rad_ambient]);
        HandleError(iErr);
    end
end
end

