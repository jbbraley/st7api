classdef connection < st7prop
%% classdef beam
% 
% axial stiffness of elelements is assumed to be the 3rd dimension of
% translational stiffness and is set by default to 1e12 to restrict any
% axial deformation
% 
% author: john braley
% create date: 15-Aug-2016 18:23:09

%% object properties
	properties
        propNum % St7 property number
        beamID % St7 element ID
        propName % St7 property name
        Xstif
        Ystif
        Zstif
        Rstiffness % rotational stiffness. 3 element array: 4,5,6 element axes
	end

%% dependent properties
	properties (Dependent)
        Tstiffness
	end

%% private properties
	properties (Access = private)
	end

%% dynamic methods
	methods
	%% constructor
		function self = connection()
		end

	%% dependent methods
    function Tstiffness = get.Tstiffness(self)
        Tstiffness = cat(2, self.Xstif, self.Ystif, self.Zstif);
    end

	end

%% static methods
	methods (Static)
	end

%% protected methods
	methods (Access = protected)
	end

end
