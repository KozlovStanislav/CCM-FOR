function new_map = TakeCores(regs_in_map, map, MIN_REG_SIZE)
% Iterate through all anatomacal regions and search for the stable and big 
% regions inside the anatomacal regions
    k = -1; 
    for i = 1:max(map(:))  % Through all regions of the original map
        for j=1:max(regs_in_map{1,i}(:)) % Through all new regions of the original region
            if size(find(regs_in_map{1,i}==j),1)<MIN_REG_SIZE % If the size of the new region is small
                regs_in_map{1,i}(regs_in_map{1,i}==j)=0; % Zeroing
            else % Otherwise, we assign a new number, the numbering is continuous for both cycles
                regs_in_map{1,i}(regs_in_map{1,i}==j)=k; 
                k = k-1;
            end
        end
    end

    new_map = zeros(size(map));
    for i = 1:max(map(:)) % We go over all regions and assign new numerization to a new map
        new_map(map==i) = regs_in_map{1,i}(:);
    end
    new_map=-new_map; % Invert negativity
end