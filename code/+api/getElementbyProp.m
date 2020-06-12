function element_nums = getElementbyProp(uID,type,prop_num)
%% getTotalNodes
% 
% returns the total nodes found in uID
% 
% author: john devitis
% create date: 16-Aug-2016 13:40:50
global tyPLATE tyBEAM tyBRICK
switch type
    case 'plate'
        entity = tyPLATE;
    case 'beam'
        entity = tyBEAM;
    case 'brick'
        entity = tyBRICK;
end
	
[iErr,nelem] = calllib('St7API','St7GetTotal',uID,entity,0);
HandleError(iErr);

element_nums = [];
for ii = 1:nelem
    [iErr, elem_prop] = calllib('St7API','St7GetElementProperty',uID, entity, ii, 1);
    HandleError(iErr);
    if elem_prop == prop_num
        element_nums = [element_nums ii];
    end
end
