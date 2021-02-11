function new_map = GetMaximumRegionsFromAllCorrelationRegions(all_data, allRegions, mask, minRegSize)
    if (nargin < 3)
        minRegSize = 10;
    end
    
    all_voxels = find(mask==1);

    N = ones(size(allRegions,1),1); 
    for i=1:size(allRegions,1)
        for j=2:size(allRegions{i},2)
            if (size(allRegions{i},2) < size(allRegions{find(all_voxels == allRegions{i}(j),1)},2))
                N(i) = 0;
                break;
            end
        end
    end

    k=1;
    for i=1:size(N,1)
        if (N(i) == 0) continue; end;
        N(i) = k;
        k = k + 1;
    end

    new_map = zeros(size(mask));

    for i=1:size(N,1)
        if N(i)==0
            continue;
        end
        for j=1:size(allRegions{i},2)
            if (new_map(allRegions{i}(j)) ~= 0)
                tmp_data_vox = detrend(double(all_data{allRegions{i}(j)}));
                tmp_data_cent1 = detrend(double(all_data{allRegions{i}(1)}));
                tmp_data_cent2 = detrend(double(all_data{all_voxels(find(N == new_map(allRegions{i}(j)),1))}));  
                C1 = corr(tmp_data_vox,tmp_data_cent1);
                C2 = corr(tmp_data_vox,tmp_data_cent2);
                if C2>C1, continue; end;
            end
            new_map(allRegions{i}(j)) = N(i);
        end
    end


    for i=1:k
        if size(find(new_map==i),1) < minRegSize
            new_map(new_map==i)=0;
        end
    end

    k=1;
    for i=1:max(new_map(:))
        if size(find(new_map==i,1),1)>0
            new_map(new_map==i) = k;
            k = k + 1;
        end
    end

end
