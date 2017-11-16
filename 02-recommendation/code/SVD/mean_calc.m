function mean = mean_calc(data_set, rated_set)
    
    sigma = sum(sum(data_set));
    num = length(find(rated_set==1));
    mean = sigma/num;
end