function getBricks(self,uID,propNum)
%% get coordinate info in plane
%
% 1. gets total bricks in model
% 4. loops all bricks, indexes propNum if supplied 
% 6. returns list of brick ids
%
% outputs:
% 		idS = array of brick ID numbers stored to self.ids
if nargin<2; uID = 1; end
if nargin<3; propNum = []; end

type = class(self);
self.id = getElements(uID,type,propNum);
    
end