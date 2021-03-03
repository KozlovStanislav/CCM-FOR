function idx_reg = GetRegionsInMap(all_data, map, WINDOW, STEP, NOT_IN_REG_COUNT)
% Calculate stable in time regions by the k-means method by runnig for each
% anatomical region. Each run uses all neighboring regions to find stable 
% regions in a given region. The result is a variable that provides a new 
% numeration for each anatomical region - stable regions in anatomical 
% regions

    % Recalculate the percentage into number of time windows
    NOT_IN_REG_COUNT = round(NOT_IN_REG_COUNT*floor((size(all_data{1,1},1)-WINDOW)/STEP+1));
    
    idx_reg = cell(1, max(map(:)));
    
    for q=1:max(map(:)) % Sizes of all regions
        reg_size(q) = size(find(map==q), 1);
    end

    k=1;
    for i=1:STEP:size(all_data{1,1},1)+1-WINDOW % Breakdown of source data into time windows
        for j=1:size(all_data,2)
            all_data_windowed{k}{j} = detrend(all_data{j}(i:i+WINDOW-1 ,:));
        end
        k=k+1;
    end
    
    
    for q=1:max(map(:)) % Main loop through all anatomical regions
        neig = find_neighbors(map, q); % Finding Neighboring Regions
        opt = round(size(neig,2)/1.5); % "Adaptive" "K" for k-means method
        
        disp(['Region in work=' num2str(q) ', optimal=' num2str(opt)]);

        clear idx
        for i=1:size(all_data_windowed,2) % Main function for calculating the FHR in different time windows
%             disp(['i=' num2str(i) '/' num2str(size(all_data_windowed,2))]);
            idx(:, i) = clustering_by_kmeans(get_data(all_data_windowed{i}, neig), opt, 100);
        end

        t=1; % Find identical rows (voxels defined in one region each time)
        idx_sum = zeros(size(idx,1),1); % New variable - numeration in one anatomical region
        for i = 1:size(idx,1) 
            if (idx_sum(i)~=0) 
                continue; % If the row of this voxel was already equal to someone - skip
            end
            for j = i:size(idx,1) % Compare rows starting from the current one
    %             if (all(idx(j, :)==idx(i,:))) % if it completely matches
    %                 idx_sum(j)=t; % We assign a new region number
    %             end
                if (sum(idx(j, :)~=idx(i,:))<=NOT_IN_REG_COUNT) % if it matches, but not completely
                    idx_sum(j)=t; % We assign a new region number
                end
            end
            t = t+1;
        end
        % A common variable for all anatomical regions (+ restriction so that only the region of interest is saved)
        idx_reg{1, q} = idx_sum(1:reg_size(q));
    end
end