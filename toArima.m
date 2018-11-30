function res = toArima(emp, regN, time)
    dates = datenum(time(:,1),time(:,2),time(:,3));
    [a,b,c] = size(emp);
    res = zeros(a,b,c);
    for i = 1:a
        for j = 1:regN(i)
            model = x13([dates(regN(i,2):74),reshape(emp(i,j,regN(i,2):c),[75-regN(i,2) 1])]);
            res(i,j,regN(i,2):c) = model.e2.e2;
        end
    end
end