%%% GetCorrelationRegions
%% Load_data
% disp('Loading data and parameters...');

PATH_TO_4D_DATA = 'path\to\4d\data.nii';
PATH_TO_MASK = 'path\to\mask.nii';

[all_data, mask] = LoadData(PATH_TO_4D_DATA, PATH_TO_MASK);


%% Parameters 

%% Remove autocorrelation from data
% disp('Removing autocorrelation from data...');

all_data = RemoveAutocorrelation(all_data, mask);


%% Functions
% disp('Finding new regions...'); 

%

%% Plot result
% disp('Complete, plotting result');
% plot_map(newMap)

%% Save result as .mat map
% disp('Complete, saving result');
% save('newMap.mat', newMap);

%% Complete
% disp('Complete');
