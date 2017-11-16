function result = dynarange(x)
    L = 256;
    result = sqrt((L-1).^2 - (double(x)-L+1).^2);
end