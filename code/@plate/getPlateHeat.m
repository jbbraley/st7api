function [heat] = getPlateHeat(self,uID,LCase,side,type)
%% getPlateThickness
% 
% side - 'positive' or 'negative'
% 
% author: John Braley
% create date: 09-Nov-2016 12:44:09
global psPlateZPlus	psPlateZMinus
% Handle zero entry
if nargin<2; uID = 1; end
if nargin<3; LCase = 1; end
if nargin<4 || isempty(side); side = {'positive','negative'}; end
if ~iscell(side); side = {side}; end
if nargin<5 || isempty(type); type = {'convection';'radiation'}; end

if any(strcmp(type,'convection')) || any(strcmp(type,'conv'))
    heat.conv_coeff = zeros(length(self.id),length(side));
    heat.conv_ambient = heat.conv_coeff;
    for jj = 1:length(side)       
        switch side{jj}
        case {'positive'; 'pos'; '+'; 'plus'}
            plate_face = psPlateZPlus;
        case {'negative'; 'neg'; '-'; 'minus'}
            plate_face = psPlateZMinus;
        end

        for ii = 1:length(self.id)
            % Intitialize st7 output
            cresults = zeros(1,2);      
            try
                % get plate convection coefficients
                [iErr, cresults] = calllib('St7API','St7GetPlateFaceConvection2',uID,self.id(ii),LCase,...
                plate_face,cresults);
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
    heat.rad_coeff = zeros(length(self.id),length(side));
    heat.rad_ambient = heat.rad_coeff;
    for jj = 1:length(side)       
        switch side{jj}
        case {'positive'; 'pos'; '+'; 'plus'}
            plate_face = psPlateZPlus;
        case {'negative'; 'neg'; '-'; 'minus'}
            plate_face = psPlateZMinus;
        end
        for ii = 1:length(self.id)
            rresults = zeros(1,2);
            try
                % get plate radiation coefficients
                [iErr, rresults] = calllib('St7API','St7GetPlateFaceRadiation2',uID,self.id(ii),LCase,...
                plate_face,rresults);
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
