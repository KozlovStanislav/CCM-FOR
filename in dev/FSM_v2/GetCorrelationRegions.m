%%% GetCorrelationRegions
%% Load_data
% disp('Loading data and parameters...');

PATH_TO_4D_DATA = 'path\to\4d\data.nii';
PATH_TO_MASK = 'path\to\mask.nii';

[all_data, mask] = LoadData(PATH_TO_4D_DATA, PATH_TO_MASK);


%% Parameters 

MIN_REG_SIZE = 10;
CORR_CUTOFF = 0.85;
func = @(x,y)corr(x,y); % Выбор функции, которая сравнивает динамики. Обязана принимать 2 ряда, отдавать 1 число.
MoreOrLess = '>'; % Возможность поменять сторону, по которой считается близость. 
                      % '>' - больше отсечки = попадают в один регион, '<' - меньше отсечки

%% Remove autocorrelation from data
% disp('Removing autocorrelation from data...');

all_data = RemoveAutocorrelation(all_data, mask);


%% Functions
% disp('Finding new regions...'); 

[~, newMap, ~] = GetCorrelationRegions_v2(...
    all_data, mask, CORR_CUTOFF, MIN_REG_SIZE, @(x,y)corr(x,y), MoreOrLess);


%% Plot result
% disp('Complete, plotting result');
% plot_map(newMap)

%% Save result as .mat map
% disp('Complete, saving result');
% save('newMap.mat', newMap);

%% Complete
% disp('Complete');
