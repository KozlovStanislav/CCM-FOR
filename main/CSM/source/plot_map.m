function plot_map( map, reg )
% Функция для отображения карты в 3д. 
% Второй параметр - отобразить только выбранные регионы.
    if (nargin==1)
        [x,y,z] = ind2sub(size(map),find(map ~= 0));
        figure
%         figure('Position', [100,100,(575+57+58),(425+85)])
        hSurface = scatter3(x(:),y(:),z(:),20,map([find(map~=0)]), 'filled');
        colormap jet;
        
%         rotate(hSurface, [0 0 1], 90);
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