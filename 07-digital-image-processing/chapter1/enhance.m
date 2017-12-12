function result = enhance(x)
    if x <= 100 
        result = 0.5*x;
    elseif  x<=200 
        result = 1.775*x -127.5;
    else result = 0.5*x + 127.5;
    end
end