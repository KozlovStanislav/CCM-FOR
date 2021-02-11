function [all_data, map] = LoadData(PATH_TO_4D_NII, PATH_TO_MASK)
    
    nii=load_nii(PATH_TO_4D_NII); 
    nii=nii.img;

    map=load_nii(PATH_TO_MASK);
    map=round(map.img);

    % Reform the data from 4D double to region cells with dynamics
    all_data = cell(1,max(map(:)));
    for i=1:max(map(:)) 
        coords{i} = find(map==i);
        all_data{i} = zeros(1000, size(coords{i},1));
    end
    for j=1:max(map(:))
        for k=1:size(coords{j},1)
            [x,y,z] = ind2sub(size(map),coords{j}(k));
            all_data{j}(:,k) = nii(x,y,z,:);
        end
    end
    
end
