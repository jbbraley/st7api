%% Update grid1.st7 model using natural frequency data
%
%
%           jbb - 10242016
%% Parameters to be updated:
% ca - composite action connection element stiffness [1e4 - 1e12] 
% dE - deck stiffness (E) fc = [1500 10000] -> E = [2.2e6 5.7e6] 
% gI - girder Ix (I11) - [.8X 1.5X]
% NSM - nodal mass at deck edges (to simulate barrier) - [0 1500]
% boundary conditions (rotational stiffness) - 
% dia - Diaphragm stiffness (E) - [0.5X - 2X]


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

%% Composite Action
% Alter section property of composite action connection element
ca = connection(); % create instance of connection class
ca.propNum = 3; % Identify beam property number
% Create stiffness range
steps = 12;
stif = logspace(3,15,steps)';

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