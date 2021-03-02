function result = GetCorrelationRegionsForAllVoxels(data, mask, CORR_BR)

    if (nargin<3)
        disp('You need to specify data{X,Y,Z}(T), greymask(X,Y,Z) and cutoff')
    end
    
    all_voxels = find(mask==1); 
    voxels_to_analyze = zeros(0,3); 
    result = cell(size(all_voxels)); 

    for i=1:size(all_voxels,1) 
        clear voxels_analyzed 
        voxels_analyzed(1) = all_voxels(i); 
        [x,y,z] = ind2sub(size(mask), all_voxels(i)); 
        main_dynamic = detrend(data{x,y,z}(:)); 
        result{i}(end+1) = all_voxels(i);
        
        if (mask(x+1,y,z)) 
            voxels_to_analyze(end+1,:) = [x+1 y z]; 
        end
        if (mask(x-1,y,z)) 
            voxels_to_analyze(end+1,:) = [x-1 y z]; 
        end
        if (mask(x,y+1,z)) 
            voxels_to_analyze(end+1,:) = [x y+1 z];
        end
        if (mask(x,y-1,z)) 
            voxels_to_analyze(end+1,:) = [x y-1 z];
        end
        if (mask(x,y,z+1)) 
            voxels_to_analyze(end+1,:) = [x y z+1];
        end
        if (mask(x,y,z-1)) 
            voxels_to_analyze(end+1,:) = [x y z-1];
        end
        while (~isempty(voxels_to_analyze)) 
            xt = voxels_to_analyze(end,1);  yt = voxels_to_analyze(end,2); zt = voxels_to_analyze(end,3);
            voxels_to_analyze(end, :) = []; 
            if any(voxels_analyzed == sub2ind(size(data), xt, yt, zt)), continue; end 
            voxels_analyzed(end+1) = sub2ind(size(data), xt, yt, zt);
            if (mask(xt,yt,zt)==0), continue; end 
            tmp_dynamic = detrend(data{xt,yt,zt}(:)); 
            C = corr(main_dynamic(:), tmp_dynamic(:)); 
            if (C > CORR_BR) 
                result{i}(end+1) =  voxels_analyzed(end); 
                if (mask(xt+1,yt,zt)) 
                        voxels_to_analyze(end+1,:) = [xt+1 yt zt];
                end
                if (mask(xt-1,yt,zt))
                        voxels_to_analyze(end+1,:) = [xt-1 yt zt];
                end
                if (mask(xt,yt+1,zt))
                        voxels_to_analyze(end+1,:) = [xt yt+1 zt];
                end
                if (mask(xt,yt-1,zt))
                        voxels_to_analyze(end+1,:) = [xt yt-1 zt];
                end
                if (mask(xt,yt,zt+1))
                        voxels_to_analyze(end+1,:) = [xt yt zt+1];
                end
                if (mask(xt,yt,zt-1))
                        voxels_to_analyze(end+1,:) = [xt yt zt-1];
                end
            end
        end
    end
end