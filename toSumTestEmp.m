function empl = toSumTestEmp(res,regN) %return normalize number of employees in region (podíl 
clc;
    [a,b,c,~] = size(res); %(country, region, time, field)    
    empl = zeros(a,b,c); %employment
    for i = 1:a %pøes všechny zemì
        for j = 1:regN(i); % pøes všechny regiony
            for k = 1:c %pøes všechny èasy   
                empl(i,j,k) = sum(res(i,j,k,:));%;/sum(sum(res(i,1:regN(i),k,:)));
            end
        end
    end
end