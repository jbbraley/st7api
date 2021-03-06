function sensitivity(uID,model)
%% sensitivity
% 
% populate - boolean: 1 - fill empty model parameter values; 0 - field
% already populated
% 
% author: John Braley
% create date: 15-Nov-2016 16:02:49

if ~isfield(model, 'options') || ~isfield(model.options,'populate'); 
    populate = 1; else; populate = model.options.populate; end

    if populate
        getModelProp(uID,model.params);
    end

    if isfield(model,'params')
        % Set new model properties
        setModelProp(uID,model.params)
    end
    if isfield(model,'solvers')
        % run solvers
        solver(uID,model.solvers)
    end
	
	
	
end
