function B= mydct2(A)
% 二维离散余弦变换函数
% 输入：二维矩阵A
% 返回值：A的二维离散余弦变换B
% B = DCTtwo(A) 返回矩阵A的二维离散余弦变换，矩阵B和矩阵A大小相同

    [M,N]=size(A);      %获取矩阵A的大小
    B=zeros(M,N);       %初始化返回矩阵B
    D=zeros(M,N);       %初始化DCT算子矩阵
    for i=1:M
        for j=1:N
            %DCT算子的元素计算公式
        	D(i,j)=sqrt(2/M)*cos((i-1)*(2*j-1)*pi/(2*M));
        end
    end
    D(1,:)=D(1,:)/sqrt(2);  %系数例外情况
    B=D*A*D';               %直接根据矩阵运算
    
end
