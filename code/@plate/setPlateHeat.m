function setPlateHeat(self,uID,LDcase,side)
%SETPLATEHEAT Summary of this function goes here
%   Detailed explanation goes here
global psPlateZPlus	psPlateZMinus
% Handle zero entry
if nargin<2; uID = 1; end
if nargin<3; LDcase = 1; end
if nargin<4 || isempty(side); side = {'positive','negative'}; end
if ~iscell(side); side = {side}; end
if size(self.conv_coeff,1)==1; self.conv_coeff = self.conv_coeff*ones(length(self.id),length(side)); end
if size(self.conv_ambient,1)==1; self.conv_ambient = self.conv_ambient*ones(length(self.id),length(side)); end
if size(self.rad_coeff,1)==1; self.rad_coeff = self.rad_coeff*ones(length(self.id),length(side)); end
if size(self.rad_ambient,1)==1; self.rad_ambient = self.rad_ambient*ones(length(self.id),length(side)); end

% Assign heat parameters 
for ii = 1:length(self.id)
    for jj = 1:length(side)
        switch side{jj}
            case {'positive'; 'pos'; '+'; 'plus'}
                plate_face = psPlateZPlus;
            case {'negative'; 'neg'; '-'; 'minus'}
                plate_face = psPlateZMinus;
        end
        if ~isempty(self.conv_coeff)
            iErr = calllib('St7API','St7SetPlateFaceConvection2',uID,self.id(ii),...
                LDcase,plate_face,[self.conv_coeff(ii,jj) self.conv_ambient(ii,jj)]);
            HandleError(iErr);
        end
        if ~isempty(self.rad_coeff)
            iErr = calllib('St7API','St7SetPlateFaceRadiation2',uID,self.id(ii),...
                LDcase,plate_face,[self.rad_coeff(ii,jj) self.rad_ambient(ii,jj)]);
            HandleError(iErr);
        end
        if ~isempty(self.conv_table_id) || any(self.conv_table_id~=0)
            iErr = calllib('St7API','St7SetPlateFaceConvectionTables',uID,self.id(ii),...
                LDcase,plate_face,self.conv_table_id);
            HandleError(iErr);
        end
        if ~isempty(self.rad_table_id) || any(self.rad_table_id~=0)
            iErr = calllib('St7API','St7SetPlateFaceRadiationTables',uID,self.id(ii),...
                LDcase,plate_face,self.rad_table_id);
            HandleError(iErr);
        end
        
    end
end
end

