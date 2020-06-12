classdef THA < file
%% classdef THA
% 
% 
% 
% author: 
% create date: 11-Jun-2020 15:02:17
% classy version: 0.1.2

%% object properties
	properties
        run
        outputtype = 'node' % element type from which to pull results ('beam' or 'node')
        outputid % nodeid to return results
        steps % array corresponding to steps in analysis [numsteps time]
        LDcase % load case from which initial temp distribution is obtained
        resp % [outputid x 1] nodal Temp from St7GetNodeResult
	end

%% dependent properties
	properties (Dependent)
	end

%% private properties
	properties (Access = private)
	end

%% constructor
	methods
		function self = THA()
            self.ext = '.THA';
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
