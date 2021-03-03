function data_for_clust = get_data(regionsCopy, regions)
% Formatting data for clusterization:
% "data_for_clust" is a matrix of dynamics from all given regions
    k=1;
    for i=1:size(regions,2)
        data_for_clust(:,k:k+size(regionsCopy{regions(i)},2)-1) = regionsCopy{regions(i)};
        k = k + size(regionsCopy{regions(i)},2);
    end
end