function [all_data, mask] = LoadData(PATH_TO_4D_NII, PATH_TO_MASK)
% Load data into comfortable format 
    nii=load_nii(PATH_TO_4D_NII); 
    nii=nii.img;

    mask=load_nii(PATH_TO_MASK);
    mask=mask.img;

    % Reform the data from 4D double to 3D cell with dynamics in cells
    mask = logical(mask);
    all_data = cell(size(mask));
    coords = find(mask~=0);
    [x,y,z] = ind2sub(size(mask),coords);
    for i=1:size(coords,1)
        all_data{coords(i)}(:) = nii(x(i),y(i),z(i),:);
    end
    
end
