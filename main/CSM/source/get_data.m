function data_for_clust = get_data(regionsCopy, regions)
%     N=0;
%     for i=1:size(regions,2)
%         N = N + size(regionsCopy{regions(i)},2);
%     end
%     data_for_clust = zeros(size(regionsCopy{1,1}, 1), N);
%     idx_def(1:N) = 0;
    k=1;
    for i=1:size(regions,2)
        data_for_clust(:,k:k+size(regionsCopy{regions(i)},2)-1) = regionsCopy{regions(i)};
%         idx_def(k:k+size(regionsCopy{regions(i)}.Y,2)-1) = i;
        k = k + size(regionsCopy{regions(i)},2);
    end
end