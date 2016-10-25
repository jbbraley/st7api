%% Sensitivity study on grid1.st7 of composite action
% connection element stiffness to be altered
%
%           jbb - 10242016

%% setup st7 file info
sys = st7model();
sys.pathname = 'C:\Users\John\Projects_Git\st7api\models';
sys.filename = 'grid1.st7';
sys.scratchpath = 'C:\Temp';

%% setup nfa info
nfa = NFA();
nfa.name = fullfile(sys.pathname,[sys.filename(1:end-4) '.NFA']);
nfa.nmodes = 5; % set number of modes to compute
nfa.run = 1;

%% Run Sensitivity studies on parameters.


%% setup node restraints
bc = boundaryNode();
bc.nodeid = [7 8 9 855 856 857];
bc.restraint = zeros(length(bc.nodeid),6); % no restraints
bc.restraint(1,1:3) = 1; % pinned
bc.restraint(11,2:3) = 1; % roller (x kept released)
bc.fcase = ones(size(bc.nodeid));

% build model array
for ii = 1:steps
    % the class st7model is not a handle subclass. it is just a value
    % class, like a hard-coded structure. because of this we can create
    % copies of it
    grid(ii).sys = sys;
    
    % create new instance of nfa class
    % * this is because nfa subclasses the handle class. handles are 
    % persistent. if you create a copy and change it, the original changes 
    % too. we we need to create a new instance. 
    grid(ii).nfa = NFA();
    grid(ii).nfa.name = strcat(fullfile(sys.pathname,sys.filename(1:end-4)), ...
        '_step',num2str(ii),'.NFA');
    grid(ii).nfa.nmodes = 10;
    grid(ii).nfa.run = 1;
    
    % Beam properties
    % Create new instance of beam class
    % Instance labeled as materials for functionality
    grid(ii).comp = ca;
    grid(ii).comp.Tstiffness = [stif(ii) stif(ii) 1e9];
    
end

%% run the shell
tic

results = apish(@main,grid);

toc
% plot frequency vs. connection element stiffness
field = 'Tstiffness';
plotCompVsFreq(results,field);