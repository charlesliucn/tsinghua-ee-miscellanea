function [idx,p]=findsetarea(idx,p,i,j)
if(p(i,j))
    idx=[idx;i j];
    p(i,j)=0;
    [idx,p]=findsetarea(idx,p,i-1,j-1);
    [idx,p]=findsetarea(idx,p,i-1,j);
    [idx,p]=findsetarea(idx,p,i-1,j+1);
    [idx,p]=findsetarea(idx,p,i,j-1);
    [idx,p]=findsetarea(idx,p,i,j+1);
    [idx,p]=findsetarea(idx,p,i+1,j-1);
    [idx,p]=findsetarea(idx,p,i+1,j);
    [idx,p]=findsetarea(idx,p,i+1,j+1);    
end