%% SetModelProp Function
% to be used with apish.m
% jbb
% model - cell array of propmeter objects

function setModelProp(uID,model)
%% Get porperty names for material and section classes for future string comparison
info_m = ?material;
matprop = {info_m.PropertyList.Name};
info_s = ?section;
sxnprop = {info_s.PropertyList.Name};

%initialize checks
platemat = 0;

%% Make changes to St7 Model
for ii = 1:length(model)
    if isa(model,'cell')
        Para = model{ii};
    else
        Para = model(ii);
    end
    prop = Para.obj;
    % Operate on st7 plate elements
    if isa(prop,'plate')
        % Alter plate material
        if any(strcmp(Para.name,matprop))
            % set new material properties
            prop.setPlateMaterial(uID)
        elseif strcmp(Para.name,'offset')
            % set new plate offset
            prop.setPlateOffset(uID)
        elseif any(strcmp(Para.name,{'ambient'; 'conv_coeff'; 'rad_coeff'; 'conv_ambient'; 'rad_ambient'}))
            % set plate heat attributes
            prop.setPlateHeat(uID,1);
        else
            % set new plate thickness
            prop.setPlateThickness(uID)
        end
    end

    % Operate on st7 beam elements
    if isa(prop,'beam')
        if any(strcmp(Para.name,matprop))
            % Alter material property
            % set new material properties 
            prop.setBeamMaterial(uID);
        elseif any(strcmp(Para.name,sxnprop))
            % Alter section property
            % set new section properties 
            prop.setBeamSection(uID)
        end
    end
    
    % Operate on St7 spring-damper elements
    if isa(prop,'spring_damper')
        % set spring damper data
        prop.setSDData(uID)
    end


    % Operate on nodes
    if isa(prop,'node')
        % set node non-structural mass
        if strcmp(Para.name,'Mns')
            prop.setNodeNSMass(uID); 
        end
    end

    % Apply boundary restraints
    if isa(prop,'boundaryNode')
        if ~exist('nodes','var')
            nodes = node();         % create instance of node class
            nodes.getUCSinfo(uID);  % get UCS info 
        end
        nodes.setRestraint(uID,prop.nodeid,prop.fcase,prop.restraint);
    end

    % Alter node stiffness
    if isa(prop, 'spring')
        % set node stiffnesses using st7indices
        nodes = node();         % create instance of node class
        nodes.getUCSinfo(uID);  % get UCS info 
        nodes.setNodeK(uID,prop);
    end

    % Operate on st7 connection elements
    if isa(prop,'connection')
        % Change stiffness    
        % set new section properties 
        prop.setConnection(uID)
    end
end
end
