function img_mean = meanfilter(img,n)
% 函数功能：对图像进行均值滤波(模板操作)
% 输入:
%       img:        输入图像
%       n:          选择模板尺寸(常用为奇数)
% 输出:
%       img_mean:   均值滤波后的图像

    if(mod(n,2) == 0)           % 要求模板尺寸(边长)为奇数
        error('模板边长要求为奇数!');
    end
    [height,width] = size(img); % 获取输入图像尺寸
    template = uint8(ones(n));  % 设置模板
    tempsize = n*n;             % 模板大小
    r = (n-1)/2;                % 计算模板半径
    
    %% 使用对称法将图像大小进行扩展，便于进行模板操作
    img_temp = [img(:,r:-1:1),img,img(:,width:-1:width-r+1)];                   % 横向扩展
    img_sym = [img_temp(r:-1:1,:);img_temp;img_temp(height:-1:height-r+1,:)];   % 纵向扩展
    %% 均值滤波模板操作
    for i = 1:height
        for j = 1:width
            m = i+r; n = j+r;
            img(i,j) = sum(sum(img_sym(m-r:m+r,n-r:n+r).*template))/tempsize;   % 计算模板内的均值
        end
    end
    %% 返回均值滤波后的图像
    img_mean = uint8(img);
end