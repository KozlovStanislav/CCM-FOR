function [res, new_map, N] = GetCorrelationRegions_v2(data, greymask, CORR_BR, minRegSize, func, MoreOrLess)
    if (nargin<4)
        disp('You need to specify data{X,Y,Z}(T), greymask(X,Y,Z) and cutoff and...')
    elseif (nargin == 4)
        func = @(x,y)corr(x,y);
        MoreOrLess = '>';
    end
    
%     for i=1:size(data,1) %ƒетренд
%         for j=1:size(data,2)
%             for k=1:size(data,3)
%                 if (greymask(i,j,k)==0) continue; end
%                 data{i,j,k}(:) = detrend(double(data{i,j,k}(:)));
%             end
%         end
%     end

%     disp('Stage 1'); % ѕоиск регионов дл€ каждого воксел€
    greymask(greymask~=0) = 1;
    all_voxels = find(greymask==1);
    voxels_to_analyze = zeros(0,3);
    res = cell(size(all_voxels));
    for i=1:size(all_voxels,1)
%             if (mod(i,1000)==0); disp(i); end;
        clear voxels_analyzed tmp_res
        voxels_analyzed(1) = all_voxels(i);
        [x,y,z] = ind2sub(size(greymask), all_voxels(i));
        if (greymask(x,y,z)==0) N(i)=0; continue; end 
        main_dynamic = data{x,y,z}(:);
        tmp_res(1) = all_voxels(i);
        if (greymask(x+1,y,z)); voxels_to_analyze(end+1,:) = [x+1 y z]; end;
        if (greymask(x-1,y,z)); voxels_to_analyze(end+1,:) = [x-1 y z]; end;
        if (greymask(x,y+1,z)); voxels_to_analyze(end+1,:) = [x y+1 z]; end;
        if (greymask(x,y-1,z)); voxels_to_analyze(end+1,:) = [x y-1 z]; end;
        if (greymask(x,y,z+1)); voxels_to_analyze(end+1,:) = [x y z+1]; end;
        if (greymask(x,y,z-1)); voxels_to_analyze(end+1,:) = [x y z-1]; end;

        while (~isempty(voxels_to_analyze))
            xt = voxels_to_analyze(end,1);  yt = voxels_to_analyze(end,2); zt = voxels_to_analyze(end,3);
            voxels_to_analyze(end, :) = [];
            if any(voxels_analyzed == sub2ind(size(data), xt, yt, zt)); continue; end;
            tmp_dynamic = data{xt,yt,zt}(:);
            voxels_analyzed(end+1) = sub2ind(size(greymask), xt, yt, zt);
            C = func(main_dynamic(:), tmp_dynamic(:));
            if size(C,1)>1 || size(C,2)>1
                disp('Distance function output is not a number!')
                exit;
            end
            if (strcmp(MoreOrLess, '>')); flag = C > CORR_BR;
            elseif strcmp(MoreOrLess, '<'); flag = C < CORR_BR;
            else error('MoreOrLess must be equal ">" or "<"');
            end 
            if (flag)
                tmp_res(end+1) = voxels_analyzed(end);
                if (greymask(xt+1,yt,zt)); voxels_to_analyze(end+1,:) = [xt+1 yt zt]; end;
                if (greymask(xt-1,yt,zt)); voxels_to_analyze(end+1,:) = [xt-1 yt zt]; end;
                if (greymask(xt,yt+1,zt)); voxels_to_analyze(end+1,:) = [xt yt+1 zt]; end;
                if (greymask(xt,yt-1,zt)); voxels_to_analyze(end+1,:) = [xt yt-1 zt]; end;
                if (greymask(xt,yt,zt+1)); voxels_to_analyze(end+1,:) = [xt yt zt+1]; end;
                if (greymask(xt,yt,zt-1)); voxels_to_analyze(end+1,:) = [xt yt zt-1]; end;
            end
        end
        res{i} = tmp_res;
    end
    
