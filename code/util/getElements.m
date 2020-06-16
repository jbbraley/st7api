function getElements(uID,elementObj,propNum)
%% get coordinate info in plane
%
% 1. gets total elements in model
% 2. loops all elements, retains if matching propNum if supplied 
% 3. returns list of element ids
%
% outputs:
% 		EltIDs = array of element ID numbers 

if nargin<3; propNum = elementObj.propNum; end

elementType = class(elementObj);
fprintf(['\t Getting ' elementType ' numbers... ']); 
    
global tyBRICK tyPLATE tyBEAM tyNODE

switch elementType
    case 'brick'
        type = tyBRICK;
    case 'plate'
        type = tyPLATE;
    case 'beam'
        type = tyBEAM;
    case 'node'
        type = tyNODE;
end

% get total elements in model
[iErr, nElts] = calllib('St7API','St7GetTotal', uID, type, 0);
HandleError(iErr);

% retain only those with matching property number
if ~isempty(propNum) && ~strcmp(elementType,'node')
    EltIDs = [];
    for ii = 1:nElts
        % pull property of each brick
        [iErr, EltPropNum] = calllib('St7API','St7GetElementProperty', uID, type, ii,0);
        HandleError(iErr);
        if any(EltPropNum==propNum)
            EltIDs = cat(2,EltIDs, ii);
        end
    end
else
    EltIDs = 1:nElts;
end

elementObj.id = EltIDs';
% update UI
fprintf('Done. \n');     
end