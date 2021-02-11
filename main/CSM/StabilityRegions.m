%%% StabilityRegions
%% Load_data
% disp('Loading data and parameters...');

addpath('source');

PATH_TO_4D_NII = 'D:\Lab\Rest\Data\Fedorova_A_A\filtered_func_data_smooth.nii';
PATH_TO_MASK = 'D:\result_full_mask.nii';

[all_data, map] = LoadData(PATH_TO_4D_NII, PATH_TO_MASK);


%% Remove autocorrelation from data
% disp('Removing autocorrelation from data...');

all_data = RemoveAutocorrelation(all_data, map);


%% Parameters

WINDOW = 198;
STEP = 100;
NOT_IN_REG_COUNT = round(0.2*((1000-WINDOW)/STEP+1)); % срого меньше  not_in_reg_count
MIN_REG_SIZE = 10;


%% Functions
% disp('Finding new regions...'); 

regs_in_map = GetStabilityRegions(all_data, map, WINDOW, STEP, NOT_IN_REG_COUNT);
newMap = TakeCores(regs_in_map, map);

%% Plot result
% disp('Complete, plotting result');
% plot_map(newMap)

%% Save result as .mat map
% disp('Complete, saving result');
% save('newMap.mat', newMap);

%% Complete
% disp('Complete');


