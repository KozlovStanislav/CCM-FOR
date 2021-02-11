function new_map = TakeCores(regs_in_map, map)
    k = -1;
    for i = 1:max(map(:))
        for j=1:max(regs_in_map{1,i}(:))
            if size(find(regs_in_map{1,i}==j),1)<10
                regs_in_map{1,i}(regs_in_map{1,i}==j)=0;
            else
                regs_in_map{1,i}(regs_in_map{1,i}==j)=k;
                k = k-1;
            end
        end
    end

    new_map = zeros(size(map));
    for i = 1:max(map(:)) 
        new_map(map==i) = regs_in_map{1,i}(:);
    end
    new_map=-new_map;
end