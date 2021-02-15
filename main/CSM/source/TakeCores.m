function new_map = TakeCores(regs_in_map, map, MIN_REG_SIZE)
% Перебор по всем регионам карты и поиск выделившися внутри ргеионов
% стабильных ядер. 
    k = -1;  % Идём в отрицательную сторону
    for i = 1:max(map(:))  % По всем регионам исходной карты
        for j=1:max(regs_in_map{1,i}(:)) % По всем новым регионам новой карты
            if size(find(regs_in_map{1,i}==j),1)<MIN_REG_SIZE % Если размер нового региона мал
                regs_in_map{1,i}(regs_in_map{1,i}==j)=0; % Зануляем
            else % Иначе присваиваем новый номер, нумерация сквозная для обоих циклов
                regs_in_map{1,i}(regs_in_map{1,i}==j)=k; 
                k = k-1;
            end
        end
    end

    new_map = zeros(size(map));
    for i = 1:max(map(:)) % Пробегаемся по всем регионам, присваиваем новой карте
        new_map(map==i) = regs_in_map{1,i}(:);
    end
    new_map=-new_map; % Инвертируем отрицательность
end