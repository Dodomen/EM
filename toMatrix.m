function res = toMatrix(data)
    res = zeros(11,42,74,22);% - ones(11,42,74,22);
    for i = 1:235497%236399
        if (isnan(data(i,1)) || isnan(data(i,2)) || isnan(data(i,3)) || isnan(data(i,4)) || isnan(data(i,5)))
        elseif (res(data(i,1),data(i,2),data(i,3),data(i,4)) == 0)
            res(data(i,1),data(i,2),data(i,3),data(i,4)) =  data(i,5);
        elseif (res(data(i,1),data(i,2),data(i,3),data(i,4)) ~= 0)
            res(data(i,1),data(i,2),data(i,3),data(i,4)) = res(data(i,1),data(i,2),data(i,3),data(i,4)) + data(i,5);
        end
    end
end