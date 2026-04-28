function Peri = find_peri(x1,y1,x2,y2,x3,y3)
len = length(x1);
    for(i=1:1:1)
        for(j=1:1:len-1)
            dis1(i,j) = sqrt([x2(i,j) - x1(i,j)]^2 + [y2(i,j) - y1(i,j)]^2);
            dis2(i,j) = sqrt([x3(i,j) - x2(i,j)]^2 + [y3(i,j) - y2(i,j)]^2);
            dis3(i,j) = sqrt([x3(i,j) - x1(i,j)]^2 + [y3(i,j) - y1(i,j)]^2);
        end
    end
periT = dis1+dis2+dis3;
Peri = mean(periT);
end