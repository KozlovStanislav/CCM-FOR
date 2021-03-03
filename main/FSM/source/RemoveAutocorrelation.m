function newData = RemoveAutocorrelation(data, greymask)
% Remove autocorrelation from data
    newData = cell(size(greymask));
    coords = find(greymask~=0);
    [x,y,z] = ind2sub(size(greymask),coords);
    for i=1:size(coords,1)
        q = detrend(double(data{x(i),y(i),z(i)}));
        acf = ar(q,2);
        newData{x(i),y(i),z(i)} = q(3:end)+...
            acf.Report.Parameters.ParVector(1)*q(2:end-1)+...
            acf.Report.Parameters.ParVector(2)*q(1:end-2);
    end
end