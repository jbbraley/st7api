function [dat] = getSDData(self,uID)
%% getBeamPropertyData
% 
% get beam property data and return sorted structures
% 
% inputs:
%
% uID
% propNum   - beam property number
%

% Handle zero entry
if nargin<2; uID = 1; end

% Preallocate output variables
springData = zeros(1,7);

% Beam Strand7 property identifier
propNum = self.propNum;

% Retrieve section data from strand7 model (FIRST propNum)
[iErr, springData]  = calllib('St7API','St7GetSpringDamperData',uID,propNum(1),...
    springData);
HandleError(iErr)

%% Populate section structure with data
dat.ka = springData(1);    % axial stiffness
dat.kl = springData(2);      % lateral stiffness
dat.kt = springData(3);      % torsional stiffness
dat.ca = springData(4);      % axial damping coefficient
dat.cl = springData(5);      % lateral damping
dat.ct = springData(6);      % torsional damping
dat.m  = springData(7);      % element mass

end
