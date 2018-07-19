classdef NFA < file
%% classdef NFA
% 
% 
% 
% author: john devitis
% create date: 15-Aug-2016 18:58:33

%% object properties
	properties
        nmodes
        run
        U % mode shape array of size [nNodes x 6 DOF x nModes]
        freq % undamped natural freqs [hz]
        modal % st7 modal results
        nodeid % strand7 node index (where results are pulled)
        NSMcase % load cases for which nonstructural mass is to be enabled
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
		function self = NFA()
            self.ext = '.NFA';
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
