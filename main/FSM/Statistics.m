%%% FormStatisticsForCorrelationRegions
%% Load_data
% disp('Loading data and parameters...');

addpath('source');

PATH_TO_4D_NII = 'path\to\4d\data.nii';
PATH_TO_MASK = 'path\to\mask.nii';
PATH_TO_STATISTICS_FOLDER = '.\statistics\';

mkdir(PATH_TO_STATISTICS_FOLDER);
[all_data, mask] = LoadData(PATH_TO_4D_NII, PATH_TO_MASK);


%% Remove autocorrelation from data
% disp('Removing autocorrelation from data...');

all_data = RemoveAutocorrelation(all_data, mask);


%% Parameters 

MIN_REG_SIZE = 10;
CORR_CUTOFF_RANGE = 0.4:0.01:0.9; % Cutoff

%% Functions
% disp('Finding new regions...'); 

allCorrelationRegions = GetCorrelationRegionsForAllVoxels(...
    all_data, mask, CORR_CUTOFF);
newMap = GetMaximumRegionsFromAllCorrelationRegions(...
    all_data, allCorrelationRegions, mask, MIN_REG_SIZE);

tmp_mask = mask;
for CORR_CUTOFF = CORR_CUTOFF_RANGE
    disp(CORR_CUTOFF);
    newMap = zeros(size(mask));
    allCorrelationRegionsResult = GetCorrelationRegionsForAllVoxels(...
        all_data, tmp_mask, CORR_CUTOFF);
    newMap_tmp = GetMaximumRegionsFromAllCorrelationRegions(... 
        all_data, allCorrelationRegions, tmp_mask, MIN_REG_SIZE);
    allCorrelationRegions = allCorrelationRegionsResult;
    while (size(find(newMap_tmp > 0,1),1) > 0)
        newMap = newMap + (newMap_tmp+max(newMap(:))).*logical(newMap_tmp);
        tmp_mask(newMap_tmp > 0) = 0;
        allCorrelationRegions = GetCorrelationRegionsForAllVoxels(...
            all_data, tmp_mask, CORR_CUTOFF);
        newMap_tmp = GetMaximumRegionsFromAllCorrelationRegions(...
            all_data, allCorrelationRegions, tmp_mask, MIN_REG_SIZE);
    end
    save([PATH_TO_STATISTICS_FOLDER 'RESULT_CORR_CUTOFF_' num2str(metricCutoff, '%0.2f') '.mat'], 'allCorrelationRegionsResult', 'newMap', 'CORR_CUTOFF');
end


%% Get Statistics
files = dir(PATH_TO_STATISTICS_FOLDER);
files = {files(3:end).name};
for i=1:size(files,2)
    load(files{i});
    correlation_data = [];
    correlation_data_min = [];
    correlation_with_center = [];
    correlation_with_mean = [];
    n = [];
    for j=1:max(newMap(:))
        data_for_corr = [];
        coords = find(newMap==j);
        n(j) = size(coords,1);
        for k = 1:n(j)
            [x,y,z] = ind2sub(size(newMap),coords(k));
            data_for_corr(:,k) = all_data{x,y,z}(:);
        end
        C = corrcoef(data_for_corr);
        correlation_data_min(end+1) = min(C(:));
        for k = 1:(size(C,1)-1)
            for q = (k+1):(size(C,1))
                correlation_data(end+1) = C(k,q);
            end
        end
        [row] = find(min(C)==max(min(C)),1);
        for k = 1:(size(C,1))
            if k==row, continue; end;
            correlation_with_center(end+1) = C(k,row);
        end
        data_for_corr(:,end+1) = mean(data_for_corr, 2);
        C = corrcoef(data_for_corr);
        for k = 1:(size(C,1)-1)
            correlation_with_mean(end+1) = C(k,end);
        end
    end
    n(n==0) = [];
    map_data(i).cluster_amount = size(n,2);
    map_data(i).cluster_mean_size = mean(n);
    map_data(i).cluster_max_size = max(n);
    map_data(i).voxels_amount = size(find(newMap>0),1);
    map_data(i).min_correlation = min(correlation_data);
    map_data(i).min_correlation_mean_by_regions = mean(correlation_data_min);
    map_data(i).mean_correlation = mean(correlation_data);
    map_data(i).mean_correlation_with_center = mean(correlation_with_center);
    map_data(i).mean_correlation_with_mean = mean(correlation_with_mean);
    map_data(i).min_correlation_with_center = min(correlation_with_center);
    map_data(i).min_correlation_with_mean = min(correlation_with_mean);
    map_data(i).map = newMap;
end

% save(['map_data.mat'], 'map_data');

%% Plot Statistics

figure
plot(CORR_CUTOFF_RANGE, [map_data.cluster_amount]);
title('Clusters amount')

figure
plot(CORR_CUTOFF_RANGE, [map_data.voxels_amount]);
title('Voxels amount')

%% Complete
% disp('Complete');
