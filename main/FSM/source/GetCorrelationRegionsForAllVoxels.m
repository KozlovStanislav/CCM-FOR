function result = GetCorrelationRegionsForAllVoxels(data, mask, CORR_BR)
% Поиск корреляционных регионов для каждого вокселя из маски. В результат
% для каждого вокселя запишутся все те воксели, которые коррелируют с
% первым не менее отсечки.
    if (nargin<3)
        disp('You need to specify data{X,Y,Z}(T), greymask(X,Y,Z) and cutoff')
    end
    
    all_voxels = find(mask==1); % Все воксели
    voxels_to_analyze = zeros(0,3); % Переменная, в которую будут записываться воксели для анализа
    result = cell(size(all_voxels)); % Результат

    for i=1:size(all_voxels,1) % Цикл по всем вокселям
        clear voxels_analyzed % Переменная, в которую записываются уже просмотренные воксели
        voxels_analyzed(1) = all_voxels(i); % Записываем первый воксель. 
        [x,y,z] = ind2sub(size(mask), all_voxels(i)); % В удобные координаты
        main_dynamic = detrend(data{x,y,z}(:)); % Основная динамика
        result{i}(end+1) = all_voxels(i); % В результатах - первый - сам же с собой
        
        if (mask(x+1,y,z)) % Первый прогон цикла
            voxels_to_analyze(end+1,:) = [x+1 y z]; % Записываем воксели, которые надо проверить
        end
        if (mask(x-1,y,z)) 
            voxels_to_analyze(end+1,:) = [x-1 y z]; % Шесть направлений, без диагоналей
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
        while (~isempty(voxels_to_analyze)) % Основной цикл по поиску корреляционного региона
            xt = voxels_to_analyze(end,1);  yt = voxels_to_analyze(end,2); zt = voxels_to_analyze(end,3); % Записываем координаты
            voxels_to_analyze(end, :) = []; % Зачищаем 
            if any(voxels_analyzed == sub2ind(size(data), xt, yt, zt)), continue; end % Если уже смотрели - пропустить
            voxels_analyzed(end+1) = sub2ind(size(data), xt, yt, zt); % Записываем что мы его смотрели
            if (mask(xt,yt,zt)==0), continue; end % Если он вне маски - пропустить
            tmp_dynamic = detrend(data{xt,yt,zt}(:)); % Смотрим его динамику
            C = corr(main_dynamic(:), tmp_dynamic(:)); % На корреляцию с основной
            if (C > CORR_BR) % Если корреляиця хорошая, то 
                result{i}(end+1) =  voxels_analyzed(end); % Записываем этот воксель
                if (mask(xt+1,yt,zt)) % Проверяем всех соседей дальше
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