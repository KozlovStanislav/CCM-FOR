function res = find_neighbors( map, reg )
% Find all neighboring regions for given region "reg"
% Full iteration over the region's voxels: checking all voxels around
    k=2;  res(1)=reg;
    for i=find(map==reg)'
        [x,y,z] = ind2sub(size(map),i);
        new=map(x-1,y,z);
        if ((new~=reg) && (new~=0) && (isempty(find(res==new, 1))))
            res(k)=new;
            k=k+1;
        end
        
        new=map(x+1,y,z);
        if ((new~=reg) && (new~=0) && (isempty(find(res==new, 1))))
            res(k)=new;
            k=k+1;
        end
        
        new=map(x,y-1,z);
        if ((new~=reg) && (new~=0) && (isempty(find(res==new, 1))))
            res(k)=new;
            k=k+1;
        end
        
        new=map(x,y+1,z);
        if ((new~=reg) && (new~=0) && (isempty(find(res==new, 1))))
            res(k)=new;
            k=k+1;
        end
        
        new=map(x,y,z-1);
        if ((new~=reg) && (new~=0) && (isempty(find(res==new, 1))))
            res(k)=new;
            k=k+1;
        end
        
        new=map(x,y,z+1);
        if ((new~=reg) && (new~=0) && (isempty(find(res==new, 1))))
            res(k)=new;
            k=k+1;
        end
        
        
        
%         new=map(i-size(map,1)-1);
%         if ((new~=reg) && (new~=0) && (isempty(find(res==new, 1))))
%             res(k)=new;
%             k=k+1;
%         end
%         
%         new=map(i-size(map,1)+1);
%         if ((new~=reg) && (new~=0) && (isempty(find(res==new, 1))))
%             res(k)=new;
%             k=k+1;
%         end
%         
%         new=map(i+size(map,1)-1);
%         if ((new~=reg) && (new~=0) && (isempty(find(res==new, 1))))
%             res(k)=new;
%             k=k+1;
%         end
%         
%         new=map(i+size(map,1)+1);
%         if ((new~=reg) && (new~=0) && (isempty(find(res==new, 1))))
%             res(k)=new;
%             k=k+1;
%         end
%         
%         
%         
%         i=i-size(map,1)*size(map,2);
%         new=map(i-1);
%         if ((new~=reg) && (new~=0) && (isempty(find(res==new, 1))))
%             res(k)=new;
%             k=k+1;
%         end
%         
%         new=map(i+1);
%         if ((new~=reg) && (new~=0) && (isempty(find(res==new, 1))))
%             res(k)=new;
%             k=k+1;
%         end
%         
%         new=map(i-size(map,1));
%         if ((new~=reg) && (new~=0) && (isempty(find(res==new, 1))))
%             res(k)=new;
%             k=k+1;
%         end
%         
%         new=map(i+size(map,1));
%         if ((new~=reg) && (new~=0) && (isempty(find(res==new, 1))))
%             res(k)=new;
%             k=k+1;
%         end
%         
%         new=map(i-size(map,1)-1);
%         if ((new~=reg) && (new~=0) && (isempty(find(res==new, 1))))
%             res(k)=new;
%             k=k+1;
%         end
%         
%         new=map(i-size(map,1)+1);
%         if ((new~=reg) && (new~=0) && (isempty(find(res==new, 1))))
%             res(k)=new;
%             k=k+1;
%         end
%         
%         new=map(i+size(map,1)-1);
%         if ((new~=reg) && (new~=0) && (isempty(find(res==new, 1))))
%             res(k)=new;
%             k=k+1;
%         end
%         
%         new=map(i+size(map,1)+1);
%         if ((new~=reg) && (new~=0) && (isempty(find(res==new, 1))))
%             res(k)=new;
%             k=k+1;
%         end
%         
%         
%         
%          
%         i=i+2*size(map,1)*size(map,2);
%         new=map(i-1);
%         if ((new~=reg) && (new~=0) && (isempty(find(res==new, 1))))
%             res(k)=new;
%             k=k+1;
%         end
%         
%         new=map(i+1);
%         if ((new~=reg) && (new~=0) && (isempty(find(res==new, 1))))
%             res(k)=new;
%             k=k+1;
%         end
%         
%         new=map(i-size(map,1));
%         if ((new~=reg) && (new~=0) && (isempty(find(res==new, 1))))
%             res(k)=new;
%             k=k+1;
%         end
%         
%         new=map(i+size(map,1));
%         if ((new~=reg) && (new~=0) && (isempty(find(res==new, 1))))
%             res(k)=new;
%             k=k+1;
%         end
%         
%         new=map(i-size(map,1)-1);
%         if ((new~=reg) && (new~=0) && (isempty(find(res==new, 1))))
%             res(k)=new;
%             k=k+1;
%         end
%         
%         new=map(i-size(map,1)+1);
%         if ((new~=reg) && (new~=0) && (isempty(find(res==new, 1))))
%             res(k)=new;
%             k=k+1;
%         end
%         
%         new=map(i+size(map,1)-1);
%         if ((new~=reg) && (new~=0) && (isempty(find(res==new, 1))))
%             res(k)=new;
%             k=k+1;
%         end
%         
%         new=map(i+size(map,1)+1);
%         if ((new~=reg) && (new~=0) && (isempty(find(res==new, 1))))
%             res(k)=new;
%             k=k+1;
%         end
    end
end

