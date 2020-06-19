classdef plate < material & st7prop
%% classdef plate
% 
% 
% 
% author: 
% create date: 15-Aug-2016 18:57:07

%% object properties
	properties
        t % thickness
        plane   % string describing the resident plane (e.g. 'XY')
        layer   % elevation coordinate of plate
        side % 'positive' or 'negative' sides of plate to apply or obtain attributes

	end

%% dependent properties
	properties (Dependent)
	end

%% private properties
	properties (Access = private)
	end

%% dynamic methods
	methods
	%% constructor
		function self = plate()
		end

	%% dependent methods

	end

%% static methods
	methods (Static)
        
	end

%% protected methods
	methods (Access = protected)
	end

end
