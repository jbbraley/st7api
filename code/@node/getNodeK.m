function [Kt,Kr] = getNodeK(self,uID,springs)
%% getNodeK 
%
% NOT WORKING
% 
% gets the rotational stiffness acting at the specified node
% 
% nodes:
%   strand7 node index
%
% casenum:
%   load case number
%
% USCid: 
%   The ID number for the specified UCS
%
% Kt:
%   A 3 element array describing the translational stiffnesses for the specified
%   node.  Doubles[i-1] describes the stiffness for the i th translational DoF
%   according to the 123 axis definition in the specified UCS.
%
% Kr:
%   A 3 element array describing the rotational stiffnesses for the specified node.
%   Doubles[i-1] describes the stiffness for the i th rotational DoF according to
%   the 456 axis definition in the specified UCS.
%   
% 
% author: john devitis
% create date: 12-Aug-2016 15:29:10

    Kt = zeros(length(springs.nodeid),3);
    Kr = zeros(length(springs.nodeid),3);

    for ii = 1:length(springs.nodeid)   
        
        % get translation spring stiffnesses
        [iErr,ucsid,kt] = calllib('St7API','St7GetNodeKTranslation3F',uID,...
            springs.nodeid(ii),springs.Kfc,self.ucsid, [0 0 0]);
        % check for empty sping values
        %  (this happens when there's no discrete spring at the node)
        if iErr == 10
            % no springs there
            Kt(ii,:) = [0 0 0];
        else
            Kt(ii,:) = kt;
        end
        
        % get rotation spring stiffnesses
        [iErr,ucsid,kr] = calllib('St7API','St7GetNodeKRotation3F',uID,...
            springs.nodeid(ii),springs.Kfc,self.ucsid, [1 1 1]);
        % check for empty sping values
        %  (this happens when there's no discrete spring at the node)
        if iErr == 10
            % no springs there
            Kr(ii,:) = [0 0 0];
        else
            Kr(ii,:) = kr;
        end
    end
end
