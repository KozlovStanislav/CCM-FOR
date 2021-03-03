function result = GetCorrelationRegionsForAllVoxels(data, mask, CORR_BR)
% Search for "correlation" regions for each voxel from the mask. 
% As a result, for each voxel will be written all voxels that 
% correlate with the first not less than cutoff.
    if (nargin<3)
        disp('You need to specify data{X,Y,Z}(T), greymask(X,Y,Z) and cutoff')
    end
    
    all_voxels = find(mask==1); % All voxels in mask
    voxels_to_analyze = zeros(0,3); % Voxels, that need to be checked
    result = cell(size(all_voxels)); % Result

    for i=1:size(all_voxels,1) % Loop by all voxels
        clear voxels_analyzed % Voxels that have already been analyzed for first voxels 
        voxels_analyzed(1) = all_voxels(i); % Write down the first voxel.
        [x,y,z] = ind2sub(size(mask), all_voxels(i)); 
        main_dynamic = detrend(data{x,y,z}(:)); % Dynamic of the first voxels
        result{i}(end+1) = all_voxels(i); % In the results - the first - he correlate with himself
        
        if (mask(x+1,y,z)) % First run in a loop
            voxels_to_analyze(end+1,:) = [x+1 y z]; % Writing voxels to Check
        end
        if (mask(x-1,y,z)) 
            voxels_to_analyze(end+1,:) = [x-1 y z]; % Six directions, no diagonals
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
        while (~isempty(voxels_to_analyze)) % Main loop by voxels to analyze
            xt = voxels_to_analyze(end,1);  yt = voxels_to_analyze(end,2); zt = voxels_to_analyze(end,3);
            voxels_to_analyze(end, :) = []; % Take the voxel into analysis
            if any(voxels_analyzed == sub2ind(size(data), xt, yt, zt)), continue; end % If it have already been analyzed - skip
            voxels_analyzed(end+1) = sub2ind(size(data), xt, yt, zt); % Write down that it was analyzed
            if (mask(xt,yt,zt)==0), continue; end % If it out of the mask - skip
            tmp_dynamic = detrend(data{xt,yt,zt}(:)); % Check it dynamic
            C = corr(main_dynamic(:), tmp_dynamic(:)); % on correlation with main
            if (C > CORR_BR) % If the correlation is good, then
                result{i}(end+1) =  voxels_analyzed(end); % record this voxel
                if (mask(xt+1,yt,zt)) % and check all neighbors further
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