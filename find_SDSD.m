function [SDSD_RR_array]= find_SDSD(QRS_array_i)
difference=[];
for j=1:length(QRS_array_i)-2
    difference =[difference QRS_array_i(j+2)-2*QRS_array_i(j+1)+QRS_array_i(j)];
end
SDSD_RR_array = std(difference,1);