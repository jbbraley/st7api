classdef parameter < handle
%% classdef parameter
% 
% 
% 
% author: John Braley
% create date: 26-Oct-2016 14:36:55

%% object properties
	properties
        name % name of parameter
        uba % upper bound alpha value for optimization
        lba % lower bound alpha value for optimization
        base % base value to which alpha value is applied
        starta % starting alpha value for optimization
        obj % instance of class containing all model info for parameter
        scale % string, 'lin' or 'log'
        value % the intended value for the parameter
	end

%% dependent properties
	properties (Dependent)
        ub % upper bound of parameter
        lb % lower bound of parameter
	end

%% private properties
	properties (Access = private)
	end

%% dynamic methods
	methods
	%% constructor
		function self = parameter()
		end

	%% dependent methods
    % make a clone of instance
    function new = clone(self)
        new = feval(class(self));

        p = properties(self);
        info = metaclass(self);

        for ii = 1:length(p)
            if ~info.PropertyList(ii).Dependent
                new.(p{ii}) = self.(p{ii});
            end
        end
    end
        
    function ub = get.ub(self)
        if isempty(self.scale) || strcmp(self.scale,'lin')
            ub = self.uba*self.base;
        elseif strcmp(self.scale,'log')
            ub = self.base*10^self.uba;
        end
    end
    function lb = get.lb(self)
        if isempty(self.scale) || strcmp(self.scale,'lin')
            lb = self.lba*self.base;
        elseif strcmp(self.scale,'log')
            lb = self.base*10^self.lba;
        end
    end
    function set.lb(self,value)
        if isempty(self.scale) || strcmp(self.scale,'lin')
            self.lba = value/self.base;
        elseif strcmp(self.scale,'log')
            self.lba = log10(value/self.base);
        end
    end
    function set.ub(self,value)
        if isempty(self.scale) || strcmp(self.scale,'lin')
            self.uba = value/self.base;
        elseif strcmp(self.scale,'log')
            self.uba = log10(value/self.base);
        end
    end

	end

%% static methods
	methods (Static)
	end

%% protected methods
	methods (Access = protected)
	end

end
