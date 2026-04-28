function angle = find_angle(x1,y1,x2,y2,x3,y3)
len = length(x1);
    for(i=1:1:1)
        for(j=1:1:len-1)
            mT1(i,j) = [y2(i,j) - y1(i,j)]/[x2(i,j) - x1(i,j)]; 
            mT2(i,j) = [y3(i,j) - y2(i,j)]/[x3(i,j) - x2(i,j)];
            Theta(i,j) = (mT1(i,j) - mT2(i,j))/(1 + mT1(i,j) * mT2(i,j));
            angleT(i,j) = atand(Theta(i,j));
        end
    end
angle = mean(angleT);
end