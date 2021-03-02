function newData = RemoveAutocorrelation(data)
% Autocorrelation remove from data
    newData = cell(size(data));
    for i=1:size(data,2)
        for j=1:size(data{i},2)
            q = detrend(double(data{i}(:,j)));
            acf = ar(q,2);
            newData{i}(:,j) = q(3:end)+...
                acf.Report.Parameters.ParVector(1)*q(2:end-1)+...
                acf.Report.Parameters.ParVector(2)*q(1:end-2);
        end
    end
end