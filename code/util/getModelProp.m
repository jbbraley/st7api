function getModelProp(uID,model)
%% getModelProp
% 
% Pulls propmeter properties from model and populates propmeter object
% 
% model - cell array of propmeter objects
% author: John Braley
% create date: 09-Nov-2016 10:43:28
%% Get porperty names for material and section classes for future string comparison
info_m = ?material;
matprop = {info_m.PropertyList.Name};
info_s = ?section;
sxnprop = {info_s.PropertyList.Name};

%% Pull properties from St7 Model
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
            % call get plate material fcn
            mat = prop.getPlateMaterial(uID);
            %populate empty material property fields
            prop = fillempty(prop, mat);
        elseif any(strcmp(Para.name,{'ambient'; 'heat'; 'conv_coeff'; 'rad_coeff'; 'conv_ambient'; 'rad_ambient'}))
            % get plate heat attributes
            heat = prop.getPlateHeat(uID,1,prop.side,prop.heat_type);
            % populate empty heat fields
            prop = fillempty(prop, heat);
        else
            % get plate thickness
            thick = prop.getPlateThickness(uID);
            %populate empty fields
            prop = fillempty(prop, thick);
        end
    end
% Operate on st7 brick elements
    if isa(prop,'brick')
        if any(strcmp(Para.name,{'ambient'; 'heat'; 'conv_coeff'; 'rad_coeff'; 'conv_ambient'; 'rad_ambient'}))
            % get brick heat attributes
            heat = prop.getBrickHeat(uID,1,prop.face,prop.heat_type);
            % populate empty heat fields
            prop = fillempty(prop, heat);
        % Alter brick material
%         elseif any(strcmp(Para.name,matprop))
%             % call get brick material fcn
%             mat = prop.getBrickMaterial(uID);
%             %populate empty material property fields
%             prop = fillempty(prop, mat);
       end
    end
    % Operate on st7 beam elements
    if isa(prop,'beam')
        % Alter material property
        if any(strcmp(Para.name,matprop))
            % call get material fcn
            mat = prop.getBeamMaterial(uID);
            % Populate empty material property fields
            prop = fillempty(prop, mat);
        elseif any(strcmp(Para.name,sxnprop))
            % Alter section property
            % call get section fcn
            sxn = prop.getBeamSection(uID);
            % Populate empty section property fields
            prop = fillempty(prop, sxn);
        end
    end
    
    % Operate on St7 spring-damper elements
    % check for sections structure
    if isa(prop,'spring_damper')
        % get spring damper data
        vals = prop.getSDData(uID);
        % populate empty spring property data
        prop = fillempty(prop, vals);
    end

    % Operate on nodes
    if isa(prop,'node')
        % get node non-structural mass
        if strcmp(Para.name,'Mns')
            nsm = prop.getNodeNSMass(uID); 
            prop.Mns = nsm(1);
        end
    end

%     % Apply boundary restraints
%     if isa(prop,'boundaryNode')
%         if ~exist('nodes','var')
%             nodes = node();         % create instance of node class
%             nodes.getUCSinfo(uID);  % get UCS info 
%         end
%         nodes.setRestraint(uID,prop.nodeid,prop.fcase,prop.restraint);
%     end

    % Operate on node stiffness
    if isa(prop, 'spring')
        % set node stiffnesses using st7indices
        if ~exist('nodes','var')
            nodes = node();         % create instance of node class
            nodes.getUCSinfo(uID);  % get UCS info 
        end
        % get node stiffness
        [Kt,Kr] = nodes.getNodeK(uID,prop);
        % parse stiffness values for direction
        if size(unique(Kt,'rows'),1)==1
            springs.KtX = Kt(1,1);
            springs.KtY = Kt(1,2);
            springs.KtZ = Kt(1,3);
        end
        if size(unique(Kr,'rows'),1)==1
            springs.KrX = Kr(1,1);
            springs.KrY = Kr(1,2);
            springs.KrZ = Kr(1,3);
        end
        % Populate empty stiffness fields
        prop = fillempty(prop, springs);
        
    end

    % Operate on st7 connection elements
    if isa(prop,'connection')
        % Change stiffness    
        % call get connection fcn
        vals = prop.getConnection(uID);
        % Populate empty section property fields
        prop = fillempty(prop, vals);
    end
end
	
fprintf('Done. \n');
	
end
