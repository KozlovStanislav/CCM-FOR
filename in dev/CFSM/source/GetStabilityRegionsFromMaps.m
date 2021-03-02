function new_map = GetStabilityRegionsFromMaps(maps, mask, WINDOW, STEP, NOT_IN_REG_PERCENT, MIN_REG_SIZE)
    
    NOT_IN_REG_COUNT = round(NOT_IN_REG_PERCENT*((1000-WINDOW)/STEP+1));
    
    all_voxels = find(mask>0);
    
    idx = zeros(size(all_voxels,1),size(maps,2));
    for i=1:size(maps,2)
        idx(:, i) = maps{i}(all_voxels);
    end

    idx_sum = zeros(size(all_voxels,1),1);
    t=1;
    for i = 1:size(idx,1) 
        if (idx_sum(i)~=0) 
            continue;
        end
        if (sum(idx(i, :)==0)>NOT_IN_REG_COUNT) 
            idx_sum(i)=-1;
            continue;
        end
        for j = i:size(idx,1) 
    %             if (all(idx(j, :)==idx(i,:)))
    %                 idx_sum(j)=t;
    %             end
            if (sum(idx(j, :)~=idx(i,:)) < NOT_IN_REG_COUNT) 
                idx_sum(j)=t;
            end
        end
        t = t+1;
    end
    idx_sum(idx_sum==-1) = 0;
    res = idx_sum;

    new_res = res;
    k = -1;
    for i = 1:size(new_res, 1)
        if (new_res(i)==0), continue; end;
        if size(find(new_res==new_res(i)),1)<MIN_REG_SIZE
            new_res(new_res==new_res(i))=0;
        else
            new_res(new_res==new_res(i))=k;
            k = k-1;
        end
    end
    new_res = -new_res;

    new_map = zeros(size(mask));
    new_map(all_voxels) = new_res;
end