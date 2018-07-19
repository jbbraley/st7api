classdef spring_damper < st7prop
%% classdef spring-damper
% 
% 
% 
% author: John Braley
% create date: 2018-07-12 12:58:38.264
% classy version: 0.1.2

%% object properties
	properties
        propNum % St7 property number
        springID % St7 element ID
        propName % St7 property name 
        ka      % axial stiffness
        kl      % lateral stiffness
        kt      % torsional stiffness
        ca      % axial damping coefficient
        cl      % lateral damping
        ct      % torsional damping
        m       % element mass
	end

%% dependent properties
	properties (Dependent)
	end

%% private properties
	properties (Access = private)
	end

%% constructor
	methods
		function self = spring_damper()
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
