function s = fun_classify_clasteroid_lipsym (s)


for i = 1 : length(s)
    
    s(i).Roundness = (4*s(i).Area*pi)/(s(i).Perimeter.^2);  % roundness > 0.9 means circular shape
    s(i).clasteroid = 0;
    
%     if (s(i).Eccentricity > 0.8) && (s(i).Area >= 500)
%         s(i).clasteroid = 1;
%         
%     end

    if (s(i).Area >= 100)  %dosc dobrze wylapuje obiekty ktore trzeba poddac podzialowi
        s(i).clasteroid = 1;
        
    end
    if (s(i).Eccentricity > 0.8) && (s(i).Area >= 100)  %dosc dobrze wylapuje obiekty ktore trzeba poddac podzialowi
        s(i).clasteroid = 2;
        
    end
    
end

