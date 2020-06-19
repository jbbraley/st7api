classdef st7table < handle
%% classdef st7table
% 
% 
% 
% author: John Braley
% create date: 19-Jun-2020 12:38:59
% classy version: 0.1.2

%% object properties
	properties
        type % dependent variable: "time", 'temp', 'freq', stressstrain', 'forcedisp', 'momcurv'
        id
        name
        data_mat % nx2 matrix containing table data
	end

%% dependent properties
	properties (Dependent)
        data_array % array containing data pairs as required for api input
        num_rows
	end

%% private properties
	properties (Access = private)
	end

%% constructor
	methods
		function self = st7table()
		end
	end

%% ordinary methods
	methods 
	end % /ordinary

%% dependent methods
	methods 
        function data_array = get.data_array(self)
            data_array = reshape(self.data_mat',1,[]);
        end
        function set.data_array(self,dat)
            self.data_mat = reshape(dat,2,[])';
        end
        function num_rows = get.num_rows(self)
            num_rows = size(self.data_mat,1);
        end
	end % /dependent

%% static methods
	methods (Static)
	end % /static

%% protected methods
	methods (Access = protected)
	end % /protected

end
