function [output,entropy] = toSum(res,empl,regN) %
clc;
    [a,b,c,d] = size(res); %(country, region, time, economic activity)
    nE = 7; %number of Entropies/indeces
    
    entropy = zeros(a,b,c,nE); %entropies
    output = zeros(186,nE*9+4+1);
    for i = 1:a %pøes všechny zemì
%         coutry = sum(sort(nonzeros(sum(res(i,:,
        for j = 1:regN(i,1); % pøes všechny regiony
            for k = regN(i,2):c %pøes všechny èasy 
                if k < 40
                    d = 18;
                end
                pr = res(i,j,k,:)/sum(res(i,j,k,:));
               % entropy(i,j,k,1) = 1/(1-0)*log2(sum(power(pr,0))); %Renyi q = 0 aka max entropy                                
                entropy(i,j,k,1) = -nansum(pr .* log2(pr)); %Renyi q = 1 aka Shannon entropy aka Boltzman 
                entropy(i,j,k,2) = 1/(1-2)*log2(sum(power(pr,2))); %Renyi q = 2
               % entropy(i,j,k,4) = 1/(0-1)*(1-sum(power(pr,0))); %Tsallis q = 0
                entropy(i,j,k,3) = 1/(2-1)*(1-sum(power(pr,2))); %Tsallis q = 2
                entropy(i,j,k,4) = entropy(i,j,k,1) - entropy(i,j,k,2); %Theil index
                entropy(i,j,k,5) = sum(power(pr,2)); %Herfindal index | Simpson (Gini-Simpson is 1-HHI)             
                entropy(i,j,k,6) = (2*sum(sort(reshape(res(i,j,k,1:d),[1,d])) .* (1:d)))/(d*sum(res(i,j,k,:)))-((d+1)/d);%Gini,
                suma = sum(sum(res(i,:,k,:)));
                eaSum = zeros(1,18);
                for l = 1:d;
                    eaSum(l) = sum(res(i,:,k,l))/suma;
                end
                max = 0;
                for m = 1:regN(i,1);
                    regIndex = sum(sort(reshape(res(i,m,k,1:d)/sum(res(i,m,k,:)),[1,d])) .* (1:d));
                    if max < regIndex;
                        max = regIndex;
                    end
                end        
                region = sum(sort(reshape(pr(1:d),[1,d])) .* (1:d));
                country = sum(sort(reshape(eaSum(1:d),[1,d])) .* (1:d)) ;              
                entropy(i,j,k,7) = (region - country)/(max - country);  
                clc;
            end
        end
    end
    outp = zeros(a,b,nE*5+3);
    for i = 1:a  %pøes všechny zemì
        for j = 1:regN(i,1) %pøes všechny regiony    
            [ups,down,x,y,] = rawall(reshape(empl(i,j,regN(i,2):c),[c+1-regN(i,2),1]),2,c+1-regN(i,2),2,5,10.4);
            [up,dow,dowm] = findDUD(ups-1+regN(i,2),down-1+regN(i,2),x,y,reshape(empl(i,j,regN(i,2):c),[1, c+1-regN(i,2)]),regN(i,2)); %return peaks and bottoms - data, turnphase = 2 for querterly data, time, phase = 2, cycle = 5, threshold = 10%             
            for l = 1:nE %pøes všechny entorpie
                outp(i,j,(l-1)*5+1) = entropy(i,j,up,l); % l-tá entropie v èase vrcholu
                outp(i,j,(l-1)*5+2) = entropy(i,j,up-1,l);% l-tá entropie v èase vrcholu -1
                outp(i,j,(l-1)*5+3) = entropy(i,j,up-2,l);% l-tá entropie v èase vrcholu -2 aby to nebylo míò jak 40 vè-
              %  outp(i,j,(l-1)*9+4) = var(entropy(i,j,41:up,l));%l-tá entropie rozptyl <41,vrchol>
                %sl = polyfit(1:up-41+1,reshape(entropy(i,j,41:up,1),[1, up-41+1]),1); %l-tá entropie slope mezi 40 - vrchol 
               % outp(i,j,(l-1)*9+5) = sl(1);
              %  outp(i,j,(l-1)*9+6) = geomean(entropy(i,j,42:up,l)./entropy(i,j,41:up-1,l)); %geomean diff <41 - top>                       
                outp(i,j,(l-1)*5+4) = var(entropy(i,j,dowm:40,l));%l-tá entropie rozptyl <down,40>                      
%                 sl = polyfit(1:40-dowm+1,reshape(entropy(i,j,dowm:40,1),[1,40-dowm+1]),1); %l-tá entropie slope mezi <down,40>
                outp(i,j,(l-1)*5+5) = var(entropy(i,j,regN(i,2):40,l));%%sl(1);  
               % outp(i,j,(l-1)*9+9) = geomean(entropy(i,j,dowm+1:40,l)./entropy(i,j,dowm:39,l)); %geomean diff <down,40>
            end
            outp(i,j,nE*5+1) = empl(i,j,dow)/empl(i,j,up); %recese aka vrchol/dno
            outp(i,j,nE*5+2) = var(empl(i,j,up:dow));       %recese aka rozptyl <vrchol, dno>
            sl = polyfit(1:dow-up+1,reshape(empl(i,j,up:dow),[1,dow-up+1]),1); %recese aka slope lineární regrese <vrchol,dno>
            outp(i,j,nE*5+3) = sl(1);
            outp(i,j,nE*5+4) = geomean(empl(i,j,up+1:dow)./empl(i,j,up:dow-1)); %geometric mean from employment values zam(t+1)/zam(t)
            outp(i,j,nE*5+5) = up;
        end
    end
    row = 1; %formating for output table
    for i = 1:a
        for j = 1:regN(i,1)
            output(row,1) = i;
            output(row,2) = mean(empl(i,j,30:40));
            for col = 3:nE*5+5+2
                output(row,col) = outp(i,j,col-2);
            end
            row = row + 1;
        end
    end
end