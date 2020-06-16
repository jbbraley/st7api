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
apish(@getModelProp,sys,brick_ambient,APIop);

% override heat parameter values
hexa.conv_ambient = ambient_temp*ones(size(hexa.conv_ambient));
hexa.rad_ambient = ambient_temp*ones(size(hexa.rad_ambient));


%% setup tha (transient heat analysis) info
steps = [];
result_nodes = [];

for ii = 1:length(ambient_temp)
    tha = THA();
    tha.name = strcat(fullfile(sys.pathname,sys.filename(1:end-4)), ...
            '-', num2str(EI_fact(jj)),'ambient',num2str(ambient_temp(ii)),'.tha');
    tha.run = 1;
    tha.outputtype = 'node';
    tha.outputid = result_nodes;
    tha.steps = steps;
    tha.LDcase = 1;
    
    % Apply Plate attributes
    % Create new instance of parameter class
    Para = parameter();
    Para.obj = plate_ambient.obj.clone; % create clone of previously defined beam class
    Para.obj.conv_ambient = ambient_temp(ii); % overwrite with step value
    Para.obj.rad_ambient = ambient_temp(ii);
    Para.name = 'heat'; % must correspond to the property being altered
    
    % Apply Brick attributes
    % Create new instance of parameter class
    BPara = parameter();
    BPara.obj = brick_ambient.obj.clone; % create clone of previously defined beam class
    BPara.obj.conv_ambient = ambient_temp(ii); % overwrite with step value
    BPara.obj.rad_ambient = ambient_temp(ii);
    BPara.name = 'heat'; % must correspond to the property being altered
    
    % add sensitivity info to "model" structure
    model(ii).params = {Para BPara};
    model(ii).solvers = tha;
    model(ii).options.populate = 0; % don't repopulate st7 property values
    
    logg.done();
end


%% run the shell
APIop.keepOpen = 1;

tic
% Run sensitivity shell
apish(@sensitivity,sys,model,APIop);
toc

% save last step model
new_filename = [sys.filename(1:end-4) '_step' num2str(ii) '.st7'];
api.saveas(sys.uID,sys.pathname,new_filename);

%% Close Model
api.closeModel(sys.uID)
sys.open=0;