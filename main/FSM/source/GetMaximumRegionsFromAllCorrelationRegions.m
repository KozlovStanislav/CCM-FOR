function new_map = GetMaximumRegionsFromAllCorrelationRegions(all_data, allRegions, mask, minRegSize)
% Select the largest correlation regions 
    if (nargin < 4)
        minRegSize = 10;
    end
    
    all_voxels = find(mask==1); % All voxels in mask

    N = ones(size(allRegions,1),1); % Voxel-centers
    for i=1:size(allRegions,1) % Loop across all "correlation" regions
        for j=2:size(allRegions{i},2) % Loop Check across all inner voxels to check their regions
            if (size(allRegions{i},2) < size(allRegions{find(all_voxels == allRegions{i}(j),1)},2))
                N(i) = 0; % If inside there is a voxel with a larger region then current voxel is not the center
                break;
            end
        end
    end

    k=1; % Numbering the regions
    for i=1:size(N,1)
        if (N(i) == 0) continue; end;
        N(i) = k;
        k = k + 1;
    end

    new_map = zeros(size(mask));

    for i=1:size(N,1) % Loop for all remaining center voxels
        if N(i)==0
            continue;
        end
        for j=1:size(allRegions{i},2) % Assigning voxels to new regions 
            if (new_map(allRegions{i}(j)) ~= 0) % If suddenly new regions overlapped
                tmp_data_vox = detrend(all_data{allRegions{i}(j)}); % Check the correlation
                tmp_data_cent1 = detrend(all_data{allRegions{i}(1)}); % with voxel-centers
                tmp_data_cent2 = detrend(all_data{all_voxels(find(N == new_map(allRegions{i}(j)),1))});  
                C1 = corr(tmp_data_vox,tmp_data_cent1);
                C2 = corr(tmp_data_vox,tmp_data_cent2);
                if C2>C1, continue; end % If the previously assigned region is better - leave it
            end
            new_map(allRegions{i}(j)) = N(i); % Or assign a new region
        end
    end


    for i=1:max(new_map(:)) % Removing too small regions 
        if size(find(new_map==i),1) < minRegSize
            new_map(new_map==i)=0;
        end
    end

    k=1; % Check the numerization
    for i=1:max(new_map(:))
        if size(find(new_map==i,1),1)>0
            new_map(new_map==i) = k;
            k = k + 1;
        end
    end
    
end
