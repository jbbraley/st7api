function setSDData(self, uID)
%% setBeamProperty
% 
% 
% 
% author: John Braley
% create date: 08-Sep-2016 14:08:07
	
% Handle zero entry
if nargin<2; uID = 1; end

%% Populate Section Data vector
springData = [self.ka... % axial stiffness
    self.kl... % lateral stiffness
    self.kt... % torsional stiffness
    self.ca... % axial damping coefficient
    self.cl... % lateral damping
    self.ct... % torsional damping
    self.m]; % element mass
	

% Beam Strand7 property identifier
propNum = self.propNum;

for ii = 1:length(propNum)
% set material data for Strand7 beam property
iErr = calllib('St7API','St7SetSpringDamperData',uID,propNum(ii),...
    springData);
HandleError(iErr)
end
	
end
