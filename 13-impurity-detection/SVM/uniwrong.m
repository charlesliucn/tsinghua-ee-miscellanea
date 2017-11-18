function wrongset=uniwrong(label,N,M)
wrongset=cell(0);
check=reshape(label,M,N);
check=[ones(1,N+2);ones(M,1),check,ones(M,1);ones(1,N+2)];
check=~check;
for i=2:(M+1)
    for j=2:(N+1)
        if check(i,j)
            idx=[];
            [idx,check]=findsetarea(idx,check,i,j);
            idx=(idx(:,2)-2)*M+idx(:,1)-1;
            wrongset=[wrongset;idx];
        end
    end
end
            