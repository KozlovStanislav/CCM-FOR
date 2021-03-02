function maps = GetCorrelationRegionsInWindows(all_data, mask, CORR_CUTOFF, WINDOW, STEP, MIN_REG_SIZE)
    
    all_data_windowed = cell(size(all_data));
    maps = [];
    all_voxels = find(mask>0);
    k=0;
    for i=1:STEP:size(all_data{all_voxels(1)},2)+1-WINDOW %Break all data into windows
        k=k+1; disp(k);
        for j=1:size(all_voxels,1)
            all_data_windowed{all_voxels(j)}(:) = detrend(all_data{all_voxels(j)}(i:i+WINDOW-1));
        end
        allCorrelationRegions = GetCorrelationRegionsForAllVoxels(...
            all_data_windowed, mask, CORR_CUTOFF);
        maps{k} = GetMaximumRegionsFromAllCorrelationRegions(...
            all_data_windowed, allCorrelationRegions, mask, MIN_REG_SIZE);
    end
    
end

