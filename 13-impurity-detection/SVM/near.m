function result=near(label,N,M)
check=reshape(label,M,N);
check=[ones(1,N+2);ones(M,1),check,ones(M,1);ones(1,N+2)];
result=check;
connect=zeros(M+2,N+2);
check=~check;
for i=2:(M+1)
    for j=2:(N+1)
        if check(i,j)
            connect(i,j)=check(i-1,j-1)+check(i-1,j)+check(i-1,j+1)+check(i,j-1)+check(i,j+1)+check(i+1,j-1)+check(i+1,j)+check(i+1,j+1);       
        end
    end
end
for i=2:(M+1)
    for j=2:(N+1)
        if check(i,j)
            if connect(i,j)<4&&connect(i-1,j-1)<4&&connect(i-1,j)<4&&connect(i-1,j+1)<4&&connect(i,j-1)<4&&connect(i,j+1)<4&&connect(i+1,j-1)<4&&connect(i+1,j)<4&&connect(i+1,j+1)<4
                result(i,j)=1;
            end
        end
    end
end

result=reshape(result(2:(M+1),2:(N+1)),M*N,1);
        
        