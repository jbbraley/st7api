classdef brick < material & st7prop
%% classdef brick
% 
% 
% 
% author: John Braley
% create date: 12-Jun-2020 12:24:25
% classy version: 0.1.2

%% object properties
	properties
        offset % vertical offset in inches
        propNum % St7 property number
        id % St7 element ID
        propName % St7 property name
        face % st7 face number to which attributes should be obtained or applied
        conv_coeff % for heat analyses
        rad_coeff % for heat analyses
        conv_ambient % temperature for heat analyses
        rad_ambient
        heat_type % 'radiation', 'convection' or both
	end

%% dependent properties
	properties (Dependent)
	end

%% private properties
	properties (Access = private)
	end

%% constructor
	methods
		function self = brick()
		end
	end

%% ordinary methods
	methods 
	end % /ordinary

%% dependent methods
	methods 
	end % /dependent

%% static methods
	methods (Static)
	end % /static

%% protected methods
	methods (Access = protected)
	end % /protected

end
