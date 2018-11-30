function empl = toSumTestEmp(res,regN) %return normalize number of employees in region (pod�l 
clc;
    [a,b,c,~] = size(res); %(country, region, time, field)    
    empl = zeros(a,b,c); %employment
    for i = 1:a %p�es v�echny zem�
        for j = 1:regN(i); % p�es v�echny regiony
            for k = 1:c %p�es v�echny �asy   
                empl(i,j,k) = sum(res(i,j,k,:));%;/sum(sum(res(i,1:regN(i),k,:)));
            end
        end
    end
end