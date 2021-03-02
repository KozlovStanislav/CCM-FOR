function plot_map( map, reg )
% Plot 3D map 
% If "regs"~=[], then on plot will be only regions from "regs" 
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