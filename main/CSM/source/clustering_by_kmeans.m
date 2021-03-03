function idx = clustering_by_kmeans (data_for_clust, optimal, replicates)
% Set options for kmeans in MATLAB
    % opts = statset('Display','final');
    % opts = statset('Display','off');
    opts = statset('Display','off','UseParallel', true); %final
%     tic
%     [idx, CLAST, SUMD] = kmeans(data_for_clust', optimal, 'Distance', 'correlation', 'Replicates', replicates,'Options',opts);
    idx = kmeans(data_for_clust', optimal, 'Distance', 'correlation', 'Replicates', replicates,'Options',opts);
%     toc
end