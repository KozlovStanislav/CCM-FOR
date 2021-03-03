function plot_map( map, reg )
% Display the map in 3D.
% The second parameter is to display only the selected regions.
    if (nargin==1)
        [x,y,z] = ind2sub(size(map),find(map ~= 0));
        figure
        hSurface = scatter3(x(:),y(:),z(:),20,map([find(map~=0)]), 'filled');
        colormap jet;
        axis([0 size(map,1) 0 size(map,2) 0 size(map,3)]); 
    else
        for i=1:max(max(max(map)))
            if ~any(reg == i)
                map(map==i) = 0;
            end
        end
        for i=-1:-1:min(min(min(map)))
            if ~any(reg == i)
                map(map==i) = 0;
            end
        end
        figure
        [x,y,z] = ind2sub(size(map),find(map ~= 0));
        hSurface = scatter3(x(:),y(:),z(:),20,map([find(map~=0)]), 'filled');
        colormap jet;
        
        axis([0 size(map,1) 0 size(map,2) 0 size(map,3)]); 
    end
end