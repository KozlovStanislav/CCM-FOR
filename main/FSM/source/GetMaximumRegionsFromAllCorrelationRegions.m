function new_map = GetMaximumRegionsFromAllCorrelationRegions(all_data, allRegions, mask, minRegSize)
% Здесь из всех корреляционных регионов для каждого вокселя выбираем самые
% большие
    if (nargin < 4)
        minRegSize = 10;
    end
    
    all_voxels = find(mask==1); % Все воксели

    N = ones(size(allRegions,1),1); % Какие воксели-центры останутся
    for i=1:size(allRegions,1) % Цикл по всем регионам
        for j=2:size(allRegions{i},2) % Для проверки регионов внутрилежащих вокселей
            if (size(allRegions{i},2) < size(allRegions{find(all_voxels == allRegions{i}(j),1)},2))
                N(i) = 0; % Если внутри оказался воксель с бОльшим регионом - этот воксель не рассматриваем
                break;
            end
        end
    end

    k=1; % Нумерация регионов
    for i=1:size(N,1)
        if (N(i) == 0) continue; end;
        N(i) = k;
        k = k + 1;
    end

    new_map = zeros(size(mask)); % Новая карта

    for i=1:size(N,1) % Цикл для всех оставшихся вокселей-центров
        if N(i)==0
            continue;
        end
        for j=1:size(allRegions{i},2) % Присваиваем всем вокселям новые регионы
            if (new_map(allRegions{i}(j)) ~= 0) % Если вдруг новые регионы наложились
                tmp_data_vox = detrend(all_data{allRegions{i}(j)}); % Проверяем для каждого вокселя
                tmp_data_cent1 = detrend(all_data{allRegions{i}(1)}); % Их корреляцию с центрами
                tmp_data_cent2 = detrend(all_data{all_voxels(find(N == new_map(allRegions{i}(j)),1))});  
                C1 = corr(tmp_data_vox,tmp_data_cent1);
                C2 = corr(tmp_data_vox,tmp_data_cent2);
                if C2>C1, continue; end % Если ранее назначенный регион лучше - оставляем его
            end
            new_map(allRegions{i}(j)) = N(i); % Присваиваем новый регион
        end
    end


    for i=1:max(new_map(:)) % Удаляем регионы минимального размера
        if size(find(new_map==i),1) < minRegSize
            new_map(new_map==i)=0;
        end
    end

    k=1; % Перенумеруем регионы (Чтобы в нумерации не было пробелов)
    for i=1:max(new_map(:))
        if size(find(new_map==i,1),1)>0
            new_map(new_map==i) = k;
            k = k + 1;
        end
    end
    
end
