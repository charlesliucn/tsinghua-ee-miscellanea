function img_medi = medifilter(img,n)
% 函数功能：对图像进行中值滤波(模板操作)
% 输入:
%       img:        输入图像
%       n:          选择模板尺寸(常用为奇数)
% 输出:
%       img_mean:   中值滤波后的图像

    if(mod(n,2) == 0)           % 要求模板尺寸(边长)为奇数
        error('模板边长要求为奇数!');
    end
    [height,width] = size(img); % 获取输入图像尺寸
    r = (n-1)/2;                % 计算模板半径
    %% 使用对称法将图像大小进行扩展，便于进行模板操作
    img_temp = [img(:,r:-1:1),img,img(:,width:-1:width-r+1)];                   % 横向扩展
    img_sym = [img_temp(r:-1:1,:);img_temp;img_temp(height:-1:height-r+1,:)];   % 纵向扩展
    %% 中值滤波模板操作
    for i = 1:height
        for j = 1:width
            m = i+r; n = j+r;
            block = img_sym(m-r:m+r,n-r:n+r); % 模板内的部分
            vec = reshape(block,1,(2*r+1)*(2*r+1));% 转换为向量
            img(i,j) = median(vec); % 计算模板的中值
        end
    end
    %% 返回中值滤波后的图像
    img_medi = uint8(img);
end