function ans = toPlotEnt(entropy, res, time,regN, emp2, emp, country)
    [a,~,~] = size(emp);
    for i = 1:a
        for j = 1:regN(i,1)
            if time
                c=74;
                [up,down,x,y] = rawall(reshape(emp2(i,j,regN(i,2):c),[c+1-regN(i,2),1]),2,c+1-regN(i,2),2,5,10.4);
                [top,bottom,bottom2] = findDUD(up-1+regN(i,2),down-1+regN(i,2),x,y,reshape(emp2(i,j,regN(i,2):c),[1, c+1-regN(i,2)]),regN(i,2));
                ax0 = subplot(3,4,[1,2,3,4]);
                plot(ax0,regN(i,2):c,       reshape(emp(i,j,regN(i,2):c),[c+1-regN(i,2),1])/emp2(i,j,top),    'g',...
                         regN(i,2):c,       reshape(emp2(i,j,regN(i,2):c), [c+1-regN(i,2),1])/emp2(i,j,top),  'r',...
                         up-1+regN(i,2),    reshape(emp2(i,j,up-1+regN(i,2)), [x, 1])/emp2(i,j,top),          'c*',...
                         down-1+regN(i,2),  reshape(emp2(i,j,down-1+regN(i,2)), [y, 1])/emp2(i,j,top),        'b*',...
                         top,               emp2(i,j,top)/emp2(i,j,top),                                      'r+',...
                         bottom,            emp2(i,j,bottom)/emp2(i,j,top),                                   'r>',...
                         bottom2,           emp2(i,j,bottom2)/emp2(i,j,top),                                  'r<')
                title(strcat('NUTS2: ', country(i), sprintf('%02d',j)))
                xlim([0.5 74.5])            
                set(gca,'XTick',1:4:74)
                set(gca,'XTickLabel',{'1998','1999','2000','2001','2002','2003','2004','2005','2006','2007','2008','2009','2010','2011','2012','2013','2014','2015','2016'});                
                legend('Employement','Employement X-13 Arima','Peaks','Troughs','Peak in the vicinity of the crisis', 'Through after the crisis', 'Through before the crisis')
                legend('Location','northwest');
                
                ax1 = subplot(3,4,[5,6]);
                plot(ax1,reshape(entropy(i,j,1:40,1:7),[40,7]))
                xlim([0.5 40.5])
                set(gca,'XTick',1:4:40)
                set(gca,'XTickLabel',{'1998','1999','2000','2001','2002','2003','2004','2005','2006','2007'});
                
                ax2 = subplot(3,4,[7,8]);
                plot(ax2,reshape(entropy(i,j,41:74,1:7),[34,7]))
                xlim([0.5 34.5])
                set(gca,'XTick',1:4:34)
                set(gca,'XTickLabel',{'2008','2009','2010','2011','2012','2013','2014','2015','2016'});
                legend('Shannon entropy','Rényi entropy','Tsallis entropy','Theil index','Herfindal index','Gini coefficient','Net diversity index');
                
                ax3 = subplot(3,4,[9,10]); 
                bar(ax3,bsxfun(@rdivide,reshape(res(i,j,1:40,1:18),[40,18]),sum(reshape(res(i,j,1:40,1:18),[40,18]),2)),'stacked');
                xlim([0.5 40.5])
                set(gca,'XTick',1:4:40)
                set(gca,'XTickLabel',{'1998','1999','2000','2001','2002','2003','2004','2005','2006','2007'});
                ylim([0 1])
                colormap lines(18)
                
                ax4 = subplot(3,4,[11,12]); 
                bar(ax4,bsxfun(@rdivide,reshape(res(i,j,41:74,:),[34,22]),sum(reshape(res(i,j,41:74,:),[34,22]),2)),'stacked');    
                xlim([0.5 34.5])
                set(gca,'XTick',1:4:34)
                set(gca,'XTickLabel',{'2008','2009','2010','2011','2012','2013','2014','2015','2016'});
                ylim([0 1])
                colormap lines(22)              
            else
                ax1 = subplot(2,1,1);
                plot(ax1,reshape(entropy(i,1:8,j,3:7),[8,5]))
                xlim([0 9])
                ax2 = subplot(2,1,2); 
                bar(ax2,bsxfun(@rdivide,reshape(res(i,1:8,j,1:18),[8,18]),sum(reshape(res(i,1:8,j,1:18),[8,18]),2)),'stacked');
                colormap prism
                ylim([0 1])
            end
            set(gcf, 'PaperUnits', 'centimeters');
            set(gcf, 'PaperPosition', [0 0 30 40]); %x_width=10cm y_width=15cm
            saveas(gcf,strcat('Brchart',int2str(i),'-',int2str(j),'.png'))        
        end
    end
end