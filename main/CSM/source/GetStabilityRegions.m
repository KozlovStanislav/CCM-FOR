function newMap = GetStabilityRegions(all_data, map, WINDOW, STEP, NOT_IN_REG_COUNT)
    
    NOT_IN_REG_COUNT = round(NOT_IN_REG_COUNT*floor((size(all_data{1,1},1)-WINDOW)/STEP+1));
    
    idx_reg = cell(1, max(map(:)));
    
    for q=1:max(map(:)) %размеры всех регионов. 
        reg_size(q) = size(find(map==q), 1);
    end

    k=1;
    for i=1:STEP:size(all_data{1,1},1)+1-WINDOW
        for j=1:size(all_data,2)
            all_data_windowed{k}{j} = detrend(all_data{j}(i:i+WINDOW-1 ,:));
        end
        k=k+1;
    end
    
    
    for q=1:max(map(:))    
        neig = find_neighbors(map, q);
        opt = round(size(neig,2)/1.5);
        disp(['q=' num2str(q) ', opt=' num2str(opt)]);

        clear idx
        k=1;
        for i=1:STEP:size(all_data{1,1},1)+1-WINDOW
            disp(['i=' num2str(i)]);
            idx(:, k) = clustering_by_kmeans(get_data(all_data_windowed{k}, neig), opt, 100);
            k=k+1;
        end

        t=1;
        idx_sum = zeros(size(idx,1),1);
        for i = 1:size(idx,1) 
            if (idx_sum(i)~=0) 
                continue;
            end
            for j = i:size(idx,1)
    %             if (all(idx(j, :)==idx(i,:))) %если полностью совпадает
    %                 idx_sum(j)=t;
    %             end
                if (sum(idx(j, :)~=idx(i,:))<=NOT_IN_REG_COUNT) %если не полностью
                    idx_sum(j)=t;
                end
            end
            t = t+1;
        end
        idx_reg{1, q} = idx_sum(1:reg_size(q));
    end
end