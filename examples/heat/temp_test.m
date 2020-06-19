%% changes specified ambient temperature in FE model
ambient_temp = 29.4;
initial_temp = -8.9;
% load model file
[filename, pathname] = uigetfile('.st7');
localdir = 'C:\Users\John B\Projects_Git';
% add dependencies to path
pname{1} = [localdir '\st7api'];
for ii = 1:length(pname)
    addpath(genpath(pname{ii}));
end

sys = st7model();
sys.pathname = pathname;
sys.filename = filename;
sys.scratchpath = 'C:\Temp';

% api options
APIop = apiOptions();
APIop.keepLoaded = 1;
APIop.keepOpen = 1;

% pull all brick ids
hexa = brick();
hexa.propNum = [1 2];
hexa.face = 1:6;

tetra = brick();
tetra.propNum = 4;
tetra.face = 1:4;

% start logger
logg = logger('Ambient temperature analysis');
% run shell to get all brick numbers
logg.task('Getting brick numbers');
apish(@getElements,sys,hexa,APIop);
apish(@getElements,sys,tetra,APIop);

% get load case defaults
defaults = sys.getLoadCase(1);
% override initial/reference temp
defaults(1) = initial_temp;
sys.setLoadCase(1,defaults)

brick_ambient = parameter();
brick_ambient.obj = hexa;
brick_ambient.name = {'heat'};

haunch_ambient = parameter();
haunch_ambient.obj = tetra;
haunch_ambient.name = {'heat'};

% run shell to get initial property values
logg.task('Getting model props');
apish(@getModelProp,sys,{brick_ambient haunch_ambient},APIop);

% override heat parameter values
hexa.conv_ambient = ambient_temp*(hexa.conv_ambient)/max(max(hexa.conv_ambient,[],1));
hexa.rad_ambient = ambient_temp*(hexa.rad_ambient)/max(max(hexa.rad_ambient,[],1));
tetra.conv_ambient = ambient_temp*(tetra.conv_ambient)/max(max(tetra.conv_ambient,[],1));
tetra.rad_ambient = ambient_temp*(tetra.rad_ambient)/max(max(tetra.rad_ambient,[],1));

% implement changes in model
apish(@setModelProp,sys,{brick_ambient haunch_ambient},APIop);

%% setup tha (transient heat analysis) info
tha = THA();
tha.name = strcat(fullfile(sys.pathname,sys.filename(1:end-4)), ...
        '-','ambient-',num2str(ambient_temp),'.THA');
tha.run = 1;
tha.outputtype = 'node';
% find nodes at section x==0
all_nodes = node();
all_nodes.getNodes(sys.uID);
result_nodes = all_nodes.id(all_nodes.coords(:,1)<=0);
tha.outputid = result_nodes;
% time steps
steps = [20 3; 30 10]; %minutes
tha.steps = steps;
tha.LDcase = 1;


%% run the shell
tic
% Run solver (results saved to tha.resp, nodal temperature results by default for all node numbers in outputid)
apish(@solver,sys,tha,APIop);
toc

%% save as changed model
new_filename = [sys.filename(1:end-4) '_new' '.st7'];
api.saveas(sys.uID,sys.pathname,new_filename);

%% Close Model
api.closeModel(sys.uID)
sys.open=0;

%% Plot temperature distribution for section
tstep = 28;
figure 
scatter(all_nodes.coords(all_nodes.coords(:,1)<=0,2),all_nodes.coords(all_nodes.coords(:,1)<=0,3),10,tha.resp{1}(:,tstep),'filled')
colormap(jet); % or other colormap
colorbar; % color bar