%     disp('Stage 2') 
% ÷икл: поиск карты - вырезание из маски найденной карты, поиск новой карты
% в оставшейс€ маске (и т.д., пока выделенна€ крата не будет пустой)
    allRegions = res;
    N_res = zeros(size(all_voxels,1),1);
    flag = 1;
    while (flag)
        N = ones(size(all_voxels,1),1);
        for i=1:size(allRegions,1)
            if (size(allRegions{i},2)<minRegSize)
                N(i) = 0;
                continue;
            end
            for j=2:size(allRegions{i},2)
                if (size(allRegions{i},2) < size(allRegions{find(all_voxels == allRegions{i}(j),1)},2))
                    N(i) = 0;
                    break;
                end
                if (size(allRegions{i},2) == size(allRegions{find(all_voxels == allRegions{i}(j),1)},2))
                    if (mean(mean(corrcoef(get_data_from_3d_cell_raw(data, allRegions{i})))) <...
                            mean(mean(corrcoef(get_data_from_3d_cell_raw(data, allRegions{...
                            find(all_voxels == allRegions{i}(j),1)})))))
                        N(i) = 0;
                        break;
                    end
                end
            end
        end
        
        new_map_tmp = zeros(size(greymask));
        k=1;
        for i=1:size(N,1)
            if (N(i) == 0) continue; end;
            N(i) = k;
            k = k + 1;
        end
        for i=1:size(N,1)
            if N(i)==0
                continue;
            end
            for j=1:size(allRegions{i},2)
                if (new_map_tmp(allRegions{i}(j)) ~= 0)
                    tmp_data_vox = data{allRegions{i}(j)}';
                    tmp_data_cent1 = data{allRegions{i}(1)}';
                    tmp_data_cent2 = data{all_voxels(find(N == new_map_tmp(allRegions{i}(j)),1))}';  
                    C1 = func(tmp_data_vox,tmp_data_cent1);
                    C2 = func(tmp_data_vox,tmp_data_cent2);
                    if C2>C1 continue; end;
                end
                new_map_tmp(allRegions{i}(j)) = N(i);
            end
        end
        
        for i=1:k
            if size(find(new_map_tmp==i),1) < minRegSize
                N(N==i) = 0;
                new_map_tmp(new_map_tmp==i)=0;
            end
        end
        
        if (all(new_map_tmp == 0)), break; end
        
        N_res = N_res + logical(N);
        voxels_to_delete = find(new_map_tmp>0);
        for i=1:size(allRegions,1)
            for j=size(allRegions{i},2):-1:1
                if any(allRegions{i}(j)==voxels_to_delete)
                    allRegions{i}(j)=[];
                end
            end
        end
%         flag = 0;
    end
    
%     disp('Stage end'); % ¬ыбор всех вокселей-центров и перераспределение всех других вокселей
    allRegions = res;
    N = N_res;
    k=1;
    for i=1:size(N,1)
        if (N(i) == 0) continue; end;
        N(i) = k;
        k = k + 1;
    end

    new_map = zeros(size(greymask));
    for i=1:size(N,1)
        if N(i)==0
            continue;
        end
        for j=1:size(allRegions{i},2)
            if (new_map(allRegions{i}(j)) ~= 0)
                tmp_data_vox = data{allRegions{i}(j)}';
                tmp_data_cent1 = data{allRegions{i}(1)}';
                tmp_data_cent2 = data{all_voxels(find(N == new_map(allRegions{i}(j)),1))}';  
                C1 = func(tmp_data_vox,tmp_data_cent1);
                C2 = func(tmp_data_vox,tmp_data_cent2);
                if C2>C1 continue; end;
            end
            new_map(allRegions{i}(j)) = N(i);
        end
    end

    for i=1:k
        if size(find(new_map==i),1) < minRegSize
            N(N==i) = 0;
            new_map(new_map==i)=0;
        end
    end

    k=1;
    for i=1:max(new_map(:))
        if size(find(new_map==i,1),1)>0
            N(N==i)=k;
            new_map(new_map==i) = k;
            k = k + 1;
        end
    end
    
end