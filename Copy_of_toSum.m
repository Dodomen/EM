function output = toSum(res,regN) %return normalize number of employees in region (podíl 
clc;
    [a,b,c,d] = size(res); %(country, region, time, field)
    nE = 5; %number of Entropies
    
    empl = zeros(a,b,c); %employment
    entropy = zeros(a,b,c,nE); %entropies
    output = zeros(205,10);
    for i = 1:a %pøes všechny zemì
        for j = 1:regN(i); % pøes všechny regiony
            for k = 1:c %pøes všechny èasy
                suma = 0;
                suma2 = zeros(4);
                for l = 1:d
                   if(res(i,j,k,l) ~= -1) 
                       suma = suma + res(i,j,k,l);
                   end
                end %count sum from valid values
                for l = 1:d % pøes všechny odvìtví
                    if(res(i,j,k,l) ~= -1) %if data exist
                        empl(i,j,k) = empl(i,j,k) + res(i,j,k,l); %employement
                        suma2(1) = suma2(1) + power(res(i,j,k,l)/suma,0); %q=0 Renyi
                        suma2(2) = suma2(2) + power(res(i,j,k,l)/suma,2); %q=2 Renyi
                        suma2(3) = suma2(3) + power(res(i,j,k,l),0); %q=0 Tsallis
                        suma2(4) = suma2(4) + power(res(i,j,k,l),2); %q=2 Tsallis
                        entropy(i,j,k,2) = entropy(i,j,k,2) - (res(i,j,k,l)/suma * log2(res(i,j,k,l)/suma)); %Renyi q = 1 a.k.a Shannon entropy
                    end
                end
                entropy(i,j,k,1) = 1/(1-0)*log2(suma2(1)); %Renyi q = 0
                entropy(i,j,k,3) = 1/(1-2)*log2(suma2(2)); %Renyi q = 2
                entropy(i,j,k,4) = 1/(0-1)*(1-suma2(3)); %Tsallis q = 0
                entropy(i,j,k,5) = 1/(2-1)*(1-suma2(4)); %Tsallis q = 2
            end
        end
    end
    for i = 1:a %country
        for j = 1:regN(i) %region
            for k = 1:c %time
                empl(i,j,k) = empl(i,j,k)/sum(empl(i,:,k));
            end
        end
    end
    recese = zeros(a,b,3); %y
    inputs = zeros(a,b,nE*5); %x
    treshold = 3; %threashold for min number of datapoint in timeseries
    for i = 1:a 
        for j = 1:regN(i)
            reshape(empl(i,j,:),[1, c])
            [up,down] = mbbq(transpose(reshape(empl(i,j,:),[1, c]))); %return peaks and bottoms
     %       zup = transpose(up)
     %       dwn = transpose(down)
            [x,~] = size(up);
            [y,~] = size(down);
            for k = 1:x
                if(up(k) > 40) %pokud nalezen vrchol po krizi tak:
                    dow = 74; %if there is no end bottom (continuous decline)
                    dowm = down(y); %default value for bottom as last bottom
                    for n = 1:y % naleznutí dna po vrcholu a pøed vrcholem
                        if(down(n) > up(k))
                            dow = down(n);
                            if (down(n-1) < 38)
                                dowm = down(n-1); % if there is enough values before t = 40 then select previous down
                            else
                                dowm = down(n-2); % if there is not enought data select 2 cycles prior
                            end
                            break;
                        end
                    end
        %            up(k)
        %            dow
        %            dowm
                    for l = 1:nE %pøes všechny entorpie
                        inputs(i,j,(i-1)*9+1) = entropy(i,j,up(k),l); % l-tá entropie v èase vrcholu
                        inputs(i,j,(i-1)*9+2) = entropy(i,j,up(k)-1,l);% l-tá entropie v èase vrcholu -1
                        inputs(i,j,(i-1)*9+3) = entropy(i,j,up(k)-2,l);% l-tá entropie v èase vrcholu -2 aby to nebylo míò jak 40 vè-
                        inputs(i,j,(i-1)*9+4) = var(entropy(i,j,41:up(k),l));%l-tá entropie rozptyl <41,vrchol>
                        sl = polyfit(1:up(k)-41+1,reshape(entropy(i,j,41:up(k),1),[1, up(k)-41+1]),1); %l-tá entropie slope mezi 40 - vrchol 
                        inputs(i,j,(i-1)*9+5) = sl(1);
                        for m = 41:up(k)-1
                            diff(m-40) = entropy(i,j,m+1,l)/entropy(i,j,m,l);
                        end
                        inputs(i,j,(i-1)*9+6) = geomean(diff); %geomean diff <41 - top>
                        
                        inputs(i,j,(i-1)*9+7) = var(entropy(i,j,dowm:40,l));%l-tá entropie rozptyl <down,40>
                        sl = polyfit(1:40-dowm+1,reshape(entropy(i,j,dowm:40,1),[1,40-dowm+1]),1); %l-tá entropie slope mezi <down,40>
                        inputs(i,j,(i-1)*9+8)= sl(1);                       
                        for m = dowm:39
                            diffd(m-dowm+1) = entropy(i,j,m+1,l)/entropy(i,j,m,l);
                        end
                        inputs(i,j,(i-1)*9+9) = geomean(diffd); %geomean diff <down,40>
                    end                                             
                    recese(i,j,1) = empl(i,j,dow)/empl(i,j,up(k)); %recese aka vrchol/dno
                    recese(i,j,2) = var(empl(i,j,up(k):dow));       %recese aka rozptyl <vrchol, dno>

                    sl = polyfit(1:dow-up(k)+1,reshape(empl(i,j,up(k):dow),[1,dow-up(k)+1]),1); %recese aka slope lineární regrese <vrchol,dno>
                    recese(i,j,3) = sl(1);
                    for l = up(k):dow-1
                        dif(l-up(k)+1) = empl(i,j,l+1)/empl(i,j,l);
                    end
                    recese(i,j,4) = geomean(dif); %geometric mean from employment values zam(t+1)/zam(t)
                    break;
                end
            end
        end
    end
    row = 1;
        for i = 1:a
            for j = 1:b
                output(row,1) = i;
                for col = 2:nE*9+4+1
                    if(col < 6)
                        output(row,col) = recese(i,j,col-1);
                    else
                        output(row,col) = inputs(i,j,col-5);
                    end
                end
                row = row + 1;
            end
        end
end
