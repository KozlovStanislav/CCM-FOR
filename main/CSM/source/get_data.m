function data_for_clust = get_data(regionsCopy, regions)
% Формирование данных для кластеризации:
% Формирование матрицы из динамик для всех переданных регионов
    k=1;
    for i=1:size(regions,2)
        data_for_clust(:,k:k+size(regionsCopy{regions(i)},2)-1) = regionsCopy{regions(i)};
        k = k + size(regionsCopy{regions(i)},2);
    end
end