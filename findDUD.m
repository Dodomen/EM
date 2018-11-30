function [upk,dow,dowm] = findDUD(up,down,x,y,emp,r) 
    if(x == 0) % pokud nejsou žádné vrcholy, tak vytvoøím umìle 
        up = [1 2];
        x = 2;
    end
    for k = 1:x
        if(up(k) > 40) %pokud nalezen vrchol po krizi tak:
            if (up(k) > 50) % pokud je nalezený vrchol hodnì vzdálený, tak nastavit natvrdo max hodnotu <40,50>
                max = 0;
                for l = 40+1-r:50+1-r % nalezne nejvìtší hodnotu v letech 40:50
                    if emp(l) > max
                        max = emp(l);
                        up(k) = l-1+r;
                    end
                end
            end
            upk = up(k);
            dow = 74; %if there is no end down set last value (continuous decline)
            dowm = down(y); %default value for bottom as last bottom
            for n = 1:y % naleznutí dna po vrcholu a pøed vrcholem
                if(down(n) > upk)
                    dow = down(n);
                    if (n-1 > 0 && down(n-1) < 38)
                        dowm = down(n-1); % if there is enough values before t = 40 then select previous down
                    elseif n-2 > 0
                        dowm = down(n-2); % if there is not enought data select 2 cycles prior
                    else
                        dowm = upk - 10;
                    end
                    break;
                end
            end
        else %pokud není žádný vrchol vhodný tak
            max = 0;
            for l = 40+1-r:50+1-r % nalezne nejvìtší hodnotu v letech 40:50
                if emp(l) > max
                    max = emp(l);
                    upk = l-1+r;
                end
            end
            dow = 74; %if there is no end down set last value (continuous decline)
            dowm = down(y); %default value for bottom as last bottom
            for n = 1:y % naleznutí dna po vrcholu a pøed vrcholem
                if(down(n) > upk)
                    dow = down(n);
                    if (n-1 > 0 && down(n-1) < 38)
                        dowm = down(n-1); % if there is enough values before t = 40 then select previous down
                    elseif n-2 > 0
                        dowm = down(n-2); % if there is not enought data select 2 cycles prior
                    else
                        dowm = upk - 10;
                    end
                    break;
                end
            end 
        end
    end
end