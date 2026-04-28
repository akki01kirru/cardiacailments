function dis = find_dis(x1,y1,x2,y2)
len = length(x1);
    for(i=1:1:1)
        for(j=1:1:len-1)
            disT(i,j) = sqrt([x2(i,j) - x1(i,j)]^2 + [y2(i,j) - y1(i,j)]^2); 
        end
    end
dis = mean(disT);
end