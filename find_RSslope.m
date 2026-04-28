function RSslope = find_RSslope(x1,y1,x2,y2)
len = length(x1);
    for(i=1:1:1)
        for(j=1:1:len-1)
            RSslopeT(i,j) = [y2(i,j) - y1(i,j)]/[x2(i,j) - x1(i,j)]; 
        end
    end
RSslope = mean(RSslopeT);
end