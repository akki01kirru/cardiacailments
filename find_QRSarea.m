function QRSarea = find_QRSarea(a1,a2,b1,b2,c1,c2)
len = length(a1);
    for(i=1:1:1)
        for(j=1:1:len-1)
            QRSareaT(i,j) = (abs(a1(i,j)*(b2(i,j)-c2(i,j)) + b1(i,j)*(c2(i,j)-a2(i,j)) + c1(i,j)*(a2(i,j)-b2(i,j))))/2;
        end
    end
QRSarea = mean(QRSareaT);
end