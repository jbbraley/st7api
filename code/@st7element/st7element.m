classdef st7element < st7prop
%% classdef St7element
% 
% 
% 
% author: John Braley
% create date: 19-Jun-2020 12:33:41
% classy version: 0.1.2

%% object properties
	properties
        id % St7 element ID
        offset % vertical offset
        propNum % St7 property number
        propName % St7 property name
        conv_coeff % for heat analyses
        rad_coeff % for heat analyses
        conv_ambient % ambient temperature for heat analyses
        rad_ambient % ambient temperature for heat analyses
        conv_table_id % 1x3 array specifying convection table ids
        rad_table_id % 1x3 array specifying convection table ids
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
		function self = St7element()
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
