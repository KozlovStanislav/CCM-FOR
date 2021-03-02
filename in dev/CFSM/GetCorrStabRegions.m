%%% GetCorrelationRegions
%% Load_data
% disp('Loading data and parameters...');

PATH_TO_4D_DATA = 'path\to\4d\data.nii';
PATH_TO_MASK = 'path\to\mask.nii';

[all_data, mask] = LoadData(PATH_TO_4D_DATA, PATH_TO_MASK);


%% Parameters 

CORR_CUTOFF = 0.85;
WINDOW = 200;
STEP = 100;
NOT_IN_REG_PERCENT = 0.2;
MIN_REG_SIZE = 10;

%% Remove autocorrelation from data
% disp('Removing autocorrelation from data...');

all_data = RemoveAutocorrelation(all_data, mask);


%% Functions
% disp('Finding new regions...'); 

maps = GetCorrelationRegionsInWindows(all_data, mask, CORR_CUTOFF, WINDOW, STEP, MIN_REG_SIZE);
newMap = GetStabilityRegionsFromMaps(maps, mask, WINDOW, STEP, NOT_IN_REG_PERCENT, MIN_REG_SIZE);

%% Plot result
% disp('Complete, plotting result');
% plot_map(newMap)

%% Save result as .mat map
% disp('Complete, saving result');
% save('newMap.mat', newMap);

%% Complete
% disp('Complete');
