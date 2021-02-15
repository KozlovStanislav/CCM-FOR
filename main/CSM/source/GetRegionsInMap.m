function idx_reg = GetRegionsInMap(all_data, map, WINDOW, STEP, NOT_IN_REG_COUNT)
% Расчёт стабильных ядер по методу к-средних прогоном для каждого
% анатомического региона. В каждом прогоне для поиска стабильных областей в
% данном регионе используются все соседние регионы. Результат - переменная,
% которая для каждого исходного региона предоставляет новую нумерацию -
% стабильные области внутри исходного региона. 

    % Пересчитываем количество временных окон (от процента)
    NOT_IN_REG_COUNT = round(NOT_IN_REG_COUNT*floor((size(all_data{1,1},1)-WINDOW)/STEP+1));
    
    % Результирующая переменная
    idx_reg = cell(1, max(map(:)));
    
    for q=1:max(map(:)) % Запишем размеры всех регионов. 
        reg_size(q) = size(find(map==q), 1);
    end

    k=1;
    for i=1:STEP:size(all_data{1,1},1)+1-WINDOW %Разобьём исходные данные на временные окна
        for j=1:size(all_data,2)
            all_data_windowed{k}{j} = detrend(all_data{j}(i:i+WINDOW-1 ,:));
        end
        k=k+1;
    end
    
    
    for q=1:max(map(:)) % Основной цикл по всем исходным регионам
        neig = find_neighbors(map, q); % Поиск соседних регионов
        opt = round(size(neig,2)/1.5); % "Адаптивное" K для метода k-средних
        
        disp(['Region in work=' num2str(q) ', optimal=' num2str(opt)]);

        clear idx
        for i=1:size(all_data_windowed,2) % Вызов основной функции просчёта ФОР в разных временных окнах
%             disp(['i=' num2str(i) '/' num2str(size(all_data_windowed,2))]);
            idx(:, i) = clustering_by_kmeans(get_data(all_data_windowed{i}, neig), opt, 100);
        end

        t=1; % Цикл для поиска одинаковых рядов (вокселей, определяемых в один регион каждый раз)
        idx_sum = zeros(size(idx,1),1); % Новая переменная - принадлежность к новому региону
        for i = 1:size(idx,1) 
            if (idx_sum(i)~=0) 
                continue; % Если ряд этого вокселя уже кому-то был кому-то равен - пропустить
            end
            for j = i:size(idx,1) % Сравнение рядов, начиная с текущего
    %             if (all(idx(j, :)==idx(i,:))) %если полностью совпадает
    %                 idx_sum(j)=t; % Присваиваем новое число - номер региона
    %             end
                if (sum(idx(j, :)~=idx(i,:))<=NOT_IN_REG_COUNT) %если не полностью совпадает
                    idx_sum(j)=t; % Присваиваем новое число - номер региона
                end
            end
            t = t+1;
        end
        % Общая для всех исходных регионов переменная (+ ограничение, чтобы сохранялся только исследуемый регион)
        idx_reg{1, q} = idx_sum(1:reg_size(q));
    end
end