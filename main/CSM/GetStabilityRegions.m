%%% GetStabilityRegions
%% Load_data
% disp('Loading data and parameters...');

PATH_TO_4D_DATA = 'path\to\4d\data.nii';
PATH_TO_MASK = 'path\to\mask.nii';

[all_data, map] = LoadData(PATH_TO_4D_DATA, PATH_TO_MAP);


%% Parameters

WINDOW = 200;
STEP = 100;
NOT_IN_REG_COUNT = 0.2;
MIN_REG_SIZE = 10;


%% Remove autocorrelation from data
% disp('Removing autocorrelation from data...');

all_data = RemoveAutocorrelation(all_data, map);


%% Functions
% disp('Finding new regions...'); 

regs_in_map = GetRegionsInMap(all_data, map, WINDOW, STEP, NOT_IN_REG_COUNT);
newMap = TakeCores(regs_in_map, map);

%% Plot result
% disp('Complete, plotting result');
% plot_map(newMap)

%% Save result as .mat map
% disp('Complete, saving result');
% save('newMap.mat', newMap);

%% Complete
% disp('Complete');


