function [user_bias, item_bias] = bias_calc(dataset, rated_mark, mean)

    [nuser, nitem] = size(dataset);   
    user_bias = zeros(nuser, 1);
    item_bias = zeros(nitem, 1);

    for i = 1:nuser
        sigma1 = 0;
        num1 = length(find(rated_mark(i, :) == 1));
        for j = 1 : nitem
           if rated_mark(i, j) == 1
               sigma1 = sigma1 + (dataset(i, j) - mean);
           end
        end
        user_bias(i, 1) = sigma1/num1;
    end
    user_bias(isnan(user_bias)) = 0;
    for i = 1:nitem
        sigma2 = 0;
        num2 = length(find(rated_mark(:, i) == 1));
        for j = 1 : nuser
            if rated_mark(j, i) == 1
                sigma2 = sigma2 + (dataset(j, i) - mean);
            end
        end
        item_bias(i, 1) = sigma2/num2;
    end
    item_bias(isnan(item_bias)) = 0;
end