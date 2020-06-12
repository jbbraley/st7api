function setPlateHeat(self,uID,LDcase)
%SETPLATEHEAT Summary of this function goes here
%   Detailed explanation goes here
global psPlateZPlus
% Assign heat parameters 
        for ii = 1:length(self.plateID)
            iErr = calllib('St7API','St7SetPlateFaceConvection2',uID,self.inputid(ii),...
                LDcase,psPlateZPlus,[self.conv_coeff(ii) self.ambient]);
            HandleError(iErr);
            
            iErr = calllib('St7API','St7SetPlateFaceRadiation2',uID,self.inputid(ii),...
                LDcase,psPlateZPlus,[self.rad_coeff(ii) self.ambient]);
            HandleError(iErr);
        end
end

