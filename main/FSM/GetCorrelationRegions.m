%%% GetCorrelationRegions
%% Load_data
% disp('Loading data and parameters...');

addpath('source');

PATH_TO_4D_NII = 'D:\Lab\Rest\Data\Fedorova_A_A\filtered_func_data_smooth.nii';
PATH_TO_MASK = 'D:\result_full_mask.nii';

[all_data, mask] = LoadData(PATH_TO_4D_NII, PATH_TO_MASK);


%% Remove autocorrelation from data
% disp('Removing autocorrelation from data...');

all_data = RemoveAutocorrelation(all_data, mask);


%% Parameters 

MIN_REG_SIZE = 10;
CORR_CUTOFF = 0.85; % Cutoff

%% Functions
% disp('Finding new regions...'); 

allCorrelationRegions = GetCorrelationRegionsForAllVoxels(...
    all_data, mask, CORR_CUTOFF);
newMap = GetMaximumRegionsFromAllCorrelationRegions(...
    all_data, allCorrelationRegions, mask, MIN_REG_SIZE);


%% Plot result
% disp('Complete, plotting result');
% plot_map(newMap)

%% Save result as .mat map
% disp('Complete, saving result');
% save('newMap.mat', newMap);

%% Complete
% disp('Complete');
